package wallpaper.cn.mewlxy.free_wallpaper

import android.app.Activity
import android.content.Context
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.app.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.File


class SetWallpaperPlugin constructor(private val mContext: Context) : FlutterActivity(), FlutterPlugin, MethodCallHandler {
    private var channel: MethodChannel? = null


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "goToSystemWallPaperManager" -> result.success(settingWallpaper(call.arguments as String))
            else -> result.notImplemented()
        }
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "SetWallpaperPlugin")
        channel!!.setMethodCallHandler(SetWallpaperPlugin(mContext))

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        channel = null
    }

    private fun settingWallpaper(filePath: String) {
        val intent = Intent(Intent.ACTION_ATTACH_DATA)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
        intent.putExtra("mimeType", "image/*")
        val photoURI = FileProvider.getUriForFile(mContext, mContext.applicationContext.packageName.toString() + ".provider", File(filePath))
        intent.data = photoURI
        (mContext as Activity).startActivity(intent)
    }

}