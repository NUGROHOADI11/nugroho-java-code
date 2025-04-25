class MenuDetail {
  final int id;
  final String nama;
  final String kategori;
  final int harga;
  final String deskripsi;
  final String foto;
  final bool stock;

  MenuDetail({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.deskripsi,
    required this.foto,
    required this.stock,
  });

  factory MenuDetail.fromJson(Map<String, dynamic> json) {
    return MenuDetail(
      id: json['id_menu'],
      nama: json['nama'],
      kategori: json['kategori'],
      harga: json['harga'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      stock: json['status'] == 1,
    );
  }
}

class DetailItem {
  final int id;
  final String keterangan;
  final int harga;
  final String type;

  DetailItem({
    required this.id,
    required this.keterangan,
    required this.harga,
    this.type = '',
  });

  factory DetailItem.fromJson(Map<String, dynamic> json) {
    return DetailItem(
      id: json['id_detail'],
      keterangan: json['keterangan'],
      harga: json['harga'],
      type: json['type'] ?? '',
    );
  }
}

class MenuDetailModel {
  final MenuDetail menu;
  final List<DetailItem> topping;
  final List<DetailItem> level;

  MenuDetailModel(
      {required this.menu, required this.topping, required this.level});

  factory MenuDetailModel.fromJson(Map<String, dynamic> json) {
    return MenuDetailModel(
      menu: MenuDetail.fromJson(json['menu']),
      topping:
          (json['topping'] as List).map((e) => DetailItem.fromJson(e)).toList(),
      level:
          (json['level'] as List).map((e) => DetailItem.fromJson(e)).toList(),
    );
  }
}
