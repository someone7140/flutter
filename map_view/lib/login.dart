import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';

class Login extends StatefulWidget {
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  bool _authFailed = true;

  // メールアドレス更新用メソッド
  void _updateEmail(String email) {
    setState(() {
      _email = email;
    });
  }
  // パスワード更新用メソッド
  void _updatePassword(String password) {
    setState(() {
      _password = password;
    });
  }
  // 認証失敗フラグ更新用メソッド
  void _updateAuthFailed(bool authFailed) {
    setState(() {
      _authFailed = authFailed;
    });
  }

  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child:
        Scaffold(
          body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 20),
                child: TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'メールアドレス',
                  ),
                  inputFormatters: <TextInputFormatter> [
                    WhitelistingTextInputFormatter(RegExp(r'[0-9a-zA-Z -/:-@[~]'))
                  ],
                  // 入力内容に対するバリデーション
                  validator: (value){
                    // 入力内容が空でないかチェック
                    if (value.isEmpty) {
                      return 'メールアドレスを入力してください。';
                    } else {
                      return null;
                    }
                  },
                  // _formKey.currentState.save() 呼び出し時に実行する処理
                  onSaved: (value) {
                    _updateEmail(value);
                  }
                )
              ),
              Container(
                width: 300,
                margin: const EdgeInsets.only(bottom: 30),
                child: TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'パスワード',
                  ),
                  inputFormatters: <TextInputFormatter> [
                    WhitelistingTextInputFormatter(RegExp(r'[0-9a-zA-Z -/:-@[~]'))
                  ],
                  // 入力内容に対するバリデーション
                  validator: (value){
                    // 入力内容が空でないかチェック
                    if (value.isEmpty) {
                      return 'パスワードを入力してください。';
                    } else {
                      return null;
                    }
                  },
                  // _formKey.currentState.save() 呼び出し時に実行する処理
                  onSaved: (value) {
                    _updatePassword(value);
                  }
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: RaisedButton(
                  child: Text("ログイン"),
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: (){
                    _updateAuthFailed(false);
                    // バリデーションチェック
                    if (_formKey.currentState.validate()) {
                      final HomePageState state = HomePage.of(context, rebuild: false);
                      // メッセージを表示
                      Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('ログインしました')));
                      // TOP画面へ遷移 + ログインフラグを更新
                      state.setState(() { state.isLogin = true; state.screen = "/";});
                    }
                  }
                )
              ),
              Visibility(
                visible: this._authFailed,
                child: Text(
                  '認証に失敗しました',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              )
            ],
          ),
        )
      )
    );
  }
}
