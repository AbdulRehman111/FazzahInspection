
// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/storage.dart';
import 'package:http/http.dart' as http;
import '../pages/incidentdetails.dart';
import '../pages/login1.dart';


class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
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
    var refNo = box.read('userId').toString();
    final queryParameters = {
      'userId': refNo,

    };


    final uri = Uri.https(
        mainURL, 'fazzahAPI/api/Inspector/getArchivedComplaints',
        queryParameters);

    var response = await http.get(uri, headers: {
//
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);

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
        title: Text("Archive".tr),
      ),
      // drawer: MainDrawer(),
      // bottomNavigationBar: makeBottom,
      body: makeBody(),

    );
  }



  Widget makeBody() {
    if (complaints.contains(null) || complaints.length < 0 || isLoading) {
      return Center(child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),));
    }
    return
      ListView.builder(
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
    var endDate = item['endDate'];
    return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: EdgeInsets.only(right: 12.0),
          decoration: new BoxDecoration(
              border: new Border(
                  right: new BorderSide(width: 1.0, color: Colors.white24))),
          child: Icon(Icons.archive, color: Colors.white),
        ),
        title: Text("Complaint#: " + refNo.toString(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

        subtitle: Row(
          children: <Widget>[
            Icon(Icons.linear_scale, color: Colors.yellowAccent),
            Text('Completion Date:'+ ' '+ endDate.toString(), style: TextStyle(color: Colors.white))
          ],
        ),
        trailing:
        Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    onTap: () => Get.to(LoginPage(),
    arguments: {'refNo': refNo.toString() })
    );
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
