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
      appBar: CommanMethods.mainAppBar('Task Details: ${args.name}'),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Description: "),
                Flexible(child: Text(args.description)),
              ]
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Fequancy: "),
                Flexible(child: Text(args.frequency)),
              ],
            ),
            weeklyDaysgrid(args),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Times to Complete'),
                Flexible(
                  child: ListView.builder(

                    shrinkWrap: true,
                    itemCount: args.completetimes.length,
                    itemBuilder: (context, index){
                      return ListTile(
                        title: Center(child: Text(args.completetimes[index].format(context))),
                      );
                    },
                  )
                )
              ],
            ),
            Text("Complete?: ${args.complete}"),
            Text("Task Points: ${args.points}"),
            Text("Completes: ${args.completes}"),
            Text("Fails: ${args.fails}"),
            Text("Completed Times"),
            ListView.builder(
              shrinkWrap: true,
              itemCount: args.datetimecompleted.length,
              itemBuilder: (context, index){
                return ListTile(
                  title: Center(child: Text(args.datetimecompleted[index].toString())),
                );
              }
            ),
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

  Container weeklyDaysgrid(Task task){
    const Map<int, String> weekdays = {1:'Monday', 2:'Tuesday', 3:'Wednesday', 4:'Thursday', 5:'Friday', 6:'Saturday', 7:'Sunday'};
    if(task.frequency == "Weekly"){
      return Container(
        child: Row(
          children: [
            Text("Selected Days:"),
            SizedBox(
              width: MediaQuery.of(context).size.width * (2/3),
              //height: 50,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: task.completedays.length,
                padding: const EdgeInsets.all(5.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, childAspectRatio: 1.75),
                itemBuilder: (_, int index) {
                  return SizedBox(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: GridTile(
                        child: Text(weekdays[task.completedays[index]]!),
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}