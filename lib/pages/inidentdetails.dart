import 'package:flutter/material.dart';
import '../main.dart';
import 'package:get/get.dart';

class IncidentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incident Details'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Get.off(HomePage()),
          child: Text('Go Home'),
        ),
      ),
    );
  }
}
