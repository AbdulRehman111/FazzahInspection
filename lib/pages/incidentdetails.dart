// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';


class IncidentDetails extends StatefulWidget {
  @override
 _IncidentDetailsState createState() => _IncidentDetailsState();
}

class _IncidentDetailsState extends State<IncidentDetails> {
List complaintDetails = [];

  bool isLoading = false;
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    this.fetchUser();
  }
fetchUser() async {
    setState(() {
      isLoading = true;
    });
    // print(box.read('userId'));
    var complaintID =Get.arguments['refNo'];
    print(complaintID);
    final queryParameters = {
      'complaintId': complaintID ,

    };


    final uri = Uri.https(mainURL, 'fazzahAPI/api/Inspector/getComplaintDetails',queryParameters);

    var response = await http.get(uri, headers: {
//
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if(response.statusCode == 200){
      List complaintData= [];
      var items = json.decode(response.body);

print(items);
complaintData.insert(0, items);
 Map<String, dynamic> incidentDetails = complaintData[0]['complaint'];
      complaintData.insert(1,incidentDetails);
      print(incidentDetails['id']);
      setState(() {
        complaintDetails = complaintData;
        isLoading = false;
      });
    }else{
      complaintDetails = [];
      isLoading = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xff6bceff)),
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
                  colors: const [
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
                ),
                      // size: 90,
                      // color: Colors.white,
                    // ),
                  ),
                  Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                          right: 32
                        ),
                        child: Text('incidentDetails'.tr,
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

            SingleChildScrollView(child: Container(
              // height: MediaQuery.of(context).size.height/2,
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child:Center(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Name:'),
                          Spacer(),
                          Text('abdul Rehman',style: TextStyle(color: Color(0xff6bceff),fontSize: 18)),
                  
                        ],
                      ),
                    )
                    //  TextField(
                      // decoration: InputDecoration(
                      //   border: InputBorder.none,
                      //     hintText: 'Full Name',
                      // ),
                    // ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: Center(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Reference No:'),
                          Spacer(),
                          Text('123456',style: TextStyle(color: Color(0xff6bceff),fontSize: 18)),
                        ]
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: Center(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Subject:'),
                          Spacer(),
                          Text('123456',style: TextStyle(color: Color(0xff6bceff),fontSize: 18)),
                        ]
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child:Center(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Phone No:'),
                          Spacer(),
                          Text('0561411237',style: TextStyle(color: Color(0xff6bceff),fontSize: 18)),
                        ]
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),                  
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: Center(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Coordinates:'),
                          Spacer(),
                          Text('123456',style: TextStyle(color: Color(0xff6bceff),fontSize: 18)),
                        ]
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
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
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5
                        )
                      ]
                    ),
                    child: Center(
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Comments:'),
                          Spacer(),
                          Text('123456',style: TextStyle(color: Color(0xff6bceff),fontSize: 18)),
                           Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 30.0),
        // onTap: () =>
        //     Get.to(IncidentDetails(), arguments: {'refNo':'11'})
        //     )
                        ]
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, '/');
                    },
                    child: Center(
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                             width: 110,
                           // width: MediaQuery.of(context).size.width/1.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0xff6bceff),
                                  Color(0xFF00abff),
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              )
                            ),
                            child: Center(
                              child: Text('Comment'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                             width: 110,
                           // width: MediaQuery.of(context).size.width/1.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0xff6bceff),
                                  Color(0xFF00abff),
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              )
                            ),
                            child: Center(
                              child: Text('Return'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 110,
                           // width: MediaQuery.of(context).size.width/1.2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0xff6bceff),
                                  Color(0xFF00abff),
                                ],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(50)
                              )
                            ),
                            child: Center(
                              child: Text('Take Action'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Have an account ?"),
                  Text("Login",style: TextStyle(color: Color(0xff6bceff)),),
                ], 
              ),
              onTap: (){
                Navigator.pop(context);
              },
            ),           
          ],
          
        ),
      ),
    );
  }
}