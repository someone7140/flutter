import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';

import 'package:mistake_memo_view/page/my_post/my_post_register.dart';
import 'package:mistake_memo_view/page/top_page.dart';
import 'package:mistake_memo_view/page/user_account/login/user_account_login.dart';
import 'package:mistake_memo_view/page/user_account/register/user_account_register_auth.dart';

Handler createBasicHandler(Widget targetWidget) {
  return Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return targetWidget;
  });
}

class Routes {
  static void configureRoutes(FluroRouter router) {
    router
      ..define('/', handler: createBasicHandler(const TopPage()))
      ..define('/userAccount', handler: createBasicHandler(const TopPage()))
      ..define('/userAccount/registerAuth',
          handler: createBasicHandler(const UserAccountRegisterAuthPage()))
      ..define('/userAccount/login',
          handler: createBasicHandler(const UserAccountLoginPage()))
      ..define('/myPost', handler: createBasicHandler(const TopPage()))
      ..define('/myPost/create',
          handler: createBasicHandler(const MyPostRegisterPage()));
  }
}
