import 'package:rugbydriver/model/car_service_book_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowServiceDocScreen extends StatelessWidget {
  final ServiceData serviceData;

  const ShowServiceDocScreen({Key? key, required this.serviceData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(serviceData.fileName.toString()),
      ),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SfPdfViewer.network(
          // 'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
          serviceData.photoCarServiceBookPath.toString(),
        ),
      ),
    );
  }
}
