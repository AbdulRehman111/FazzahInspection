// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';
import "package:get_storage/get_storage.dart";
import 'package:path_provider/path_provider.dart';
import '../pages/resources/change_languages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

const mainURL = 'portal.fujmun.gov.ae';
// const mainURL = 'dev.fujmun.gov.ae';
const fileURl =
    r'https://www.fujmun.gov.ae/Localwebapi/Mobile/FileHandler.asmx/GetFiles?filePath=\\192.168.2.8\\\\WebApplicationfiles$\\\\fazzah/uploadedFujairah/';

final box = GetStorage();

void showErrorToast(msg) {
  // ignore: void_checks
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showSuccessToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}

// Future<File?> downloadFile(String url, name) async {
//   final appStore = await getApplicationDocumentsDirectory();
//   final file = File('${appStore.path}/$name');
//   try {
//     final response = await Dio().get(url,
//         options: Options(
//           responseType: ResponseType.bytes,
//           followRedirects: false,
//           receiveTimeout: 0,
//         ));
//     final raf = file.openSync(mode: FileMode.write);
//     raf.writeFromSync(response.data);
//     await raf.close();
//     return file;
//   } catch (e) {
//     return null;
//   }
// }

MyController myController = Get.put(MyController());

// The easiest way for creating RFlutter Alert

