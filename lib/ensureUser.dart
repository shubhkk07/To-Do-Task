import 'package:flutter/material.dart';
import 'package:newproject/login.dart';
import 'package:newproject/screens/homepage.dart';
import 'package:newproject/services/locator.dart';

import 'authentication/auth_service.dart';

class EnsureUser extends StatelessWidget {

  getToHome(context){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage()));
  }

  login(context){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginPage()));
  }


  @override
  Widget build(BuildContext context) {
    if(getIt.get<AuthService>().getUser() == null){
       return LoginPage();
    }
    else{
      return HomePage();
    }
  }
}