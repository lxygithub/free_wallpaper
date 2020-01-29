/*
  description:
  author:59432
  create_time:2020/1/29 18:22
*/

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/utils/toast.dart';

///进度
class LinearProgressDialog {
  bool _isShowing = false;
  double maxProgress;
  _Progress _progress;
  _ProgressState _progressState;

  ///展示
  void showProgress(BuildContext context, double maxProgress, double currentProgress) {
    this.maxProgress = maxProgress;
    _progress = _Progress(maxProgress);
    _progressState = _progress.createState();
    if (!_isShowing) {
      _isShowing = true;
      Future.delayed(Duration()).then((e) {
        Navigator.push(
          context,
          _PopRoute(
            child: _progress,
          ),
        );
      });
    } else {
      _updateProgress(currentProgress);
    }
  }

  _updateProgress(double currentProgress) {
    _progressState.updateProgress(currentProgress);
  }

}

// ignore: must_be_immutable
class _Progress extends StatefulWidget {
  double maxProgress;

  _Progress(this.maxProgress);

  @override
  State<StatefulWidget> createState() => _ProgressState(maxProgress);

}

class _ProgressState extends State<_Progress> {
  double _progressValue = 0;
  double _maxProgress;


  _ProgressState(this._maxProgress);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 300,
          height: 200,
          child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 200,
                    child: LinearProgressIndicator(
                      value: _progressValue,
                    ),
                  ),
                  Text('${((_progressValue / _maxProgress) * 100).round()}%'),
                ],
              )
          ),
        ),
      ),
    );
  }

  // we use this function to simulate a download
  // by updating the progress value
  void updateProgress(double currentProgress) {
    _progressValue = currentProgress;
    if (mounted) {
      setState(() {

      });
    }
    // we "finish" downloading here
    if (currentProgress >= _maxProgress) {
      ToastUtil.showToast("下载成功");
        Navigator.of(context).pop();
    }
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