import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/service/data_cache_service.dart';

final _firestore = Firestore.instance;

class TaskData extends ChangeNotifier {
  final DataCacheService dataCacheService;

  TaskData({@required this.dataCacheService});

  final List<Task> _tasks = [];

  int get taskCount => _tasks.length;

  UnmodifiableListView<Task> get tasks => UnmodifiableListView(_tasks);

  void getCachedTasks(FirebaseUser loggedUser) async {
    await for (var tasks in _firestore
        .collection('${loggedUser.email}/profile/tasks')
        .snapshots()) {
      for (var task in tasks.documentChanges) {
        var tempTask = task.document;

        _tasks.add(
          Task(
            id: task.newIndex,
            name: tempTask['title'].toString(),
            isDone: tempTask['isCheck'],
          ),
        );
      }

      notifyListeners();
      return;
    }

    dataCacheService.setData(_tasks);

    // print(taskCount);
  }

  Future<String> getName(FirebaseUser loggedUser) async {
    await for (var tasks
        in _firestore.collection('${loggedUser.email}').snapshots()) {
      for (var task in tasks.documentChanges) {
        var tempTask = task.document;
        var name = tempTask['name'].toString();

        dataCacheService.setName(name);
        return name;
      }
    }
  }

  void clearList() {
    _tasks.clear();
    notifyListeners();
  }

  void addTask(String newTaskTitle) {
    final task = Task(id: taskCount, name: newTaskTitle);

    _tasks.add(task);
    dataCacheService.setData(_tasks);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();

    _firestore
        .collection('${dataCacheService.getUserEmail()}/profile/tasks')
        .document(task.id.toString())
        .setData({'title': task.name, 'isCheck': task.isDone});
    dataCacheService.updateTask(task.id.toString(), task.isDone);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    _firestore
        .collection('${dataCacheService.getUserEmail()}/profile/tasks')
        .document(task.id.toString())
        .delete();
    dataCacheService.setData(_tasks);
    notifyListeners();
  }
}
