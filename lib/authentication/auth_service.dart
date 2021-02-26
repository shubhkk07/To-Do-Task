import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:newproject/models/notes.dart';

class AuthService {
  Note note;

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final usersref = FirebaseFirestore.instance.collection('Users');

  userAlreadyexists() {
    final GoogleSignInAccount user =
        googleSignIn.currentUser; //ye abhi handel krna hai
    return user.id;
  }

  getUser() {
    var currUser = auth.currentUser;
    return currUser.uid;
  }

  Future signInwithGoogle() async {
    final GoogleSignInAccount user = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleauth = await user.authentication;

    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken, idToken: googleauth.idToken);

    return await auth.signInWithCredential(credential);
  }

  Future addPost(Note note) async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersref.doc(user.id).get();

    await usersref
        .doc(user.id)
        .collection('notes')
        .doc(note.id)
        .set(note.toMap());
  }

  Future deletePost(String docId) async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    await usersref.doc(user.id).collection('notes').doc(docId).delete();
  }

  Future retrievePost() async {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    QuerySnapshot querySnapshot =
        await usersref.doc(user.id).collection('notes').get();
    return querySnapshot.docs;
  }

  void signout() async {
    await googleSignIn.signOut();
  }
}
