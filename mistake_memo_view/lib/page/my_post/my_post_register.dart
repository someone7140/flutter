import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mistake_memo_view/page/top_page.dart';
import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/widget/common/appBarWidget.dart';
import 'package:mistake_memo_view/widget/common/drawerWidget.dart';
import 'package:mistake_memo_view/widget/post/register/post_register_widget.dart';

class MyPostRegisterPage extends ConsumerWidget {
  const MyPostRegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!AuthManagementService.loginCheck(context, ref)) {
      return const TopPage();
    } else {
      return const Scaffold(
          appBar: AppBarWidget(),
          drawer: DrawerWidget(),
          body: PostRegisterWidget());
    }
  }
}
