class SignUpRequestDTO {

  SignUpRequestDTO({
    this.schoolToken,
    this.email,
    this.password
  });

  final String? schoolToken;
  final String? email;
  final String? password;

  Map<String, dynamic> toJson() => {
    "schoolToken": schoolToken,
    "email": email,
    "password": password
  };

}