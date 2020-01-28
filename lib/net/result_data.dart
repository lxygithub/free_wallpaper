/*
  description:
  author:59432
  create_time:2020/1/26 22:14
*/

class ResultData {
  String data;
  bool isSuccess;
  int code;
  var headers;

  ResultData(this.data, this.isSuccess, this.code, {this.headers});
}