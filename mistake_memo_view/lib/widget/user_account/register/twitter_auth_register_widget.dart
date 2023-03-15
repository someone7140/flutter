import 'package:flutter/material.dart';

class TwitterAuthRegisterWidget extends StatelessWidget {
  const TwitterAuthRegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> handleSignIn() async {}

    return ElevatedButton(
      onPressed: handleSignIn,
      style: ElevatedButton.styleFrom(fixedSize: const Size(150, 50)),
      child: const Text('Twitter 認証'),
    );
  }
}
