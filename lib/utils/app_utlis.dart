/*
  description:
  author:59432
  create_time:2020/1/29 18:11
*/

class AppUtils {
  static getFileNameFormUrl(String url) {
    return url
        .split("/")
        .last;
  }
}