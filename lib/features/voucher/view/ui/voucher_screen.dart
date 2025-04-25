import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nugroho_javacode/shared/styles/color_style.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../configs/routes/route.dart';
import '../../../../shared/widgets/skeleton.dart';
import '../../../cart/controllers/cart_controller.dart';
import '../../controllers/voucher_controller.dart';

class VoucherScreen extends StatelessWidget {
  VoucherScreen({super.key});
  final VoucherController controller = Get.put(VoucherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
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
                        .map((voucher) => _buildVoucherCard(voucher)),
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
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> voucher) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.voucherDetailRoute, arguments: {
          'id': voucher['id_promo'],
          'title': voucher['nama'],
          'terms': voucher['syarat_ketentuan'],
          'valid': voucher['kadaluarsa'],
          'image': voucher['foto']
        });
      },
      child: Obx(() {
        final isSelected = controller.isVoucherSelected(voucher['id_promo']);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: isSelected
                ? Border.all(color: ColorStyle.primary, width: 2)
                : null,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          voucher['nama'],
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          value: isSelected,
                          onChanged: (_) =>
                              controller.selectVoucher(voucher['id_promo']),
                          activeColor: ColorStyle.primary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20.r)),
                child: CachedNetworkImage(
                  imageUrl: voucher['foto'],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: SkeletonLoading()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.discount,
            color: ColorStyle.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Pilih Voucher'.tr,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      shadowColor: Colors.black,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Obx(() => Container(
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: ColorStyle.primary,
                      size: 15,
                    ),
                    SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Penggunaan voucher tidak dapat digabung dengan",
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          "discount employee reward program",
                          style: TextStyle(
                              fontSize: 15, color: ColorStyle.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.selectedVoucherId.value != -1
                      ? () {
                          final selected = controller.vouchers.firstWhere(
                            (v) =>
                                v['id_promo'] ==
                                controller.selectedVoucherId.value,
                          );
                          CartController.to.applyVoucher(
                            selected['id_promo'],
                            selected['nominal'],
                          );
                          Get.back();
                        }
                      : () {
                          CartController.to.selectedVoucherId.value == -1;
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
                    'Oke'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
