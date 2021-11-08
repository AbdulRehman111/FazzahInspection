import 'dart:async';

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/storage.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../theme/theme_service.dart';
import '../pages/home.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

TextEditingController oldPassController = TextEditingController();
TextEditingController newPassController = TextEditingController();
TextEditingController confirmPassController = TextEditingController();

class _ChangePasswordState extends State<ChangePassword> {
  final RoundedLoadingButtonController _btnSavePassController =
      RoundedLoadingButtonController();

  void change_password() async {
    var oldPassword = oldPassController.text;
    var newPassword = newPassController.text;
    var userID = box.read('userId').toString();
    var confirmPassword = confirmPassController.text;
    print(oldPassController.text);

    print(confirmPassController.text);
    Map<String, dynamic> args = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'userId': userID,
    };
    final uri =
        Uri.https(mainURL, 'fazzahAPI/api/Inspector/changePassword', args);
    print(uri);
    if (oldPassword == '') {
      showErrorToast("Old Password is Required..!");
      _btnSavePassController.error();
      Timer(Duration(seconds: 3), () {
        _btnSavePassController.stop();
      });
    } else if (newPassword == '') {
      showErrorToast("New Password is Required..!");
      _btnSavePassController.error();
      Timer(Duration(seconds: 3), () {
        _btnSavePassController.stop();
      });
    } else if (confirmPassword == '') {
      showErrorToast("Confirm Password is Required..!");
      _btnSavePassController.error();
      Timer(Duration(seconds: 3), () {
        _btnSavePassController.stop();
      });
    } else if (confirmPassword != newPassword) {
      showErrorToast("Password does not match");
      _btnSavePassController.error();
      Timer(Duration(seconds: 3), () {
        _btnSavePassController.stop();
      });
    } else {
      var response = await http.post(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        _btnSavePassController.success();
        Timer(Duration(seconds: 2), () {
          Get.to(Home());
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff6bceff)),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Color(0xff6bceff), Color(0xFF00abff)],
                  ),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'ChangePassword'.tr,
                        style: TextStyle(
                            color: Colors.orange.shade700, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                // height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 40),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 2,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 45,
                            padding: EdgeInsets.only(
                                top: 4, left: 16, right: 16, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: TextField(
                              controller: oldPassController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(Icons.password, color: Colors.blue),
                                hintText: 'Old Password',
                                hintStyle: TextStyle(
                                    fontSize: 16.0, color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 45,
                            margin: EdgeInsets.only(top: 22),
                            padding: EdgeInsets.only(
                                top: 4, left: 16, right: 16, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: TextField(
                              controller: newPassController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor:
                                      ThemeService().theme == ThemeMode.light
                                          ? Colors.black
                                          : Colors.white,
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.vpn_key,
                                    color: Colors.blue,
                                  ),
                                  hintText: 'New Password',
                                  hintStyle: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  )),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: 45,
                            margin: EdgeInsets.only(top: 22),
                            padding: EdgeInsets.only(
                                top: 4, left: 16, right: 16, bottom: 4),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black12, blurRadius: 5)
                                ]),
                            child: TextField(
                              controller: confirmPassController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  fillColor:
                                      ThemeService().theme == ThemeMode.light
                                          ? Colors.black
                                          : Colors.white,
                                  border: InputBorder.none,
                                  icon: Icon(Icons.verified_user,
                                      color: Colors.blue),
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                      fontSize: 16.0, color: Colors.black)),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          InkWell(
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  color: Colors.orangeAccent,
                                  child: Text('Save'.tr,
                                      style: TextStyle(color: Colors.white)),
                                  resetAfterDuration: true,
                                  controller: _btnSavePassController,
                                  onPressed: change_password,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
