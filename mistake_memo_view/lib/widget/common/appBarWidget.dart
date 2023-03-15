import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistake_memo_view/service/auth/auth_management_service.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var userAccount = AuthManagementService.getUserAccountGlobalState(ref);
    List<Widget>? iconWidget;
    if (userAccount != null) {
      if (userAccount.iconImageUrl != null) {
        iconWidget = [
          Image.network(userAccount.iconImageUrl!, width: 40, height: 40),
        ];
      } else {
        iconWidget = [
          const Icon(Icons.account_box, size: 40),
        ];
      }
    }

    return AppBar(
      title: const Text("失敗メモ"),
      actions: iconWidget,
    );
  }
}
