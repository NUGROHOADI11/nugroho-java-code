class MenuItem {
  final int id;
  final String name;
  final int price;
  final String image;
  final bool stock;
  final String category;
  final String description;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.stock,
    required this.category,
    required this.description,
  });

  MenuItem copyWith({
    int? id,
    String? name,
    int? price,
    String? image,
    bool? stock,
    int? quantity,
    String? category,
    String? description,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      description: description ?? this.description,
    );
  }
}