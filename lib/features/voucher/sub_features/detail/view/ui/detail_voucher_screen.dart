import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/features/voucher/controllers/voucher_controller.dart';
import 'package:intl/intl.dart'; 

import '../../../../../../shared/styles/color_style.dart';
import '../../../../constants/voucher_assets_constant.dart';

class DetailVoucherScreen extends StatelessWidget {
  DetailVoucherScreen({super.key});

  final assetsConstant = VoucherAssetsConstant();

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments ?? {};
    final int id = arguments['id'];
    final String title = arguments['title'];
    final String terms = arguments['terms'];
    final int valid = arguments['valid'];
    final String image = arguments['image'];

    final now = DateTime.now();
    final endDate = now.add(Duration(days: valid));
    final dateFormat = DateFormat('dd/MM/yyyy');

    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _builtImage(image),
          Expanded(
            child: _builtContent(title, terms, dateFormat.format(now),
                dateFormat.format(endDate)),
          ),
          _buildBottomBar(context, id),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Detail Voucher'.tr,
        style: Get.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.normal,
        ),
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  Widget _builtImage(image) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(25.r)),
          child: Image.network(image)),
    );
  }

  Widget _builtContent(
      String title, String term, String startDate, String endDate) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ColorStyle.primary),
            ),
            const SizedBox(height: 8),
            Text(
              stripHtmlTags(term),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 1,
              color: const Color(0xFFE2E2E2),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: ColorStyle.primary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  "Valid Date".tr,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const Spacer(),
                Text("$startDate - $endDate"),
              ],
            ),
            Container(
              height: 1,
              color: const Color(0xFFE2E2E2),
              margin: const EdgeInsets.symmetric(vertical: 8),
            ),
          ],
        ),
      ),
    );
  }

  String stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  Widget _buildBottomBar(BuildContext context, id) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (!VoucherController.to.isVoucherSelected(id)) {
                  VoucherController.to.selectVoucher(id);
                }
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorStyle.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              child: Text(
                'Pakai Voucher'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
