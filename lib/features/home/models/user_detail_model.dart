class UserDetail {
  final int statusCode;
  final int id;
  final String name;
  final String email;
  final String birthDate;
  final String? address;
  final String phone;
  final String photo;
  final String ktpPhoto;
  final String pin;
  final bool isActive;
  final bool isCustomer;
  final int roleId;
  final String roleName;

  UserDetail({
    required this.statusCode,
    required this.id,
    required this.name,
    required this.email,
    required this.birthDate,
    this.address,
    required this.phone,
    required this.photo,
    required this.ktpPhoto,
    required this.pin,
    required this.isActive,
    required this.isCustomer,
    required this.roleId,
    required this.roleName,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      statusCode: json['status_code'] ?? 200,
      id: json['data']['id_user'] ?? 0,
      name: json['data']['nama'] ?? '',
      email: json['data']['email'] ?? '',
      birthDate: json['data']['tgl_lahir'] ?? '',
      address: json['data']['alamat'],
      phone: json['data']['telepon'] ?? '',
      photo: json['data']['foto'] ?? '',
      ktpPhoto: json['data']['ktp'] ?? '',
      pin: json['data']['pin'] ?? '',
      isActive: (json['data']['status'] ?? 0) == 1,
      isCustomer: (json['data']['is_customer'] ?? 0) == 1,
      roleId: json['data']['roles_id'] ?? 0,
      roleName: json['data']['roles'] ?? '',
    );
  }
}