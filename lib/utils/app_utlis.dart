/*
  description:
  author:59432
  create_time:2020/1/29 18:11
*/


import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';

import '../constant.dart';

class AppUtils {
  static getFileNameFormUrl(String url) {
    return url
        .split("/")
        .last;
  }

  static getDownloadPath() async {
    var downloadPath = (await DownloadsPathProvider.downloadsDirectory).path;
    return "$downloadPath${Platform.pathSeparator}${Constant.APP_DOWNLOAD_DIRECTORY}${Platform.pathSeparator}";
  }
}