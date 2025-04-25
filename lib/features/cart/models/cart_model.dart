import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

part 'cart_model.g.dart';

@HiveType(typeId: 1)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int menuId;

  @HiveField(1)
  final String productName;

  @HiveField(2)
  final int harga;

  @HiveField(3)
  final int jumlah;

  @HiveField(4)
  final String? notes;

  @HiveField(5)
  final int? level;

  @HiveField(6)
  final List<int>? topping;

  @HiveField(7)
  final String? imageUrl;

  @HiveField(8)
  final DateTime addedAt;

  @HiveField(9)
  final int? hargaLevel;

  @HiveField(10)
  final int? hargaTopping;

  CartItemModel({
    required this.menuId,
    required this.harga,
    required this.jumlah,
    this.productName = '',
    this.notes,
    this.level,
    this.topping,
    this.imageUrl,
    this.hargaLevel,
    this.hargaTopping,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  int get totalPrice {
    final int hargaTambahan = (hargaLevel ?? 0) + (hargaTopping ?? 0);
    return (harga + hargaTambahan) * jumlah;
  }

  Map<String, dynamic> toJson() => {
        'id_menu': menuId,
        'harga': harga,
        'jumlah': jumlah,
        'level': level,
        'topping': topping,
      };

  CartItemModel copyWith({
    int? menuId,
    String? productName,
    int? harga,
    int? jumlah,
    String? notes,
    int? level,
    List<int>? topping,
    String? imageUrl,
    int? hargaLevel,
    int? hargaTopping,
  }) {
    return CartItemModel(
      menuId: menuId ?? this.menuId,
      harga: harga ?? this.harga,
      jumlah: jumlah ?? this.jumlah,
      productName: productName ?? this.productName,
      notes: notes ?? this.notes,
      level: level ?? this.level,
      topping: topping ?? this.topping,
      imageUrl: imageUrl ?? this.imageUrl,
      hargaLevel: hargaLevel ?? this.hargaLevel,
      hargaTopping: hargaTopping ?? this.hargaTopping,
    );
  }

  bool isSameItem(CartItemModel other) {
    return menuId == other.menuId;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CartItemModel &&
        other.menuId == menuId &&
        other.level == level &&
        listEquals(other.topping, topping);
  }

  @override
  int get hashCode => Object.hash(menuId, level, topping?.join(','));
}

@HiveType(typeId: 2)
class OrderModel extends HiveObject {
  @HiveField(0)
  final int idUser;

  @HiveField(1)
  final int? idVoucher;

  @HiveField(2)
  final int potongan;

  @HiveField(3)
  final int totalBayar;

  @HiveField(4)
  final List<CartItemModel> menu;

  OrderModel({
    required this.idUser,
    required this.potongan,
    required this.totalBayar,
    required this.menu,
    this.idVoucher,
  });

  Map<String, dynamic> toJson() => {
        'order': {
          'id_user': idUser,
          'id_voucher': idVoucher,
          'potongan': potongan,
          'total_bayar': totalBayar,
        },
        'menu': menu.map((item) => item.toJson()).toList(),
      };
}
