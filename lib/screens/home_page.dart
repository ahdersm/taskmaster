import 'package:flutter/material.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/screens/_main_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommanMethods.mainAppBar('Home'),
      drawer: CommanMethods.mainDrawer(context),
      body: Row(
        children: const [
          Icon(Icons.backpack),
          Icon(Icons.leaderboard),
          Icon(Icons.person)
        ],
      )
    );
  }
} 