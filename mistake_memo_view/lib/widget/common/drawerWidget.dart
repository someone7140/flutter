import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/widget/common/snackBarWidget.dart';

class DrawerWidget extends ConsumerWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userAccount = AuthManagementService.getUserAccountGlobalState(ref);

    return Drawer(
        child: ListView(children: [
      const SizedBox(
        height: 70,
        child: DrawerHeader(
          decoration: BoxDecoration(),
          child: Text(
            'メニュー',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      ListTile(
        title: const Text('Top'),
        onTap: () {
          Navigator.pushNamed(context, '/');
        },
      ),
      if (userAccount == null)
        ListTile(
          title: const Text('ログイン'),
          onTap: () {
            Navigator.pushNamed(context, '/userAccount/login');
          },
        ),
      if (userAccount == null)
        ListTile(
          title: const Text('会員登録'),
          onTap: () {
            Navigator.pushNamed(context, '/userAccount/registerAuth');
          },
        ),
      if (userAccount != null)
        ListTile(
          title: const Text('メモ投稿'),
          onTap: () {
            Navigator.pushNamed(context, '/myPost/create');
          },
        ),
      if (userAccount != null)
        ListTile(
          title: const Text('ログアウト'),
          onTap: () async {
            AuthManagementService.setUserAccountGlobalState(null, ref);
            await AuthManagementService.removeAuthTokenLocalStorage();
            Navigator.pop(context);
            SnackBarWidget.showSnackBar(context, "ログアウトしました", "success");
            Navigator.pushNamed(context, '/');
          },
        ),
      const SizedBox(height: 20),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text(
          'Close',
          style: TextStyle(
            color: Colors.blue,
          ),
        ),
      )
    ]));
  }
}
