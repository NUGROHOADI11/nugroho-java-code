import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/constants/cores/assets/image_constant.dart';
import 'package:nugroho_javacode/features/chat_review/controllers/chat_review_controller.dart';
import 'package:nugroho_javacode/features/review/controllers/review_controller.dart';

import '../../../../shared/widgets/app_bar.dart';
import '../components/typing_indicator.dart';
import '../components/date_indicator.dart';
import '../components/message_bubble.dart';
import '../components/message_input.dart';
import '../components/review_header.dart';

class ChatReviewScreen extends StatelessWidget {
  ChatReviewScreen({super.key});
  final ChatReviewController controller = Get.put(ChatReviewController());

  @override
  Widget build(BuildContext context) {
    final review = Get.find<ReviewController>()
        .reviews
        .firstWhere((r) => r.id == Get.arguments['reviewId']);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Balasan Review'.tr,
        showUnderline: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                image: const DecorationImage(
                  image: AssetImage(ImageConstant.bgPattern2),
                  opacity: 0.1,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  buildReviewHeader(review),
                  const SizedBox(height: 12),
                  buildDateIndicator(review, controller),
                  Expanded(
                    child: Obx(() {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: controller.scrollController,
                              padding: const EdgeInsets.all(12),
                              itemCount: controller.messages.length,
                              itemBuilder: (context, index) {
                                return buildMessageBubble(
                                    context, controller.messages[index]);
                              },
                            ),
                          ),
                          if (controller.isAdminTyping.value)
                            buildTypingIndicator(),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          buildMessageInput(controller),
        ],
      ),
    );
  }
}
