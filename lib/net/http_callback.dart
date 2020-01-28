/*
  description:
  author:59432
  create_time:2020/1/26 23:10
*/


import 'result_data.dart';

typedef OnStart = void Function();
typedef OnSuccess = void Function(ResultData data);
typedef OnError = void Function(ResultData e);

class HttpCallback {
  OnStart onStart;
  OnSuccess onSuccess;
  OnError onError;

  HttpCallback({this.onStart, this.onSuccess, this.onError});
}