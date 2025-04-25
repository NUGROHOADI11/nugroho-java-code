import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as syncfusion;
import '../../constants/pdf_viewer_assets_constant.dart';
import '../../controllers/pdf_viewer_controller.dart';

class PdfViewerScreen extends StatelessWidget {
  PdfViewerScreen({super.key});

  final assetsConstant = PdfViewerAssetsConstant();

  @override
  Widget build(BuildContext context) {
    var controller = PdfViewerController.to;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return controller.isSearching.value
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(color: Colors.black),
                        textInputAction: TextInputAction.done,
                        onSubmitted: controller.search,
                        decoration: const InputDecoration(
                          hintText: 'Cari di dokumen...',
                          hintStyle: TextStyle(color: Colors.black),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                )
              : const Text('PDF Viewer Syncfusion');
        }),
        leading: const BackButton(),
        actions: [
          GetBuilder<PdfViewerController>(
            builder: (controller) {
              if (controller.searchResult.hasResult) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.black),
                      onPressed: controller.clearSearch,
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_up,
                          color: Colors.black),
                      onPressed: controller.previousInstance,
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.black),
                      onPressed: controller.nextInstance,
                    ),
                  ],
                );
              }
              return IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: controller.toggleSearch,
              );
            },
          ),
        ],
      ),
      body: syncfusion.SfPdfViewer.network(
        'https://css4.pub/2015/textbook/somatosensory.pdf',
        controller: controller.pdfViewerController,
      ),
    );
  }
}
