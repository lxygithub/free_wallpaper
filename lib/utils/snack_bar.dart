/*
  description:
  author:59432
  create_time:2020/1/30 9:12
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SnackBarUtil {
  static showSnake(BuildContext context, String content, {String label = "确定", Function action}) {
    final snackBar = SnackBar(
      content: Text(content, style: TextStyle(color: Colors.white, fontSize: 16),),
      backgroundColor: Colors.lightBlueAccent,
      action: SnackBarAction(
        label: label,
        textColor: Colors.white,
        onPressed: action != null ? action : () {
          // Some code to undo the change.
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }
}