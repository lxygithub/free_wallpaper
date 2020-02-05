/*
  description:
  author:59432
  create_time:2020/1/26 22:08
*/

import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:free_wallpaper/constant.dart';
import 'package:free_wallpaper/net/http_callback.dart';

import 'address.dart';
import 'code.dart';
import 'logs_interceptor.dart';
import 'response_interceptor.dart';
import 'result_data.dart';

class HttpManager {
  static HttpManager _instance = HttpManager._internal();
  Dio _dio;

  static const CODE_SUCCESS = 200;
  static const CODE_TIME_OUT = -1;


  factory HttpManager() => _instance;

  ///通用全局单例，第一次使用时初始化
  HttpManager._internal({String baseUrl}) {
    if (null == _dio) {
      _dio = Dio(BaseOptions(
          baseUrl: Address.BASE_URL, connectTimeout: 15000));
      _dio.interceptors.add(LogsInterceptors());
      _dio.interceptors.add(ResponseInterceptors());
    }
  }

  static HttpManager getInstance({String baseUrl}) {
    if (baseUrl == null) {
      return _instance._normal();
    } else {
      return _instance._baseUrl(baseUrl);
    }
  }

  //用于指定特定域名，比如cdn和kline首次的http请求
  HttpManager _baseUrl(String baseUrl) {
    if (_dio != null) {
      _dio.options.baseUrl = baseUrl;
    }
    return this;
  }

  //一般请求，默认域名
  HttpManager _normal() {
    if (_dio != null) {
      if (_dio.options.baseUrl != Address.BASE_URL) {
        _dio.options.baseUrl = Address.BASE_URL;
      }
    }
    return this;
  }

  ///通用的GET请求
  get(api, HttpCallback callback) async {
    if (callback != null) {
      callback.onStart();
    }
    Response response;
    try {
      response = await _dio.get(api);
    } on DioError catch (e) {
      if (callback != null) {
        callback.onError(resultError(e));
      }
      return resultError(e);
    }

    if (response.data is DioError) {
      if (callback != null) {
        callback.onError(resultError(response.data['code']));
      }
      return resultError(response.data['code']);
    }

    if (callback != null) {
      callback.onSuccess(response.data);
    }
    return response.data;
  }

  ///通用的GET请求
  getHtml(api, HttpCallback callback, {bool defaultHeader = true}) async {
    if (callback != null) {
      callback.onStart();
    }
    Response response;
    try {
      if (defaultHeader) {
        response = await _dio.get(api, options: Options(headers: {"User-Agent": Constant.UA}));
      } else {
        response = await _dio.get(api);
      }
    } on DioError catch (e) {
      if (callback != null) {
        callback.onError(resultError(e));
      }
      return resultError(e);
    }

    if (response.data is DioError) {
      if (callback != null) {
        callback.onError(resultError(response.data['code']));
      }
      return resultError(response.data['code']);
    }

    if (callback != null) {
      callback.onSuccess(response.data);
    }
    return response.data;
  }

  ///通用的POST请求
  post(api, params, HttpCallback callback) async {
    if (callback != null) {
      callback.onStart();
    }
    Response response;

    try {
      response = await _dio.post(api, data: params);
    } on DioError catch (e) {
      if (callback != null) {
        callback.onError(resultError(e));
      }
      return resultError(e);
    }

    if (response.data is DioError) {
      if (callback != null) {
        callback.onError(resultError(response.data['code']));
      }
      return resultError(response.data['code']);
    }
    if (callback != null) {
      callback.onSuccess(response.data);
    }
    return response.data;
  }

}

ResultData resultError(DioError e) {
  Response errorResponse;
  if (e.response != null) {
    errorResponse = e.response;
  } else {
    errorResponse = Response(statusCode: 666);
  }
  if (e.type == DioErrorType.CONNECT_TIMEOUT ||
      e.type == DioErrorType.RECEIVE_TIMEOUT) {
    errorResponse.statusCode = Code.NETWORK_TIMEOUT;
  }
  return ResultData(
      errorResponse.statusMessage, false, errorResponse.statusCode);
}

