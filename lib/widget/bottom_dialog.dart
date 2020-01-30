/*
  description:
  author:59432
  create_time:2020/1/30 12:44
*/

import 'package:flutter/material.dart';

class BottomSheetDialog{

  static showDialog(BuildContext context,{Function function1,Function function2,Function function3,}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Colors.transparent,
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text('设置为桌面壁纸'),
                    onTap: () {
                      Navigator.pop(context);
                      if(function1!=null){
                        function1();
                      }
                    },
                  ),
                ),
                Divider(height: 1,),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text('设置为锁屏壁纸'),
                    onTap: () {
                      Navigator.pop(context);
                      if(function2!=null){
                        function2();
                      }
                    },
                  ),
                ),
                Divider(height: 1,),
                Expanded(
                  flex: 1,
                  child: ListTile(
                    title: Text('设置为桌面和锁屏壁纸'),
                    onTap: () {
                      Navigator.pop(context);
                      if(function3!=null){
                        function3();
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }
}