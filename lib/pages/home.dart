import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/pages/Appbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ,
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