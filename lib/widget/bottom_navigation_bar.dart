import 'package:flutter/material.dart';
import 'package:free_wallpaper/pages/page_mobile.dart';
import 'package:free_wallpaper/pages/page_categories.dart';
import 'package:free_wallpaper/pages/page_home.dart';
import 'package:free_wallpaper/pages/page_profile.dart';

/*
  description:
  author:59432
  create_time:2020/1/22 12:53
*/


class BottomNavigationWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BottomNavigationWidgetState();
}


class BottomNavigationWidgetState extends State<BottomNavigationWidget> with SingleTickerProviderStateMixin {
  List<Widget> pages = [];
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages..add(HomePage())..add(CategoriesPage())..add(MobilePage())..add(ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 14,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.lightBlueAccent,
        showUnselectedLabels: true,
        selectedIconTheme: IconThemeData(color: Colors.lightBlueAccent, size: 24),
        unselectedIconTheme: IconThemeData(color: Colors.grey, size: 24),
        selectedLabelStyle: TextStyle(color: Colors.lightBlueAccent),
        unselectedLabelStyle: TextStyle(color: Colors.grey),
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              title: Container(
                child: Text(
                  '首页',
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.computer,
              ),
              title: Text(
                'PC壁纸',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.phone_android,
              ),
              title: Text(
                '手机壁纸',
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.android,
              ),
              title: Text(
                '我',
              )),
        ],
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
