import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:newproject/screens/addtask.dart';
import 'package:newproject/screens/homepage.dart';
import 'package:newproject/services/locator.dart';

import 'ensureUser.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffFFF9EC),
      statusBarIconBrightness: Brightness.dark));
  setupServices();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Color(0xffFFF9EC), fontFamily: 'Sen'),
      home: EnsureUser(),
      initialRoute: '/',
      routes: {
        '/home': (context) => HomePage(),
        '/addTask': (context) => AddTask(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
//TODO:first authentication method should be properly handled
//TODO:push and pop operations on add task function to refresh the homepage we need push but for empty the stack we need pop.


