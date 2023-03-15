import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistake_memo_view/model/view/post/url_item.dart';
import 'package:mistake_memo_view/service/common/date_service.dart';
import 'package:mistake_memo_view/widget/post/input/tag_input_widget.dart';
import 'package:mistake_memo_view/widget/post/input/text_editing_list_widget.dart';
import 'package:mistake_memo_view/widget/post/input/url_editing_list_widget.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/service/api/post_api_service.dart';
import 'package:mistake_memo_view/widget/common/snackBarWidget.dart';
import 'package:url_launcher/link.dart';

class PostRegisterWidget extends StatefulHookConsumerWidget {
  const PostRegisterWidget({super.key});

  @override
  PostRegisterWidgetState createState() => PostRegisterWidgetState();
}

class PostRegisterWidgetState extends ConsumerState<PostRegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final titleRegisterController = TextEditingController();
  final tagRegisterController = TextfieldTagsController();

  @override
  Widget build(BuildContext context) {
    final userAccount = AuthManagementService.getUserAccountGlobalState(ref);

    final isOpenState = useState<bool>(false);
    final occurrenceDateState = useState<DateTime?>(null);
    final causesState = useState<List<String>>([]);
    final refUrlsState = useState<List<UrlItem>>([]);

    final postLoadingState = useState<bool>(false);

    Future<void> submitPost() async {
      if (!postLoadingState.value) {
        postLoadingState.value = true;
        try {
          var tags = tagRegisterController.getTags;
          var tagInput = tagRegisterController.textEditingController!.text;
          if (tagInput.isNotEmpty) {
            tags?.add(tagInput);
          }
          await PostApiService.createPost(
            userAccount!.authToken,
            titleRegisterController.text,
            isOpenState.value,
            tags,
            occurrenceDateState.value,
            causesState.value.where((cause) => cause.isNotEmpty).toList(),
            refUrlsState.value
                .where((urlItem) => urlItem.url.isNotEmpty)
                .toList(),
          );
          // ignore: use_build_context_synchronously
          SnackBarWidget.showSnackBar(context, "投稿完了しました", "success");
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/');
        } catch (e) {
          SnackBarWidget.showSnackBar(context, "投稿に失敗しました", "error");
        }
        postLoadingState.value = false;
      }
    }

    return SingleChildScrollView(
        child: Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 20),
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: TextFormField(
                  controller: titleRegisterController,
                  decoration: InputDecoration(
                    label: Row(children: const [
                      Text('*', style: TextStyle(color: Colors.red)),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                      ),
                      Text("タイトル")
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
            ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    isOpenState.value ? const Text("公開") : const Text("非公開"),
                    const SizedBox(width: 20),
                    Switch(
                      value: isOpenState.value,
                      activeColor: Colors.blue,
                      activeTrackColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor:
                          const Color.fromARGB(255, 222, 220, 220),
                      onChanged: (bool e) => {isOpenState.value = e},
                    )
                  ],
                )),
            const SizedBox(height: 30),
            TagInputWidget(tagRegisterController: tagRegisterController),
            const SizedBox(height: 20),
            if (occurrenceDateState.value != null)
              Column(children: [
                Text(DateService.getStringFromDate(occurrenceDateState.value!)),
                const SizedBox(height: 5),
              ]),
            ElevatedButton(
              onPressed: () async =>
                  {DateService.selectDatePicker(context, occurrenceDateState)},
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
                backgroundColor: const Color.fromARGB(255, 38, 196, 177),
              ),
              child: const Text('発生日の選択'),
            ),
            const SizedBox(height: 20),
            if (causesState.value.isNotEmpty)
              Column(children: [
                ...causesState.value
                    .where((cause) => cause.isNotEmpty)
                    .map((cause) => Text(cause)),
                const SizedBox(height: 2),
              ]),
            ElevatedButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("原因の入力"),
                      content: SizedBox(
                          height: 450,
                          width: 360,
                          child: TextEditingListWidget(
                              textEditingListItemsState: causesState,
                              title: "原因")),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 40),
                          ),
                          child: const Text("入力終了"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                )
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
                backgroundColor: const Color.fromARGB(255, 38, 196, 177),
              ),
              child: const Text('原因の入力'),
            ),
            const SizedBox(height: 20),
            if (refUrlsState.value.isNotEmpty)
              Column(children: [
                ...refUrlsState.value
                    .where((item) => item.url.isNotEmpty)
                    .map((item) => Link(
                        uri: Uri.parse(item.url),
                        target: LinkTarget.blank,
                        builder: (BuildContext ctx, FollowLink? openLink) {
                          return TextButton(
                              onPressed: openLink,
                              child: Container(
                                  padding: const EdgeInsets.only(bottom: 0),
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.blue,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                      item.siteName.isNotEmpty
                                          ? item.siteName
                                          : item.url,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ))));
                        })),
                const SizedBox(height: 2),
              ]),
            ElevatedButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("参考URLの入力"),
                      content: SizedBox(
                          height: 450,
                          width: 360,
                          child: UrlEditingListWidget(
                              urlEditingListItemsState: refUrlsState)),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: const Size(200, 40),
                          ),
                          child: const Text("入力終了"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                )
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
                backgroundColor: const Color.fromARGB(255, 38, 196, 177),
              ),
              child: const Text('参考URLの入力'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async => {
                if (_formKey.currentState!.validate())
                  {
                    // 登録処理
                    await submitPost()
                  }
                else
                  {
                    // スナックバーの表示
                    SnackBarWidget.showSnackBar(
                        context, "入力内容に不備があります", "error")
                  }
              },
              style: ElevatedButton.styleFrom(fixedSize: const Size(250, 50)),
              child: const Text('投稿登録'),
            ),
            if (postLoadingState.value)
              Column(children: const [
                SizedBox(height: 10),
                CircularProgressIndicator(),
              ])
          ],
        ),
      ),
    ));
  }
}
