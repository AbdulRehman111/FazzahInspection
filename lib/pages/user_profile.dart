// ignore_for_file: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/storage.dart';



// ignore: must_be_immutable
class UserProfilePage extends StatelessWidget {


  // final box = GetStorage();
  var firstName = box.read('firstName')?? 'firstName';
  var lastName = box.read('lastName')?? 'lastName';
  var department = box.read('departmentNameEn')?? 'department';
  var passportNumber = box.read('passportNumber')?? 'passportNumber';
  var branch = box.read('branchNameEn')?? 'branch';
  var workingHourFrom = box.read('workingHourFrom')?? 'workingHourFrom';
  var workingHourTo = box.read('WorkingHourTo')?? 'WorkingHourTo';


  final String _status = "Software Developer";

  UserProfilePage({Key? key}) : super(key: key);


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    // final userProfilePic = box.read('profileURL') ?? 'Profile Pic';
    final userProfilePic = 'assets/userProfilePic.png';
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                userProfilePic,
              ), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
  }

  Widget _buildFullName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      firstName + ' ' + lastName ?? 'FullName',
      style: _nameTextStyle,
    );
  }
  Widget _buildFiniancialNo() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      passportNumber ?? 'passportNumber',
      style: _nameTextStyle,
    );
  }

  Widget _buildEmail() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      box.read('email')?? 'Email',
      style: _nameTextStyle,
    );
  }
  Widget _buildWorkingTime() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
    );

    return Text(
      workingHourFrom + ' till' + workingHourTo ??'Working Time',
      style: _nameTextStyle,
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        department +'/'+branch ?? 'Department',
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
  //
  // Widget _buildStatItem(String label, String count) {
  //   TextStyle _statLabelTextStyle = TextStyle(
  //     fontFamily: 'Roboto',
  //     color: Colors.black,
  //     fontSize: 16.0,
  //     fontWeight: FontWeight.w200,
  //   );
  //
  //   TextStyle _statCountTextStyle = TextStyle(
  //     color: Colors.black54,
  //     fontSize: 24.0,
  //     fontWeight: FontWeight.bold,
  //   );
  //
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       Text(
  //         count,
  //         style: _statCountTextStyle,
  //       ),
  //       Text(
  //         label,
  //         style: _statLabelTextStyle,
  //       ),
  //     ],
  //   );
  // }



  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic> user = Get.arguments['userData'] ;
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SafeArea(

            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: screenSize.height / 6.4),
                  _buildProfileImage(),
                  Center(child: _buildFullName()),
                  _buildFiniancialNo(),

                  _buildStatus(context),
                  _buildEmail(),

                  _buildSeparator(screenSize),
                  _buildWorkingTime(),
                  SizedBox(height: 10.0),

                  SizedBox(height: 10.0),
                  // Cards(),
                  Column(
                    children: [
                      Container(

                        child: ListTile(
                          title: Text('Home'),
                          tileColor: Get.currentRoute == '/home' ? Colors.grey[300] : null,
                          leading: Icon(
                            Icons.home,
                            color: Colors.blue,
                            size: 24.0,
                          ),
                trailing:
                Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 30.0),
                          onTap: () {
                            print(Get.currentRoute);
                            Get.back();
                            Get.offNamed('/home');
                          },
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Container(


                        child: ListTile(


                          title: Text('List'),
                          tileColor: Get.currentRoute == '/home' ? Colors.grey[300] : null,
                          leading: Icon(
                            Icons.list,
                            color: Colors.blue,
                            size: 24.0,
                          ),
                            trailing:
                            Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 30.0),
                          onTap: () {
                            print(Get.currentRoute);
                            Get.back();
                            Get.offNamed('/home');
                          },
                        ),
                      ),

                    ],
                  ),
                ],

              ),

            ),

          ),

         ]



      ),
    );
  }
}