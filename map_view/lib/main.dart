import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home : HomePage(child:
        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, 
            title: HeaderWidget()
          ),
          body: BodyContainer()
        )
      )
    );
  }
}
