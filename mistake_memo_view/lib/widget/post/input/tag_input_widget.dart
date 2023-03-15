import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:textfield_tags/textfield_tags.dart';

import 'package:mistake_memo_view/service/auth/auth_management_service.dart';
import 'package:mistake_memo_view/service/api/post_api_service.dart';
import 'package:mistake_memo_view/service/common/debounce_service.dart';

class TagInputWidget extends StatefulHookConsumerWidget {
  final TextfieldTagsController? tagRegisterController;
  const TagInputWidget({super.key, this.tagRegisterController});

  @override
  TagInputWidgetState createState() => TagInputWidgetState();
}

class TagInputWidgetState extends ConsumerState<TagInputWidget> {
  @override
  Widget build(BuildContext context) {
    final userAccount = AuthManagementService.getUserAccountGlobalState(ref);
    final tagSelectListState = useState<List<String>>([]);
    final debouncer = DebounceService(milliseconds: 1000);
    final tagRegisterController = widget.tagRegisterController;

    Future<void> onTagTextChanged(
        String value, TextEditingController ttec) async {
      if (value.isNotEmpty) {
        debouncer.run(() async {
          try {
            // API経由で候補を取得
            tagSelectListState.value =
                (await PostApiService.getTagsFromStartWordWithAuth(
                        userAccount!.authToken, value))
                    .map((tag) => tag.tagWord)
                    .toList();

            ttec.notifyListeners();
          } catch (e) {
            tagSelectListState.value = [];
          }
        });
      }
    }

    return Autocomplete<String>(
      optionsViewBuilder: (context, onSelected, options) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: ConstrainedBox(
                constraints:
                    const BoxConstraints(maxHeight: 300, maxWidth: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final dynamic option = options.elementAt(index);
                    return TextButton(
                      onPressed: () {
                        onSelected(option);
                      },
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: Text(
                            '#$option',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 74, 137, 92),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<String>.empty();
        } else {
          return tagSelectListState.value.where((String option) {
            return option.startsWith(textEditingValue.text);
          });
        }
      },
      onSelected: (String selectedTag) {
        widget.tagRegisterController!.addTag = selectedTag;
      },
      fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
        return TextFieldTags(
          textEditingController: ttec,
          focusNode: tfn,
          textfieldTagsController: tagRegisterController,
          initialTags: const [],
          textSeparators: const [' '],
          letterCase: LetterCase.normal,
          validator: (String tag) {
            if (tagRegisterController!.getTags != null &&
                tagRegisterController.getTags!.contains(tag)) {
              return '登録済みのタグです';
            }
            return null;
          },
          inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
            return ((context, sc, tags, onTagDelete) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 350),
                    child: TextField(
                      controller: tec,
                      focusNode: fn,
                      decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 74, 137, 92),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 74, 137, 92),
                            width: 3.0,
                          ),
                        ),
                        hintText: tagRegisterController!.hasTags
                            ? ''
                            : "タグをスペース区切りで入力してください",
                        errorText: error,
                        prefixIconConstraints:
                            const BoxConstraints(maxWidth: 400),
                        prefixIcon: tags.isNotEmpty
                            ? SingleChildScrollView(
                                controller: sc,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: tags.map((String tag) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      color: Color.fromARGB(255, 74, 137, 92),
                                    ),
                                    margin: const EdgeInsets.only(right: 10.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Text(
                                            '#$tag',
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            //print("$tag selected");
                                          },
                                        ),
                                        const SizedBox(width: 4.0),
                                        InkWell(
                                          child: const Icon(
                                            Icons.cancel,
                                            size: 14.0,
                                            color: Color.fromARGB(
                                                255, 233, 233, 233),
                                          ),
                                          onTap: () {
                                            onTagDelete(tag);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                              )
                            : null,
                      ),
                      onChanged: (v) async {
                        onChanged!(v);
                        // テキスト入力が変わったら候補リストを更新
                        await onTagTextChanged(v, ttec);
                      },
                      onSubmitted: onSubmitted,
                    )),
              );
            });
          },
        );
      },
    );
  }
}
