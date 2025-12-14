import 'package:flutter/material.dart';
import 'package:taskmaster/features/tasks/models/task_form_model.dart';

class TimeSelector extends StatefulWidget{
  const TimeSelector({
    super.key,
    required this.task,
  });

  final TaskFormModel task;
  @override
  State<TimeSelector> createState() => _TimeSelector();
}

class _TimeSelector extends State<TimeSelector>{

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final TimeOfDay? newtime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if(newtime != null){
          widget.task.addTime(newtime);
        }
      },
      child: const Text('Select Time')
    );
  }
}



