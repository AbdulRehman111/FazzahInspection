// ignore_for_file: import_of_legacy_library_into_null_safe
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:fazzah_inspector/pages/inbox.dart';
import 'package:fazzah_inspector/pages/incidentdetails.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import '../theme/storage.dart';
import 'package:path_provider/path_provider.dart';
import '../theme/theme_service.dart';
import '../pages/comments.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';

import 'audio_record/recorder_view.dart';
// Page Three

class TakeAction extends StatefulWidget {
  final Function onSaved;
  final String records;

  const TakeAction(
      {Key? key,
      required this.onSaved,
      required String title,
      required this.records})
      : super(key: key);

  @override
  _TakeActionState createState() => _TakeActionState();
}

bool _isVisibleEID = true;
bool _isVisibleLIC = true;
bool _isVisibleName = true;
enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _TakeActionState extends State<TakeAction> {
  bool _IndividualhasBeenPressed = false;
  bool _CompanyhasBeenPressed = false;
  bool _AnonymoushasBeenPressed = false;
  String dropdownValue = 'SelectActionType'.tr;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  TextEditingController nameController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController eidController = TextEditingController();

  File? _selectedFile;
  File? _audioFile;
  File? _selectedFileFromGallery;
  File? _videoFile;
  bool _inProcess = false;
  List attachments = [];
  RecordingState _recordingState = RecordingState.UnSet;
  late FlutterAudioRecorder2 audioRecorder;
  bool isLoading = false;
  late Directory appDirectory;
  List<String> records = [];

  Widget _buildAppHeaderPageName(pagename) {
    // final userProfilePic = box.read('profileURL') ?? 'Profile Pic';

    return Center(
      child: Container(
        width: MediaQuery.of(this.context).size.width,
        // height: MediaQuery.of(this.context).size.height / 5.5,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [Color(0xff6bceff), Color(0xFF00abff)],
          ),
          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(90))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerAttachments() {
    Size screenSize = MediaQuery.of(this.context).size;
    return Container(
      alignment: FractionalOffset.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(1),
            topRight: Radius.circular(1),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      //   color: Colors.transparent,
      child: Column(
        children: [
          Container(
            color: Colors.black12,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.attach_file, color: Colors.black),
              Text(
                'Customer Attachments',
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ]),
          ),
          // _buildSeparator(screenSize),
          Container(
            color: Colors.black12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(15.0),
                  child: FlatButton(
                    onPressed: () =>
                        {openFile(url: Get.arguments['imageFile'])},
                    color: Color(0xff6bceff),
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          // color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: FlatButton(
                      onPressed: () =>
                          {openFile(url: Get.arguments['videoFile'])},
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.video_camera_back,
                            // color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(15.0),
                    child: FlatButton(
                      onPressed: () => {
                        {openFile(url: Get.arguments['audioFile'])}
                      },
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(15.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Icon(
                            Icons.mic,
                            // color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
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
                        'commentid': Get.arguments['commentid'],
                        'commentText': Get.arguments['commentText']
                      })
                    },
                    // color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            // Replace with a Row for horizontal icon + text
                            children: <Widget>[
                              Text(Get.arguments['commentText'].toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.orangeAccent,
                              )
                            ],
                          ),
                        ),
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
          Column(
            children: [
              Container(
                color: Colors.black12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      RaisedButton(
                        child: new Text('INDIVIDUAL'.tr),
                        textColor: Colors.white,
                        // 2
                        color: _IndividualhasBeenPressed
                            ? Colors.orangeAccent
                            : Color(0xff6bceff),
                        // 3
                        onPressed: () => {
                          setState(() {
                            _IndividualhasBeenPressed =
                                !_IndividualhasBeenPressed;
                            _CompanyhasBeenPressed = false;
                            _AnonymoushasBeenPressed = false;
                            _isVisibleLIC = false;
                            _isVisibleEID = true;
                            _isVisibleName = true;
                          })
                        },
                      ),
                      RaisedButton(
                        child: new Text('COMPANY'.tr),
                        textColor: Colors.white,
                        // 2
                        color: _CompanyhasBeenPressed
                            ? Colors.orangeAccent
                            : Color(0xff6bceff),
                        // 3
                        onPressed: () => {
                          setState(() {
                            _CompanyhasBeenPressed = !_CompanyhasBeenPressed;
                            _IndividualhasBeenPressed = false;
                            _AnonymoushasBeenPressed = false;
                            _isVisibleEID = false;
                            _isVisibleLIC = true;
                            _isVisibleName = true;
                          })
                        },
                      ),
                      RaisedButton(
                        child: new Text('ANONYMOUS'.tr),
                        textColor: Colors.white,
                        // 2
                        color: _AnonymoushasBeenPressed
                            ? Colors.orangeAccent
                            : Color(0xff6bceff),
                        // 3
                        onPressed: () => {
                          setState(() {
                            _AnonymoushasBeenPressed =
                                !_AnonymoushasBeenPressed;
                            _CompanyhasBeenPressed = false;
                            _IndividualhasBeenPressed = false;
                            _isVisibleLIC = false;
                            _isVisibleEID = false;
                            _isVisibleName = false;
                          })
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.black12,
                child: Visibility(
                  visible: _isVisibleName,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: nameController,
                    // obscureText: true,
                    decoration: InputDecoration(
                        fillColor: ThemeService().theme == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        border: UnderlineInputBorder(),
                        icon: Icon(
                          Icons.people,
                          color: Colors.black,
                        ),
                        hintText: 'Name',
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                color: Colors.black12,
                child: Visibility(
                  visible: _isVisibleLIC,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: eidController,
                    // obscureText: true,
                    decoration: InputDecoration(
                        fillColor: ThemeService().theme == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        suffixIcon: IconButton(
                            icon: Icon(Icons.timer), onPressed: () {}),
                        border: UnderlineInputBorder(),
                        icon: Icon(
                          Icons.perm_identity,
                          color: Colors.black,
                        ),
                        hintText: 'Licence',
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black)),
                  ),
                ),
              ),
              Container(
                color: Colors.black12,
                child: Visibility(
                  visible: _isVisibleEID,
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: eidController,
                    // obscureText: true,
                    decoration: InputDecoration(
                        fillColor: ThemeService().theme == ThemeMode.light
                            ? Colors.black
                            : Colors.white,
                        suffixIcon: IconButton(
                            icon: Icon(Icons.timer), onPressed: () {}),
                        border: UnderlineInputBorder(),
                        icon: Icon(
                          Icons.perm_identity,
                          color: Colors.black,
                        ),
                        hintText: 'EID',
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                color: Colors.black12,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: subjectController,
                  // obscureText: true,
                  decoration: InputDecoration(
                      fillColor: ThemeService().theme == ThemeMode.light
                          ? Colors.black
                          : Colors.white,
                      border: UnderlineInputBorder(),
                      icon: Icon(
                        Icons.subject,
                        color: Colors.black,
                      ),
                      hintText: 'Subject'.tr,
                      hintStyle:
                          TextStyle(fontSize: 16.0, color: Colors.black)),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                color: Colors.black12,
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  // underline: Container(
                  //   height: 2,
                  //   color: Colors.deepPurpleAccent,
                  // ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: <String>[
                    'Select Action Type',
                    'Fine'.tr,
                    'Warning'.tr,
                    'Other'.tr,
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                color: Colors.black12,
                child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: commentController,
                    minLines:
                        5, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Enter your Comment here",
                        contentPadding: EdgeInsets.all(20.0),
                        hintStyle:
                            TextStyle(fontSize: 16.0, color: Colors.blue))),
              ),
            ],
          ),
          Container(
            color: Colors.black12,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: RoundedLoadingButton(
                        // width: MediaQuery.of(context).size.width / 1.2,
                        color: Color(0xFF00abff),
                        child: Text('Submit'.tr,
                            style: TextStyle(color: Colors.white)),
                        resetAfterDuration: true,
                        controller: _btnController,
                        onPressed: () {
                          submit();
                        }),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.blue,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    super.dispose();
  }

  Widget getImageWidget() {
    print(_selectedFile);
    // ignore: unnecessary_null_comparison
    if (_selectedFile != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            _selectedFile!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          if (_selectedFileFromGallery != null)
            Image.file(
              _selectedFileFromGallery!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          if (_videoFile != null)
            Image.file(
              _videoFile!,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/camera.png",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/splash.png",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          Image.asset(
            "assets/video.png",
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ],
      );
    }
  }

  Upload(var imageFile, var fileType) async {
    // var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var stream = new http.ByteStream(imageFile.openRead());
    stream.cast();
    var length = await imageFile.length();
    var uploadURL =
        'https://portal.fujmun.gov.ae/fazzahAPI/api/Inspector/uploadFiles';
    var uri = Uri.parse(uploadURL);

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    //  contentType: new MediaType('image', 'png');

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
      List file = jsonDecode(value);
      print(mainURL + '/' + file[0]);
      var attachFile = file[0];

      if (fileType == 'camera' || fileType == 'gallery') {
        attachments.insert(
            0, {"type": '0', "file": attachFile, "filename": "image/jpeg"});
      }
      if (fileType == 'video') {
        attachments.insert(
            1, {"file": attachFile, "type": '1', "filename": "video/mp4"});
      }
      if (fileType == 'audio') {
        attachments.insert(
            2, {"type": '2', "file": attachFile, "filename": "audio/aac"});
      }
    });
  }

  getImage(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });

    // final ImagePicker _picker = ImagePicker();
    // XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    // print(image.path);
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await picker.getImage(source: source);
    var imageFile = File(pickedFile!.path);

    print(imageFile);
    // ignore: unnecessary_null_comparison
    if (imageFile != null) {
      // File? cropped = await ImageCropper.cropImage(
      //     sourcePath: imageFile.path,
      //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //     compressQuality: 100,
      //     maxWidth: 700,
      //     maxHeight: 700,
      //     compressFormat: ImageCompressFormat.jpg,
      //     androidUiSettings: AndroidUiSettings(
      //       toolbarColor: Colors.deepOrange,
      //       toolbarTitle: "RPS Cropper",
      //       statusBarColor: Colors.deepOrange.shade900,
      //       backgroundColor: Colors.white,
      //     ));

      this.setState(() {
        if (source == ImageSource.gallery) {
          _selectedFileFromGallery = imageFile;
          Upload(imageFile, 'gallery');
          // attachments.insert(0, _selectedFileFromGallery);
        } else {
          _selectedFile = imageFile;
          // attachments.insert(0, _selectedFile);
          Upload(imageFile, 'camera');
        }
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  getVideo(ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });

    // final ImagePicker _picker = ImagePicker();
    // XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    // print(image.path);
    final picker = ImagePicker();
    PickedFile? pickedFile = await picker.getVideo(source: source);
    var videoFile = File(pickedFile!.path);

    // PickedFile? pickedVideoFile = await picker.getVideo(source: source);
    print(videoFile);

    // ignore: unnecessary_null_comparison
    if (videoFile != null) {
      this.setState(() {
        _videoFile = videoFile;
        _inProcess = false;
        Upload(videoFile, 'video');
        // attachments.insert(1, videoFile);
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
  }

  submit() async {
    print(attachments);
    var action = '';
    var userID = box.read('userId').toString();
    var comment = commentController.text;
    var subject = subjectController.text;
    var name = nameController.text;
    var LicenseNumberOrEID = eidController.text;
    var complaintType = '';
    var complaintID = Get.arguments['complaintID'];

    print(_IndividualhasBeenPressed);
    if (_IndividualhasBeenPressed) complaintType = '1';

    if (_CompanyhasBeenPressed) complaintType = '2';

    if (_AnonymoushasBeenPressed) complaintType = '0';

    if (complaintType == '') {
      showErrorToast("Action Type is Required..!");
      _btnController.error();
      Timer(Duration(seconds: 3), () {
        _btnController.stop();
      });
      return false;
    }
    if (complaintType == '0') {
      LicenseNumberOrEID = '0';
      name = '';

      print(LicenseNumberOrEID);
      if (subject == '') {
        showErrorToast("Subject is Required..!");
        _btnController.error();
        Timer(Duration(seconds: 3), () {
          _btnController.stop();
        });
        return false;
      }
      if (dropdownValue == 'Fine'.tr) {
        action = '0';
      }
      if (dropdownValue == 'Other'.tr) {
        action = '1';
      }
      if (dropdownValue == 'Warning'.tr) {
        action = '2';
      }
      if (comment == '') {
        showErrorToast("Comment is Required..!");
        _btnController.error();
        Timer(Duration(seconds: 3), () {
          _btnController.stop();
        });
        return false;
      }
    } else {
      if (name == '') {
        showErrorToast("Name is Required..!");
        _btnController.error();
        Timer(Duration(seconds: 3), () {
          _btnController.stop();
        });
        return false;
      }
      if (subject == '') {
        showErrorToast("Subject is Required..!");
        _btnController.error();
        Timer(Duration(seconds: 3), () {
          _btnController.stop();
        });
        return false;
      }
      if (comment == '') {
        showErrorToast("Comment is Required..!");
        _btnController.error();
        Timer(Duration(seconds: 3), () {
          _btnController.stop();
        });
        return false;
      }

      print(dropdownValue);

      if (action == '') {
        showErrorToast("Action is Required..!");
        _btnController.error();
        Timer(Duration(seconds: 3), () {
          _btnController.stop();
        });
        return false;
      }
    }

    Map<String, dynamic> args = {
      'userId': userID,
      'statusId': '5',
      'complaintId': complaintID,
      'comment': comment,
      'complaintCategoryId': '0',
      'complaintLogCategory': action,
      'complaintType': complaintType,
      'name': name,
      'LicenseNumberOrEID': LicenseNumberOrEID,
      'subject': subject,
      'attachements': jsonDecode(jsonEncode(jsonEncode(attachments)))
    };

    print(args);

    final uri = Uri.https(
        mainURL, 'fazzahAPI/api/Inspector/updateComplaintStatus', args);
    var response = await http.get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _btnController.success();
      Timer(Duration(seconds: 2), () {
        Get.to(InboxPage());
      });
    }
    print(response.statusCode);

    // _btnController.stop();
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
  //   final ByteData imageData = await NetworkAssetBundle(
  //           Uri.parse(json.decode(Get.arguments['imageFile'].toString())))
  //       .load("");
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

  Widget getAttachmenWidget() {
    Size screenSize = MediaQuery.of(this.context).size;
    print(widget.records);
    return Container(
      alignment: FractionalOffset.center,
      color: Colors.orange,
      // margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Text(
            'Attachments',
            style: TextStyle(fontSize: 18.0),
          ),
          _buildSeparator(screenSize),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (_selectedFile != null)
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(1.0),
                  child: FlatButton(
                    onPressed: () => {getImage(ImageSource.camera)},
                    color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Image.asset(
                          'assets/camera_check.png',
                          width: 50,
                          height: 25,
                        ),
                        Text("Camera")
                      ],
                    ),
                  ),
                ))
              else
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: () => {getImage(ImageSource.camera)},
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Image.asset(
                            'assets/camera.png',
                            width: 50,
                            height: 25,
                          ),
                          Text("Camera")
                        ],
                      ),
                    ),
                  ),
                ),
              if (_selectedFileFromGallery != null)
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(1.0),
                  child: FlatButton(
                    onPressed: () => {getImage(ImageSource.gallery)},
                    color: Color(0xff6bceff),
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
                      children: <Widget>[
                        Image.asset(
                          'assets/gallery_check.png',
                          width: 50,
                          height: 25,
                        ),
                        Text("Gallery")
                      ],
                    ),
                  ),
                ))
              else
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: () => {getImage(ImageSource.gallery)},
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Image.asset(
                            'assets/gallery.png',
                            width: 50,
                            height: 25,
                          ),
                          Text("Gallery")
                        ],
                      ),
                    ),
                  ),
                ),
              if (_videoFile != null)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: () => {getVideo(ImageSource.camera)},
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Image.asset(
                            'assets/video_check.png',
                            width: 50,
                            height: 25,
                          ),
                          Text("Video")
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: () => {getVideo(ImageSource.camera)},
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Image.asset(
                            'assets/video.png',
                            width: 50,
                            height: 25,
                          ),
                          Text("Video")
                        ],
                      ),
                    ),
                  ),
                ),
              if (_audioFile == '' || _audioFile == null)
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: () => {
                        showDialog(
                            context: this.context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.close),
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: RecorderView(
                                        onSaved: _onRecordComplete,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })
                        // Get.to(RecorderHomeView(
                        //   title: 'Incident Recording',
                        // )),
                        // RecorderHomeView()
                      },
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Image.asset(
                            'assets/audio.png',
                            width: 50,
                            height: 25,
                          ),
                          Text("Audio")
                        ],
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(1.0),
                    child: FlatButton(
                      onPressed: () => {
                        showDialog(
                            context: this.context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  overflow: Overflow.visible,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: CircleAvatar(
                                          child: Icon(Icons.close),
                                          backgroundColor: Colors.red,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: RecorderView(
                                        onSaved: _onRecordComplete,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            })

                        // Get.to(RecorderHomeView(
                        //   title: 'Incident Recording',
                        // ))
                      },
                      color: Color(0xff6bceff),
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        // Replace with a Row for horizontal icon + text
                        children: <Widget>[
                          Image.asset(
                            'assets/audio_check.png',
                            width: 50,
                            height: 25,
                          ),
                          Text("Audio")
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("TakeAction".tr), backgroundColor: Color(0xff6bceff)),
      body: Container(
        child: ListView(children: <Widget>[
          _buildAppHeaderPageName('takeaction'.tr),
          getAttachmenWidget(),
          _buildCustomerAttachments(),
        ]),
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      if (onData.path.contains('.aac')) records.add(onData.path);
    }).onDone(() {
      records.sort();
      records = records.reversed.toList();
      print(records.last);
      // attachments.add(records.last);
      // Get.to(ReportIncident(records: records.last, title: 'Incident Report'),
      //      arguments: {'audioFile': records.last});
      setState(() {
        _audioFile = File(records.last);
        Upload(_audioFile, 'audio');
      });
    });
  }
}
