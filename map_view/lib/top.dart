import 'package:flutter/material.dart';

class Top extends StatefulWidget {
  @override
  _Top createState() => _Top();
}

class _Top extends State<Top> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Top画面',
            )
          ],
        ),
      ),
    );
  }
}
