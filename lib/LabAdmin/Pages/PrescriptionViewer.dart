import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PrescriptionViewer extends StatelessWidget {
  final String url;
  bool isPdf = false;
  PrescriptionViewer({super.key, required this.url, this.isPdf = false});

  @override
  Widget build(BuildContext context) {
    if (isPdf) {
      // 📄 PDF Viewer using SfPdfViewer.network
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'PDF Viewer',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: SfPdfViewer.network(
          url,
          onDocumentLoadFailed: (details) => Center(
            child: Text(
              'Failed to load PDF: ${details.description}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      );
    }

    // 🖼️ Image Viewer using CachedNetworkImage (for better reliability)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Viewer'),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: InteractiveViewer(
          // Allows pinch-to-zoom and panning
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,

            // Show a progress indicator while loading
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),

            // Show a specific error message on failure
            errorWidget: (context, url, error) {
              // 💡 Recommended: Print the error to console for debugging
              // print('Image Loading Error: $error');
              return const Center(
                child: Text(
                  'Failed to load file. (Image Loading Error)',
                  style: TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
