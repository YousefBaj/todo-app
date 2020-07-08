import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/models/task.dart';

class DataCacheService {
  DataCacheService({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  List<Task> getData() {
    List<Task> values = [];
    print(66);
    final count = sharedPreferences.getInt('count');
    if (count != null) {
      for (var x = 0; x < count; x++) {
        print(x);
        final name = sharedPreferences.getString('${x}/name');
        final isDone = sharedPreferences.getBool('${x}/isDone');

        values.add(Task(id: x, name: name, isDone: isDone));
      }
    }

    return values;
  }

  // ignore: non_constant_identifier_names
  Future<void> setData(List<Task> TaskData) async {
    for (var value in TaskData) {
      print('name: ${value.id}');
      await sharedPreferences.setString(
          '${value.id.toString()}/name', value.name);
      await sharedPreferences.setBool(
          '${value.id.toString()}/isDone', value.isDone);
    }
    await sharedPreferences.setInt('count', TaskData.length);
  }

  Future<void> updateTask(String id, bool isDone) async {
    print('yousef${id}');
    await sharedPreferences.setBool(id, isDone);
  }

  Future<void> signIn(bool isLogin, String email) async {
    await sharedPreferences.setBool('isLogin', true);
    sharedPreferences.setString('userEmail', email);
  }

  Future<void> signOut() async {
    await sharedPreferences.clear();
  }

  bool isLogin() {
    return sharedPreferences.getBool('isLogin');
  }

  String getUserEmail() {
    return sharedPreferences.getString('userEmail');
  }
}
