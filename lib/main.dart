import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/Screens/TasksScreen.dart';
import 'package:todoapp/Screens/loginScreen.dart';
import 'package:todoapp/models/task_data.dart';
import 'package:todoapp/service/data_cache_service.dart';

import 'Screens/RegistrationScreen.dart';
import 'Screens/TasksScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  final dataCache = DataCacheService(sharedPreferences: sharedPreferences);
  bool isLogin = dataCache.isLogin();
  var initialRoute = LoginScreen.id;
  if (isLogin != null && isLogin) {
    TasksScreen.data = dataCache;
    initialRoute = TasksScreen.id;
  }
  runApp(
    MyApp(
      sharedPreferences: sharedPreferences,
      initialRoute: initialRoute,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key, @required this.sharedPreferences, this.initialRoute})
      : super(key: key);
  final SharedPreferences sharedPreferences;
  final initialRoute;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskData(
        dataCacheService:
            DataCacheService(sharedPreferences: sharedPreferences),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: initialRoute,
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          RegistrationScreen.id: (context) => RegistrationScreen(),
          TasksScreen.id: (context) => TasksScreen(),
        },
      ),
    );
  }
}
