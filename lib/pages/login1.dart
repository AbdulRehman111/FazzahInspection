import 'dart:async';
import 'dart:io';
import '../pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'dart:convert' as convert;
import '../theme/storage.dart';
import 'package:http/http.dart' as http;

TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }
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
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff6bceff),
                    Color(0xff6bceff)
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90)
                )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                )
                  ),
                  Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                          right: 32
                        ),
                        child: Text('Login',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 20
                          ),
                        ),
                      ),
                  ),
                ],
              ),
            ),

            Container(
              height: MediaQuery.of(context).size.height/2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    padding: EdgeInsets.only(
                      top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50)
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: TextField(
                       controller: nameController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.person,
                            color: Color(0xff6bceff),
                        ),
                          hintText: 'Username',
                      ),
                    ),
                  ),
                  
                  Container(
                    width: MediaQuery.of(context).size.width/1.2,
                    height: 45,
                    margin: EdgeInsets.only(top: 32),
                    padding: EdgeInsets.only(
                        top: 4,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(Icons.vpn_key,
                          color: Color(0xff6bceff),
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 16, right: 32
                      ),
                      child: Text('Forgot Password ?',
                        style: TextStyle(
                          color: Colors.grey
                        ),
                      ),
                    ),
                  ),
                  Spacer(),

                  InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, '/');
                      },
                      child: Container(
                      height: 45,
                 
                      // decoration: BoxDecoration(
                      //   gradient: LinearGradient(
                      //     colors: [
                      //       Color(0xff6bceff),
                      //       Color(0xFF00abff),
                      //     ],
                      //   ),
                        
                      // ),
                      child: Center(
                        child: RoundedLoadingButton(
                          
                               width: MediaQuery.of(context).size.width/1.2,
                               color:Color(0xFF00abff),
                  child:
                        Text('Login'.tr, style: TextStyle(color: Colors.white)),
                  resetAfterDuration: true,
                  controller: _btnController,
                  onPressed: userAuthSubmit,
                
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Fujairah Municipality"),
                  Text(" ©2021",style: TextStyle(color: Color(0xff6bceff)),),
                ], 
              ),
              // onTap: (){
              //   Navigator.pushNamed(context, '/signup');
              // },
            ),           
          ],
          
        ),
      ),
    );
  }
}