// Response Models
class LoginResponse {
  final int statusCode;
  final User user;
  final String token;

  LoginResponse({
    required this.statusCode,
    required this.user,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['status_code'] ?? 200,
      user: User.fromJson(json['data']['user']),
      token: json['data']['token'],
    );
  }
}

class User {
  final int id;
  final String email;
  final String name;
  final String pin;
  final String photo;
  final int roleId;
  final bool isGoogle;
  final bool isCustomer;
  final String roleName;
  final Map<String, bool> access;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.pin,
    required this.photo,
    required this.roleId,
    required this.isGoogle,
    required this.isCustomer,
    required this.roleName,
    required this.access,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id_user'] ?? 0,
      email: json['email'] ?? '',
      name: json['nama'] ?? '',
      pin: json['pin'] ?? '',
      photo: json['foto'] ?? '',
      roleId: json['m_roles_id'] ?? 0,
      isGoogle: (json['is_google'] ?? 0) == 1,
      isCustomer: (json['is_customer'] ?? 0) == 1,
      roleName: json['roles'] ?? '',
      access: Map<String, bool>.from(json['akses'] ?? {}),
    );
  }
}
