import 'package:flutter/material.dart';

import 'package:get/get.dart';

// Inbox
class Inbox extends StatelessWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              Get.arguments['id'] ?? 'Page One',
              style: const TextStyle(fontSize: 40),
            ),
            
           
              
            
          ],
        ),
      ),
    );
  }
}
