import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/review_model.dart';
import 'package:logger/logger.dart';

class ReviewController extends GetxController {
  static ReviewController get to => Get.find();

  late Box<ReviewModel> _reviewsBox;
  final RxList<ReviewModel> reviews = <ReviewModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _initHiveBox();
  }

  Future<void> _initHiveBox() async {
    isLoading(true);
    errorMessage('');
    try {
      _reviewsBox = await Hive.openBox<ReviewModel>('reviews');
      _loadReviews();
    } catch (e) {
      errorMessage('Failed to initialize reviews: ${e.toString()}');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }

  void _loadReviews() {
    if (!(_reviewsBox.isOpen)) {
      return;
    }

    final allReviews = _reviewsBox.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    reviews.assignAll(allReviews);

    for (var review in reviews) {
      logger.i(
          '[ReviewController] Review => id: ${review.id}, rating: ${review.rating}, comment: ${review.desc}, image: ${review.imagePath}');
    }
  }

  Future<int> addReview(Map<String, dynamic> reviewData) async {
    try {
      final newId = _reviewsBox.length; 
      final newReview = ReviewModel.fromMap(reviewData, id: newId);
      final id = await _reviewsBox.add(newReview);
      logger
          .d('[ReviewController] Review added with id: $newId (Hive key: $id)');
      _loadReviews();
      return id;
    } catch (e) {
      errorMessage('Failed to add review: ${e.toString()}');
      logger.e('[ReviewController] Error adding review: $e');
      Get.snackbar('Error', errorMessage.value);
      return -1;
    }
  }

  Future<void> deleteAllReviews() async {
    isLoading(true);
    errorMessage('');
    try {
      await _reviewsBox.clear(); 
      reviews.clear(); 
      logger.i('[ReviewController] All reviews deleted.');
      Get.snackbar('Success', 'All reviews deleted successfully.');
    } catch (e) {
      errorMessage('Failed to delete reviews: ${e.toString()}');
      logger.e('[ReviewController] Error deleting all reviews: $e');
      Get.snackbar('Error', errorMessage.value);
    } finally {
      isLoading(false);
    }
  }
}
