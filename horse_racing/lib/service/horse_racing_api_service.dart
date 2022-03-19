import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../model/api/horse_analisys_request.dart';
import '../model/api/horse_analisys_response.dart';

class HorceRacingApiService {
  static final _apiDomain = dotenv.env['API_DOMMIN'];

  static Future<List<HorceAnalysisResponse>> getAnalisysResult(
      String inputUrl) async {
    var url = Uri.parse(_apiDomain! + "/race/analytics");
    var body = json.encode(HorceAnalysisRequest(url: inputUrl));
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode != 200) {
      return List.empty();
    } else {
      return (json.decode(response.body) as List)
          .map((rBody) => HorceAnalysisResponse.fromJson(rBody))
          .toList();
    }
  }
}
