import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:io';

class PdfViewerScreen extends StatelessWidget {
  final String filePath;
  const PdfViewerScreen({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PDF invoice view");
    print("filePath ::$filePath");
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice PDF')),
      body: PdfView(
        controller: PdfController(document: PdfDocument.openFile(filePath)),
      ),
    );
  }
}
