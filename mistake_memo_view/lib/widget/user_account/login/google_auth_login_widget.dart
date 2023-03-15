import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../exception/unauthorized_exception.dart';
import '../../../provider/user_account_provider.dart';
import '../../../service/api/user_account_api_service.dart';
import '../../../service/auth/auth_management_service.dart';
import '../../../service/auth/google_auth_service.dart';
import '../../common/snackBarWidget.dart';

class GoogleAuthLoginWidget extends ConsumerWidget {
  const GoogleAuthLoginWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GoogleSignIn googleSignIn = GoogleAuthService.getGoogleSignIn();

    Future<void> idTokenValidate() async {
      try {
        var googleAuth = await googleSignIn.currentUser?.authentication;
        var res = await UserAccountApiService.loginByGoogleToken(
            googleAuth!.idToken!);
        // localStorageにtokenを保存
        await AuthManagementService.setAuthTokenLocalStorage(res.token);
        // グローバルstateにユーザ情報を設定
        AuthManagementService.setUserAccountGlobalState(
            UserAccountGlobalState(
                authToken: res.token,
                userId: res.userId,
                userName: res.userName,
                iconImageUrl: res.iconImageUrl),
            ref);
        // ignore: use_build_context_synchronously
        SnackBarWidget.showSnackBar(context, "ログインしました", "success");
        // TOP画面へ遷移
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/');
      } on UnauthorizedException catch (_) {
        SnackBarWidget.showSnackBar(context, "未登録のGoogleアカウントです", "error");
      } catch (error) {
        SnackBarWidget.showSnackBar(context, "認証時にエラーが発生しました", "error");
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
        SnackBarWidget.showSnackBar(context, "認証時にエラーが発生しました", "error");
      }
    }

    return ElevatedButton(
      onPressed: handleSignIn,
      style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
      child: const Text('Google ログイン'),
    );
  }
}
