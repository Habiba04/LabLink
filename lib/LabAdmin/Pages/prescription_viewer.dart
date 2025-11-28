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
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Results Viewer',
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

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prescription Viewer',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: InteractiveViewer(
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,

            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),

            errorWidget: (context, url, error) {
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
