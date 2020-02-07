/*
  description:
  author:59432
  create_time:2020/1/26 22:08
*/

import 'package:dio/dio.dart';
import 'package:free_wallpaper/constant.dart';

import 'address.dart';
import 'logs_interceptor.dart';

class DownloadManager {
  static DownloadManager _instance = DownloadManager._internal();
  Dio _dio;

  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;


  factory DownloadManager() => _instance;

  ///通用全局单例，第一次使用时初始化
  DownloadManager._internal({String baseUrl}) {
    if (null == _dio) {
      _dio =  Dio( BaseOptions(connectTimeout: 15000));
      _dio.interceptors.add( LogsInterceptors());
    }
  }

  static DownloadManager getInstance() {
      return _instance._normal();
  }

  //一般请求，默认域名
  DownloadManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != Address.BASE_URL) {
        _dio.options.baseUrl = Address.BASE_URL;
      }
    }
    return this;
  }

  download(api, savePath, ProgressCallback progressCallback) async {
    Response response;
    try {
      response = await _dio.download(api, savePath, onReceiveProgress: progressCallback,
          options: Options(headers: {"User-Agent":Constant.UA},contentType: "image/jpeg"),
          deleteOnError: true);
    } on DioError catch (e) {
      return e.error;
    }

    return response.data;
  }
}

