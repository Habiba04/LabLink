import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lablink/LabAdmin/Pages/PrescriptionViewer.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback onViewDetails;
  final VoidCallback? onAccept;

  const OrderCard({
    required this.order,
    required this.onViewDetails,
    this.onAccept,
    Key? key,
  }) : super(key: key);

  // Upload PDF/image to Firebase Storage
  Future<void> uploadResults(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
      }
      return;
    }

    // 1. File Selection and Validation
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      withData: true,
    );

    if (result == null || result.files.single.bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File selection cancelled or failed.')),
        );
      }
      return;
    }

    final Uint8List fileBytes = result.files.single.bytes!;
    final String filename = result.files.single.name;

    // NOTE: The Firebase Storage security rules from your image check the path:
    // match /results/{allPaths=**}.
    // We use 'results/' followed by the order ID and filename.
    final String storagePath = 'results/${order['id']}/$filename';

    try {
      // 2. Create Storage Reference
      final storageRef = FirebaseStorage.instance.ref().child(storagePath);

      // 3. Upload the file (putData is used since we have bytes)
      final uploadTask = storageRef.putData(fileBytes);
      final snapshot = await uploadTask.whenComplete(() {});

      // 4. Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // 5. Update Firestore for lab and patient
      final firestore = FirebaseFirestore.instance;

      // Update the Lab's appointment status
      await firestore
          .collection('lab')
          .doc(uid)
          .collection('appointments')
          .doc(order['id'])
          .update({'status': 'Completed', 'results': downloadUrl});

      // Update the Patient's appointment status
      await firestore
          .collection('patient')
          .doc(order['patientId'])
          .collection('appointments')
          .doc(order['id'])
          .update({'status': 'Completed', 'results': downloadUrl});

      // Update local map so UI reacts immediately (optional but good practice)
      order['results'] = downloadUrl;
      order['status'] = 'Completed';

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Results uploaded successfully.")),
      );
    } on FirebaseException catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firebase upload failed: ${e.message}")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to upload results: $e")));
    }
  }

  Future<void> confirmReject(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Confirm Rejection"),
        content: const Text("Are you sure you want to reject this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text("Reject", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      await FirebaseFirestore.instance
          .collection('lab')
          .doc(uid)
          .collection('appointments')
          .doc(order['id'])
          .update({'status': 'Cancelled'});

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Order rejected.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = order['name'] ?? '';
    final String age = order['age'] != null ? "${order['age']} yrs" : '';
    final String date = order['date'] ?? '-';
    final String time = order['time'] ?? '-';
    final String service = order['collection'] ?? '-';
    final List tests = order['tests'] ?? [];
    final status = order['status']?.toLowerCase() ?? '';
    final isAwaiting = status == 'awaiting results';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name row
            Row(
              children: [
                const CircleAvatar(
                  radius: 23,
                  backgroundColor: Color(0x3300BBA7),
                  child: Icon(Icons.person_outline, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontSize: 18)),
                      if (age.isNotEmpty)
                        Text(
                          age,
                          style: const TextStyle(color: Colors.black54),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _infoRow(Icons.calendar_today_outlined, "$date at $time"),
            const SizedBox(height: 8),
            _infoRow(Icons.article_outlined, service),
            const SizedBox(height: 16),
            if (tests.isNotEmpty) _buildTestSection(context, tests),
            const SizedBox(height: 16),

            // Action buttons
            if (isAwaiting)
              ElevatedButton(
                onPressed: () => uploadResults(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00BBA7),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  "Upload Results",
                  style: TextStyle(color: Colors.white),
                ),
              )
            else
              Column(
                children: [
                  Row(
                    children: [
                      if (onAccept != null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onAccept,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text(
                              "Accept",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      if (onAccept != null) const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => confirmReject(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text(
                            "Reject",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        final link = order['results'];
                        if (link == null || link.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Results not available yet."),
                            ),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PrescriptionViewer(url: link),
                          ),
                        );
                      },
                      child: const Text("View Results"),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) => Row(
    children: [
      Icon(icon, size: 22, color: Colors.blueGrey),
      const SizedBox(width: 8),
      Expanded(
        child: Text(text, style: const TextStyle(color: Colors.black54)),
      ),
    ],
  );

  Widget _buildTestSection(BuildContext context, List tests) => Container(
    decoration: BoxDecoration(
      color: const Color(0x1100BBA7),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tests", style: TextStyle(fontWeight: FontWeight.bold)),
        ...tests.map((t) {
          final prescriptionUrl = t['prescription'];
          return Row(
            children: [
              Expanded(child: Text(t['name'] ?? '')),
              if (prescriptionUrl != null)
                IconButton(
                  icon: const Icon(
                    Icons.visibility_outlined,
                    color: Colors.teal,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PrescriptionViewer(url: prescriptionUrl),
                    ),
                  ),
                ),
            ],
          );
        }),
      ],
    ),
  );
}
