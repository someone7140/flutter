import 'package:flutter/material.dart';

import 'package:mistake_memo_view/widget/common/appBarWidget.dart';
import 'package:mistake_memo_view/widget/common/drawerWidget.dart';
import 'package:mistake_memo_view/widget/user_account/register/user_account_register_widget.dart';

class UserAccountRegisterPage extends StatelessWidget {
  final String? authGoogleToken;
  const UserAccountRegisterPage({super.key, this.authGoogleToken});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AppBarWidget(),
        drawer: const DrawerWidget(),
        body: UserAccountRegisterWidget(authGoogleToken: authGoogleToken));
  }
}
