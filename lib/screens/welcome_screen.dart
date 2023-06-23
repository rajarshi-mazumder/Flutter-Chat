import 'package:flutter/material.dart';
import 'package:firebase_setup/screens/login_screen.dart';
import 'package:firebase_setup/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_setup/big_rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = '/';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation =
        ColorTween(begin: Colors.red, end: Colors.blue).animate(controller!);
    controller?.forward();

    controller?.addListener(() {
      setState(() {});
      print(animation?.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation?.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                SizedBox(width: 20),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Flutter',
                      textStyle: TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                      speed: Duration(milliseconds: 100),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              buttonColor: Colors.blueAccent,
              buttonText: 'Log in',
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              buttonColor: Colors.blueAccent,
              buttonText: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
