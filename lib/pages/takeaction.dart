
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// Page Three
class TakeAction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Action page'),
      ),
      body: Center(
        child: Text(
          Get.arguments['id'] ?? 'Page Three',
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
