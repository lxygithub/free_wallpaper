/*
  description:
  author:59432
  create_time:2020/1/26 22:14
*/

import 'package:dio/dio.dart';
import 'result_data.dart';

class ResponseInterceptors extends InterceptorsWrapper {
  @override
  onResponse(Response response) async {
    RequestOptions option = response.request;
    try {

      ///一般只需要处理200的情况，300、400、500保留错误信息，外层为http协议定义的响应码
      if (response.statusCode == 200 || response.statusCode == 201) {
        return new ResultData(response.data, true, 200,
            headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + option.path);

      return new ResultData(response.data, false, response.statusCode,
          headers: response.headers);
    }

    return new ResultData(response.data, false, response.statusCode,
        headers: response.headers);
  }
}