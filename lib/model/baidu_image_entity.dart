import 'package:json_annotation/json_annotation.dart'; 
  
part 'baidu_image_entity.g.dart';


@JsonSerializable()
  class BaiduImageEntity extends Object {

  @JsonKey(name: 'queryEnc')
  String queryEnc;

  @JsonKey(name: 'queryExt')
  String queryExt;

  @JsonKey(name: 'listNum')
  int listNum;

  @JsonKey(name: 'displayNum')
  int displayNum;

  @JsonKey(name: 'data')
  List<Data> data;

  BaiduImageEntity(this.queryEnc,this.queryExt,this.listNum,this.displayNum,this.data,);

  factory BaiduImageEntity.fromJson(Map<String, dynamic> srcJson) => _$BaiduImageEntityFromJson(srcJson);

  Map<String, dynamic> toJson() => _$BaiduImageEntityToJson(this);

}

  
@JsonSerializable()
  class Data extends Object {

  @JsonKey(name: 'thumbURL')
  String thumbURL;

  @JsonKey(name: 'middleURL')
  String middleURL;

  @JsonKey(name: 'largeTnImageUrl')
  String largeTnImageUrl;

  @JsonKey(name: 'hasLarge')
  int hasLarge;

  @JsonKey(name: 'hoverURL')
  String hoverURL;

  @JsonKey(name: 'pageNum')
  int pageNum;

  @JsonKey(name: 'fromURLHost')
  String fromURLHost;

  @JsonKey(name: 'width')
  int width;

  @JsonKey(name: 'height')
  int height;

  @JsonKey(name: 'type')
  String type;

  @JsonKey(name: 'is_gif')
  int isGif;

  @JsonKey(name: 'replaceUrl')
  List<ReplaceUrl> replaceUrl;

  @JsonKey(name: 'bdImgnewsDate')
  String bdImgnewsDate;

  @JsonKey(name: 'fromPageTitleEnc')
  String fromPageTitleEnc;

  @JsonKey(name: 'cs')
  String cs;

  @JsonKey(name: 'os')
  String os;

  @JsonKey(name: 'simid')
  String simid;

  Data(this.thumbURL,this.middleURL,this.largeTnImageUrl,this.hasLarge,this.hoverURL,this.pageNum,this.fromURLHost,this.width,this.height,this.type,this.isGif,this.replaceUrl,this.bdImgnewsDate,this.fromPageTitleEnc,this.cs,this.os,this.simid,);

  factory Data.fromJson(Map<String, dynamic> srcJson) => _$DataFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataToJson(this);

}

  
@JsonSerializable()
  class ReplaceUrl extends Object {

  @JsonKey(name: 'ObjURL')
  String objURL;

  @JsonKey(name: 'ObjUrl')
  String objUrl;

  @JsonKey(name: 'FromURL')
  String fromURL;

  @JsonKey(name: 'FromUrl')
  String fromUrl;

  ReplaceUrl(this.objURL,this.objUrl,this.fromURL,this.fromUrl,);

  factory ReplaceUrl.fromJson(Map<String, dynamic> srcJson) => _$ReplaceUrlFromJson(srcJson);

  Map<String, dynamic> toJson() => _$ReplaceUrlToJson(this);

}

  
