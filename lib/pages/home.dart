// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/drawer.dart';
import '../pages/cards.dart';
import '../pages/resources/theme_service.dart';



class Home extends StatefulWidget {

  // final String title;

  // Home({required Key key, required this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xff6bceff),
              
              actions: [
                IconButton(
                    icon: Icon(ThemeService().theme == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    onPressed: () {

                      ThemeService().switchTheme();
                      _HomeState.themeNotifier.value =
                      _HomeState.themeNotifier.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light;


                      print(themeNotifier);
                    })
              ],
            ),
            drawer: MainDrawer(),
            body:  Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff6bceff),
                    Color(0xff6bceff)
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(90)
                )
              ),
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
                      // size: 90,
                      // color: Colors.white,
                    // ),
                  ),
                  Spacer(),

                  Align(
                    alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 32,
                          right: 32
                        ),
                        child: Text('FazzahInspection'.tr,
                          style: TextStyle(
                            color: Colors.orange.shade700,
                            fontSize: 20
                          ),
                        ),
                      ),
                  ),
                  
                ],
              ),
            ),
            
            
            
          
            Padding(
             padding: EdgeInsets.only(top: 75),
              child: Container(
                
                child: Center(
                  child: Cards()
                  )
                  ),
            )
           ] )
        ),
         floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff6bceff),
        onPressed: () { 
        },
        child: Icon(Icons.add,color:Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: makeBottom,

          );
        }
        );

  }
 
}



