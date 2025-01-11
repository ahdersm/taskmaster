import 'package:flutter/material.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';
import 'package:taskmaster/screens/home_page.dart';
import 'package:taskmaster/screens/taskdetail_page.dart';
import 'package:taskmaster/screens/tasklist_page.dart';
import 'package:provider/provider.dart';


void main() {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
        '/tasks': (context) => TaskListPage(),
        '/task': (context) => TaskDetailPage(),
      }
    );
  }
}