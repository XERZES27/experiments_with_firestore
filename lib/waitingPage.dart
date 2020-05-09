import 'package:experimentswithfirestore/home.dart';
import 'package:experimentswithfirestore/repo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';

class waitingPage extends StatefulWidget {
  final FirebaseUser user;
  final AuthService authService;

  waitingPage({this.user,this.authService});

  @override
  _waitingPageState createState() => _waitingPageState();
}

class _waitingPageState extends State<waitingPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Builder(
        builder: (contex) => Container(
          color: Colors.white,
          child: Stack(
            children: [
              FlareActor("assets/Swinging_Red.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "Swing"),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    0, MediaQuery.of(contex).size.height / 2, 0, 0),
                child: Center(
                  child: MaterialButton(
                    textColor: Colors.white,
                    color: Colors.redAccent,
                    onPressed: () => checkIfVerified(widget.authService,widget.user, contex),
                    elevation: 2.0,
                    child: Text('I am Verified'),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkIfVerified(AuthService authService,FirebaseUser user, BuildContext context) async {

  final isEmailVerified = await authService.isVerified();
    if (isEmailVerified) {
      final callable = authService.createDocumentForVerifiedVendorCallable();
      dynamic resp = await callable.call(<String,dynamic>{
        "name":"Bernard",
        "email":"${user.email}"
      });
      print(resp.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homePage(authService: authService,)),
      );
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("You are still not Verified, Check your Email"),
      ));
    }
  }
}
