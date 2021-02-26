import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:newproject/login.dart';
import 'package:newproject/services/locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupServices();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color(0xffFFF9EC),
    statusBarIconBrightness: Brightness.dark
  ));
  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffFFF9EC),
        fontFamily: 'Sen'
      ),
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
//TODO:first authentication method should be properly handled
//TODO:handle back button properly


