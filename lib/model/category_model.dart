/*
  description:
  author:59432
  create_time:2020/1/28 10:51
*/

class CategoryModel {

  String name;
  String src;
  String href;
  String color;
  bool checked;

  String type;

  ///0：设备 1：风格 2：尺寸 3：颜色
  int tagType;

  CategoryModel({this.name, this.src, this.href, this.color, this.tagType=0, this.type,this.checked=false});

}