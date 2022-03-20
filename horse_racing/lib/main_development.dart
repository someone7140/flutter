import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:horse_racing/widget/horse_racing_widget.dart';

Future main() async {
  await dotenv.load(fileName: ".env.development");
  setUrlStrategy(PathUrlStrategy());
  runApp(const HorceRacingApp());
}
