package wallpaper.cn.mewlxy.free_wallpaper

import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.provider.MediaStore
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File


/**
 * description：
 * author：luoxingyuan
 */
class MediaStorePlugin constructor(var mContext: Context) : FlutterPlugin, MethodChannel.MethodCallHandler {
    private var channel: MethodChannel?=null
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "MediaStorePlugin")
        channel!!.setMethodCallHandler(MediaStorePlugin(mContext))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        channel=null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "refreshMediaStore" -> result.success(sendMediaBroadcast(call.arguments as String))
            else -> result.notImplemented()
        }
    }

    private fun sendMediaBroadcast(filePath: String) {
        val file = File(filePath)
        //通知相册更新
        MediaStore.Images.Media.insertImage(mContext.contentResolver, BitmapFactory.decodeFile(file.absolutePath), file.name, null)
        val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
        val uri: Uri = Uri.fromFile(file)
        intent.data = uri
        mContext.sendBroadcast(intent)
    }

}