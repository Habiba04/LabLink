import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  // 🧩 Upload results (enter Drive link)
  Future<void> uploadResults(BuildContext context) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

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

    final fileBytes = result.files.single.bytes!;
    final fileName =
        'results/${order['id']}/${DateTime.now().microsecondsSinceEpoch}_results.pdf';

    try {
      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putData(fileBytes);

      const String BUCKET_NAME = 'lablink-53a91.appspot.com';
      final String filePathEncoded = Uri.encodeComponent(fileName);

      final String downloadUrl = 
        'https://storage.googleapis.com/$BUCKET_NAME/$filePathEncoded?mimeType=application/pdf';
      await FirebaseFirestore.instance
          .collection('lab')
          .doc(uid)
          .collection('appointments')
          .doc(order['id'])
          .update({'status': 'Completed', 'results': downloadUrl});

      await FirebaseFirestore.instance
          .collection('patient')
          .doc(order['patientId'])
          .collection('appointments')
          .doc(order['id'])
          .update({'status': 'Completed', 'results': downloadUrl});

      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Results uploaded.")));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload results.")),
      );
    }
  }

  // 🧩 Confirm before rejecting
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
          .update({'status': 'Rejected'});

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
    final status = order['status'].toString().toLowerCase();
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
            Row(
              children: [
                _avatar(),
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

            if (isAwaiting)
              // ✅ Upload Results Button (Full Width)
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
              // ✅ Accept / Reject + View Details
              Column(
                children: [
                  Row(
                    children: [
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
                      const SizedBox(width: 10),
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
                      onPressed: onViewDetails,
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

  Widget _avatar() => const CircleAvatar(
    radius: 23,
    backgroundColor: Color(0x3300BBA7),
    child: Icon(Icons.person_outline, color: Colors.white),
  );

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
