import 'package:flutter/material.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:59
*/

class AlarmPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AlarmPageState();
}

class AlarmPageState extends State<AlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('alarm'),
      ),
    );
  }
}