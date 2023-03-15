class UserAccountResponse {
  final String token;
  final String userId;
  final String userName;
  final String? iconImageUrl;

  UserAccountResponse(
      {required this.token,
      required this.userId,
      required this.userName,
      this.iconImageUrl});

  UserAccountResponse.fromJson(Map<String, dynamic> json)
      : token = json["token"],
        userId = json["userId"],
        userName = json["userName"],
        iconImageUrl = json["iconImageUrl"];
}
