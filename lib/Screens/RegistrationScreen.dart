import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:todoapp/Animation/FadeAnimation.dart';
import 'package:todoapp/Screens/show_alert_dialog.dart';
import 'package:todoapp/errors/error.dart';

import 'TasksScreen.dart';

final _firestore = Firestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String name;
  String email;
  String passWord;
  String confirmPassword;
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      1.5,
                      Text(
                        'Registration',
                        style: TextStyle(
                          color: Color.fromRGBO(49, 39, 79, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Your Name",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Color.fromRGBO(196, 135, 198, 1),
                                onChanged: (newName) {
                                  name = newName;
                                },
                              ),
                            ),
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
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Color.fromRGBO(196, 135, 198, 1),
                                onChanged: (newUsername) {
                                  email = newUsername;
                                },
                              ),
                            ),
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
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Color.fromRGBO(196, 135, 198, 1),
                                onChanged: (newPassword) {
                                  passWord = newPassword;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                cursorColor: Color.fromRGBO(196, 135, 198, 1),
                                onChanged: (newConfirmPassword) {
                                  confirmPassword = newConfirmPassword;
                                },
                              ),
                            ),
                          ],
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
                            onPressed: () async {
                              setState(() {
                                showSpinner = true;
                              });
                              if (email != null &&
                                  passWord != null &&
                                  confirmPassword != null) {
                                if (passWord == confirmPassword) {
                                  try {
                                    final user = await _auth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: passWord);

                                    if (user != null) {
                                      _firestore
                                          .collection(email)
                                          .document('profile')
                                          .setData({'name': name});
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
                              }
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                      2,
                      Center(
                        child: FlatButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Already have account?",
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
