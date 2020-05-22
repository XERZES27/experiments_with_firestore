import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:flutter/services.dart';


class User {
  final String uid;
  User({this.uid});
}



class AuthService {
  bool isSignedIn__;
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


  Future writeTime(dynamic date) async{
    var user = await _auth.currentUser();
    if(user!=null){
      return Firestore.instance.document('vendors/${user.uid}/').updateData({
        'date':FieldValue.arrayUnion(date)
      });
    }
  }


  Future<List<String>> getCategory ()async{
    final CollectionReference categoriesCollection = Firestore.instance.collection('Catagories');
    final List<String> categoryList=[];



    await categoriesCollection.getDocuments().then((onValue){
      onValue.documents.forEach((document){
        print(document.documentID);
        categoryList.add(document.documentID);
      });
    });

    return categoryList;



  }

  Stream<User> get user {
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) {
          if(user!=null){isSignedIn__ = true;}
          else{isSignedIn__ = false;}
          return _userFromFirebaseUser(user);});
  }

  Future<bool> isSignedIn()  async{
  var user = await _auth.currentUser();
  return user!=null;


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