// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_adjacent_string_concatenation

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/storage.dart';
import '../theme/drawer.dart';
import 'package:http/http.dart' as http;
import '../pages/incidentdetails.dart';
import '../theme/theme_service.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List complaints = [];
  final ScrollController _scrollController = ScrollController();

  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    // print(box.read('userId'));
    var userID = box.read('userId').toString();

    final queryParameters = {
      'userId': userID,
    };

    final uri = Uri.https(mainURL,
        'fazzahAPI/api/Inspector/getAssignedIncidents', queryParameters);

    var response = await http.get(uri, headers: {
//
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      List itemss = [];
      //  List itemss= ['{InspectorID: -1, id: 18241, refNo: #210318241, xLoc: null, yLoc: null, fkStatusId: 2, submissionDate: 2021-03-23T12:55:27.813, endDate: 2021-03-24T09:31:59.95, deviceId: null, phoneNumber: 0504344217, fkUserProfileId: null, fkComplaintSource: 1, text: Test Complaint, name: Test, subject: Test, fkComplaintCategoryId: null, firstSeenByInspector: 2021-05-04T09:55:23.347, EServiceRefNo: null, ServiceCategoryID: null, ComplaintType: null, statusName: null},'
      //  'InspectorID: -1, id: 182413333, refNo: #210318241, xLoc: null, yLoc: null, fkStatusId: 2, submissionDate: 2021-03-23T12:55:27.813, endDate: 2021-03-24T09:31:59.95, deviceId: null, phoneNumber: 0504344217, fkUserProfileId: null, fkComplaintSource: 1, text: Test Complaint, name: Test, subject: Test, fkComplaintCategoryId: null, firstSeenByInspector: 2021-05-04T09:55:23.347, EServiceRefNo: null, ServiceCategoryID: null, ComplaintType: null, statusName: null}'];
      // var items = json.decode(response.body);
      // print(items);
      //  print(items[0]['complaint']);
      // itemss.insert(0, items[0]['complaint']);
      // Map<String, dynamic> complaints = items['complaint'];
      // print(items['complaint']);
      print(itemss);

      setState(() {
        complaints = items;
        isLoading = false;
      });
    } else {
      complaints = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Inbox".tr),
          backgroundColor: Color(0xff6bceff),
        ),
        // drawer: MainDrawer(),

        body: Container(
            child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView(children: <Widget>[
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
                            padding:
                                const EdgeInsets.only(bottom: 32, right: 32),
                            child: Text(
                              'Inbox'.tr,
                              style: TextStyle(
                                  color: Colors.orange.shade700, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  makeBody()
                ]))),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: bottomAppBar);
  }

  Widget makeBody() {
    if (complaints.contains(null) || complaints.length < 0 || isLoading) {
      return Center(
          child: Text('No record found',
              style: TextStyle(color: Colors.orange.shade700, fontSize: 20)));
    } else if (complaints.contains(null) ||
        complaints.length < 0 ||
        isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return Scrollbar(
        child: ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: complaints.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(complaints[index]['complaint']);
      },
    ));
  }

  Widget makeListTile(item) {
    var refNo = item['id'];
    var submissionDate = item['submissionDate'];
    return ListTile(
        // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          // padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.archive, color: Colors.blue),
          // Icon(
          //   Icons.inbox,
          //   color: ThemeService().theme == ThemeMode.light
          //       ? Colors.black
          //       : Colors.white,
          // ),
        ),
        title: Text(
          "Complaint#: " + refNo.toString(),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Container(
          child: Row(
            children: <Widget>[
              // Icon(Icons.details, color: Colors.yellowAccent),
              Expanded(
                child: Text(
                    'Submission Date:' + ' ' + submissionDate.toString(),
                    style: TextStyle(color: Colors.orange.shade700)),
              ),
            ],
          ),
        ),
        trailing: Icon(Icons.keyboard_arrow_right,
            color: Colors.orange.shade700, size: 30.0),
        onTap: () =>
            Get.to(IncidentDetails(), arguments: {'refNo': refNo.toString()}));
  }

  Widget makeCard(item) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: SizedBox(child: makeListTile(item)),
      ),
    );
  }
}
