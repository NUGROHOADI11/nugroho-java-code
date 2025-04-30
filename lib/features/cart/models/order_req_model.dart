class OrderRequest {
  final Order order;
  final List<OrderMenu> menu;

  OrderRequest({
    required this.order,
    required this.menu,
  });

  Map<String, dynamic> toJson() => {
        'order': order.toJson(),
        'menu': menu.map((item) => item.toJson()).toList(),
      };
}

class Order {
  final int idUser;
  final int idVoucher;
  final int potongan;
  final int totalBayar;

  Order({
    required this.idUser,
    required this.idVoucher,
    required this.potongan,
    required this.totalBayar,
  });

  Map<String, dynamic> toJson() => {
        'id_user': idUser,
        'id_voucher': idVoucher,
        'potongan': potongan,
        'total_bayar': totalBayar,
      };
}

class OrderMenu {
  final int idMenu;
  final int harga;
  final int level;
  final List<int> topping;
  final int jumlah;

  OrderMenu({
    required this.idMenu,
    required this.harga,
    required this.level,
    required this.topping,
    required this.jumlah,
  });

  Map<String, dynamic> toJson() => {
        'id_menu': idMenu,
        'harga': harga,
        'level': level,
        'topping': topping,
        'jumlah': jumlah,
      };
}
