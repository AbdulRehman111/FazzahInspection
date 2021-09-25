
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';




class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: RegisterForm(title: 'Flutter Login'),
    );
  }
}

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;



  @override
  _RegisterFormState createState() => _RegisterFormState();
  
}



class _RegisterFormState extends State<RegisterForm> {

  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

void _doSomething() async {
    Timer(const Duration(seconds: 3), () {
        _btnController.success();
    });
}
 void userAuthSubmit(){
 
   print(nameController.text);
   print(passwordController.text);
   if(nameController.text == ''){
      alert('Alert','Username is required!','Close');
   }
   if(passwordController.text == ''){
      alert('Alert','Password is required!','Close');
   }
 }
  void alert(title,content,actionText){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(actionText),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    final emailField = TextField(
      //obscureText: true,
      style: style,
       
      controller: nameController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Username",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      controller: passwordController,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          labelText: "Password",
          
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    );

    final loginButon = Material(
     // elevation: 5.0,
      //borderRadius: BorderRadius.circular(30.0),
      //color: Color(0xff01A0C7),
      child: Column(
        children: [
          RoundedLoadingButton(
    child: Text('Login', style: TextStyle(color: Colors.white)),
    controller: _btnController,
    onPressed: _doSomething,
)
          /*MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(15),
            onPressed: userAuthSubmit,
                    
            child: Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),*/
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: const Text('Fazzah Inspection'),
        ),
        //    backgroundColor: Colors.blue[300],
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    emailField,
                    SizedBox(height: 20.0),
                    passwordField,
                    SizedBox(
                      height: 20.0,
                    ),
                    loginButon,
                    SizedBox(
                      height: 15.0,
                    ),
                  
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
