import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/storage.dart';
import '../theme/drawer.dart';
import 'package:http/http.dart' as http;

class Comments extends StatefulWidget {
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final ScrollController _scrollController = ScrollController();
  List complaints = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchComments();
  }

  fetchComments() async {
    setState(() {
      isLoading = true;
    });
    // print(box.read('userId'));
    var commentid = Get.arguments['commentid'];
    final queryParameters = {
      'commentid': commentid,
    };

    final uri = Uri.https(mainURL,
        'fazzahAPI/api/Inspector/GetIncidentsComments', queryParameters);

    var response = await http.get(uri, headers: {
//
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);

      // Map<String, dynamic> userProfile = json.decode(response.body);
      print(items);

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
          title: Text("Comments".tr),
          backgroundColor: Color(0xff6bceff),
        ),
        // drawer: MainDrawer(),
        // bottomNavigationBar: makeBottom,
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
                              'Comments'.tr,
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
          return makeCard(complaints[index]);
        },
      ),
    );
  }

  Widget makeListTile(item) {
    var comment = item['comment'];
    var date = item['date'];
    var userProfile = item['userProfile'];
    var firstname = userProfile['firstName'];
    var lastname = userProfile['lastName'];

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Icon(Icons.comment),
      ),
      title: Text(
        firstname.toString() + ' ' + lastname.toString(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

      subtitle: Row(
        children: <Widget>[
          Expanded(
              // child: Text('Comment Date:' + ' ' + date.toString(),
              child: Text('Comment:' + ' ' + comment.toString(),
                  style: TextStyle(color: Colors.orange.shade700))),
          Expanded(
              child: Text('Date:' + ' ' + date.toString(),
                  style: TextStyle(color: Colors.orange.shade700))),
        ],
      ),
    );
  }

  Widget makeCard(item) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: makeListTile(item),
      ),
    );
  }
}
