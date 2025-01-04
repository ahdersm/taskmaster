import 'package:taskmaster/models/task.dart';

class StatefulValues {
  String title = '';
  int index = 0;
  List<Task> tasklist = [];

  void setTitle(String title){
    this.title = title;
  }
  void setIndex(int index){
    this.index = index;
  }
  void addTask(Task task){
    this.tasklist.add(task);
  }
  void removeTask(Task task){
    this.tasklist.remove(task);
  }
}