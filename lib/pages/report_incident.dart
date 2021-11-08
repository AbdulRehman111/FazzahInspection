// ignore_for_file: import_of_legacy_library_into_null_safe, prefer_typing_uninitialized_variables, unnecessary_new, non_constant_identifier_names, empty_constructor_bodies
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fazzah_inspector/pages/home.dart';
import 'package:path/path.dart';
import '../theme/storage.dart';
import '../../pages/audio_record/recorder_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:http/http.dart' as http;
import '../theme/colors.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ReportIncident extends StatefulWidget {
  final Function onSaved;
  final String records;
  const ReportIncident(
      {Key? key,
      required this.onSaved,
      required String title,
      required this.records})
      : super(key: key);

  @override
  _ReportIncidentState createState() => _ReportIncidentState();
}

//@override
// _ReportIncidentsState createState() => _ReportIncidentsState();
// }
enum RecordingState {
  UnSet,
  Set,
  Recording,
  Stopped,
}

class _ReportIncidentState extends State<ReportIncident> {
  var _deviceId;
  late Directory appDirectory;
  List<String> records = [];
  File? _audioFile;
  IconData _recordIcon = Icons.mic_none;
  String _recordText = 'Click To Start';
  RecordingState _recordingState = RecordingState.UnSet;
  late FlutterAudioRecorder2 audioRecorder;

  // @override
  List locations = [];
  File? _selectedFile;
  // File? _audioFile;
  File? _selectedFileFromGallery;
  File? _videoFile;
  bool _inProcess = false;
  List attachments = [];

  bool isLoading = false;

  void initState() {
    super.initState();
    initPlatformState();
    getUserLocation();
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.contains('.aac')) records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });

    FlutterAudioRecorder2.hasPermissions.then((hasPermision) {
      if (hasPermision!) {
        _recordingState = RecordingState.Set;
        _recordIcon = Icons.mic;
        _recordText = 'Record';
      }
    });
  }

  TextEditingController subjectController = TextEditingController();
  TextEditingController commentController = TextEditingController();

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  void submitReport() async {
    // attachments.add(Get.arguments['audioFile']);
    var subject = subjectController.text;
    var comment = commentController.text;
    var userID = box.read('userId').toString();
    var phoneNumber = box.read('phoneNumber').toString();
    var name = box.read('firstName').toString();
    var xLoc = locations[0];
    var yLoc = locations[1];

    Map<String, dynamic> args = {
      'userId': userID,
      'xlocation': json.encode(xLoc),
      'ylocation': json.encode(yLoc),
      'complaintSubject': subject,
      'complaintText': comment,
      'SourceType': '9',
      'categoryId': '',
      'name': name,
      'phoneNumber': phoneNumber,
      'deviceId': _deviceId,
      'attachements': jsonDecode(jsonEncode(jsonEncode(attachments)))
    };

    // print(args);

    final uri =
        Uri.https(mainURL, 'fazzahAPI/api/fujairahApp/submitComplaints', args);

    if (subject == '') {
      showErrorToast("Subject is Required..!");
      _btnController.error();
      Timer(Duration(seconds: 3), () {
        _btnController.stop();
      });
    } else if (comment == '') {
      showErrorToast("Comment is Required..!");
      _btnController.error();
      Timer(Duration(seconds: 3), () {
        _btnController.stop();
      });
    } else {
      var response = await http.get(
        uri,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
        },
      );

      if (response.statusCode == 200) {
        _btnController.success();
        Timer(Duration(seconds: 2), () {
          Get.to(Home());
        });
      }
      print(response.statusCode);
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

  @override
  void dispose() {
    _recordingState = RecordingState.UnSet;
    super.dispose();
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

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

  getUserLocation() async {
    setState(() {
      isLoading = true;
    });
    //call this async method from whereever you need

    LocationData? myLocation;
    String error;
    Location location = new Location();
    try {
      myLocation = await location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = 'please grant permission';
        print(error);
      }
      if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error = 'permission denied- please enable it from app settings';
        print(error);
      }

      myLocation = null;
    }
    var currentLocation = myLocation;
    locations.insert(0, myLocation!.latitude);
    locations.insert(1, myLocation.longitude);
    setState(() {
      locations = locations;
      isLoading = false;
      print(getUserLocation);
    });
    print(myLocation);
    return myLocation;
  }

  Widget _buildAppHeaderPageName(pagename) {
    // final userProfilePic = box.read('profileURL') ?? 'Profile Pic';

    return Center(
      child: Container(
        width: MediaQuery.of(this.context).size.width,
        height: MediaQuery.of(this.context).size.height / 3.5,
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
                  pagename,
                  style: TextStyle(color: Colors.orange.shade700, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginController() {
    return Container(
        child: Center(
      child: RoundedLoadingButton(
        width: MediaQuery.of(this.context).size.width / 1.8,
        color: buttonColor,
        child: Text('Submit'.tr),
        resetAfterDuration: true,
        controller: _btnController,
        onPressed: submitReport,
      ),
    ));
  }

  Widget _buildCurrentLocation() {
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
          Text(locations[0].toString()),
          SizedBox(
            width: 5,
          ),
          Text(','),
          SizedBox(
            width: 5,
          ),
          // SizedBox(width: 10),
          Text(locations[1].toString())
        ],
      ),
    );
  }

  Widget _buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(this.context).size.width,
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Center(child: _buildCurrentLocation()),
            Container(
              width: MediaQuery.of(this.context).size.width / 1.2,
              height: 35,
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ]),
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: subjectController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.subject,
                      color: Color(0xff6bceff),
                    ),
                    hintText: 'Subject'.tr,
                    hintStyle: TextStyle(fontSize: 16.0, color: Colors.blue),
                    contentPadding: EdgeInsets.all(10.0)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(this.context).size.width / 1.2,
              padding: EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 3),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 5)
                  ]),
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
            // _buildAttachments(),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final List<CameraDescription> cameras;
    if (isLoading) {
      return Scaffold(
          appBar: AppBar(backgroundColor: Color(0xff6bceff)),
          body: Center(
              child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(primary),
          )));
    } else {
      return Scaffold(
        appBar: AppBar(backgroundColor: Color(0xff6bceff)),
        body: Container(
          child: ListView(
            children: <Widget>[
              _buildAppHeaderPageName('reportIncidents'.tr),
              getAttachmenWidget(),
              _buildSingleChildScrollView(),
              InkWell(
                child: _buildLoginController(),
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.Set:
        await _recordVoice();
        break;

      case RecordingState.Recording:
        await _stopRecording();
        _recordingState = RecordingState.Stopped;
        _recordIcon = Icons.fiber_manual_record;
        _recordText = 'Record new one';
        break;

      case RecordingState.Stopped:
        await _recordVoice();
        break;

      case RecordingState.UnSet:
        ScaffoldMessenger.of(this.context).hideCurrentSnackBar();

        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  _initRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder2(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  _startRecording() async {
    await audioRecorder.start();
    // await audioRecorder.current(channel: 0);
  }

  _stopRecording() async {
    await audioRecorder.stop();

    widget.onSaved();
  }

  Future<void> _recordVoice() async {
    final hasPermission = await FlutterAudioRecorder2.hasPermissions;
    if (hasPermission ?? false) {
      await _initRecorder();

      await _startRecording();
      _recordingState = RecordingState.Recording;
      _recordIcon = Icons.stop;
      _recordText = 'Recording';
    } else {
      ScaffoldMessenger.of(this.context).hideCurrentSnackBar();
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
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
