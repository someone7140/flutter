import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/api/horse_analisys_response.dart';

class AnalysisResultWidget extends StatelessWidget {
  final List<HorceAnalysisResponse> responses;
  const AnalysisResultWidget({Key? key, required this.responses})
      : super(key: key);

  List<TableRow> getAnalysisTableRow(List<HorceAnalysisResponse> rowObjects) {
    // タイトル
    List<TableRow> titleRows = [
      const TableRow(
          decoration: BoxDecoration(
            color: Colors.grey,
          ),
          children: <Widget>[
            TableCell(child: Text("馬名")),
            TableCell(child: Text("同コース")),
            TableCell(child: Text("スコア"))
          ])
    ];
    // データ行
    List<TableRow> scoreRows = rowObjects
        .map((obj) => TableRow(children: <Widget>[
              TableCell(
                  child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: () async {
                      await launch(obj.horseUrl);
                    },
                    child: Text(
                      obj.horseName,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    )),
              )),
              TableCell(child: Text(obj.sameCourseFastTime)),
              TableCell(child: Text(obj.score.toString()))
            ]))
        .toList();
    return titleRows + scoreRows;
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Center(child: Text(responses.first.raceName)),
      Container(
          margin: const EdgeInsets.only(top: 10),
          child: Table(
              border: TableBorder.all(),
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: getAnalysisTableRow(responses)))
    ]);
  }
}
