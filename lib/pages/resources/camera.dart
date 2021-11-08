import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? _selectedFile;
  bool _inProcess = false;

  Widget getImageWidget() {
    print(_selectedFile);
    // ignore: unnecessary_null_comparison
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile!,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/logo1.png",
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    }
  }

  getImage(ImageSource source) async {
    // this.setState(() {
    // _inProcess = true;
    //});

    // final ImagePicker _picker = ImagePicker();
    // XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    // print(image.path);
    final picker = ImagePicker();
    // ignore: deprecated_member_use
    PickedFile? pickedFile = await picker.getImage(source: ImageSource.camera);
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
        _selectedFile = imageFile;
        // _inProcess = false;
      });
    } else {
      this.setState(() {
        //_inProcess = false;
      });
    }
  }

  @override
  Widget _buildCamera() {
    return Column(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getImageWidget(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                    color: Colors.green,
                    child: Text(
                      "Camera",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      getImage(ImageSource.camera);
                    }),
                MaterialButton(
                    color: Colors.deepOrange,
                    child: Text(
                      "Device",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      getImage(ImageSource.gallery);
                    })
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
