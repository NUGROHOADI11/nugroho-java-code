class Promo {
  final int id;
  final String name;
  final String? type;
  final int? discount;
  final int? nominal;
  final int? exp;
  final String? photo;
  final String terms;

  Promo({
    required this.id,
    required this.name,
    required this.type,
    this.discount,
    this.nominal,
    this.exp,
    this.photo,
    required this.terms,
  });

  factory Promo.fromJson(Map<String, dynamic> json) {
    return Promo(
      id: json['id_promo'],
      name: json['nama'],
      type: json['type'],
      discount: json['diskon'],
      nominal: json['nominal'],
      exp: json['kadaluarsa'],
      photo: json['foto'],
      terms: json['syarat_ketentuan'],
    );
  }

  String get displayValue =>
      type == 'diskon' ? '$discount%' : 'Rp ${nominal ?? 0}';
}
