// // // main.dart
// // ignore: import_of_legacy_library_into_null_safe
// //import 'package:easy_localization/easy_localization.dart';
// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
// import 'dart:math';
import 'package:get/get.dart';
import 'pages/inbox.dart';
import 'pages/archive.dart';
import 'theme/theme_service.dart';
import 'theme/themes.dart';

import 'theme/storage.dart';
import 'pages/comments.dart';
import 'pages/login.dart';
import 'pages/resources/app_translation.dart';
import "package:get_storage/get_storage.dart";
import './pages/home.dart';

void main() async {
  await GetStorage.init();

  var landingPage = '';
  var isLogin = box.read('isLogin').toString();

  if (isLogin == true || isLogin == 'true') {
    landingPage = '/home';
  } else {
    landingPage = '/login';
  }
  print(isLogin);
  print(landingPage);
  // final cameras = await availableCameras();
  runApp(GetMaterialApp(
    navigatorKey: Get.key,
    debugShowCheckedModeBanner: false,
    translations: AppTranslation(),
    locale: Locale('en', 'US'),
    fallbackLocale: Locale('en', 'US'),
    theme: Themes.light.copyWith(
      hintColor: Colors.white,
    ),
    darkTheme: Themes.dark.copyWith(
      hintColor: Colors.black,
    ),
    themeMode: ThemeService().theme,

    initialRoute: landingPage,
    // initialRoute: '/home',
    getPages: [
      GetPage(
        name: '/home',
        page: () => Home(),
        binding: HomeBinding(),
      ),
      GetPage(
        name: '/inbox',
        page: () => InboxPage(),
        binding: InboxBinding(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: '/archive',
        page: () => Archive(),
        binding: ArchiveBinding(),
      ),
      // GetPage(
      //   name: '/camara',
      //   page: () => CameraScreen(cameras: cameras),
      //   binding: CameraBinding(),
      // ),
      GetPage(
        name: '/comments',
        page: () => Comments(),
        binding: CommentsBinding(),
      ),
    ],
  ));
}

class InboxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InboxController());
  }
}

// // class Inbox extends GetView<InboxController> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Inbox')),
// //       drawer: MainDrawer(),
// //
// //       body: Center(
// //         child: Text(controller.title),
// //       ),
// //     );
// //   }
// // }
// //
class InboxController extends GetxController {
  final title = 'Inbox';

  @override
  void onInit() {
    print('>>> InboxController init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> InboxController ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> Page1Controller close');
    super.onClose();
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class LoginController extends GetxController {
  final title = 'Page 2';

  @override
  void onInit() {
    print('>>> Page2Controller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> Page2Controller ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> Page2Controller close');
    super.onClose();
  }
}

class CommentsController extends GetxController {
  final title = 'Comments ';

  @override
  void onInit() {
    print('>>> Page2Controller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> Page2Controller ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> Page2Controller close');
    super.onClose();
  }
}

class ArchiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
  }
}

class CommentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CommentsController());
  }
}

class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraController());
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class ArchiveController extends GetxController {
  final title = 'Page 2';

  @override
  void onInit() {
    print('>>> Page2Controller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> Page2Controller ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> Page2Controller close');
    super.onClose();
  }
}

class CameraController extends GetxController {
  final title = 'Page 2';

  @override
  void onInit() {
    print('>>> Page2Controller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> Page2Controller ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> Page2Controller close');
    super.onClose();
  }
}

class HomeController extends GetxController {
  final title = 'Home';

  @override
  void onInit() {
    print('>>> Page2Controller init');
    super.onInit();
  }

  @override
  void onReady() {
    print('>>> Page2Controller ready');
    super.onReady();
  }

  @override
  void onClose() {
    print('>>> Page2Controller close');
    super.onClose();
  }
}
// import 'package:flutter/material.dart';
// import 'pages/inbox.dart';
// import 'theme/colors.dart';
//
// void main() => runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           primaryColor: primary
//       ),
//       home: IndexPage(),
//     )
// );