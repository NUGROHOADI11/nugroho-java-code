import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:nugroho_javacode/features/detail_order/repositories/detail_order_repository.dart';
import '../models/order_detail_model.dart';

class DetailOrderController extends GetxController {
  static DetailOrderController get to => Get.find();

  var isLoading = false.obs;
  var orderDetail = Rxn<OrderDetailModel>();
  var orderItem = <OrderItem>[].obs;
  final logger = Logger();

  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final int id = Get.arguments['id'];
    fetchOrderDetails(id);
    logger.d("logger id $id");
  }

  Future<void> fetchOrderDetails(int id) async {
  try {
    isLoading.value = true;
    errorMessage('');

    final response = await DetailOrderRepository.getOrderDetail(id);
    logger.d('Response: $response');

    if (response?['status_code'] == 200 && response!['data'] != null) {
      final parsed = OrderDetailModel.fromJson(response['data']);
      orderDetail.value = parsed;
      orderItem.value = parsed.detail;
    } else {
      throw Exception(response?['message'] ?? 'Gagal mengambil data');
    }
  } catch (e) {
    errorMessage('Terjadi kesalahan saat memuat detail pesanan.');
    logger.e('Error fetching order details: $e');
  } finally {
    isLoading.value = false;
    update(); 
  }
}


  Future<void> refreshOrderData(int orderId) async {
    await fetchOrderDetails(orderId);
  }
}
