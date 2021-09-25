// main.dart
// ignore: import_of_legacy_library_into_null_safe
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'pages/inbox.dart';
import 'pages/inidentdetails.dart';
import 'pages/takeaction.dart';
import 'pages/login.dart';
void main() {
  runApp(EasyLocalization(child: MyApp(),
  path: "resources/langs",
  saveLocale: true,
  supportedLocales: [
    Locale('en','US'),
    Locale('ar','AR')
  ],));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'FazzahInspection',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: HomePage(),
      getPages: [
        GetPage(name: '/page-three', page: () => TakeAction()),
        GetPage(
            name: '/page-four/:data', page: () => Login()) // Dynamic route
      ],
    );
  }
}

// Home Screen
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('title').tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget> [
            Text('hello').tr(),
           
            ElevatedButton(
                onPressed: () => Get.to(Inbox(), arguments: {
                      'id': '657657657575765'
                    }), // Passing data by using "arguments"
                child: Text('Go to page One')),
            ElevatedButton(
                onPressed: () => Get.off(IncidentDetails()),
                child: Text('Go to page Two (Can not go back)')),
            Divider(),
            Text('Navigate Using named routes'),
            OutlinedButton(
                onPressed: () => Get.toNamed('/page-three',
                    arguments: {'id': Random().nextInt(10000).toString()}),
                child: Text('Go to page Three')),
            OutlinedButton(
                onPressed: () => Get.toNamed(
                      '/page-four/${Random().nextInt(10000)}',
                    ),
                child: Text('Go to page Four'))
          ,
          ],
        ),
      ),
    );
  }
}



