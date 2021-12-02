class ResetPasswordDTO {
  ResetPasswordDTO(
    this.email,
    this.password,
    this.token,
  );

  final String? email;
  final String? password;
  final String? token;

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
        "token": token,
      };
}
