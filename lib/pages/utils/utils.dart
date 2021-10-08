// ignore_for_file: import_of_legacy_library_into_null_safe
import '../../theme/storage.dart';
import 'package:get/get.dart';



class Utils extends GetxController {


}

void logout(){
  print('logout');
  box.remove('isLogin');
  Get.back();

}

