import 'package:flutter/material.dart';
import 'package:newproject/login.dart';
import 'package:newproject/models/userContr.dart';
import 'package:newproject/screens/homepage.dart';
import 'package:newproject/services/locator.dart';

class EnsureUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (getIt.get<UserController>().currentUser.uid == null) {
      return LoginPage();
    } else {
      return HomePage();
    }
  }
}
