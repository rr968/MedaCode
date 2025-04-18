import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfUrl;

  const PDFViewerPage({super.key, required this.pdfUrl});

  @override
  _PDFViewerPageState createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  String? localPath;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePDF();
  }

  Future<void> _downloadAndSavePDF() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/temp.pdf";

      // Download the PDF file
      Dio dio = Dio();
      await dio.download(widget.pdfUrl, filePath);

      // Update the local path after downloading
      setState(() {
        localPath = filePath;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: localPath != null
          ? PDFView(
              filePath: localPath!,
              autoSpacing: false,
              swipeHorizontal: true,
              onError: (error) {},
              onRender: (pages) {
                setState(() {});
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
