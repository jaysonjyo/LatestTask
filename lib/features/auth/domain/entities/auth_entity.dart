class AuthEntity {
  final bool status;
  final bool privilage;
  final String accessToken;
  final String refreshToken;
  final String phone;

  AuthEntity({
    required this.status,
    required this.privilage,
    required this.accessToken,
    required this.refreshToken,
    required this.phone,
  });
}
