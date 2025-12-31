import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewScreen extends StatelessWidget {
  final String pdfUrl;
  final String title;

  const PDFViewScreen({super.key, required this.pdfUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(icon: const Icon(Icons.download), onPressed: () {
            // यहाँ बाद में डाउनलोडिंग लॉजिक जोड़ सकते हैं
          }),
        ],
      ),
      body: SfPdfViewer.network(pdfUrl), // यह इंटरनेट से सीधे PDF लोड करेगा
    );
  }
}