// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'baidu_image_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaiduImageEntity _$BaiduImageEntityFromJson(Map<String, dynamic> json) {
  return BaiduImageEntity(
    json['queryEnc'] as String,
    json['queryExt'] as String,
    json['listNum'] as int,
    json['displayNum'] as int,
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BaiduImageEntityToJson(BaiduImageEntity instance) =>
    <String, dynamic>{
      'queryEnc': instance.queryEnc,
      'queryExt': instance.queryExt,
      'listNum': instance.listNum,
      'displayNum': instance.displayNum,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['thumbURL'] as String,
    json['middleURL'] as String,
    json['largeTnImageUrl'] as String,
    json['hasLarge'] as int,
    json['hoverURL'] as String,
    json['pageNum'] as int,
    json['fromURLHost'] as String,
    json['width'] as int,
    json['height'] as int,
    json['type'] as String,
    json['is_gif'] as int,
    json['bdImgnewsDate'] as String,
    json['fromPageTitleEnc'] as String,
    json['cs'] as String,
    json['os'] as String,
    json['simid'] as String,
    json['di'] as String,
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'thumbURL': instance.thumbURL,
      'middleURL': instance.middleURL,
      'largeTnImageUrl': instance.largeTnImageUrl,
      'hasLarge': instance.hasLarge,
      'hoverURL': instance.hoverURL,
      'pageNum': instance.pageNum,
      'fromURLHost': instance.fromURLHost,
      'width': instance.width,
      'height': instance.height,
      'type': instance.type,
      'is_gif': instance.isGif,
      'bdImgnewsDate': instance.bdImgnewsDate,
      'fromPageTitleEnc': instance.fromPageTitleEnc,
      'cs': instance.cs,
      'os': instance.os,
      'simid': instance.simid,
      'di': instance.di,
    };
