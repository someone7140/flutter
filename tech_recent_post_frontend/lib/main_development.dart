import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;
import 'package:intl/date_symbol_data_local.dart';
import 'widget/tech_recent_posts_app.dart';

Future main() async {
  initializeDateFormatting("ja_JP");
  await DotEnv.load(fileName: ".env.development");
  runApp(TechRecentPostsApp());
}
