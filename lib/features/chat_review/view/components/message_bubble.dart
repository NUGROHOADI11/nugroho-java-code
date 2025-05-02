import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/styles/color_style.dart';

Widget buildMessageBubble(BuildContext context, Map<String, dynamic> msg) {
    final isUser = msg['isUser'] as bool;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 4),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color:
                  isUser ? ColorStyle.info.withOpacity(0.1) : Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isUser ? 12 : 0),
                bottomRight: Radius.circular(isUser ? 0 : 12),
              ),
            ),
            child: isUser
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            msg['time'],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.person,
                            color: ColorStyle.primary,
                            size: 16,
                          ),
                        ],
                      ),
                      Text(msg['text'], style: const TextStyle(fontSize: 14)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.person,
                            color: ColorStyle.primary,
                            size: 16,
                          ),
                          Text(
                            " Admin".tr,
                            style: const TextStyle(
                              color: ColorStyle.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            msg['time'],
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      Text(msg['text'], style: const TextStyle(fontSize: 14)),
                    ],
                  ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }