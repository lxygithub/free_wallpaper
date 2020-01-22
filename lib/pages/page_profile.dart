import 'package:flutter/material.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:59
*/

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'),
      ),
    );
  }
}