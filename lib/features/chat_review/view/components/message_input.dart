import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';

Widget buildMessageInput(controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      color: Colors.white,
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.messageController,
            focusNode: controller.focusNode,
            decoration: InputDecoration(
              hintText: 'Tulis Pesan ...'.tr,
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => controller.sendMessage(),
          ),
        ),
        const SizedBox(width: 8),
        Obx(() => IconButton(
              icon: const Icon(Icons.send_rounded,
                  size: 30, color: ColorStyle.primary),
              onPressed:
                  controller.isSending.value ? null : controller.sendMessage,
            )),
      ],
    ),
  );
}
