import 'package:flutter/material.dart';

import '../widget/common/appBarWidget.dart';
import '../widget/common/drawerWidget.dart';

class TopPage extends StatelessWidget {
  const TopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        appBar: AppBarWidget(), drawer: DrawerWidget(), body: Text("Top"));
  }
}
