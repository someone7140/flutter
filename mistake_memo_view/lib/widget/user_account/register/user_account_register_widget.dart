import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/service/api/user_account_api_service.dart';
import 'package:mistake_memo_view/exception/bad_request_exception.dart';
import 'package:mistake_memo_view/provider/user_account_provider.dart';
import 'package:mistake_memo_view/widget/common/snackBarWidget.dart';

class UserAccountRegisterWidget extends StatefulHookConsumerWidget {
  final String? authGoogleToken;
  const UserAccountRegisterWidget({super.key, this.authGoogleToken});

  @override
  UserAccountRegisterState createState() => UserAccountRegisterState();
}

class UserAccountRegisterState
    extends ConsumerState<UserAccountRegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final userIdRegisterController = TextEditingController();
  final userNameRegisterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userIdServerErrorMsgState = useState<String?>(null);
    final postLoadingState = useState<bool>(false);
    final imageFileState = useState<PlatformFile?>(null);

    Future<void> uploadImage() async {
      var result = await FilePicker.platform.pickFiles();
      if (result != null) {
        imageFileState.value = result.files.first;
      } else {
        // User canceled the picker
      }
    }

    Future<void> submitUserAccount() async {
      if (!postLoadingState.value) {
        postLoadingState.value = true;
        try {
          // 登録のAPI
          var res = await UserAccountApiService.createUser(
              userIdRegisterController.text,
              userNameRegisterController.text,
              imageFileState.value,
              widget.authGoogleToken);
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
          SnackBarWidget.showSnackBar(context, "ユーザを登録しました", "success");
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/');
        } on BadRequestException catch (_) {
          SnackBarWidget.showSnackBar(context, "登録済みのユーザIDです", "error");
          userIdServerErrorMsgState.value = "登録済みのユーザIDです";
        } catch (_) {
          SnackBarWidget.showSnackBar(context, "ユーザの登録に失敗しました", "error");
        }
        postLoadingState.value = false;
      }
    }

    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: userIdRegisterController,
                  decoration: InputDecoration(
                    label: Row(children: const [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      Text("ユーザID")
                    ]),
                    border: const OutlineInputBorder(),
                    errorText: userIdServerErrorMsgState.value,
                  ),
                  validator: (value) {
                    // 一度サーバのエラーMSGを初期化する。
                    userIdServerErrorMsgState.value = null;
                    final regUserId = RegExp(r'^[a-zA-Z0-9_-]+$');
                    if (value != null && regUserId.hasMatch(value)) {
                      return null;
                    }
                    return '半角英数字、「_」、「-」で入力してください';
                  },
                )),
            const SizedBox(height: 20),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: userNameRegisterController,
                  decoration: InputDecoration(
                    label: Row(children: const [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      Text("ユーザ名")
                    ]),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '入力必須です';
                    }
                    return null;
                  },
                )),
            const SizedBox(height: 20),
            if (imageFileState.value != null)
              Column(children: [
                SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.memory(imageFileState.value!.bytes!)),
                const SizedBox(height: 20),
              ]),
            ElevatedButton(
              onPressed: () async => {uploadImage()},
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
                backgroundColor: const Color.fromARGB(255, 102, 100, 100),
              ),
              child: const Text('アイコン画像アップロード'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => {
                if (_formKey.currentState!.validate())
                  {
                    // ユーザ登録処理
                    await submitUserAccount()
                  }
                else
                  {
                    // スナックバーの表示
                    SnackBarWidget.showSnackBar(
                        context, "入力内容に不備があります", "error")
                  }
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
              child: const Text('会員登録'),
            ),
            if (postLoadingState.value)
              Column(children: const [
                SizedBox(height: 10),
                CircularProgressIndicator(),
              ])
          ],
        ),
      ),
    );
  }
}
