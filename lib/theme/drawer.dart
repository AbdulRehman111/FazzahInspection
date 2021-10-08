// ignore_for_file: import_of_legacy_library_into_null_safe
import '../../theme/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/inbox.dart';
import '../pages/home.dart';
import '../pages/archive.dart';
import '../pages/login.dart';





int _selectedDestination = 0;
class Utils extends GetxController {


}

void logout(){
  print('logout');
  box.remove('isLogin');
  Get.back();

}

class MainDrawer extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    var firstName = box.read('firstName')?? 'firstName';
    var lastName = box.read('lastName')?? 'lastName';
    var department = box.read('departmentNameEn')?? 'department';
    var passportNumber = box.read('passportNumber')?? 'passportNumber';
    var phoneNumber = box.read('phoneNumber')?? 'phoneNumber';
    var branch = box.read('branchNameEn')?? 'branch';
    var workingHourFrom = box.read('workingHourFrom')?? 'workingHourFrom';
    var workingHourTo = box.read('WorkingHourTo')?? 'WorkingHourTo';
    var email = box.read('email')?? 'email';
    var profileURL = box.read('profileURL')?? 'email';
    final userProfilePic = 'assets/userProfilePic1.jpg';
    List<bool> _selections = List.generate(2, (_) => false);
    return Drawer(

      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            color: Colors.blueAccent,
            child: Column(


              children: [

                Center(

                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(userProfilePic), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(80.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 10.0,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      firstName + ' ' + lastName ?? 'FullName',
                      style: textTheme.headline6,
                    ),
                    Text(
                      phoneNumber ?? 'phoneNumber',
                      style: textTheme.headline6,
                    ),
                    Text(

                      email ?? 'Email',
                      style: textTheme.headline6,


                    ),
                  ],
                ),

              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'.tr),
            tileColor: Get.currentRoute == '/home' ? Colors.blueAccent[300] : null,
            selected: _selectedDestination == 0,
            onTap: ()  {
              Get.back();
              Get.offNamed('/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.archive),
            tileColor: Get.currentRoute == '/archive' ? Colors.blueAccent[300] : null,
            title: Text('Archive'.tr),
            selected: _selectedDestination == 1,
            onTap: () {
              Get.back();
              Get.to(Archive(), arguments: {'userId': box.read('userId').toString()});
            },
          ),
          ListTile(
            leading: Icon(Icons.inbox),
            title: Text('Inbox'.tr),
            tileColor: Get.currentRoute == '/inbox' ? Colors.blueAccent[300] : null,
            selected: _selectedDestination == 2,
            onTap: ()  {
              Get.back();
              Get.to(InboxPage(), arguments: {'userId': box.read('userId').toString()});
            },
          ),
          ListTile(
            leading: Icon(Icons.login),
            title: Text('Login'.tr),
            tileColor: Get.currentRoute == '/login' ? Colors.blueAccent[300] : null,
            selected: _selectedDestination == 2,
            onTap: () {
              Get.back();
              Get.to(Login());
            },
          ),
          //    ListTile(
          //      leading: Icon(Icons.inbox),
          //      title: Text('reportIncidents'.tr),
          // //     tileColor: Get.currentRoute == '/inbox' ? Colors.grey[300] : null,
          //      selected: _selectedDestination == 2,
          //      onTap: () => {},
          //    ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'.tr),
            //     tileColor: Get.currentRoute == '/logout' ? Colors.grey[300] : null,
            selected: _selectedDestination == 2,
            onTap: ()  {
              logout();
              Get.back();
              Get.offNamed('/login');
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Change Language',
                ),
              ),
              Container(

                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                // padding: EdgeInsets.all(20),
                //
                child: ToggleButtons(

                  children: [
                    TextButton(
                      child: Text("Set to ARABIC"),
                      onPressed: () {
                        myController.changeLanguage('ar','ae');
                      },
                    ),
                    TextButton(
                      child: Text("Set to ENGLISH"),
                      onPressed: ()  {
                        myController.changeLanguage('en','US');
                      },
                    ),
                  ],
                  isSelected: _selections,
                  onPressed: (int index) {

                  },
                ),

              ),
            ],
          ),




        ],

      ),
    );
  }
}
final makeBottom = Container(
  height: 55.0,
  child: BottomAppBar(

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.star, color: Colors.blueAccent),
          onPressed: (){
            Home();
          },

        ),
        IconButton(
          icon: Icon(Icons.inbox, color: Colors.blueAccent),
          onPressed: (){
            InboxPage();
          },
        ),
        IconButton(
          icon: Icon(Icons.password, color: Colors.blueAccent),
          onPressed:(){

          } ,
        ),
        IconButton(

            icon: Icon(Icons.logout, color: Colors.blueAccent),
            onPressed:(){
              logout();
            }





        )
      ],
    ),
  ),
);
