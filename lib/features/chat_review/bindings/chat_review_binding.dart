import 'package:get/get.dart';

import '../controllers/chat_review_controller.dart';

class ChatReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChatReviewController());
  }
}
