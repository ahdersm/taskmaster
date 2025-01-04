import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});
  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Task;
    return Scaffold(
      appBar: CommanMethods.mainAppBar('Task Details'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text("Name: ${args.name}"),
            Text("Description: ${args.description}"),
            Text("Fequancy: ${args.frequency}"),
            weeklyDays(args),
            Text('Times to Complete'),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 200, minHeight: 10),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: args.completetimes.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(args.completetimes[index].format(context)),
                  );
                }
              ),
            ),
            Text("Complete?: ${args.complete}"),
            Text("Task Points: ${args.points}"),
            Consumer<Tasks>(
              builder: (context, tasklist, child){
                return TextButton(
                  onPressed:(){
                    Navigator.of(context).pop();
                    tasklist.removeTask(args);
                  },
                  child: Text("Delete Task")
                );
              }
            )
          ],
        ),
      ),
    );
  }

  Container weeklyDays(Task task){
    const Map<int, String> weekdays = {1:'Monday', 2:'Tuesday', 3:'Wednesday', 4:'Thursday', 5:'Friday', 6:'Saturday', 7:'Sunday'};
    if(task.frequency == "Weekly"){
      return Container(
        child: Column(
          children: [
            Text("Days: "),
            SizedBox(
              height: 50,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: task.completedays.length,
                itemBuilder: (context, index){
                  return SizedBox(
                    width: MediaQuery.of(context).size.width / task.completedays.length,
                    child: ListTile(
                      //tileColor: Colors.amber,
                      title: Text(
                        weekdays[task.completedays[index]]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13
                        ),
                      ),
                    ),
                  );
                }, 
              ),
            ),
          ],
        )
      );
    }
    else{
      return Container();
    }
  }
}