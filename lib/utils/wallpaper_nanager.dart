/*
  description:
  author:59432
  create_time:2020/2/9 19:40
*/
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:free_wallpaper/net/download_manager.dart';
import 'package:free_wallpaper/utils/app_utlis.dart';
import 'package:path_provider/path_provider.dart';

class WallpaperManager {

  static String _filePath;
  static const MethodChannel _channel = const MethodChannel('WallpaperPlugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> homeScreen(String imagePath) async {
    if (imagePath.startsWith("http")) {
      await _download(imagePath);
      imagePath = _filePath;
    }
    final String resultvar = await _channel.invokeMethod('HomeScreen', imagePath);
    return resultvar;
  }

  static Future<String> lockScreen(String imagePath) async {
    if (imagePath.startsWith("http")) {
      await _download(imagePath);
      imagePath = _filePath;
    }
    final String resultvar =
    await _channel.invokeMethod('LockScreen', imagePath);
    return resultvar;
  }

  static Future<String> bothScreen(String imagePath) async {
    if (imagePath.startsWith("http")) {
      await _download(imagePath);
      imagePath = _filePath;
    }
    final String resultvar =
    await _channel.invokeMethod('Both', imagePath);
    return resultvar;
  }

  static Future<String> systemScreen(String imagePath) async {
    if (imagePath.startsWith("http")) {
      await _download(imagePath);
      imagePath = _filePath;
    }
    final String resultvar =
    await _channel.invokeMethod('SystemWallpaer', imagePath);
    return resultvar;
  }


  static _download(String url) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    _filePath = "$dir${Platform.pathSeparator}${AppUtils.getFileNameFormUrl(url)}";
    await DownloadManager.getInstance().download(url, _filePath, (int count, int total) {
      if (count==total) {

      }
    });
  }

}