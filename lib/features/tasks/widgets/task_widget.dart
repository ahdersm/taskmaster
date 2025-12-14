import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/features/tasks/models/task_form_model.dart';
import 'package:taskmaster/features/tasks/providers/task_api.dart';
import 'package:taskmaster/features/tasks/providers/task_repository.dart';
import 'package:taskmaster/features/tasks/widgets/day_selector_widget.dart';
import 'package:taskmaster/features/tasks/widgets/fequancy_widget.dart';
import 'package:taskmaster/features/tasks/widgets/time_selected_widget.dart';
import 'package:taskmaster/features/tasks/widgets/time_selector_widget.dart';
import 'package:taskmaster/features/tasks/widgets/time_zone_selector_widget.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/custom_logger.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';
import 'package:taskmaster/shared/providers/api/api_client.dart';
import 'package:taskmaster/shared/widgets/object_description_widget.dart';
import 'package:taskmaster/shared/widgets/object_name_widget.dart';

/*
Fields:
  Name
  Description
  Points
  Frequancy: Daily, Weekly
  If Weekly:
    Days: Sunday, Monday, Tuesday, Wendsday, Thursday, Friday, Saterday
  Selected Times

I think I need to go with StatefulWidget as I believe the frequancy and the day selecter requires it

lets pull our the name field first

I think this should be a provided controller through an object almost like a data transfer object that when the save function is called it can just pass thw whole object instead of one value at a time.

based on passing an about the whole object should be passed to widget

I would think the validation would need to be done in the widget itself

The taskdraft object will contin
Fields:
  Name
  Description
  Points
  Frequancy
  Day Selector
  Selected Times

Yes the Taskdraft object would be used again for editing so there should be a way to populate it from an entry that is passed to it. but maybe we make this whole widget so that it can be new and able to edit so its not having to be remade?

I think the dialog should be responsible for disposing of the whole object itself when its done


1. int, it should always have a value and be a default of 0
2. this should be a ValueNotifier as this will change the UI by adding the day selector if weekly is changed
3. I think option B is a good one as I can take that a bit better in the backend when making task entry in the database and have a column for each day that is a bool and if daily is selected it just marks them all as true and simplifies my logic when displaying them later on.
4. this will need to be a ValueNotifier as well as this will be part of a tile list below where they are selected so they can be deleted.
*/

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  TaskFormModel tfm = TaskFormModel();
  TaskRepository tr = TaskRepository(TaskApi(ApiClient()));

  @override
  void dispose() {
    tfm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Column(
        children: [
          Text('Add Task'),
          NameInputWidget(name: tfm.name, hint: "Task Name"),
          DescriptionInputWidget(description: tfm.description, hint: "Task Description"),
          NameInputWidget(name: tfm.points, hint: "Points"),
          FrequancySelector(frequency: tfm.frequency),
          DaySelector(frequency: tfm.frequency, selectedDays: tfm.selectedDays),
          TimeZoneWidget(task: tfm),
          TimeSelector(task: tfm),
          TimeSelected(task: tfm),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    tr.CreateTask(tfm);
                    Navigator.of(context).pop();
                  }, 
                  icon: Icon(Icons.save)
                ),
                IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close)
                )
              ],
          ),
        ],
      ),
    );
  }
}

