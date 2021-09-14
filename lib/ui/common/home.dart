import 'package:flutter/material.dart';

import '../../common/functions.dart';
import '../../common/widgets.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    print('in homePage init going to switchUser');
    Fun.switchUser(context);

  }

  @override
  Widget build(BuildContext context) {
    return Widgets.loading();
  }
}
