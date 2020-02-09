/*
  description:
  author:59432
  create_time:2020/2/9 19:40
*/
import 'dart:async';

import 'package:flutter/services.dart';

class Wallpaper {

  static const MethodChannel _channel = const MethodChannel('wallpaper');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> homeScreen(String imagePath) async {
    final String resultvar =
    await _channel.invokeMethod('HomeScreen', imagePath);
    return resultvar;
  }

  static Future<String> lockScreen(String imagePath) async {
    final String resultvar =
    await _channel.invokeMethod('LockScreen', imagePath);
    return resultvar;
  }

  static Future<String> bothScreen(String imagePath) async {
    final String resultvar =
    await _channel.invokeMethod('Both', imagePath);
    return resultvar;
  }

  static Future<String> systemScreen(String imagePath) async {
    final String resultvar =
    await _channel.invokeMethod('SystemWallpaer', imagePath);
    return resultvar;
  }

}