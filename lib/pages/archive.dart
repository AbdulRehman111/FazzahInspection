// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/storage.dart';
import '../theme/drawer.dart';
import 'package:http/http.dart' as http;
import '../pages/incidentdetails.dart';

class Archive extends StatefulWidget {
  @override
  _ArchiveState createState() => _ArchiveState();
}

class _ArchiveState extends State<Archive> {
  final ScrollController _scrollController = ScrollController();
  List complaints = [];

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.fetchUser();

    // getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  // final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];
  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    // print(box.read('userId'));
    var refNo = box.read('userId').toString();
    final queryParameters = {
      'userId': refNo,
    };

    final uri = Uri.https(mainURL,
        'fazzahAPI/api/Inspector/getArchivedComplaints', queryParameters);

    var response = await http.get(uri, headers: {
//
      HttpHeaders.contentTypeHeader: 'application/json',
    });
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var items = json.decode(response.body);
      getPostsData(items);
      setState(() {
        complaints = items;
        isLoading = false;
      });
    } else {
      complaints = [];
      isLoading = false;
    }
  }

  void getPostsData(items) {
    // print(json.encode(items));
    List<dynamic> responseList = items;
    print(responseList);
    List<Widget> listItems = [];
    responseList.forEach((post) {
      print(post);
      listItems.add(Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(
                      Icons.archive,
                      color: Colors.blue,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Center(
                            child: Expanded(
                                child: Image.asset(
                              "assets/logo.png",
                              height: 40,
                            )),
                          ),
                          Center(
                            child: Text(
                              'Complaint#:' + post["id"].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Expanded(
                              child: Row(
                            children: [
                              Text(
                                'Completation Date:' +
                                    post["endDate"].toString(),
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    //   Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: <Widget>[
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   "aaa",
                    //   style: const TextStyle(
                    //       fontSize: 25,
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold),
                    // )
                    //  ],
                    //  ),
                    Expanded(
                        child: IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.blue),
                      onPressed: () {
                        Get.to(IncidentDetails(), arguments: {
                          'refNo': post["id"].toString(),
                          'isVisble': false
                        });
                      },
                    )),
                  ],
                ),
              ))));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Archive".tr),
          backgroundColor: Color(0xff6bceff),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.search, color: Colors.black),
          //     onPressed: () {},
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.person, color: Colors.black),
          //     onPressed: () {},
          //   )
          // ],
        ),
        body: Container(
          height: size.height,
          child: Column(
            children: <Widget>[
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceAround,
              //   children: <Widget>[
              //     Text(
              //       "Loyality Cards",
              //       style: TextStyle(
              //           color: Colors.grey,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20),
              //     ),
              //     Text(
              //       "Menu",
              //       style: TextStyle(
              //           color: Colors.black,
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20),
              //     ),
              //   ],
              // ),
              topHeader(),
              // AnimatedOpacity(
              //   duration: const Duration(milliseconds: 200),
              //   opacity: closeTopContainer ? 0 : 1,
              //   child: AnimatedContainer(
              //       duration: const Duration(milliseconds: 200),
              //       width: size.width,
              //       alignment: Alignment.topCenter,
              //       height: closeTopContainer ? 0 : categoryHeight,
              //       child: topHeader()),
              // ),
              Expanded(child: archiveList()),
            ],
          ),
        ),
        // floatingActionButtonLocation:
        //     FloatingActionButtonLocation.centerDocked,
        // bottomNavigationBar: bottomAppBar
      ),
    );
  }

  Widget topHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.5,
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Color(0xff6bceff), Color(0xFF00abff)],
          ),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))),
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
                'Archive'.tr,
                style: TextStyle(color: Colors.orange.shade700, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget archiveList() {
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
    return ListView.builder(
        controller: controller,
        itemCount: itemsData.length,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          double scale = 1.0;
          if (topContainer > 1) {
            scale = index + 1 - topContainer;
            if (scale < 0) {
              scale = 0;
            } else if (scale > 1) {
              scale = 1;
            }
          }
          return Opacity(
            opacity: scale,
            child: Transform(
              transform: Matrix4.identity()..scale(scale, scale),
              alignment: Alignment.bottomCenter,
              child: Align(
                  heightFactor: 1,
                  alignment: Alignment.topCenter,
                  child: itemsData[index]),
            ),
          );
        });
  }
}

// class CategoriesScroller extends StatelessWidget {
//   const CategoriesScroller();

//   @override
//   Widget build(BuildContext context) {
//     final double categoryHeight =
//         MediaQuery.of(context).size.height * 0.30 - 50;
//     return SingleChildScrollView(
//       physics: BouncingScrollPhysics(),
//       scrollDirection: Axis.horizontal,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//         child: FittedBox(
//           fit: BoxFit.fill,
//           alignment: Alignment.topCenter,
//           child: Row(
//             children: <Widget>[
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.orange.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Most\nFavorites",
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.blue.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           "Newest",
//                           style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           "20 Items",
//                           style: TextStyle(fontSize: 16, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 150,
//                 margin: EdgeInsets.only(right: 20),
//                 height: categoryHeight,
//                 decoration: BoxDecoration(
//                     color: Colors.lightBlueAccent.shade400,
//                     borderRadius: BorderRadius.all(Radius.circular(20.0))),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Text(
//                         "Super\nSaving",
//                         style: TextStyle(
//                             fontSize: 25,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(
//                         "20 Items",
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//   Widget makeBody() {
//     if (complaints.contains(null) || complaints.length < 0 || isLoading) {
//       return Center(
//           child: Text('No record found',
//               style: TextStyle(color: Colors.orange.shade700, fontSize: 20)));
//     } else if (complaints.contains(null) ||
//         complaints.length < 0 ||
//         isLoading) {
//       return Center(
//           child: CircularProgressIndicator(
//         valueColor: new AlwaysStoppedAnimation<Color>(primary),
//       ));
//     }
//     return ListView.builder(
//       controller: _scrollController,
//       scrollDirection: Axis.vertical,
//       shrinkWrap: true,
//       itemCount: complaints.length,
//       itemBuilder: (BuildContext context, int index) {
//         return makeCard(complaints[index]);
//       },
//     );
//   }

//   Widget makeListTile(item) {
//     var refNo = item['id'];
//     var endDate = item['endDate'];
//     return ListTile(
//         contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//         leading: Container(
//           padding: EdgeInsets.only(right: 12.0),
//           decoration: new BoxDecoration(
//               border: new Border(
//                   right: new BorderSide(width: 1.0, color: Colors.white24))),
//           child: Icon(Icons.archive, color: Colors.blue),
//         ),
//         title: Text(
//           "Complaint#: " + refNo.toString(),
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

//         subtitle: Row(
//           children: <Widget>[
//             Icon(Icons.description),
//             Expanded(
//                 child: Text('Completion Date:' + ' ' + endDate.toString(),
//                     style: TextStyle(color: Colors.orange.shade700))),
//           ],
//         ),
//         trailing:
//             Icon(Icons.keyboard_arrow_right, color: Colors.blue, size: 30.0),
//         onTap: () => Get.to(IncidentDetails(),
//             arguments: {'refNo': refNo.toString(), 'isVisble': false}));
//   }

//   Widget makeCard(item) {
//     return Card(
//       elevation: 8.0,
//       margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//         ),
//         child: makeListTile(item),
//       ),
//     );
//   }
// }


