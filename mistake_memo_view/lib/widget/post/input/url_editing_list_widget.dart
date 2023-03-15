import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistake_memo_view/model/view/post/text_editing_list_item.dart';
import 'package:mistake_memo_view/model/view/post/url_item.dart';
import 'package:mistake_memo_view/service/api/post_api_service.dart';
import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/service/common/debounce_service.dart';

class UrlEditingListWidget extends StatefulHookConsumerWidget {
  final ValueNotifier<List<UrlItem>> urlEditingListItemsState;
  const UrlEditingListWidget(
      {super.key, required this.urlEditingListItemsState});

  @override
  UrlEditingListWidgetState createState() => UrlEditingListWidgetState();
}

class UrlEditingListWidgetState extends ConsumerState<UrlEditingListWidget> {
  @override
  Widget build(BuildContext context) {
    final userAccount = AuthManagementService.getUserAccountGlobalState(ref);
    final debouncer = DebounceService(milliseconds: 1500);

    final textEditingList = useState<List<TextEditingListItem>>(
        widget.urlEditingListItemsState.value.isEmpty
            ? [
                TextEditingListItem.create(0, ""),
                TextEditingListItem.create(1, ""),
              ]
            : widget.urlEditingListItemsState.value
                .map((item) {
                  return [
                    TextEditingListItem.create(item.id, item.url),
                    TextEditingListItem.create(item.id + 1, item.url)
                  ];
                })
                .expand((item) => item)
                .toList());

    List<UrlItem> convertToUrlItemFromTextItem(
        List<TextEditingListItem> textItems) {
      return textItems.where((item) => item.id % 2 == 0).map((item) {
        final siteNameElements = textEditingList.value
            .where((itemSiteName) => (item.id + 1) == itemSiteName.id);
        return UrlItem(
            id: item.id,
            url: item.text,
            siteName:
                siteNameElements.isNotEmpty ? siteNameElements.first.text : "");
      }).toList();
    }

    void add() {
      textEditingList.value = [
        ...textEditingList.value,
        TextEditingListItem.create(textEditingList.value.length, ""),
        TextEditingListItem.create(textEditingList.value.length + 1, "")
      ];
    }

    void updateStateByTextChange(String changedText, TextEditingListItem item) {
      textEditingList.value = textEditingList.value
          .map((e) => e.id == item.id ? item.change(changedText) : e)
          .toList();
      widget.urlEditingListItemsState.value =
          convertToUrlItemFromTextItem(textEditingList.value);
    }

    void textChange(String changedText, TextEditingListItem item) async {
      // stateの更新
      updateStateByTextChange(changedText, item);
      // URLの入力があってサイト名が入力されていない
      if (item.id % 2 == 0) {
        if (textEditingList.value[item.id + 1].text.isEmpty) {
          // URLからサイト名を取得
          debouncer.run(() async {
            try {
              if (textEditingList.value[item.id + 1].text.isEmpty) {
                final siteNameFromUrl = await PostApiService.getSiteNameFromUrl(
                    userAccount!.authToken, changedText);
                // stateの更新
                updateStateByTextChange(
                    siteNameFromUrl, textEditingList.value[item.id + 1]);
              }
            } catch (e) {
              // エラーの時は何もしない
            }
          });
        }
      }
    }

    void remove(int id) {
      // itemのcontrollerをすぐdisposeすると怒られるので
      // 少し時間をおいてからdispose()
      final removeItem =
          textEditingList.value.firstWhere((element) => element.id == id);
      final removeItemSiteName =
          textEditingList.value.firstWhere((element) => element.id == (id + 1));
      Future.delayed(const Duration(seconds: 1)).then((value) {
        removeItem.dispose();
        removeItemSiteName.dispose();
      });

      // stateの更新
      textEditingList.value = textEditingList.value
          .where((element) => id != element.id && (id + 1) != element.id)
          .toList()
          .asMap()
          .entries
          .map((entry) {
        return TextEditingListItem(
            id: entry.key,
            controller: entry.value.controller,
            text: entry.value.text);
      }).toList();
      widget.urlEditingListItemsState.value =
          convertToUrlItemFromTextItem(textEditingList.value);
    }

    void removeUrl(int id) {
      remove(id);
      remove(id + 1);
    }

    Widget textFieldItem(TextEditingListItem item, bool displayDelete) {
      return Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextFormField(
                controller: item.controller,
                decoration: InputDecoration(
                  label: Row(children: [
                    item.id % 2 == 0
                        ? const Text("URLを入力")
                        : const Text("サイト名を入力")
                  ]),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (text) {
                  textChange(text, item);
                },
              ),
            ),
            if (displayDelete)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  removeUrl(item.id);
                },
              ),
          ],
        ),
      ]);
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 450, minHeight: 100),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: [
          ...textEditingList.value
              .map((item) => item.id % 2 == 0
                  ? [textFieldItem(item, true), const SizedBox(height: 5)]
                  : [textFieldItem(item, false), const SizedBox(height: 10)])
              .expand((element) => element),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 38, 196, 177),
            ),
            onPressed: () {
              add();
            },
            child: const Text("URLを追加"),
          )
        ],
      ),
    );
  }
}
