/*
  description:
  author:59432
  create_time:2020/2/8 16:24
*/

import 'package:flutter/cupertino.dart';
class EmptyPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EmptyPageState();
  }

}
class EmptyPageState extends State<EmptyPage>{

  String labelText;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Text("抱歉，未找到任何内容"),
    );
  }

}
