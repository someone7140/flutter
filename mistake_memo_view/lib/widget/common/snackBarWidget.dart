import 'package:flutter/material.dart';

class SnackBarWidget extends StatelessWidget {
  const SnackBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  static showSnackBar(
    BuildContext context,
    String message,
    String type,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
        ),
        backgroundColor: type == "error" ? Colors.red : Colors.lightGreen));
  }
}
