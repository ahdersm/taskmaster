

import 'package:taskmaster/features/tasks/models/task_form_model.dart';
import 'package:taskmaster/features/tasks/providers/task_api.dart';

class TaskRepository {
  final TaskApi taskapi;

  TaskRepository(this.taskapi);

  Future<bool> CreateTask(TaskFormModel request) async {
    //final data = await taskapi.testauth(request);
    final data = await taskapi.saveNewTask(request);
    return true;
  }
}