import 'package:flutter/material.dart';
import 'package:horse_racing/widget/url_input_widget.dart';

import '../model/api/horse_analisys_response.dart';
import '../service/horse_racing_api_service.dart';
import 'analysis_result_widget.dart';

class HorceRacingApp extends StatelessWidget {
  const HorceRacingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '競馬分析',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HorceRacingAppHome(title: '競馬分析'),
    );
  }
}

class HorceRacingAppHome extends StatefulWidget {
  final String title;
  const HorceRacingAppHome({Key? key, required this.title}) : super(key: key);

  @override
  _HorceRacingAppHome createState() => _HorceRacingAppHome();
}

class _HorceRacingAppHome extends State<HorceRacingAppHome> {
  Future<List<HorceAnalysisResponse>> futureResult =
      Future<List<HorceAnalysisResponse>>(List<HorceAnalysisResponse>.empty);
  bool displayAnalysisFlag = false;
  bool loadingFlag = false;
  final urlInputController = TextEditingController();
  final errorText = const Text("分析結果が取得できませんでした");
  final loadingDisplay = const CircularProgressIndicator();

  void analysisResult() {
    setState(() {
      futureResult =
          HorceRacingApiService.getAnalisysResult(urlInputController.text);
      displayAnalysisFlag = true;
      loadingFlag = true;
    });
    urlInputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Center(
                child: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: UrlInput(
                        controllter: urlInputController,
                        analysisResult: analysisResult))),
            Center(
                child: Container(
              margin: const EdgeInsets.only(top: 10),
              child: displayAnalysisFlag
                  ? FutureBuilder<List<HorceAnalysisResponse>>(
                      future: futureResult,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return loadingDisplay;
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return AnalysisResultWidget(
                                  responses: snapshot.data!);
                            } else {
                              return errorText;
                            }
                          } else if (snapshot.hasError) {
                            return errorText;
                          } else {
                            return loadingDisplay;
                          }
                        }
                      })
                  : const SizedBox.shrink(),
            ))
          ],
        ));
  }
}
