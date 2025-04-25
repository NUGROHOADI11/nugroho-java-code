import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as syncfusion;

class PdfViewerController extends GetxController {
  static PdfViewerController get to => Get.find();

  var pdfViewerController = syncfusion.PdfViewerController();
  var searchResult = syncfusion.PdfTextSearchResult();
  var searchText = ''.obs;
  var isSearching = false.obs;

  void toggleSearch() => isSearching.toggle();

  void search(String text) {
    searchText.value = text;
    searchResult = pdfViewerController.searchText(text);
    searchResult.addListener(() {
      if (searchResult.hasResult) {
        update();
      }
    });
  }

  void clearSearch() {
    searchResult.clear();
    searchText.value = '';
    isSearching.value = false;
    update();
  }

  void previousInstance() => searchResult.previousInstance();
  void nextInstance() => searchResult.nextInstance();
}
