/*
  description:
  author:59432
  create_time:2020/1/27 14:15
*/
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtil {

  static showToast(String msg, {length = Toast.LENGTH_SHORT, gravity = ToastGravity.BOTTOM,
    fontSize = 16.0, bgColor = Colors.black54, textColor = Colors.white}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: length,
        gravity: gravity,
        timeInSecForIos: 1,
        backgroundColor: bgColor,
        textColor: textColor,
        fontSize: fontSize
    );
  }
}