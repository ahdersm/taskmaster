import 'dart:io';

import 'package:taskmaster/features/tasks/models/task_form_model.dart';
import 'package:taskmaster/shared/providers/api/api_client.dart';

class TaskApi {
  final ApiClient api;

  TaskApi(this.api);

  Future<Map<String, dynamic>> saveNewTask(TaskFormModel request) async {
    List<bool> completeDays = [false,false,false,false,false,false,false];
    for(var day in request.selectedDays){
      switch (day){
        case SelectorDays.sunday:
          completeDays[0] = true;
        case SelectorDays.monday:
          completeDays[1] = true;
        case SelectorDays.tuesday:
          completeDays[2] = true;
        case SelectorDays.wendsday:
          completeDays[3] = true;
        case SelectorDays.thursday:
          completeDays[4] = true;
        case SelectorDays.friday:
          completeDays[5] = true;
        case SelectorDays.saturday:
          completeDays[6] = true;
      }
    }
    List<String> times = [];
    for(var time in request.times.value){
      print("${time.hour}:${time.minute}");
      times.add("${time.hour}:${time.minute}");
    }
    final response = await api.dio.post("/api/UserTask/Create", data: {
      "name": request.name.text,
      "description": request.description.text,
      "points": request.points.text,
      "frequency": request.frequency.text,
      "timezoneid": request.timezoneid.text,
      "completetimes": times,
      "completedays": completeDays,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> testauth(TaskFormModel request) async {
    final response = await api.dio.get("/WeatherForecast");
    return response.data;
  }

}