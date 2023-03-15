import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../exception/bad_request_exception.dart';
import '../../../page/user_account/register/user_account_register.dart';
import '../../../service/api/user_account_api_service.dart';
import '../../../service/auth/google_auth_service.dart';
import '../../common/snackBarWidget.dart';

class GoogleAuthRegisterWidget extends StatelessWidget {
  const GoogleAuthRegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleSignIn googleSignIn = GoogleAuthService.getGoogleSignIn();

    Future<void> idTokenValidate() async {
      try {
        var googleAuth = await googleSignIn.currentUser?.authentication;
        var verifyGoogleTokenResponse =
            await UserAccountApiService.verifyGoogleToken(googleAuth!.idToken!);
        // ユーザ登録画面へ遷移
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return UserAccountRegisterPage(
                  authGoogleToken: verifyGoogleTokenResponse
                      .authGoogleToken); // 遷移先の画面widgetを指定
            },
          ),
        );
      } on BadRequestException catch (_) {
        SnackBarWidget.showSnackBar(context, "すでに登録済みのGoogleアカウントです", "error");
      } catch (error) {
        SnackBarWidget.showSnackBar(context, "認証エラーが発生しました", "error");
      }
    }

    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? account) async {
      await idTokenValidate();
    });

    Future<void> handleSignIn() async {
      try {
        if (googleSignIn.currentUser == null) {
          await googleSignIn.signIn();
        } else {
          // すでに認証済みの場合はidTokenを取得する
          await idTokenValidate();
        }
      } catch (error) {
        SnackBarWidget.showSnackBar(context, "認証エラーが発生しました", "error");
      }
    }

    return ElevatedButton(
      onPressed: handleSignIn,
      style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
      child: const Text('Google 認証'),
    );
  }
}
