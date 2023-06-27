import 'package:firebase_setup/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_setup/big_rounded_button.dart';
import 'package:firebase_setup/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginScreen extends StatefulWidget {
  static String id = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool showLoadingIcon = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showLoadingIcon = false;
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      showLoadingIcon;
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: Hero(
                tag: 'logo',
                child: Container(
                  height: 100.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              onChanged: (value) {
                email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              onChanged: (value) {
                password = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              buttonColor: Colors.lightBlueAccent,
              buttonText: 'Log in',
              onPressed: () async {
                setState(() {
                  showLoadingIcon = true;
                });
                final cred = await _auth.signInWithEmailAndPassword(
                    email: email!, password: password!);
                print("Signed in user: " + cred.user!.email.toString());
                Navigator.pushNamed(context, ChatScreen.id);
              },
            ),
            Visibility(
              visible: showLoadingIcon,
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.lightBlueAccent, size: 100),
            ),
          ],
        ),
      ),
    );
  }
}
