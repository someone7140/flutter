import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../model/post_item.dart';

class TechRecentPostsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '技術系投稿最新記事',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TechRecentPostsAppHome(title: '技術系投稿最新記事'),
    );
  }
}

class TechRecentPostsAppHome extends StatefulWidget {
  TechRecentPostsAppHome({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _TechRecentPostsAppHome createState() =>
      _TechRecentPostsAppHome(title: title);
}

class _TechRecentPostsAppHome extends State<TechRecentPostsAppHome> {
  final String title;
  var postList = [];
  var displayList = [];
  var formatter = new DateFormat('yyyy/MM/dd HH:mm', "ja_JP");
  bool loading = false;

  _TechRecentPostsAppHome({this.title});

  Future<List> getApiRecentPosts() async {
    var url = Uri.parse(env['API_DOMMIN'] + "/recentPosts");
    var resp = await http.get(url);
    return json.decode(resp.body);
  }

  Future<void> addDisplayList() async {
    if (loading) {
      return null;
    }
    loading = true;
    try {
      var displayListLength = displayList.length;
      var postListLength = postList.length;
      if (displayListLength < postListLength) {
        var firstIndex = displayListLength;
        var addIndex = 10;
        var lastIndex = firstIndex + addIndex < postListLength
            ? firstIndex + addIndex
            : postListLength;
        var addPostList = postList.sublist(firstIndex, lastIndex);
        // 追加対象の投稿に対しOGPの情報取得
        var url = Uri.parse(env['API_DOMMIN'] + "/ogpInfo");
        Map<String, String> headers = {'content-type': 'application/json'};
        List<PostItem> postRequests = [];
        addPostList.forEach((p) => {postRequests.add(PostItem.fromJson(p))});
        String body = json.encode(postRequests);
        http.Response resp = await http.post(url, headers: headers, body: body);
        if (resp.statusCode == 200) {
          setState(() {
            displayList = displayList + json.decode(resp.body);
          });
        }
      } else {
        return null;
      }
    } finally {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: new Container(
            child: new FutureBuilder<List>(
                future: getApiRecentPosts(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    postList = snapshot.data;
                    addDisplayList();
                  }
                  return new ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= postList.length) {
                        // 全投稿を読み切ったのでnullを返す
                        return null;
                      } else if (index == displayList.length) {
                        // アイテム数を超えたので次のページを読み込む
                        addDisplayList();
                        // 画面にはローディング表示しておく
                        return new Center(
                          child: new Container(
                            margin: const EdgeInsets.only(top: 8.0),
                            width: 32.0,
                            height: 32.0,
                            child: const CircularProgressIndicator(),
                          ),
                        );
                      } else if (index > displayList.length) {
                        // ローディング表示より先は無し
                        return null;
                      }

                      var displayPost = displayList[index];
                      var displayUpdateAt = formatter
                          .format(DateTime.parse(displayPost["updated_at"]));

                      return new Container(
                          child: new Card(
                              child: Column(children: [
                        ListTile(
                          title: new Center(child: Text(displayPost["title"])),
                        ),
                        new MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () async {
                                await launch(displayPost["url"]);
                              },
                              child: Image.network(
                                displayPost["image"],
                                width: 500,
                                fit: BoxFit.fitWidth,
                              )),
                        ),
                        new Center(
                            child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(displayUpdateAt),
                        ))
                      ])));
                    },
                  );
                })));
  }
}
