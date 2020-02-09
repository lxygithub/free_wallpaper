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
import android.os.Bundle
import android.provider.MediaStore
import io.flutter.Log
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File
import java.io.IOException


/** WallpaperPlugin  */
class WallpaperPlugin private constructor(var activity: FlutterActivity, private val channel: MethodChannel, private val mRegistrar: Registrar) : FlutterActivity(), MethodCallHandler {
    private var id = 0
    private var res = ""
    override fun onCreate(savedInstanceState: Bundle) {
        super.onCreate(savedInstanceState)
        channel.setMethodCallHandler(this)
    }

    private val activeContext: Context
        get() = if (mRegistrar.activity() != null) mRegistrar.activity() else mRegistrar.context()

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
                    val contentURI = getImageContentUri(activeContext, file)
                    val intent = Intent(wallpaperManager.getCropAndSetWallpaperIntent(contentURI))
                    val mime = "image/*"
                    intent.setDataAndType(contentURI, mime)
                    try {
                        mRegistrar.activity().startActivityForResult(intent, 2)
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
        res = if (resultCode == Activity.RESULT_OK) {
            "System Screen Set Successfully"
        } else if (resultCode == Activity.RESULT_CANCELED) {
            "setting Wallpaper Cancelled"
        } else {
            "Something Went Wrong"
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    companion object {
        const val MY_PERMISSIONS_REQUEST_READ_EXTERNAL_STORAGE = 123
        /**
         * HomeScreen
         * Plugin registration.
         */
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "wallpaper")
            channel.setMethodCallHandler(WallpaperPlugin(registrar.activity() as FlutterActivity, channel, registrar))
        }

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