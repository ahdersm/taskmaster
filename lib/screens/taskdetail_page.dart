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
      backgroundColor: CommanMethods.backgroundcolor,
      appBar: CommanMethods.mainAppBar('Task Details: ${args.name}'),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
        color: Colors.blueGrey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
                color: CommanMethods.buttoncolor,
              ),
              child: Consumer<Tasks>(
                builder: (context, tasklist, child){
                  return TextButton(
                    onPressed:(){
                    },
                    child: Text(
                      "Edit Task",
                      style: TextStyle(color: Colors.white),
                    )
                  );
                }
              ),
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: Consumer<Tasks>(
                builder: (context, tasklist, child){
                  return TextButton(
                    onPressed:(){
                      Navigator.of(context).pop();
                      tasklist.removeTask(args);
                    },
                    child: Text(
                      "Delete Task",
                      style: TextStyle(color: Colors.white),  
                    )
                  );
                }
              ),
            )
          ], 
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              descriptionbox(context, args),
              frequancybox(args),
              weeklyDaysgrid(args),
              completetimes(args),
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
            ],
          ),
        ),
      ),
    );
  }

  Container frequancybox(Task args) {
    return decorationbox(90,
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Fequancy"),
          Divider(color: Colors.black,),
          Flexible(child: Text(args.frequency)),
        ],
      )
    );
  }

  Container descriptionbox(BuildContext context, Task args) {
    return decorationbox(150,
      Column(
        children: [
          Text("Description"),
          Divider(color: Colors.black,),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Text(args.description)
          ),
        ]
      ),
    );
  }

  Container weeklyDaysgrid(Task task){
    const Map<int, String> weekdays = {1:'Monday', 2:'Tuesday', 3:'Wednesday', 4:'Thursday', 5:'Friday', 6:'Saturday', 7:'Sunday'};
    if(task.frequency == "Weekly"){
      return decorationbox(200,
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Selected Days"),
            Divider(color: Colors.black,),
            SizedBox(
              width: MediaQuery.of(context).size.width * (2/3),
              //height: 50,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: task.completedays.length,
                padding: const EdgeInsets.all(5.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 3,
                  crossAxisCount: 3, 
                  crossAxisSpacing: 4, 
                  childAspectRatio: 1.75,
                ),
                itemBuilder: (_, int index) {
                  return Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blueAccent),
                    ),
                    child: GridTile(
                      child: Text(weekdays[task.completedays[index]]!),
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
  
  Container completetimes(Task args) {
    return decorationbox(200,
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Times to Complete"),
          Divider(color: Colors.black,),
          SizedBox(
            width: MediaQuery.of(context).size.width * (2/3) - 15,
            height: 100,
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: args.completetimes.length,
              padding: const EdgeInsets.all(5.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 3,
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                childAspectRatio: 1.75,
              ), 
              itemBuilder: (_, int index){
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: GridTile(
                    child: Center(child: Text(args.completetimes[index].format(context))),
                  ),
                );
              }
            ),
          )
        ],
      )
    );
  }

  Container decorationbox(double? boxheight, var input){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      decoration: BoxDecoration(
        border: Border.all(color: CommanMethods.barcolor),
        borderRadius: BorderRadius.circular(5),
        color: CommanMethods.tilecolor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3)
          )
        ]
      ),
      width: MediaQuery.of(context).size.width,
      height: boxheight,

      child: input
    );
  }
}