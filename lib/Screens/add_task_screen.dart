import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/task_data.dart';

final _firestore = Firestore.instance;

class AddTaskScreen extends StatelessWidget {
  static String userId;
  @override
  Widget build(BuildContext context) {
    String newTaskTitle;
    TaskData t = context.watch();
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(49, 39, 79, 1),
                fontSize: 30,
              ),
            ),
            TextField(
              autofocus: true,
              cursorColor: Color.fromRGBO(49, 39, 79, 1),
              decoration: InputDecoration(
                focusedBorder: new UnderlineInputBorder(
                  borderSide: new BorderSide(
                    color: Color.fromRGBO(49, 39, 79, 1),
                  ),
                ),
              ),
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            SizedBox(
              height: 10,
            ),
            FlatButton(
              child: Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              color: Color.fromRGBO(49, 39, 79, 1),
              onPressed: () {
                if (newTaskTitle != null) {
                  _firestore
                      .collection(userId)
                      .document(context.read<TaskData>().taskCount.toString())
                      .setData(
                    {
                      'title': newTaskTitle,
                      'isCheck': false,
                    },
                  );
                  context.read<TaskData>().addTask(newTaskTitle);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
