import 'package:experimentswithfirestore/repo.dart';
import 'package:experimentswithfirestore/waitingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'main.dart';



class SignIn extends StatefulWidget {
  final AuthService authService;
  SignIn({this.authService});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Register"),
          actions: <Widget>[
            // action button
            IconButton(
              icon: Icon(Icons.threed_rotation),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(
                  builder:(context)=>SignUp(authService: widget.authService,))
                );})
          ],
        ),
        body: Column(children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Material(
                  shadowColor: Colors.grey,
                  elevation: 10,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: TextFormField(
                    controller: _emailController,
                    autovalidate: true,
                    onTap: () {},
                    obscureText: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle:
                        TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
                  ))),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              flex: 1,
              child: Material(
                  shadowColor: Colors.grey,
                  elevation: 10,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: TextFormField(
                    controller: _passwordController,
                    autovalidate: true,
                    onTap: () {},
                    obscureText: true,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle:
                        TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
                  ))),
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: GestureDetector(
                onTap: () => signInButtonHandler(context),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    gradient: LinearGradient(colors: [
                      Color(0xFF0EDED2),
                      Color(0xFF03A0FE),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: ImageIcon(
                    AssetImage("assets/ic_forward.png"),
                    size: 35,
                    color: Colors.white,
                  ),
                )),
          ),
          Text('${errorMessage} hello world')
        ]));
  }

  void signInButtonHandler(BuildContext context) {

    widget.authService
        .signIn(_emailController.text, _passwordController.text).then((value) {
          final FirebaseUser user = value;
          if(user.isEmailVerified){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => homePage(authService:widget.authService)),
            );
          }
          else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => waitingPage(
                    user: value,
                    authService: widget.authService,
                  )),
            );

          }

    }).catchError((onError){
      setState(() {
        errorMessage = signInErrorHandler(onError);
      });

    });


  }

  String signInErrorHandler(PlatformException error) {
    String errorMessage;
    switch (error.code) {
      case "ERROR_INVALID_EMAIL":
        {
          errorMessage = 'INVALID EMAIL';
        }
        break;
      case "ERROR_USER_NOT_FOUND":
        {
          errorMessage = "UNABLE TO FIND USER";
        }
        break;
      case "ERROR_USER_DISABLED":
        {
          errorMessage = "WEAK USER HAS BEEN DELETED";
        }
        break;

      case "ERROR_TOO_MANY_REQUESTS":
        {
          errorMessage = "TOO MANY REQUEST TO SIGN IN WITH THIS USER HAVE BEEN ATTEMPTED";
        }
        break;
      case "ERROR_WRONG_PASSWORD":
        {
          errorMessage = "INCORRECT PASSWORD";
        }
        break;
      case "ERROR_OPERATION_NOT_ALLOWED":
        {
          errorMessage = "Email & Password accounts are not enabled";
        }
        break;
    }
    print(errorMessage);
    return errorMessage;
  }
}
