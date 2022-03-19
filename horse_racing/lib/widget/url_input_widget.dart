import 'package:flutter/material.dart';

class UrlInput extends StatefulWidget {
  final TextEditingController controllter;
  final Function analysisResult;

  const UrlInput(
      {Key? key, required this.controllter, required this.analysisResult})
      : super(key: key);

  @override
  _UrlInput createState() => _UrlInput();
}

class _UrlInput extends State<UrlInput> {
  bool disableButtonFlag = true;
  void onChnagetText(String inputUrl) {
    setState(() {
      disableButtonFlag = inputUrl.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
          height: 55,
          width: 300,
          child: TextField(
            decoration: const InputDecoration(labelText: "レースURL"),
            enabled: true,
            obscureText: false,
            maxLines: 1,
            controller: widget.controllter,
            onChanged: onChnagetText,
          )),
      Container(
          margin: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
              onPressed: () {
                if (!disableButtonFlag) {
                  disableButtonFlag = true;
                  widget.analysisResult();
                }
              },
              child: const Text('分析する'),
              style: ElevatedButton.styleFrom(
                  primary: disableButtonFlag
                      ? Colors.grey
                      : const Color.fromARGB(255, 15, 164, 233),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  )))),
    ]);
  }
}
