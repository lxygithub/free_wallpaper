package wallpaper.cn.mewlxy.free_wallpaper

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(WallpaperPlugin(applicationContext))
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

}
