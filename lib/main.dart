import 'package:experimentswithfirestore/home.dart';
import 'package:experimentswithfirestore/repo.dart';
import 'package:experimentswithfirestore/signIn.dart';
import 'package:experimentswithfirestore/waitingPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(home: home()));


class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  @override Future<void> initState()  {
    // TODO: implement initState
    super.initState();
    final auth = AuthService();
    
    if(auth.isSignedIn()){
      Future(() {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> homePage(authService: auth,)));
      });
      
    }
    else{
      Future(() {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignUp(authService: auth,)));
      });
    }
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



class SignUp extends StatefulWidget {
  final AuthService authService;
  SignUp({this.authService});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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
              icon: Icon(Icons.ac_unit),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(
                        builder:(context)=>SignIn(authService: widget.authService,))
                );

              },
            ),
            // action button

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
                onTap: () => signUpButtonHandler(context),
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

  void signUpButtonHandler(BuildContext context) {

      widget.authService
          .signUp(_emailController.text, _passwordController.text).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => waitingPage(
                user: value,
                authService: widget.authService,
              )),
        );
      }).catchError((onError){
            setState(() {
              errorMessage = signUpErrorHandler(onError);
            });

      });


  }

  String signUpErrorHandler(PlatformException error) {
    String errorMessage;
    switch (error.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
        {
          errorMessage = 'EMAIL IS ALREADY IN USE';
        }
        break;
      case "ERROR_INVALID_EMAIL":
        {
          errorMessage = "INVALID EMAIL";
        }
        break;
      case "ERROR_WEAK_PASSWORD":
        {
          errorMessage = "WEAK PASSWORD";
        }
        break;

      case "Given String is empty or null":
        {
          errorMessage = "INPUT IS EMPTY";
        }
        break;
    }
    print(errorMessage);
    return errorMessage;
  }
}
