import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:free_wallpaper/constant.dart';
import 'package:free_wallpaper/widget/bottom_navigation_bar.dart';

import 'SplashPage.dart';

void main() {
  runApp(MyApp());
  _getDownloadPath();
}

_getDownloadPath() async {
  DownloadsPathProvider.downloadsDirectory.then((value) {
    var dirPath = "${value.path}${Platform.pathSeparator}${Constant.APP_DOWNLOAD_DIRECTORY}";
    var folder = Directory(dirPath);
    if (!folder.existsSync()) {
      folder.create();
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: SplashPage(),
        routes: <String, WidgetBuilder>{
          'router/bottom_navigation': (_) => new BottomNavigationWidget()
        }
    );
  }
}


