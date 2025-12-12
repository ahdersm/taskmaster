import 'package:flutter/material.dart';

class TaskFormModel {
  final name = TextEditingController();
  final description = TextEditingController();
  int points = 0;
  enum frequency { daily, weekly }  
  String frequency = 'Daily';
  List<TimeOfDay> times = [];
  List<String> selectedDays = [];
}

