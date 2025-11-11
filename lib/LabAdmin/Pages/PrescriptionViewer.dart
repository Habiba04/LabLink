import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart'; // For images

class PrescriptionViewer extends StatelessWidget {
  final String url;
  final String? title;
  const PrescriptionViewer({required this.url, this.title ,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Prescription")),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(url),
        ),
      ),
    );
  }
}
