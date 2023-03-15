import 'package:flutter/material.dart';

class TextEditingListItem {
  final int id;
  final TextEditingController controller;
  final String text;

  TextEditingListItem({
    required this.id,
    required this.controller,
    required this.text,
  });

  factory TextEditingListItem.create(int id, String text) {
    return TextEditingListItem(
      id: id,
      text: text,
      controller: TextEditingController(text: text),
    );
  }

  TextEditingListItem change(String text) {
    return TextEditingListItem(id: id, text: text, controller: controller);
  }

  void dispose() {
    controller.dispose();
  }

  @override
  String toString() {
    return text;
  }
}
