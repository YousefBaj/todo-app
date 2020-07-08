import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/Screens/loginScreen.dart';
import 'package:todoapp/Widgets/Tasks_list.dart';
import 'package:todoapp/models/task_data.dart';
import 'package:todoapp/service/data_cache_service.dart';

import 'add_task_screen.dart';

final _firestore = Firestore.instance;
FirebaseUser loggedInUser;

class TasksScreen extends StatefulWidget {
  static const String id = 'taskScreen';
  static DataCacheService data;
  @override
  _TasksScreenState createState() => _TasksScreenState(data: data);
}

class _TasksScreenState extends State<TasksScreen> {
  TaskData dataRepository;
  final DataCacheService data;
  final _auth = FirebaseAuth.instance;
  _TasksScreenState({this.data});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void signOut() {
    print(data.isLogin());
    data.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    try {
      if (user != null) {
        loggedInUser = user;
        AddTaskScreen.userId = loggedInUser.email;
        dataRepository = Provider.of<TaskData>(context, listen: false);

        dataRepository.getCachedTasks(loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(49, 39, 79, 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.40),
                child: AddTaskScreen(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(49, 39, 79, 1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Yousef",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: Colors.white,
                        size: 35,
                      ),
                      onPressed: () => signOut(),
                    )
                  ],
                ),
                Text(
                  '${Provider.of<TaskData>(context).taskCount} Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TasksList(),
            ),
          )
        ],
      ),
    );
  }
}
