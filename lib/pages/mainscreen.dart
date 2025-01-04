import 'package:flutter/material.dart';
import 'package:taskmaster/models/statefulvalues.dart';
import 'package:taskmaster/pages/home.dart';
import 'package:taskmaster/pages/tasksscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var statefulValues = StatefulValues();

  void onItemTapped(int index) {
    setState(() {
      statefulValues.setIndex(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (statefulValues.index) {
      case 0:
        statefulValues.setTitle('Home');
        page = HomePage();
        break;
      case 1:
        statefulValues.setTitle('Tasks');
        page = TasksPage();
        break;
      //case 2:
        //statefulValues.setTitle('Create Task');
        //page = CreateTaskPage();
      default:
        throw UnimplementedError('no widget for ${statefulValues.index}');
    }

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
} 