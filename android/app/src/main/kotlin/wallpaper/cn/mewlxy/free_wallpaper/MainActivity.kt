package wallpaper.cn.mewlxy.free_wallpaper

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val flutterEngine = FlutterEngine(this)
        flutterEngine.plugins.add(WallpaperPlugin())
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }


}
