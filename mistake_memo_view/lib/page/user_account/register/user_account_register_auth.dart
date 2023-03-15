// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistake_memo_view/page/top_page.dart';

import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/widget/common/appBarWidget.dart';
import 'package:mistake_memo_view/widget/common/drawerWidget.dart';
import 'package:mistake_memo_view/widget/user_account/register/google_auth_register_widget.dart';
import 'package:mistake_memo_view/widget/user_account/register/twitter_auth_register_widget.dart';

class UserAccountRegisterAuthPage extends ConsumerWidget {
  const UserAccountRegisterAuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (AuthManagementService.loginCheck(context, ref)) {
      return const TopPage();
    } else {
      return Scaffold(
        appBar: const AppBarWidget(),
        drawer: const DrawerWidget(),
        body: Center(
          child: Column(
            children: const [
              SizedBox(height: 20),
              GoogleAuthRegisterWidget(),
              SizedBox(height: 20),
              TwitterAuthRegisterWidget(),
            ],
          ),
        ),
      );
    }
  }
}
