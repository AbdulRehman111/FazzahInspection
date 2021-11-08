// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MyController extends GetxController {
  void changeLanguage(var param1, var param2) {
    var locale = Locale(param1, param2);
    print(locale);
    Get.updateLocale(locale);
  }

  //void app_header_pagename(pagename, width, height) {

}
