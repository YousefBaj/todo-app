import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/Animation/FadeAnimation.dart';
import 'package:todoapp/Screens/show_alert_dialog.dart';
import 'package:todoapp/errors/error.dart';
import 'package:todoapp/service/data_cache_service.dart';

import 'RegistrationScreen.dart';
import 'TasksScreen.dart';

enum authProblems { UserNotFound, PasswordNotValid, NetworkError }
final _firestore = Firestore.instance;

class LoginScreen extends StatefulWidget {
  static const String id = 'loginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String passWord;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          valueColor:
              new AlwaysStoppedAnimation<Color>(Color.fromRGBO(49, 39, 79, 1)),
          strokeWidth: 5,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 400,
                child: Stack(
                  children: [
                    Positioned(
                      top: -40,
                      height: 400,
                      width: width,
                      child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/background.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      height: 400,
                      width: width + 20,
                      child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/images/background-2.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      1.5,
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Color.fromRGBO(49, 39, 79, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    FadeAnimation(
                      1.7,
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Color.fromRGBO(196, 135, 198, 1),
                                onChanged: (newEmail) {
                                  email = newEmail;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Color.fromRGBO(196, 135, 198, 1),
                                obscureText: true,
                                onChanged: (newPassword) {
                                  passWord = newPassword;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeAnimation(
                      1.8,
                      Center(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Color.fromRGBO(196, 135, 198, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                      1.8,
                      Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 60),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: FlatButton(
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (email != null && passWord != null) {
                                setState(() {
                                  showSpinner = true;
                                });
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: email, password: passWord);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  DataCacheService data = DataCacheService(
                                      sharedPreferences: prefs);

                                  if (user != null) {

                                    data.signIn(true, email);
                                    Navigator.pushNamed(
                                        context, TasksScreen.id);
                                  }
                                  setState(() {
                                    showSpinner = false;
                                  });
                                } catch (e) {
                                  final error = Error();

                                  error.getError(e);
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  showAlertDialog(
                                    context: context,
                                    title: 'Email or Password not correct',
                                    content: e.message,
                                    defaultActionText: 'OK',
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeAnimation(
                      2,
                      Center(
                        child: FlatButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          ),
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              color: Color.fromRGBO(49, 39, 79, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
