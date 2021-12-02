class AuthInfoDTO {
  AuthInfoDTO({
    this.token,
    this.refreshToken,
    this.verified,
    this.email,
  });

  final String? token;
  final String? refreshToken;
  final bool? verified;
  final String? email;

  factory AuthInfoDTO.fromJson(Map<String, dynamic> json) => AuthInfoDTO(
        token: json["token"],
        refreshToken: json["refreshToken"],
        verified: json["verified"],
        email: json["email"],
      );

  bool get validate => token != null && refreshToken != null;
}
