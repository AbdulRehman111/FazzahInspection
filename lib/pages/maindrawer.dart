// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Fazzah Inspection'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Home'),
            tileColor: Get.currentRoute == '/home' ? Colors.grey[300] : null,
            onTap: () {
              print(Get.currentRoute);
              Get.back();
              Get.offNamed('/home');
            },
          ),
          ListTile(
            title: Text('Login'),
            tileColor: Get.currentRoute == '/login' ? Colors.grey[300] : null,
            onTap: () {
              Get.back();
              Get.offNamed('/login');
            },
          ),
          ListTile(
            title: Text('Inbox'),
            tileColor: Get.currentRoute == '/page2' ? Colors.grey[300] : null,
            onTap: () {
              Get.back();
              Get.offNamed('/page2');
            },
          ),
           ListTile(
            title: Text('Archive'),
            tileColor: Get.currentRoute == '/archive' ? Colors.grey[300] : null,
            onTap: () {
              Get.back();
              Get.offNamed('/archive');
            },
          ),
         
        ],
      ),
    );
  }
}
