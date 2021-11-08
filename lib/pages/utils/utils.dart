// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/storage.dart';
import 'package:get/get.dart';

class Utils extends GetxController {}

void logout() {
  print('logout');
  box.remove('isLogin');
  Get.back();
}

class ImageDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        height: 500,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/splash1.png'),
                fit: BoxFit.cover)),
      ),
    );
  }
}
