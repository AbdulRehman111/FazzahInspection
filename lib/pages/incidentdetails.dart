// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fazzah_inspector/pages/take_action.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/storage.dart';
import 'package:http/http.dart' as http;
import '../theme/drawer.dart';
import '../theme/colors.dart';
import '../pages/comments.dart';
import '../pages/video_play.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

String filePathImage = '';
String filePathVideo = '';
String filePathAudio = '';

class IncidentDetails extends StatefulWidget {
  @override
  _IncidentDetailsState createState() => _IncidentDetailsState();
}

class _IncidentDetailsState extends State<IncidentDetails> {
  bool _isVisible = true;
  var isVisiblee =
      Get.arguments['isVisble']; // to show/hide bottom buttons for TakeAction

  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List complaintData = [];
  List attachments = [];
  bool isLoading = false;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    this.fetchUser();
  }

  submitComment() async {
    print('asas');
    setState(() {
      isLoading = true;
    });
    if (commentController.text == '') {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Enter Some Comment..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
//     // print(box.read('userId'));
      var userID = box.read('userId').toString();
      var complaintId = complaintData[1]['id'].toString();
      print(complaintData[1]['id']);
      final queryParameters = {
        'userId': userID,
        'complaintId': complaintId,
        'comment': commentController.text,
      };

      final uri = Uri.https(mainURL,
          'fazzahAPI/api/Inspector/UpdateComplaintComment', queryParameters);

      var response = await http.post(uri, headers: {
//
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var items = json.decode(response.body);

        print(items);
        if (items == 1) {
          Fluttertoast.showToast(
              msg: "Successully Submit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {
            isLoading = false;
          });
          Timer(Duration(seconds: 2), () {
            Navigator.pop(this.context, true);
          });
        }
      } else {
        isLoading = false;
      }
    }
  }

  submitReturn() async {
    print('asas');
    setState(() {
      isLoading = true;
    });
    if (commentController.text == '') {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Enter Some Comment..!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
//     // print(box.read('userId'));
      var userID = box.read('userId').toString();
      var complaintId = complaintData[1]['id'].toString();
      print(complaintData[1]['id']);
      final queryParameters = {
        'statusId': '3',
        'userId': userID,
        'complaintId': complaintId,
        'comment': commentController.text,
        'complaintCategoryId': '0',
        'complaintLogCategory': '0',
        'name': '',
        'LicenseNumberOrEID': '',
        'attachements': '',
        'complaintType': '0',
        'subject': ''
      };

      final uri = Uri.https(mainURL,
          'fazzahAPI/api/Inspector/updateComplaintStatus', queryParameters);

      var response = await http.post(uri, headers: {
//
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var items = json.decode(response.body);

        print(items);
        if (items == 1) {
          Fluttertoast.showToast(
              msg: "Successully Submit",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);

          setState(() {
            isLoading = false;
          });
          Timer(Duration(seconds: 2), () {
            Navigator.pop(this.context, true);
          });
        }
      } else {
        isLoading = false;
      }
    }
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    // print(box.read('userId'));
    var complaintID = Get.arguments['refNo'];

    print(complaintID);
    final queryParameters = {
      'complaintId': complaintID,
    };

    final uri = Uri.https(mainURL,
        'fazzahAPI/api/Inspector/getComplaintDetails', queryParameters);

    var response = await http.get(uri, headers: {
//
      HttpHeaders.contentTypeHeader: 'application/json',
    });

    if (response.statusCode == 200) {
      var items = json.decode(response.body);

      // print(items);
      complaintData.insert(0, items);
      Map<String, dynamic> incidentDetails = complaintData[0]['complaint'];

      complaintData.insert(1, incidentDetails);
      print(complaintData);
      // print(json.encode(complaintData[0]['attachements']));
      // filePath = json.encode(complaintData[0]['attachements'][0]['filePath']);

      // var fileName = json.decode(filePath).substring(
      //     filePath.lastIndexOf("/") + 1,
      //     json.decode(filePath).length); //get file name
      print(complaintData[0]['attachements']);
      for (var i = 0; i < complaintData[0]['attachements'].length; i++) {
        print(complaintData[0]['attachements'][i]['filePath']);
        if (complaintData[0]['attachements'][i]['fileType'] == 'mp4') {
          filePathVideo =
              json.encode(complaintData[0]['attachements'][i]['filePath']);
        } else {
          filePathVideo = '';
        }
        if (complaintData[0]['attachements'][i]['fileType'] == 'jpg') {
          filePathImage =
              json.encode(complaintData[0]['attachements'][i]['filePath']);
        } else {
          filePathImage = '';
        }
        if (complaintData[0]['attachements'][i]['fileType'] == 'm4a' ||
            complaintData[0]['attachements'][i]['fileType'] == 'aac') {
          filePathAudio =
              json.encode(complaintData[0]['attachements'][i]['filePath']);
        } else {
          filePathAudio = '';
        }
      }
      // print(fileURl + fileName);
      print(filePathVideo);
      print(filePathImage);
      print(filePathAudio);
      setState(() {
        complaintData = complaintData;
        isLoading = false;
      });
    } else {
      complaintData = [];
      isLoading = false;
    }
  }

  Future openFile({required String url, String? filename}) async {
    final name = filename ?? url.split('/').last;
    final file = await downloadFile(url, name);
    if (file == null) return;
    print('path : ${file.path}');
    OpenFile.open(file.path);
  }

  Future<File?> downloadFile(String url, name) async {
    final appStore = await getApplicationDocumentsDirectory();
    final file = File('${appStore.path}/$name');
    try {
      final response = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: 0,
          ));
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  // _imageDialog() async {
  //   final ByteData imageData =
  //       await NetworkAssetBundle(Uri.parse(json.decode(filePath))).load("");
  //   final Uint8List bytes = imageData.buffer.asUint8List();

  //   print(bytes);

  //   await showDialog(
  //     context: this.context,
  //     builder: (context) => GestureDetector(
  //       onTap: () {
  //         Navigator.pop(context);
  //       },
  //       child: FractionallySizedBox(
  //           widthFactor: 0.9,
  //           heightFactor: 0.9,
  //           child: new Image.memory(bytes)),
  //     ),
  //   );
  // }

  Widget _buildCurrentLocation() {
    if (complaintData.contains(null) || complaintData.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_pin, color: Colors.red, size: 30.0),

          SizedBox(
            width: 5,
          ),
          Text(complaintData[1]['xLoc'].toString()),
          SizedBox(
            width: 5,
          ),
          Text(','),
          SizedBox(
            width: 5,
          ),
          // SizedBox(width: 10),
          Text(complaintData[1]['yLoc'].toString())
        ],
      ),
    );
  }

  Widget _buildRequestDetails() {
    print(isVisiblee);
    if (isVisiblee != null) {
      _isVisible = false;
    }
    if (complaintData.contains(null) || complaintData.length < 0 || isLoading) {
      return Center(
          child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                      border: Border.all(
                        color: Colors.blue,
                      )),
                  child: FlatButton(
                    onPressed: () => {},
                    // color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text('Name'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orangeAccent)),
                        Text(complaintData[1]['name'] ?? 'Name'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                      border: Border.all(
                        color: Colors.blue,
                      )),
                  child: FlatButton(
                    onPressed: () => {},
                    // color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text('Subject'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orangeAccent)),
                        Text(complaintData[1]['subject'] ?? 'Subject',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                      border: Border.all(
                        color: Colors.blue,
                      )),
                  child: FlatButton(
                    onPressed: () => {},
                    // color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text('phoneNo'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orangeAccent)),
                        Text(complaintData[1]['phoneNumber'] ?? 'Phone Number',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                      border: Border.all(
                        color: Colors.blue,
                      )),
                  child: FlatButton(
                    onPressed: () => {},
                    // color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Text('ReferenceNo'.tr,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.orangeAccent)),
                        Text(complaintData[1]['refNo'] ?? 'Reference No',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                      border: Border.all(
                        color: Colors.blue,
                      )),
                  child: FlatButton(
                    onPressed: () => {
                      Get.to(Comments(), arguments: {
                        'commentid': complaintData[1]['id'].toString(),
                        'commentText': complaintData[1]['text'].toString()
                      })
                    },
                    // color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.orangeAccent,
                        ),
                        Text(complaintData[1]['text'].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16))
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ],
      ),
    );
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
                        'incidentDetails'.tr,
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
              padding: EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  _buildCurrentLocation(),
                  _buildRequestDetails(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      FlatButton(
                        onPressed: () =>
                            {openFile(url: json.decode(filePathImage))},
                        color: Colors.orange,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.camera),
                            Text("Camera")
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          openFile(url: json.decode(filePathVideo));
                          //  Get.to(VideoApp(), arguments: {'videoPath': bytes});
                        },
                        color: Colors.orange,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.video_camera_back),
                            Text("Video")
                          ],
                        ),
                      ),
                      FlatButton(
                        onPressed: () =>
                            {openFile(url: json.decode(filePathAudio))},
                        color: Colors.orange,
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          // Replace with a Row for horizontal icon + text
                          children: <Widget>[
                            Icon(Icons.record_voice_over),
                            Text("Audio")
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Container(
                child: Visibility(
              visible: _isVisible,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              if (isLoading) {
                                return Center(
                                    child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      primary),
                                ));
                              }
                              return Center(
                                child: Expanded(
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    content: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          right: -10.0,
                                          // top: -45,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              child: Icon(Icons.close),
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              commentController,
                                                          minLines:
                                                              5, // any number you need (It works as the rows for the textarea)
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          decoration:
                                                              InputDecoration(
                                                                  hintText:
                                                                      "Enter your Comment here",
                                                                  contentPadding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20.0),
                                                                  hintStyle:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                  )))),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RaisedButton(
                                                      child: Text(
                                                        "Submit".tr,
                                                      ),
                                                      color:
                                                          Colors.orangeAccent,
                                                      onPressed: () {
                                                        submitComment();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: Text(
                        "Comment",
                      ),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text("Action"),
                      color: Colors.red,
                      onPressed: () {
                        Get.to(
                            TakeAction(
                              onSaved: () => {},
                              title: 'Take Action',
                              records: '',
                            ),
                            arguments: {
                              'commentid': complaintData[1]['id'].toString(),
                              'commentText':
                                  complaintData[1]['text'].toString(),
                              'imageFile': filePathImage,
                              'videoFile': filePathVideo,
                              'audioFile': filePathAudio,
                              'complaintID': complaintData[1]['id'].toString()
                            });
                      },
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      child: Text("Return"),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Center(
                                child: Expanded(
                                  child: AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    content: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                          right: -10.0,
                                          // top: -45,
                                          child: InkResponse(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: CircleAvatar(
                                              child: Icon(Icons.close),
                                              backgroundColor:
                                                  Colors.orangeAccent,
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: Container(
                                            height: 200,
                                            width: 200,
                                            child: Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              commentController,
                                                          minLines:
                                                              5, // any number you need (It works as the rows for the textarea)
                                                          keyboardType:
                                                              TextInputType
                                                                  .multiline,
                                                          maxLines: null,
                                                          decoration: InputDecoration(
                                                              hintText:
                                                                  "Enter your Comment here",
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          20.0),
                                                              hintStyle: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  color: Colors
                                                                      .blue)))),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: RaisedButton(
                                                      child: Text(
                                                        "Submit".tr,
                                                      ),
                                                      color:
                                                          Colors.orangeAccent,
                                                      onPressed: () {
                                                        submitReturn();
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
