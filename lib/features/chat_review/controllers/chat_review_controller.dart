import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/review/controllers/review_controller.dart';

class ChatReviewController extends GetxController {
  static ChatReviewController get to => Get.find();

  final ReviewController _reviewController = Get.find<ReviewController>();
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isAdminTyping = false.obs;
  final RxBool isSending = false.obs;

  final List<String> adminResponses = [
    "Terima kasih atas masukan Anda. Kami akan segera menindaklanjuti keluhan ini.",
    "Mohon maaf atas ketidaknyamanan yang terjadi. Tim kami sedang menangani masalah ini.",
    "Kami sangat menghargai umpan balik Anda. Ini akan membantu kami meningkatkan layanan.",
    "Laporan Anda telah kami terima dan sedang dalam proses pengecekan.",
    "Terima kasih telah meluangkan waktu untuk memberikan ulasan. Kami akan memperbaiki kekurangan ini.",
    "Kami menyesal atas pengalaman yang tidak memuaskan. Tim kami akan melakukan evaluasi internal.",
    "Masukan Anda sangat berharga bagi kami. Kami akan berusaha lebih baik lagi ke depannya."
  ];

  @override
  void onInit() {
    super.onInit();
    focusNode.addListener(_handleFocusChange);
    initializeMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void _handleFocusChange() {
    if (focusNode.hasFocus) {
      scrollToBottom();
    }
  }

  void initializeMessages() {
    final arguments = Get.arguments ?? {};
    final int reviewId = arguments['reviewId'];
    final review = _reviewController.reviews.firstWhere((r) => r.id == reviewId);

    messages.addAll([
      {
        'time': '${review.createdAt.hour.toString().padLeft(2, '0')}.${review.createdAt.minute.toString().padLeft(2, '0')}',
        'text': review.desc,
        'isUser': true
      },
      {
        'time': '${review.createdAt.hour.toString().padLeft(2, '0')}.${(review.createdAt.minute + 10).toString().padLeft(2, '0')}',
        'text': _generateAdminResponse(review),
        'isUser': false
      },
    ]);

    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty || isSending.value) return;

    isSending.value = true;
    final now = DateTime.now();

    messages.add({
      'time': '${now.hour.toString().padLeft(2, '0')}.${now.minute.toString().padLeft(2, '0')}',
      'text': messageController.text,
      'isUser': true,
    });

    messageController.clear();
    scrollToBottom();

    // Simulate typing
    await Future.delayed(const Duration(milliseconds: 500));
    isAdminTyping.value = true;
    scrollToBottom();

    // Random typing duration
    final typingDuration = Duration(milliseconds: 2000 + (DateTime.now().millisecondsSinceEpoch % 3000));
    await Future.delayed(typingDuration);

    isAdminTyping.value = false;
    
    // Add admin response
    messages.add({
      'time': '${now.hour.toString().padLeft(2, '0')}.${(now.minute + 1).toString().padLeft(2, '0')}',
      'text': _getRandomAdminResponse(),
      'isUser': false,
    });

    isSending.value = false;
    scrollToBottom();
  }

  String _getRandomAdminResponse() {
    return adminResponses[(DateTime.now().millisecondsSinceEpoch % adminResponses.length).toInt()];
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  String _generateAdminResponse(review) {
    if (review.rating <= 2) {
      return "Mohon maaf atas ketidaknyamanan yang Anda alami. Kami sangat menyesalkan hal ini dan akan segera mengambil tindakan perbaikan.";
    } else if (review.rating == 3) {
      return "Terima kasih atas masukan Anda. Kami akan mengevaluasi dan memperbaiki kekurangan yang Anda sampaikan.";
    } else {
      return "Terima kasih atas ulasan positif Anda! Kami senang Anda menikmati pengalaman tersebut dan akan terus berusaha memberikan yang terbaik.";
    }
  }

  String getMonthName(int month) {
    const monthNames = [
      "Januari", "Februari", "Maret", "April", "Mei", "Juni",
      "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    ];
    return monthNames[month - 1];
  }
}