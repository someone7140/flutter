import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mistake_memo_view/model/response/post/post_tag.dart';
import 'package:mistake_memo_view/model/view/post/url_item.dart';

class PostApiService {
  static Future<void> createPost(
    String authToken,
    String title,
    bool isOpen,
    List<String>? tags,
    DateTime? occurrenceDate,
    List<String>? causes,
    List<UrlItem>? refUrls,
  ) async {
    var url = Uri.parse("${dotenv.get('API_URL')}/post/create");
    var res = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: json.encode({
        'title': title,
        "isOpen": isOpen,
        "tagWords": tags,
        "occurrenceDate": occurrenceDate?.toIso8601String(),
        "causes": causes,
        "refUrls": refUrls
            ?.map((refUrl) => {
                  "url": refUrl.url,
                  "siteName": refUrl.siteName.isNotEmpty
                      ? refUrl.siteName.isNotEmpty
                      : refUrl.url
                })
            .toList()
      }),
    );

    if (res.statusCode != 201) {
      throw Exception("Failed create");
    }
  }

  static Future<List<PostTagResponse>> getTagsFromStartWordWithAuth(
      String authToken, String word) async {
    var url =
        Uri.parse("${dotenv.get('API_URL')}/post/getTagsFromStartWordWithAuth");
    var res = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: json.encode({
        'word': word,
      }),
    );

    if (res.statusCode == 201) {
      return PostTagResponse.fromJsonList(jsonDecode(res.body));
    } else {
      throw Exception("Get Failed");
    }
  }

  static Future<String> getSiteNameFromUrl(String authToken, String url) async {
    var url = Uri.parse("${dotenv.get('API_URL')}/post/getSiteNameFromUrl");
    var res = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $authToken"
      },
      body: json.encode({
        'url': url,
      }),
    );

    if (res.statusCode == 201) {
      return res.body;
    } else {
      throw Exception("Get Failed");
    }
  }
}
