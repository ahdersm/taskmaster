import 'package:flutter/material.dart';
import 'package:taskmaster/features/tasks/models/task_form_model.dart';

class TimeSelected extends StatefulWidget{
  const TimeSelected({
    super.key,
    required this.task,
  });

  final TaskFormModel task;
  @override
  State<TimeSelected> createState() => _TimeSelected();
}

class _TimeSelected extends State<TimeSelected>{
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.task.times, 
      builder: (BuildContext context, List<TimeOfDay> list ,child) {
        return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Card(
                  child: ListTile(
                    title: Text(list[index].format(context)),
                    trailing: IconButton(
                      onPressed: (){
                        widget.task.removeTime(list[index]);
                      },
                      icon: Icon(Icons.close)
                    ),
                  )
                )
              );
            }
          ),
        );
      }
    );
  }
}