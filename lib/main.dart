// main.dart
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';
import 'pages/inbox.dart';
import 'pages/inidentdetails.dart';
import 'pages/takeaction.dart';
import 'pages/login.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'FazzahInspection',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
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
        title: Text('Fazzah Inspector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Navigate ising screen classes'),
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
          ],
        ),
      ),
    );
  }
}



