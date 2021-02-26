import 'package:flutter/material.dart';
import 'package:newproject/screens/homepage.dart';
import 'package:newproject/services/locator.dart';

import 'authentication/auth_service.dart';

class LoginPage extends StatelessWidget {
  movetoHome(context) {
    return Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 280.0),
        child: Center(
          child: Column(children: [
            Image(
              image: AssetImage('images/vector-open-book.jpg'),
            ),
            Text(
              'NoteKeeper',
              style: TextStyle(fontSize: 35),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.all(18),
                  color: Color(0xFF309397),
                  child: Text(
                    'sign in with google',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  onPressed: () async {
                    await getIt.get<AuthService>().signInwithGoogle();
                    await movetoHome(context);
                  }),
            ),
          ]),
        ),
      ),
    );
  }
}
