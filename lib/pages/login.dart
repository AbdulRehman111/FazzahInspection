// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:async';
import 'dart:io';
import 'inbox.dart';
import 'home.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import '../theme/storage.dart';

//
// class Login extends StatelessWidget {
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Login',
//       theme:Themes.light,
//       darkTheme: Themes.dark,
//      // theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//      //   primarySwatch: Colors.blue,
//      // ),
//       home: RegisterForm(title: 'Flutter Login'),
//     );
//   }
// }
//
// class RegisterForm extends StatefulWidget {
//
//   RegisterForm({Key? key, required this.title}) : super(key: key);
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//
//
//   @override
//   _RegisterFormState createState() => _RegisterFormState();
//
// }
//
//
//
// class _RegisterFormState extends State<RegisterForm> {
//
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
// final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();
//
//
//  void userAuthSubmit() async{
//
//    print(nameController.text);
//    print(passwordController.text);
//    if(nameController.text == ''){
//       alert('Alert','Username is required!','Close');
//
//    }
//    if(passwordController.text == ''){
//       alert('Alert','Password is required!','Close');
//    }
//
//    final queryParameters = {
//      'userName': nameController.text ,
//      'password': passwordController.text,
//    };
//   // var response1 = await http.get(Uri.https('portal.fujmun.gov.ae', 'fazzahAPI/api/Inspector/authenticateUser', queryParameters));
//
//
//
//    final uri =
//    Uri.https(mainURL, 'fazzahAPI/api/Inspector/authenticateUser', queryParameters);
//    final response = await http.get(uri, headers: {
//
//      HttpHeaders.contentTypeHeader: 'application/json',
//    });
//
//
//
//
//    if (response.statusCode == 200) {
//    //  print(response.body);
//      var jsonData =convert.jsonDecode(response.body);
//
//    print(jsonData);
//
//        Map<String, dynamic> userProfile = convert.jsonDecode(response.body);
//        Map<String, dynamic> userRecord = jsonData;
//
//        Map<String, dynamic> userDetails = userProfile['userProfile'];
//
//
//
//    //   box.write('nameEn', user['nameEn']);
//    //   print('Howdy, ${user1['userId']}');
//     // print('Howdy, ${userDetails['userId']}');
//      box.write('userId', userDetails['userId']);
//      box.write('firstName', userDetails['firstName']);
//      box.write('lastName', userDetails['lastName']);
//      box.write('email', userDetails['email']);
//      box.write('phoneNumber', userDetails['phoneNumber']);
//      box.write('passportNumber', userDetails['passportNumber']);
//      box.write('passportExpiryDate', userDetails['passportExpiryDate']);
//      box.write('profileURL', userDetails['profileURL']);
//      box.write('workingHourFrom', userDetails['workingHourFrom']);
//      box.write('WorkingHourTo', userDetails['WorkingHourTo']);
//
//      print(userDetails['department']);
//      //get user department
//      Map<String, dynamic> userDepartment = userDetails['department'];
//      box.write('departmentNameEn', userDepartment['nameEn']);
//      box.write('departmentNameAr', userDepartment['nameAr']);
//        //get user branch
//      Map<String, dynamic> branch = userDepartment['branch'];
//      box.write('branchNameEn', branch['nameEn']);
//      box.write('branchNameAr', branch['nameAr']);
//
//      print(userDepartment['nameEn']);
//       print('Howdy, ${userDetails['department']}');
//
//
//       if(userRecord['userProfile'] == null || userRecord['userProfile'] == 'null'){
//        print('wrong user name or password');
//        _btnController.error();
//
//
//
//      }else{
//        print('Login');
//        _btnController.success();
//        Timer(const Duration(microseconds: 30), ()
//        {
//          Get.to(UserProfilePage(), arguments: {
//            'userData': convert.jsonDecode(response.body)
//          });
//        });
//      }
//
//    } else {
//      print('Request failed with status: ${response.statusCode}.');
//    }
//  }
//   void alert(title,content,actionText){
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         // return object of type Dialog
//         return AlertDialog(
//           title: new Text(title),
//           content: new Text(content),
//           actions: <Widget>[
//             // usually buttons at the bottom of the dialog
//             new FlatButton(
//               child: new Text(actionText),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//   TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//
//     final usernameField = TextField(
//       //obscureText: true,
//
//       style: style,
//
//       controller: nameController,
//       decoration: InputDecoration(
//           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//           labelText: "Username",
//           border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
//     );
//
//     final passwordField = TextField(
//       obscureText: true,
//       controller: passwordController,
//       style: style,
//       decoration: InputDecoration(
//           contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
//           labelText: "Password",
//
//           border:
//               OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
//     );
//
//     final loginButon = Material(
//      // elevation: 5.0,
//       //borderRadius: BorderRadius.circular(30.0),
//       //color: Color(0xff01A0C7),
//       child: Column(
//
//         children: [
//           RoundedLoadingButton(
//                child: Text('Login', style: TextStyle(color: Colors.white)),
//                resetAfterDuration: true,
//                controller: _btnController,
//                onPressed: userAuthSubmit,
//
// ),
//
//         ],
//       ),
//     );
//
//     return Scaffold(
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         appBar: AppBar(
//           title:  Text('FazzahInspection'.tr),
//
//         ),
//         //    backgroundColor: Colors.blue[300],
//         body: SingleChildScrollView(
//
//           child: Center(
//             child: Container(
//               //color: Colors.white70,
//               child: Padding(
//                 padding: const EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 100.0,
//                       child: Image.asset(
//                         "assets/logo.png",
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                     usernameField,
//                     SizedBox(height: 20.0),
//                     passwordField,
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     loginButon,
//                     SizedBox(
//                       height: 15.0,
//                     ),
//
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ));
//   }
// }

TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  void userAuthSubmit() async {
    print(nameController.text);
    print(_btnController);
    print(passwordController.text);
    if (nameController.text == '') {
      alert('Alert'.tr, 'requiredUsername'.tr, 'Close'.tr);
      _btnController.error();
    }
    if (passwordController.text == '') {
      alert('Alert'.tr, 'requiredPass'.tr, 'Close'.tr);
      _btnController.error();
    }

    final queryParameters = {
      'userName': nameController.text,
      'password': passwordController.text,
    };
    // var response1 = await http.get(Uri.https('portal.fujmun.gov.ae', 'fazzahAPI/api/Inspector/authenticateUser', queryParameters));

    final uri = Uri.https(
        mainURL, 'fazzahAPI/api/Inspector/authenticateUser', queryParameters);
    final response = await http.get(uri, headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      //  print(response.body);
      var jsonData = convert.jsonDecode(response.body);

      // print(jsonData);

      Map<String, dynamic> userProfile = convert.jsonDecode(response.body);
      print(userProfile);

      Map<String, dynamic> userDetails = userProfile['userProfile'];

      if (userDetails == null || userDetails == 'null') {
        alert('Alert'.tr, 'wrongUsernameOrPass'.tr, 'Close'.tr);
        _btnController.error();
      } else {
        //   box.write('nameEn', user['nameEn']);
        //   print('Howdy, ${user1['userId']}');
        // print('Howdy, ${userDetails['userId']}');
        box.write('userId', userDetails['userId']);
        box.write('firstName', userDetails['firstName']);
        box.write('lastName', userDetails['lastName']);
        box.write('email', userDetails['email']);
        box.write('phoneNumber', userDetails['phoneNumber']);
        box.write('passportNumber', userDetails['passportNumber']);
        box.write('passportExpiryDate', userDetails['passportExpiryDate']);
        box.write('profileURL', userDetails['profileURL']);
        box.write('workingHourFrom', userDetails['workingHourFrom']);
        box.write('WorkingHourTo', userDetails['WorkingHourTo']);
        box.write('submissionDate', userDetails['submissionDate']);

        box.write('isLogin', true);

        print(userDetails['department']);
        //get user department
        Map<String, dynamic> userDepartment = userDetails['department'];
        box.write('departmentNameEn', userDepartment['nameEn']);
        box.write('departmentNameAr', userDepartment['nameAr']);
        //get user branch
        Map<String, dynamic> branch = userDepartment['branch'];
        box.write('branchNameEn', branch['nameEn']);
        box.write('branchNameAr', branch['nameAr']);

        print(userDepartment['nameEn']);
        print('Howdy, ${userDetails['department']}');

        print('Login');
        _btnController.success();
        Timer(const Duration(microseconds: 30), () {
          Get.to(Home(), arguments: {
            // Get.to(UserProfilePage(), arguments: {
            'userData': convert.jsonDecode(response.body)
          });
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void alert(title, content, actionText) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(actionText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TextEditingController nameController = TextEditingController();
    // TextEditingController passwordController = TextEditingController();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.65,
                child: Image.asset(
                  'assets/splash1.png',
                  fit: BoxFit.cover,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(2.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text('Login',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Username',
                  suffixIcon: Icon(Icons.verified_user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffixIcon: Icon(Icons.visibility_off),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                child: RoundedLoadingButton(
                  child:
                      Text('Login'.tr, style: TextStyle(color: Colors.white)),
                  resetAfterDuration: true,
                  controller: _btnController,
                  onPressed: userAuthSubmit,
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InboxPage()));
                },
                child: Text.rich(
                  TextSpan(text: 'Fujairah Municipality', children: [
                    TextSpan(
                      text: ' ©2021',
                      style: TextStyle(color: Color(0xffEE7B23)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
