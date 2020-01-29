/*
  description:
  author:59432
  create_time:2020/1/29 0:19
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///加载弹框
class LoadingDialog {
  static bool _isShowing = false;

  ///展示
  static void showProgress(BuildContext context,
      {Widget child = const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),)}) {
    if (!_isShowing) {
      _isShowing = true;
      Future.delayed(Duration()).then((e) {
        Navigator.push(
          context,
          _PopRoute(
            child: _Progress(
              child: child,
            ),
          ),
        );
      });
    }
  }

  ///隐藏
  static void dismiss(BuildContext context) {
    if (_isShowing) {
      Navigator.of(context).pop();
      _isShowing = false;
    }
  }
}

///Widget
class _Progress extends StatelessWidget {
  final Widget child;

  _Progress({
    Key key,
    @required this.child,
  })
      : assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Center(
          child: child,
        ));
  }
}

///Route
class _PopRoute extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  _PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

