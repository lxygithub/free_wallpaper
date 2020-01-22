import 'package:flutter/material.dart';
import 'package:free_wallpaper/pages/page_alarm.dart';
import 'package:free_wallpaper/pages/page_email.dart';
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
  List<Widget> pages = List<Widget>();
  final _bottomNavigationColor = Colors.pink;
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pages..add(HomePage())..add(EmailPage())..add(AlarmPage())..add(ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'HOME',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.email,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'Email',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.pages,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'PAGES',
                style: TextStyle(color: _bottomNavigationColor),
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.airplay,
                color: _bottomNavigationColor,
              ),
              title: Text(
                'AIRPLAY',
                style: TextStyle(color: _bottomNavigationColor),
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
