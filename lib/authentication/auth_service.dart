

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


   userAlreadyexists(){
    final GoogleSignInAccount user = googleSignIn.currentUser;
    return user.id;
     
  }

   getUser(){
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

    if (doc.exists == false) {
      await usersref.doc(user.id).collection('notes').doc().set(note.toMap());
    } else {
      await usersref.doc(user.id).collection('notes').add(note.toMap());
    }
  }

  Future retrievePost() async {
    
    final GoogleSignInAccount user = googleSignIn.currentUser;
    QuerySnapshot querySnapshot =
        await usersref.doc(user.id).collection('notes').get();
    return querySnapshot.docs;

   }

  Stream<List<Note>> getNotes() {
    final GoogleSignInAccount user = googleSignIn.currentUser;
    return usersref
        .doc(user.id)
        .collection('notes')
        .snapshots()
        .map((list) => list.docs.map((doc) => Note.fromMap(doc.data())).toList());
  }

  void signout() async {
    await googleSignIn.signOut();
  }
}
