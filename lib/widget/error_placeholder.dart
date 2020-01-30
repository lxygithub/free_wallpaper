/*
  description:
  author:59432
  create_time:2020/1/30 15:06
*/

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ErrorPlaceHolder extends StatelessWidget {
  Widget child;

  ErrorPlaceHolder({this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: child != null ? child : Material(
        color: Colors.white70,
        child: Image.asset("icons/pic_loading_error.png"),
      ),
    );
  }

}