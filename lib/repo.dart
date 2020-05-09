import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'dart:async';

import 'package:flutter/services.dart';


class User {
  final String uid;
  User({this.uid});
}



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null && user.isEmailVerified? User(uid: user.uid) : User(uid: "null");
  }


  HttpsCallable createDocumentForVerifiedVendorCallable()  {
    final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
      functionName: "createDocumentForVerifiedVendorCallable",
    );
//    dynamic resp = await callable.call(<String, dynamic>{
//      "name": "wwinkert",
//    });
//    print(resp.toString());
  return callable;
  }

  Stream<User> get user {

    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  bool isSignedIn()  {


    return _auth.currentUser() != null;
  }

  Future<bool> isVerified() async{
    var isEmailVerified;

    await _auth.currentUser().then((onValue){
       onValue.reload();
    });

   await  _auth.currentUser().then((onValue){
        isEmailVerified = onValue.isEmailVerified;
    });



    print(isEmailVerified.toString());
    return isEmailVerified;

  }

  Future<void> sendEmailVerification() async {
    final currentUser = await _auth.currentUser();
    await currentUser.sendEmailVerification();


  }

  Future sighInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      throw new Exception(e.toString());
    }
  }

  
  Future signIn(String email, String password) async {

      AuthResult result =  await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;

  }

  Future signUp(String email, String password) async {
    
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final FirebaseUser user = result.user;
      await user.sendEmailVerification();
      return user;

  }
}