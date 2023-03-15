class VerifyGoogleTokenResponse {
  final String authGoogleToken;

  VerifyGoogleTokenResponse({required this.authGoogleToken});

  VerifyGoogleTokenResponse.fromJson(Map<String, dynamic> json)
      : authGoogleToken = json["authGoogleToken"];
}
