/*
  description:
  author:59432
  create_time:2020/2/9 19:40
*/
import 'dart:async';

import 'package:flutter/services.dart';

class MediaStoreManager {

  static const MethodChannel _channel = const MethodChannel('MediaStorePlugin');

  static Future<String> refreshMedia(String filePath) async {
    var result = await _channel.invokeMethod('refreshMediaStore', filePath);
    return result;
  }

}