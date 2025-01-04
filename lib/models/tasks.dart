import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:taskmaster/models/task.dart';

class Tasks extends ChangeNotifier {
  final List<Task> _list = [];

  UnmodifiableListView<Task> get items => UnmodifiableListView(_list);

  void addTask(Task task){
    _list.add(task);
    notifyListeners();
  }
  void removeTask(Task task){
    _list.remove(task);
    notifyListeners();
  }
}