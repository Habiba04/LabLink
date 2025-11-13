// ResultsViewerScreen.dart
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ResultsViewerScreen extends StatelessWidget {
  final String pdfUrl;
  
  const ResultsViewerScreen({super.key, required this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Results'),
        backgroundColor: Colors.teal,
      ),
      // Uses Syncfusion's widget to load the PDF directly from the URL
      body: SfPdfViewer.network(
        pdfUrl,
        // Optional: Show a loading progress indicator
        onDocumentLoadFailed: (details) {
          debugPrint('PDF load failed: ${details.description}');
          // You might want to display a user-friendly error here
        },
      ),
    );
  }
}