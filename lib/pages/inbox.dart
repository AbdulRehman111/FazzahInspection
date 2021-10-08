// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/storage.dart';
import 'package:http/http.dart' as http;
import '../pages/incidentdetails.dart';

class InboxPage extends StatefulWidget {
  @override
  _InboxPageState createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  List complaints = [];

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
      itemss.insert(0, items[0]['complaint']);
      print(itemss);

      setState(() {
        complaints = itemss;
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
      ),
      // drawer: MainDrawer(),

      body: makeBody(),
    );
  }

  Widget makeBody() {
    if (complaints.contains(null) || complaints.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: complaints.length,
      itemBuilder: (BuildContext context, int index) {
        return makeCard(complaints[index]);
      },
    );
  }

  Widget makeListTile(item) {
    var refNo = item['id'];
    var submissionDate = item['submissionDate'];
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.autorenew, color: Colors.white),
        ),
        title: Text(
          "Complaint#: " + refNo.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Colors.yellowAccent),
            Text('Submission Date:' + ' ' + submissionDate.toString(),
                style: TextStyle(color: Colors.white))
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
        onTap: () =>
            Get.to(IncidentDetails(), arguments: {'refNo': refNo.toString()}));
  }

  Widget makeCard(item) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
        child: makeListTile(item),
      ),
    );
  }
}
