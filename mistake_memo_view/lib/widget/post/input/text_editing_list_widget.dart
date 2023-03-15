import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mistake_memo_view/model/view/post/text_editing_list_item.dart';

class TextEditingListWidget extends StatefulHookConsumerWidget {
  final ValueNotifier<List<String>> textEditingListItemsState;
  final String title;
  const TextEditingListWidget(
      {super.key,
      required this.textEditingListItemsState,
      required this.title});

  @override
  TextEditingListWidgetState createState() => TextEditingListWidgetState();
}

class TextEditingListWidgetState extends ConsumerState<TextEditingListWidget> {
  @override
  Widget build(BuildContext context) {
    final textEditingList = useState<List<TextEditingListItem>>(widget
            .textEditingListItemsState.value.isEmpty
        ? [TextEditingListItem.create(0, "")]
        : widget.textEditingListItemsState.value.asMap().entries.map((entry) {
            return TextEditingListItem.create(entry.key, entry.value);
          }).toList());

    void add() {
      textEditingList.value = [
        ...textEditingList.value,
        TextEditingListItem.create(textEditingList.value.length, "")
      ];
    }

    void textChange(String changedText, TextEditingListItem item) {
      textEditingList.value = textEditingList.value
          .map((e) => e.id == item.id ? item.change(changedText) : e)
          .toList();
      widget.textEditingListItemsState.value =
          textEditingList.value.map((e) => e.text).toList();
    }

    void remove(int id) {
      // itemのcontrollerをすぐdisposeすると怒られるので
      // 少し時間をおいてからdispose()
      final removeItem =
          textEditingList.value.firstWhere((element) => element.id == id);
      Future.delayed(const Duration(seconds: 1)).then((value) {
        removeItem.dispose();
      });

      // stateの更新
      textEditingList.value = textEditingList.value
          .where((element) => id != element.id)
          .toList()
          .asMap()
          .entries
          .map((entry) {
        return TextEditingListItem(
            id: entry.key,
            controller: entry.value.controller,
            text: entry.value.text);
      }).toList();
      widget.textEditingListItemsState.value =
          textEditingList.value.map((e) => e.text).toList();
    }

    Widget textFieldItem(
      TextEditingListItem item,
    ) {
      return Column(children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: TextFormField(
                controller: item.controller,
                decoration: InputDecoration(
                  label: Row(children: [Text(widget.title)]),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (text) {
                  textChange(text, item);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                remove(item.id);
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
          ...textEditingList.value.map((item) => textFieldItem(item)),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 38, 196, 177),
            ),
            onPressed: () {
              add();
            },
            child: Text("${widget.title}を追加"),
          )
        ],
      ),
    );
  }
}
