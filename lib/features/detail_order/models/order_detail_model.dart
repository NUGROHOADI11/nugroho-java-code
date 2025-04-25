class OrderDetailModel {
  final Order order;
  final List<OrderItem> detail;

  OrderDetailModel({
    required this.order,
    required this.detail,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      order: Order.fromJson(json['order']),
      detail: List<OrderItem>.from(
          json['detail'].map((x) => OrderItem.fromJson(x))),
    );
  }
}

class Order {
  final int idOrder;
  final String noStruk;
  final String nama;
  final int idVoucher;
  final String? namaVoucher;
  final int? diskon;
  final int? potongan;
  final int totalBayar;
  final String tanggal;
  final int status;

  Order({
    required this.idOrder,
    required this.noStruk,
    required this.nama,
    required this.idVoucher,
    required this.namaVoucher,
    required this.diskon,
    required this.potongan,
    required this.totalBayar,
    required this.tanggal,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      idOrder: json['id_order'],
      noStruk: json['no_struk'],
      nama: json['nama'],
      idVoucher: json['id_voucher'],
      namaVoucher: json['nama_voucher'],
      diskon: json['diskon'],
      potongan: json['potongan'],
      totalBayar: json['total_bayar'],
      tanggal: json['tanggal'],
      status: json['status'],
    );
  }
}

class OrderItem {
  final int idMenu;
  final String kategori;
  final List<int> topping;
  final String nama;
  final String foto;
  final int jumlah;
  final int harga;
  final int total;
  final String catatan;

  OrderItem({
    required this.idMenu,
    required this.kategori,
    required this.topping,
    required this.nama,
    required this.foto,
    required this.jumlah,
    required this.harga,
    required this.total,
    required this.catatan,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      idMenu: json['id_menu'],
      kategori: json['kategori'],
      topping: List<int>.from((json['topping'] as String)
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',')
          .where((e) => e.trim().isNotEmpty)
          .map((e) => int.parse(e.trim()))),
      nama: json['nama'],
      foto: json['foto'],
      jumlah: json['jumlah'],
      harga: int.tryParse(json['harga'].toString()) ?? 0,
      total: json['total'],
      catatan: json['catatan']?.replaceAll('"', '') ?? '',
    );
  }
}
