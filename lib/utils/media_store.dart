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

class MediaStoreManager {

  static const MethodChannel _channel = const MethodChannel('MediaStorePlugin');

  static Future<String> refreshMedia(String filePath) async {
    var result = await _channel.invokeMethod('refreshMediaStore', filePath);
    return result;
  }

}