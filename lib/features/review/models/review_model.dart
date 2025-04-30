import 'package:hive/hive.dart';

part 'review_model.g.dart'; 

@HiveType(typeId: 0)
class ReviewModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String category;
  
  @HiveField(2)
  final int rating;
  
  @HiveField(3)
  final String desc;

  @HiveField(4)
  final String? imagePath; 

  @HiveField(5)
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.category,
    required this.rating,
    required this.desc,
    this.imagePath,
    required this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map, {required int id}) {
    return ReviewModel(
      id: id, 
      category: map['category'],
      rating: map['rating'],
      desc: map['desc'],
      imagePath: map['imagePath'],
      createdAt: map['createdAt'] ?? DateTime.now(), 
    );
  }
}
