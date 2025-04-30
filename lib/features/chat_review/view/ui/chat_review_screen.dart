import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/constants/cores/assets/image_constant.dart';
import 'package:nugroho_javacode/features/chat_review/controllers/chat_review_controller.dart';
import 'package:nugroho_javacode/features/review/controllers/review_controller.dart';

import '../../../../shared/styles/color_style.dart';
import '../components/appbar.dart';

class ChatReviewScreen extends StatelessWidget {
  ChatReviewScreen({super.key});
  final ChatReviewController _controller = Get.put(ChatReviewController());

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 8,
            width: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 8,
            width: 8,
            decoration: BoxDecoration(
              color: Colors.grey[500],
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final review = Get.find<ReviewController>()
        .reviews
        .firstWhere((r) => r.id == Get.arguments['reviewId']);

    return Scaffold(
      appBar: buildAppBar(),
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
                  // Review summary header
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Rating stars
                        Row(
                          children: List.generate(
                            5,
                            (i) => Icon(
                              Icons.star,
                              size: 20,
                              color: i < review.rating
                                  ? Colors.amber
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Review category
                        Expanded(
                          child: Tooltip(
                            message: review.category,
                            child: Text(
                              review.category,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorStyle.primary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date indicator
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F7FA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${review.createdAt.day} ${_controller.getMonthName(review.createdAt.month)} ${review.createdAt.year}',
                      style: TextStyle(fontSize: 12, color: Colors.teal[700]),
                    ),
                  ),

                  // Chat messages
                  Expanded(
                    child: Obx(() => ListView.builder(
                          controller: _controller.scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount: _controller.messages.length +
                              (_controller.isAdminTyping.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _controller.messages.length &&
                                _controller.isAdminTyping.value) {
                              return _buildTypingIndicator();
                            }

                            final msg = _controller.messages[index];
                            final isUser = msg['isUser'] as bool;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              alignment: isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: isUser
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.only(top: 4),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.75,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isUser
                                          ? ColorStyle.info.withOpacity(0.1)
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(12),
                                        topRight: const Radius.circular(12),
                                        bottomLeft:
                                            Radius.circular(isUser ? 12 : 0),
                                        bottomRight:
                                            Radius.circular(isUser ? 0 : 12),
                                      ),
                                    ),
                                    child: isUser
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    msg['time'],
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  const Icon(
                                                    Icons.person,
                                                    color: ColorStyle.primary,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                msg['text'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ],
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.person,
                                                    color: ColorStyle.primary,
                                                    size: 16,
                                                  ),
                                                  const Text(
                                                    " Admin",
                                                    style: TextStyle(
                                                      color: ColorStyle.primary,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Text(
                                                    msg['time'],
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                msg['text'],
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                ],
              ),
            ),
          ),
          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller.messageController,
                    focusNode: _controller.focusNode,
                    decoration: InputDecoration(
                      hintText: 'Tulis Pesan ...',
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _controller.sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => IconButton(
                      icon: const Icon(Icons.send_rounded,
                          size: 30, color: ColorStyle.primary),
                      onPressed: _controller.sendMessage,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
