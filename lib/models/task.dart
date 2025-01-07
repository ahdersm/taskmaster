import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

const String tableName = "tasks";

const String idField = '_id';
const String nameField = 'name';
const String completeField = 'complete';
const String failField = 'fail';
const String freqField = 'frequency';
const String completedaysField = 'completedays';
const String completetimesField = 'completetimes';
const String datetimecompletedField = 'datetimecompleted';
const String completesField = 'completes';
const String failsField = 'fails';
const String pointsField = 'points';

class Task extends ChangeNotifier{
  

  int? id;
  String name = '';
  String description = '';
  bool complete = false; //Weither or not the task was completed that day
  bool fail = false; //if the task was failed that day
  String frequency = ''; //How frequently in days time does the user want this completed
  List<int> completedays = []; //Days during the week that this task should be completed on
  List<TimeOfDay> completetimes = []; //Times during the day that this task should be completed by
  List<DateTime> datetimecompleted = []; //Datetime of when the completed task was set to complete
  int completes = 0; //Count of how many times this task was completed succefully
  int fails = 0; //Count of how many times this task was not completed
  int points = 0; //how many points is this task worth

  Task(
    this.name,
  ); 

  String databaseCreate(){
    return '''create table $tableName (
    $idField integer primary key autoincrement,
    $nameField text not null,
    $completeField integer not null,
    $failField integer not null,
    $freqField text not null,
    $completedaysField text null,
    $completetimesField text not null
    $datetimecompletedField text
    $completesField integer
    $failsField integer
    $pointsField integer
    )''';
  }

  void taskcomplete(){
    this.complete = true;
    this.datetimecompleted.add(DateTime.now());
    this.completes += 1;
  }

  void taskuncomplete(){
    this.complete = false;
    this.datetimecompleted.removeLast();
    this.completes -= 1;
  }

  void taskfailed(){
    this.fails += 1;
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

