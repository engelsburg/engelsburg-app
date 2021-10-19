class AuthInfoDTO {

  AuthInfoDTO({
    this.token,
    this.refreshToken
  });

  final String? token;
  final String? refreshToken;

  factory AuthInfoDTO.fromJson(Map<String, dynamic> json) => AuthInfoDTO(
      token: json["token"],
      refreshToken: json["refreshToken"],
  );

  bool get validate => token != null && refreshToken != null;

}