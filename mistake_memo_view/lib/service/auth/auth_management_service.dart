import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/user_account_provider.dart';

class AuthManagementService {
  static const String authTokenKey = "authToken";

  static Future<void> setAuthTokenLocalStorage(String authToken) async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.setString(authTokenKey, authToken);
  }

  static Future<String?> getAuthTokenLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(authTokenKey);
  }

  static Future<void> removeAuthTokenLocalStorage() async {
    final localStorage = await SharedPreferences.getInstance();
    localStorage.remove(authTokenKey);
  }

  static void setUserAccountGlobalState(
      UserAccountGlobalState? userAccount, WidgetRef ref) {
    ref.read(userAccountProvider.notifier).state = userAccount;
  }

  static UserAccountGlobalState? getUserAccountGlobalState(WidgetRef ref) {
    return ref.watch(userAccountProvider);
  }

  static bool loginCheck(BuildContext context, WidgetRef ref) {
    var loginState = getUserAccountGlobalState(ref);
    return loginState != null;
  }
}
