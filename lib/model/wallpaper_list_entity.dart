import 'package:free_wallpaper/generated/json/base/json_convert_content.dart';
import 'package:free_wallpaper/model/wallpaper_entity.dart';

class WallpaperListEntity with JsonConvert<WallpaperListEntity> {
	String errno;
	String errmsg;
	String consume;
	String total;
	List<WallpaperEntity> data;
}

