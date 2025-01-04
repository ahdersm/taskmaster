import 'dart:ffi';

import 'package:flutter/material.dart';

class Task extends ChangeNotifier{
  String name = '';
  String description = '';
  bool complete = false; //Weither or not the task was completed that day
  String frequency = ''; //How frequently in days time does the user want this completed
  List<int> completedays = []; //Days during the week that this task should be completed on
  List<TimeOfDay> completetimes = []; //Times during the day that this task should be completed by
  List<DateTime> datetimecompleted = []; //Datetime of when the completed task was set to complete
  int completed = 0; //Count of how many times this task was completed succefully
  int failed = 0; //Count of how many times this task was not completed
  int points = 0; //how many points is this task worth

  Task(
    this.name,
  ); 

  void taskcomplete(){
    this.complete = true;
    this.datetimecompleted.add(DateTime.now());
    this.completed += 1;
  }

  void taskfailed(){
    this.failed += 1;
  }

  void newtask({required String frequency, String? description, List<int>? completedays, List<TimeOfDay>? completetimes, required int points}){
    this.frequency = frequency;
    this.points = points;
    if(description != null){
      this.description = description;
    }
    if(completedays != null){
      this.completedays = completedays;
    }
    if(completetimes != null){
      this.completetimes = completetimes;
    }
  }
}

