import '../../domain/entities/auth_entity.dart';

class AuthModel {
  bool? status;
  bool? privilage;
  Token? token;
  String? phone;

  AuthModel({this.status, this.privilage, this.token, this.phone});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      status: json['status'],
      privilage: json['privilage'],
      token: json['token'] != null ? Token.fromJson(json['token']) : null,
      phone: json['phone'],
    );
  }

  /// ✅ Convert model to domain entity
  AuthEntity toEntity() {
    return AuthEntity(
      status: status ?? false,
      privilage: privilage ?? false,
      accessToken: token?.access ?? '',
      refreshToken: token?.refresh ?? '',
      phone: phone ?? '',
    );
  }
}

class Token {
  String? refresh;
  String? access;

  Token({this.refresh, this.access});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      refresh: json['refresh'],
      access: json['access'],
    );
  }
}
