import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistake_memo_view/provider/user_account_provider.dart';
import 'package:mistake_memo_view/router/routes.dart';
import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/service/api/user_account_api_service.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  // ルーターの設定
  final router = FluroRouter();
  MyApp.router = router;
  Routes.configureRoutes(router);
  // URLパスのルート設定
  setPathUrlStrategy();
  // envファイルの読み込み
  const env = String.fromEnvironment('ENVIRONMENT');
  await dotenv.load(fileName: ".env.$env");

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  static FluroRouter? router;
  const MyApp({Key? key}) : super(key: key);

  Future<bool> callInitialAuth(WidgetRef ref) async {
    var authToken = await AuthManagementService.getAuthTokenLocalStorage();
    if (authToken != null) {
      var userAccount =
          await UserAccountApiService.getUserFormAuthToken(authToken);
      if (userAccount != null) {
        // グローバルstateにユーザ情報を設定
        AuthManagementService.setUserAccountGlobalState(
            UserAccountGlobalState(
                authToken: authToken,
                userId: userAccount.userId,
                userName: userAccount.userName,
                iconImageUrl: userAccount.iconImageUrl),
            ref);
      } else {
        AuthManagementService.removeAuthTokenLocalStorage();
      }
    }
    return Future.value(true);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<bool>(
        future: callInitialAuth(ref),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            );
          } else {
            return MaterialApp(
              title: '失敗メモ',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: GoogleFonts.sawarabiGothicTextTheme(
                  Theme.of(context).textTheme,
                ),
              ),
              initialRoute: '/',
              onGenerateRoute: MyApp.router!.generator,
            );
          }
        });
  }
}
