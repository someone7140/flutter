import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300,
              margin: const EdgeInsets.only(bottom: 20),
              child: TextField(
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ユーザID',
                ),
                inputFormatters: <TextInputFormatter> [
                  WhitelistingTextInputFormatter(RegExp(r'[0-9a-zA-Z -/:-@[~]'))
                ]
              )
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.only(bottom: 30),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'パスワード',
                ),
                inputFormatters: <TextInputFormatter> [
                  WhitelistingTextInputFormatter(RegExp(r'[0-9a-zA-Z -/:-@[~]'))
                ]
              ),
            ),
            RaisedButton(
              child: Text("ログイン"),
              color: Colors.green,
              textColor: Colors.white,
              onPressed: (){
                final HomePageState state = HomePage.of(context, rebuild: false);
                // TOP画面へ遷移 + ログインフラグを更新
                state.setState(() { state.isLogin = true; state.screen = "/";});
              }
            )
          ],
        ),
      )
    );
  }
}
