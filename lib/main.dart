import 'package:flutter/material.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';
import 'package:taskmaster/screens/home_page.dart';
import 'package:taskmaster/screens/store_page.dart';
import 'package:taskmaster/screens/storeitemdetail_page.dart';
import 'package:taskmaster/screens/taskdetail_page.dart';
import 'package:taskmaster/screens/tasklist_page.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
const simplePeriodicTask = "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask = "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";


@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  CommanMethods cms = CommanMethods();
  Workmanager().executeTask((task, inputData) {
    switch(task){
      case simplePeriodicTask:
        cms.checkLastClear();
    }
    print("Native called background task: $task"); //simpleTask will be emitted here.
    return Future.value(true);
  });
}


void main() {
  
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode: true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );

  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => Task()),
        ChangeNotifierProvider(create: (_) => Tasks()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    Workmanager().registerPeriodicTask(
      simplePeriodicTask,
      simplePeriodicTask,
      initialDelay: Duration(seconds: 10),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/tasks': (context) => TaskListPage(),
        '/task': (context) => TaskDetailPage(),
        '/store': (context) => StorePage(),
        '/item': (context) => StoreItemDetailPage(),
      }
    );
  }
}