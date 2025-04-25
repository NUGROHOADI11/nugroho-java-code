import 'package:get/get.dart';
import '../../../utils/services/dio_service.dart';
import '../../../utils/services/hive_service.dart';
import '../models/order_model.dart';
import 'package:logger/logger.dart';

class PesananController extends GetxController {
  static PesananController get to => Get.find();

  var selectedFilter = 'Semua'.obs;
  final selectedDate = Rx<DateTime?>(null);

  final orders = <Order>[].obs;
  final logger = Logger();
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;
  final errorMessage = ''.obs;
  final currentPage = 1.obs;
  final int perPage = 10;

  final int? idUser = LocalStorageService.getUserData()["id_user"];

  @override
  onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      errorMessage('');
      currentPage(1);
      hasMore(true);

      final response = await DioService.getOrderByUserId(idUser!);

      if (response == null) {
        throw Exception("Response is null");
      }

      if (response["data"] == null) {
        orders.assignAll([]);
        hasMore(false);
        return;
      }

      if (response["data"] is List) {
        final dataList = response["data"] as List;
        final parsedOrders = dataList
            .map((e) {
              try {
                return Order.fromJson(e);
              } catch (e) {
                logger.e('Error parsing order: $e');
                return null;
              }
            })
            .whereType<Order>()
            .toList();
        parsedOrders.sort((a, b) => b.date.compareTo(a.date));

        orders.assignAll(parsedOrders);
        hasMore(parsedOrders.length == perPage);
      } else {
        throw Exception("Data pesanan tidak valid");
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat pesanan: ${e.toString()}';
      logger.e('Error fetching orders: $e');
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  List<Order> getOrdersByStatus(int statusValue) {
    return orders.where((order) => order.status.value == statusValue).toList();
  }

  void applyDateFilter(DateTime date) {
    selectedDate.value = date;
  }

  int getActiveOrderCount() {
    return orders.where((order) => order.status.value < 4).length;
  }
}
