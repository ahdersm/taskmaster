import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum SelectorDays{
  sunday(),
  monday(),
  tuesday(),
  wendsday(),
  thursday(),
  friday(),
  saturday()
}

class TaskFormModel {
  int? id;
  final name = TextEditingController();
  final description = TextEditingController();
  final points = TextEditingController();
  final frequency = TextEditingController();
  final timezoneid = TextEditingController();
  ValueNotifier<List<TimeOfDay>> times = ValueNotifier<List<TimeOfDay>>([]);
  List<SelectorDays> selectedDays = [];

  void dispose(){
    name.dispose();
    description.dispose();
    points.dispose();
    frequency.dispose();
    times.dispose();
  }

  void addTime(TimeOfDay time){
    List<TimeOfDay> newList = List.from(times.value)..add(time);
    newList.sort();
    times.value = newList;
  }

  void removeTime(TimeOfDay time){
    List<TimeOfDay> newList = List.from(times.value)..remove(time);
    times.value = newList;
  }

  void changeTimeZone(String timeZone){
    timezoneid.text = timeZone;
  }
}

