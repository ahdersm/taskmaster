import 'package:flutter/material.dart';

class TaskFormModel {
  String name = '';
  String description = '';
  String frequency = 'Daily';
  int points = 0;
  List<TimeOfDay> times = [];
  List<String> selectedDays = [];
}