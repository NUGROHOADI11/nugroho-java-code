import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/widgets/app_bar.dart';
import '../../controllers/voucher_controller.dart';
import '../components/bottom_bar.dart';
import '../components/voucher_card.dart';

class VoucherScreen extends StatelessWidget {
  VoucherScreen({super.key});
  final VoucherController controller = Get.put(VoucherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Pilih Voucher'.tr, titleIcon: Icons.discount,),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.errorMessage.value.isNotEmpty) {
              return Center(child: Text(controller.errorMessage.value));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 100.h),
                child: Column(
                  children: [
                    ...controller.vouchers
                        .map((voucher) => buildVoucherCard(voucher, controller)),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          }),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildBottomBar(context, controller),
          ),
        ],
      ),
    );
  }
}
