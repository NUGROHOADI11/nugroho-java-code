import 'package:get/get.dart';
import 'package:nugroho_javacode/features/detail_order/repositories/detail_order_repository.dart';
import '../../../utils/services/hive_service.dart';
import '../models/order_model.dart';
import 'package:logger/logger.dart';

class PesananController extends GetxController {
  static PesananController get to => Get.find();

  var selectedFilter = 'Semua'.obs;
  final selectedDate = Rx<DateTime?>(null);

  final allOrders = <Order>[].obs;
  final ongoingOrders = <Order>[].obs;   
  final historyOrders = <Order>[].obs;   

  final displayedOngoing = <Order>[].obs; 
  final displayedHistory = <Order>[].obs; 

  final logger = Logger();
  final isLoading = false.obs;
  final isLoadingMoreOngoing = false.obs;
  final isLoadingMoreHistory = false.obs;
  final hasMoreOngoing = true.obs;
  final hasMoreHistory = true.obs;
  final errorMessage = ''.obs;

  final int perPage = 10;
  final int? idUser = LocalStorageService.getUserData()["id_user"];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading(true);
      errorMessage('');
      hasMoreOngoing(true);
      hasMoreHistory(true);

      final response = await DetailOrderRepository.getOrderByUserId(idUser!);

      if (response == null) {
        throw Exception("Response is null");
      }

      if (response["data"] == null) {
        allOrders.clear();
        ongoingOrders.clear();
        historyOrders.clear();
        displayedOngoing.clear();
        displayedHistory.clear();
        hasMoreOngoing(false);
        hasMoreHistory(false);
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

        allOrders.assignAll(parsedOrders);

        ongoingOrders.assignAll(
            allOrders.where((o) => o.status.value < 3).toList());
        historyOrders.assignAll(
            allOrders.where((o) => o.status.value == 3 || o.status.value == 4).toList());

        displayedOngoing.assignAll(ongoingOrders.take(perPage).toList());
        displayedHistory.assignAll(historyOrders.take(perPage).toList());

        hasMoreOngoing(ongoingOrders.length > displayedOngoing.length);
        hasMoreHistory(historyOrders.length > displayedHistory.length);
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

  Future<void> loadMoreOngoing() async {
    if (isLoadingMoreOngoing.value || !hasMoreOngoing.value) return;

    try {
      isLoadingMoreOngoing(true);

      await Future.delayed(const Duration(seconds: 1));

      final nextItems =
          ongoingOrders.skip(displayedOngoing.length).take(perPage).toList();
      displayedOngoing.addAll(nextItems);

      hasMoreOngoing(displayedOngoing.length < ongoingOrders.length);
    } catch (e) {
      logger.e('Error loading more ongoing orders: $e');
    } finally {
      isLoadingMoreOngoing(false);
    }
  }

  Future<void> loadMoreHistory() async {
    if (isLoadingMoreHistory.value || !hasMoreHistory.value) return;

    try {
      isLoadingMoreHistory(true);

      await Future.delayed(const Duration(seconds: 1));

      final nextItems =
          historyOrders.skip(displayedHistory.length).take(perPage).toList();
      displayedHistory.addAll(nextItems);

      hasMoreHistory(displayedHistory.length < historyOrders.length);
    } catch (e) {
      logger.e('Error loading more history orders: $e');
    } finally {
      isLoadingMoreHistory(false);
    }
  }

  void applyDateFilter(DateTime date) {
    selectedDate.value = date;
  }

  int getActiveOrderCount() {
    return allOrders.where((order) => order.status.value < 3).length;
  }
}
