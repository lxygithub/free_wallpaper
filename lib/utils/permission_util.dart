/*
  description:
  author:59432
  create_time:2020/1/29 12:23
*/

import 'package:flutter/material.dart';
import 'package:free_wallpaper/listener/dialog_listener.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  static requestPermissions(List<PermissionGroup> perms) async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions(perms);
    return permissions;
  }

  static checkingPermission(PermissionGroup perm) async {
    PermissionStatus permissionStatus = await PermissionHandler().checkPermissionStatus(perm);
    return permissionStatus;
  }

  ///检查服务状态仅对Android上的PermissionGroup.location和iOS上的PermissionGroup.location ，
  ///PermissionGroup.locationWhenInUser ， PermissionGroup.locationAlways或PermissionGroup.sensors有意义.
  ///所有其他权限组都不由单独的服务支持，并且始终返回ServiceStatus.notApplicable .
  static checkingLocationServiceStatus() async {
    ServiceStatus serviceStatus = await PermissionHandler().checkServiceStatus(PermissionGroup.location);
    return serviceStatus;
  }

  static openAppSetting() async {
    bool isOpened = await PermissionHandler().openAppSettings();
    return isOpened;
  }

  static showRationale(context, String title, { String left = "取消", String right = "确定", DialogListener dialogListener}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: <Widget>[
            FlatButton(
              child: Text(left),
              onPressed: () {
                Navigator.of(context).pop();
                if (dialogListener!=null) {
                  dialogListener.onConfirm();
                }
              },
            ),
            FlatButton(
              child: Text(right),
              onPressed: () {
                Navigator.of(context).pop();
                if (dialogListener!=null) {
                  dialogListener.onCancel();
                }
              },
            ),
          ],
        );
      },
    );
  }

}