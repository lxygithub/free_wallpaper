import 'package:free_wallpaper/model/wallpaper_entity.dart';
import 'package:free_wallpaper/model/wallpaper_list_entity.dart';

wallpaperListEntityFromJson(WallpaperListEntity data, Map<String, dynamic> json) {
	if (json['errno'] != null) {
		data.errno = json['errno']?.toString();
	}
	if (json['errmsg'] != null) {
		data.errmsg = json['errmsg']?.toString();
	}
	if (json['consume'] != null) {
		data.consume = json['consume']?.toString();
	}
	if (json['total'] != null) {
		data.total = json['total']?.toString();
	}
	if (json['data'] != null) {
		data.data = new List<WallpaperEntity>();
		(json['data'] as List).forEach((v) {
			data.data.add(new WallpaperEntity().fromJson(v));
		});
	}
	return data;
}

Map<String, dynamic> wallpaperListEntityToJson(WallpaperListEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['errno'] = entity.errno;
	data['errmsg'] = entity.errmsg;
	data['consume'] = entity.consume;
	data['total'] = entity.total;
	if (entity.data != null) {
		data['data'] =  entity.data.map((v) => v.toJson()).toList();
	}
	return data;
}

wallpaperListDataFromJson(WallpaperEntity data, Map<String, dynamic> json) {
	if (json['id'] != null) {
		data.id = json['id']?.toString();
	}
	if (json['class_id'] != null) {
		data.classId = json['class_id']?.toString();
	}
	if (json['resolution'] != null) {
		data.resolution = json['resolution']?.toString();
	}
	if (json['url_mobile'] != null) {
		data.urlMobile = json['url_mobile']?.toString();
	}
	if (json['url'] != null) {
		data.url = json['url']?.toString();
	}
	if (json['url_thumb'] != null) {
		data.urlThumb = json['url_thumb']?.toString();
	}
	if (json['url_mid'] != null) {
		data.urlMid = json['url_mid']?.toString();
	}
	if (json['download_times'] != null) {
		data.downloadTimes = json['download_times']?.toString();
	}
	if (json['imgcut'] != null) {
		data.imgcut = json['imgcut']?.toString();
	}
	if (json['tag'] != null) {
		data.tag = json['tag']?.toString();
	}
	if (json['create_time'] != null) {
		data.createTime = json['create_time']?.toString();
	}
	if (json['update_time'] != null) {
		data.updateTime = json['update_time']?.toString();
	}
	if (json['utag'] != null) {
		data.utag = json['utag']?.toString();
	}
	if (json['tempdata'] != null) {
		data.tempdata = json['tempdata']?.toString();
	}
	if (json['img_1600_900'] != null) {
		data.img1600900 = json['img_1600_900']?.toString();
	}
	if (json['img_1440_900'] != null) {
		data.img1440900 = json['img_1440_900']?.toString();
	}
	if (json['img_1366_768'] != null) {
		data.img1366768 = json['img_1366_768']?.toString();
	}
	if (json['img_1280_800'] != null) {
		data.img1280800 = json['img_1280_800']?.toString();
	}
	if (json['img_1280_1024'] != null) {
		data.img12801024 = json['img_1280_1024']?.toString();
	}
	if (json['img_1024_768'] != null) {
		data.img1024768 = json['img_1024_768']?.toString();
	}
	return data;
}

Map<String, dynamic> wallpaperListDataToJson(WallpaperEntity entity) {
	final Map<String, dynamic> data = new Map<String, dynamic>();
	data['id'] = entity.id;
	data['class_id'] = entity.classId;
	data['resolution'] = entity.resolution;
	data['url_mobile'] = entity.urlMobile;
	data['url'] = entity.url;
	data['url_thumb'] = entity.urlThumb;
	data['url_mid'] = entity.urlMid;
	data['download_times'] = entity.downloadTimes;
	data['imgcut'] = entity.imgcut;
	data['tag'] = entity.tag;
	data['create_time'] = entity.createTime;
	data['update_time'] = entity.updateTime;
	data['utag'] = entity.utag;
	data['tempdata'] = entity.tempdata;
	data['img_1600_900'] = entity.img1600900;
	data['img_1440_900'] = entity.img1440900;
	data['img_1366_768'] = entity.img1366768;
	data['img_1280_800'] = entity.img1280800;
	data['img_1280_1024'] = entity.img12801024;
	data['img_1024_768'] = entity.img1024768;
	return data;
}