import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mistake_memo_view/exception/unauthorized_exception.dart';

import '../../exception/bad_request_exception.dart';
import '../../model/response/user_account/user_account_response.dart';
import '../../model/response/user_account/verify_google_token_response.dart';

class UserAccountApiService {
  static Future<UserAccountResponse> loginByGoogleToken(String idToken) async {
    var url = Uri.parse("${dotenv.get('API_URL')}/userAccount/loginByGoogle");
    var response = await http.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: json.encode({'idToken': idToken}),
    );

    if (response.statusCode == 201) {
      return UserAccountResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException("Unauthorized");
    } else {
      throw Exception("Failed auth");
    }
  }

  static Future<VerifyGoogleTokenResponse> verifyGoogleToken(
      String idToken) async {
    var url =
        Uri.parse("${dotenv.get('API_URL')}/userAccount/verifyGoogleToken");
    var response = await http.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: "application/json"},
      body: json.encode({'idToken': idToken}),
    );

    if (response.statusCode == 201) {
      return VerifyGoogleTokenResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad Request");
    } else {
      throw Exception("Failed auth");
    }
  }

  static Future<UserAccountResponse> createUser(String userId, String userName,
      PlatformFile? fileResult, String? authGoogleToken) async {
    var url = Uri.parse("${dotenv.get('API_URL')}/userAccount/create");
    var token = authGoogleToken ?? "";
    var request = http.MultipartRequest(
      "POST",
      url,
    );
    // ヘッダー
    request.headers['authorization'] = "Bearer $token";
    // ファイル以外の項目
    request.fields["userId"] = userId;
    request.fields["userName"] = userName;
    // ファイル項目
    if (fileResult != null) {
      var multipartFile = http.MultipartFile.fromBytes(
          "iconImage", fileResult.bytes!,
          filename: fileResult.name);
      request.files.add(multipartFile);
    }
    // Post送信
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      return UserAccountResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 400) {
      throw BadRequestException("Bad Request");
    } else {
      throw Exception("Failed create");
    }
  }

  static Future<UserAccountResponse?> getUserFormAuthToken(
      String authToken) async {
    var url = Uri.parse("${dotenv.get('API_URL')}/userAccount/getMyUser");
    var response = await http.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
    );

    if (response.statusCode == 200) {
      return UserAccountResponse.fromJson(json.decode(response.body));
    } else {
      return null;
    }
  }
}
