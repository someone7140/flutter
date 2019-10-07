import 'package:flutter/material.dart';
import 'login.dart';
import 'top.dart';

class _MyAppInheritedWidget extends InheritedWidget {
  _MyAppInheritedWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  final HomePageState data;

  @override
  bool updateShouldNotify(_MyAppInheritedWidget oldWidget) {
    return true;
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  HomePageState createState() => HomePageState();

  static HomePageState of(BuildContext context, {bool rebuild = true}) {
    if (rebuild) {
      return (context.inheritFromWidgetOfExactType(_MyAppInheritedWidget) as _MyAppInheritedWidget).data;
    }
    return (context.ancestorWidgetOfExactType(_MyAppInheritedWidget) as _MyAppInheritedWidget).data;
  }
}

class HomePageState extends State<HomePage> {
  String screen = "/";
  bool isLogin = false;

  @override
  Widget build(BuildContext context) {
    return _MyAppInheritedWidget(
      data: this,
      child: widget.child,
    );
  }
}

class HeaderWidget extends StatefulWidget {
  @override
  HeaderWidgetState createState() => HeaderWidgetState();
}

class HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    bool isLogin = HomePage.of(context, rebuild: true).isLogin;
    List<Widget> widgetList = new List();
    widgetList.add(
      Text('test')
    );
    widgetList.add(
      RaisedButton(
        child: Text("TOP"),
        color: Colors.orange,
        textColor: Colors.white,
        onPressed: () {
          // TOP画面へ遷移させる
          final HomePageState state = HomePage.of(context, rebuild: false);
          state.setState(() { state.screen = "/"; });
        },
      )
    );
    if (!isLogin) {
      widgetList.add(
        RaisedButton(
          child: Text("ログイン"),
          color: Colors.orange,
          textColor: Colors.white,
          onPressed: () {
            // ログイン画面へ遷移させる
            final HomePageState state = HomePage.of(context, rebuild: false);
            state.setState(() { state.screen = "/login"; });
          }
        )
      );
    } else {
      widgetList.add(
        RaisedButton(
          child: Text("ログアウト"),
          color: Colors.orange,
          textColor: Colors.white,
          onPressed: () {
            final HomePageState state = HomePage.of(context, rebuild: false);
            // top画面へ遷移させる+ログインフラグを更新
            state.setState(() { state.isLogin = false; state.screen = "/login"; });
          }
        )
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgetList
    );
  }
}

class BodyContainer extends StatefulWidget {
  @override
  _BodyContainer createState() => _BodyContainer();
}

class _BodyContainer extends State<BodyContainer> {
  @override
  Widget build(BuildContext context) {
    // HomePageStateが変わったら呼び出される。
    final HomePageState state = HomePage.of(context);
    if (state.screen == "/") {
      return new Top();
    } else {
      return new Login();
    }
  }
}
