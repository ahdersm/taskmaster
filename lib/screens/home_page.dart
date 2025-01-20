import 'package:flutter/material.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/screens/_main_scaffold.dart';
import 'package:taskmaster/services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CommanMethods cms = CommanMethods();
  @override
  Widget build(BuildContext context) {
    cms.checkLastClear();
    return Scaffold(
      appBar: CommanMethods.mainAppBar('Home'),
      drawer: CommanMethods.mainDrawer(context),
      body: Row(
        children: [
          const Icon(Icons.backpack),
          const Icon(Icons.leaderboard),
          const Icon(Icons.person),
          TextButton(
            onPressed:(){
              DatabaseService.delete();
            }, 
            child: const Text("Delete Database")
          )
        ],
      )
    );
  }
}