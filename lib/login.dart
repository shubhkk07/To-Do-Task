import 'package:flutter/material.dart';
import 'package:newproject/screens/homepage.dart';
import 'package:newproject/services/locator.dart';

import 'authentication/auth_service.dart';



class LoginPage extends StatelessWidget {
  movetoHome(context) {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: RaisedButton(
            child: Text('sign in with google'),
            onPressed: () async {
              await getIt.get<AuthService>().signInwithGoogle();
              await movetoHome(context);
            }),
      )),
    );
  }
}
