package wallpaper.cn.mewlxy.free_wallpaper

import android.Manifest
import android.annotation.TargetApi
import android.app.Activity
import android.app.WallpaperManager
import android.content.ActivityNotFoundException
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.io.File
import java.io.IOException


/** WallpaperPlugin  */
class WallpaperPlugin : FlutterActivity(), FlutterPlugin, MethodCallHandler {
    private var id = 0
    private var res = ""
    private var channel: MethodChannel?=null


    @TargetApi(Build.VERSION_CODES.FROYO)
    private fun setWallpaper(i: Int, imagePath: String): String {
        id = i
        val wallpaperManager = WallpaperManager.getInstance(activity)
        val file = File(imagePath)
        // set bitmap to wallpaper
        val bitmap = BitmapFactory.decodeFile(file.absolutePath)
        if (id == 1) {
            try {
                res = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                    wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_SYSTEM)
                    "Home Screen Set Successfully"
                } else {
                    "To Set Home Screen Requires Api Level 24"
                }
            } catch (ex: IOException) {
                ex.printStackTrace()
            }
        } else if (id == 2) try {
            res = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                wallpaperManager.setBitmap(bitmap, null, true, WallpaperManager.FLAG_LOCK)
                "Lock Screen Set Successfully"
            } else {
                "To Set Lock Screen Requires Api Level 24"
            }
        } catch (e: IOException) {
            res = e.toString()
            e.printStackTrace()
        } else if (id == 3) {
            try {
                wallpaperManager.setBitmap(bitmap)
                res = "Home And Lock Screen Set Successfully"
            } catch (e: IOException) {
                res = e.toString()
                e.printStackTrace()
            }
        } else if (id == 4) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (activity.checkSelfPermission(Manifest.permission.READ_EXTERNAL_STORAGE)
                        != PackageManager.PERMISSION_GRANTED &&
                        activity.checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE)
                        != PackageManager.PERMISSION_GRANTED) {
                    activity.requestPermissions(arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.WRITE_EXTERNAL_STORAGE), 1)
                } else {
                    Uri.fromFile(file)
                    val contentURI = getImageContentUri(this, file)
                    val intent = Intent(wallpaperManager.getCropAndSetWallpaperIntent(contentURI))
                    val mime = "image/*"
                    intent.setDataAndType(contentURI, mime)
                    try {
                        startActivityForResult(intent, 2)
                    } catch (e: ActivityNotFoundException) { //handle error
                        res = "Error To Set Wallpaer"
                    }
                }
            }
        }
        return res
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent) {
        Log.d("Tag", "resultcode=" + resultCode + "requestcode=" + requestCode)
        res = when (resultCode) {
            Activity.RESULT_OK -> {
                "System Screen Set Successfully"
            }
            Activity.RESULT_CANCELED -> {
                "setting Wallpaper Cancelled"
            }
            else -> {
                "Something Went Wrong"
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }




    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("" + Build.VERSION.RELEASE)
            "HomeScreen" -> result.success(setWallpaper(1, call.arguments as String))
            "LockScreen" -> result.success(setWallpaper(2, call.arguments as String))
            "Both" -> result.success(setWallpaper(3, call.arguments as String))
            "SystemWallpaer" -> result.success(setWallpaper(4, call.arguments as String))
            else -> result.notImplemented()
        }
    }


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "wallpaper.cn.mewlxy.free_wallpaper.WallpaperPlugin")
        channel!!.setMethodCallHandler(WallpaperPlugin())

    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel!!.setMethodCallHandler(null)
        channel=null
    }

    companion object {

        fun getImageContentUri(context: Context, imageFile: File): Uri? {
            val filePath = imageFile.absolutePath
            Log.d("Tag", filePath)
            val cursor = context.contentResolver.query(
                    MediaStore.Images.Media.EXTERNAL_CONTENT_URI, arrayOf(MediaStore.Images.Media._ID),
                    MediaStore.Images.Media.DATA + "=? ", arrayOf(filePath), null)
            return if (cursor != null && cursor.moveToFirst()) {
                val id = cursor.getInt(cursor
                        .getColumnIndex(MediaStore.MediaColumns._ID))
                val baseUri = Uri.parse("content://media/external/images/media")
                Uri.withAppendedPath(baseUri, "" + id)
            } else {
                if (imageFile.exists()) {
                    val values = ContentValues()
                    values.put(MediaStore.Images.Media.DATA, filePath)
                    context.contentResolver.insert(
                            MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
                } else {
                    null
                }
            }
        }
    }

}