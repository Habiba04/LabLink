import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:lablink/LabAdmin/Pages/PrescriptionViewer.dart';
import 'package:lablink/LabAdmin/Pages/order_details_screen.dart';

class OrderCard extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback onViewDetails;
  final VoidCallback? onAccept;

  const OrderCard({
    required this.order,
    required this.onViewDetails,
    this.onAccept,
    super.key,
  });

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  bool isUploading = false;
  // Upload PDF/image to Firebase Storage
  Future<void> uploadResults(BuildContext context) async {
    setState(() => isUploading = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not authenticated.')),
        );
        setState(() => isUploading = false);
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
      setState(() => isUploading = false);
      return;
    }

    final Uint8List fileBytes = result.files.single.bytes!;
    final String filename = result.files.single.name;

    // NOTE: The Firebase Storage security rules from your image check the path:
    // match /results/{allPaths=**}.
    // We use 'results/' followed by the order ID and filename.
    final String storagePath = 'results/${widget.order['id']}/$filename';

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
          .doc(widget.order['id'])
          .update({'status': 'Completed', 'results': downloadUrl});

      // Update the Patient's appointment status
      await firestore
          .collection('patient')
          .doc(widget.order['patientId'])
          .collection('appointments')
          .doc(widget.order['id'])
          .update({'status': 'Completed', 'results': downloadUrl});

      // Update local map so UI reacts immediately (optional but good practice)
      widget.order['results'] = downloadUrl;
      widget.order['status'] = 'Completed';

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
    if (mounted) setState(() => isUploading = false);
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
          .doc(widget.order['id'])
          .update({'status': 'Cancelled'});

      await FirebaseFirestore.instance
          .collection('patient')
          .doc(widget.order['patientId'])
          .collection('appointments')
          .doc(widget.order['id'])
          .update({'status': 'Cancelled'});

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Order rejected.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String name = widget.order['name'] ?? '';
    final String age = widget.order['age'] != null
        ? "${widget.order['age']} yrs"
        : '';
    final String date = widget.order['date'] ?? '-';
    final String time = widget.order['time'] ?? '-';
    final String service = widget.order['collection'] ?? '-';
    final String prescription = widget.order['prescription'] ?? '';
    final List tests = widget.order['tests'] ?? [];
    final status = widget.order['status']?.toLowerCase() ?? '';
    final isAwaiting = status == 'awaiting results';

    if (isUploading) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: CircularProgressIndicator(color: Color(0xFF00BBA7)),
        ),
      );
    }
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
            if (tests.isNotEmpty)
              _buildTestSection(context, tests, prescription),
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
                      if (widget.onAccept != null)
                        Expanded(
                          child: ElevatedButton(
                            onPressed: widget.onAccept,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                            ),
                            child: const Text(
                              "Accept",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      if (widget.onAccept != null) const SizedBox(width: 10),
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OrderDetailsScreen(order: widget.order),
                          ),
                        );
                      },
                      child: const Text("View Details"),
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

  Widget _buildTestSection(
    BuildContext context,
    List tests,
    String prescription,
  ) => Container(
    decoration: BoxDecoration(
      color: const Color(0x1100BBA7),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Tests", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        // 1. List all tests using a Column and text widgets
        ...tests.map((t) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  size: 16,
                  color: Color(0xFF00BBA7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    t['name'] ?? '',
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
          );
        }),

        // 2. Add the prescription view button once, if available
        if (prescription.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TextButton.icon(
              icon: const Icon(Icons.description, size: 18),
              label: const Text(
                "View Uploaded Prescription",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PrescriptionViewer(url: prescription),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
