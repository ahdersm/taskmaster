import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';
import 'package:taskmaster/screens/_main_scaffold.dart';

final _formKey = GlobalKey<FormState>();

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String _newname = '';
  String _newdescription = '';
  String _newfreq = '';
  int _points = 0;
  List<TimeOfDay> _newtimes = [];
  List<String> _selectedDays = [];
  //list of frequancy types for drop down list
  List<String> freqdropdown = [
    'Daily',
    //'Every X Days',
    'Weekly',
    //'Monthly',
  ];
  //inital value for drop down in add task
  String _selectedFreq = 'Daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommanMethods.mainAppBar('Tasks'),
      drawer: CommanMethods.mainDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context){
              return addTaskDialog();
            }
          );
        }
      ),
      body: Consumer<Tasks>(
        builder: (context, tasklist, child){
          List<Task> completed = tasklist.items.where((i) => i.complete == true).toList();
          List<Task> uncompleted = tasklist.items.where((i) => i.complete == false).toList();
          return Column(
            children: [
              Text("Uncompleted"),
              Expanded(
                child: ListView.builder(
                  itemCount: uncompleted.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                      child: Card(
                        child: ListTile(
                          title: Text(uncompleted[index].name),
                          subtitle: Text('Due next: ${findNextDue(uncompleted[index])}'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/task',
                              arguments: uncompleted[index]
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                uncompleted[index].taskcomplete();
                              });
                            },
                            icon: Icon(Icons.check_box_outline_blank)
                          )
                        ),
                      ),
                    );
                  }
                ),
              ),
              Text("Completed"),
              Expanded(
                child: ListView.builder(
                  itemCount: completed.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                      child: Card(
                        child: ListTile(
                          title: Text(completed[index].name),
                          subtitle: Text('Due next: ${findNextDue(completed[index])}'),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/task',
                              arguments: completed[index]
                            );
                          },
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                completed[index].complete = false;
                              });
                            },
                            icon: Icon(Icons.check_box)
                          )
                        ),
                      ),
                    );
                  }
                ),
              ),
            ]
          );
        }
      ),
    );
  }

  String findNextDue(Task task){
    switch(task.frequency){
      case "Daily":
        return dailyFreq(task);
      case "Weekly":
        return weekilyFreq(task);
      default:
        return "This Message means there is a problem";

    }
  }
  
  String dailyFreq(Task task){
    var (timediff, nextdue) = timeDiff(task);
    if(timediff == 0){
      return "Tomorrow at ${task.completetimes[0].format(context)}";
    }
    else{
      return "Today at ${nextdue!.format(context)}";
    }
  }

  String weekilyFreq(Task task){
    const Map<int, String> weekdays = {1:'Monday', 2:'Tuesday', 3:'Wednesday', 4:'Thursday', 5:'Friday', 6:'Saturday', 7:'Sunday'};
    var(double timediff, TimeOfDay? nextdue) = timeDiff(task);
    DateTime now = DateTime.now();
    if(timediff == 0){
      task.completedays.sort(); //THIS IS IMPORTANT: this sorts the numbers before the loop so that it will pull the first day that is greater tomorrow so if it exists
      for(int day in task.completedays){
        if(day > now.add(const Duration(days: 1)).weekday){
          return "${weekdays[day]} at ${task.completetimes[0].format(context)}";
        }
        else if(day == now.add(const Duration(days: 1)).weekday){
          return "Tomorrow at ${task.completetimes[0].format(context)}";
        }
      }
      return "${weekdays[task.completedays[0]]} at ${task.completetimes[0].format(context)}";
      
    }
    return "Today at ${nextdue!.format(context)}";
  }

  (double, TimeOfDay?) timeDiff(Task task){
    TimeOfDay? nextdue;
    TimeOfDay nowTime = TimeOfDay.now();
    double doublenowtime = nowTime.hour.toDouble() + (nowTime.minute.toDouble() / 60);
    double timediff = 0;
    // need get the next day also for daily and weekly currently
    for(TimeOfDay timecheck in task.completetimes){
      double doubletimecheck = timecheck.hour.toDouble() + (timecheck.minute.toDouble() / 60);
      if(doublenowtime < doubletimecheck){
        double checkdiff = doubletimecheck - doublenowtime;
        if((checkdiff < timediff) || (timediff == 0)){
          timediff = checkdiff;
          nextdue = timecheck;
        }
      }
    }
    return(timediff,nextdue);
  }

  Dialog addTaskDialog(){
    return Dialog.fullscreen(
      child: Form(
        key: _formKey,
        child: Consumer<Tasks>(
          builder: (context, tasklist, child) { 
            return StatefulBuilder(
              builder: (context, setStateForDialog) {
                return Column(
                  children: [
                    Text('Add Task'),
                    taskName(),
                    taskDescription(),
                    selectFrequancy(setStateForDialog),
                    weeklyDaySelector(setStateForDialog),
                    Text("Selected Times"),
                    listSelectedTimes(setStateForDialog),
                    selectTime(setStateForDialog),
                    taskpoints(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        saveButton(tasklist),
                        IconButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                            //These are to reset the variables if the Dialog is exited without saving
                            _selectedFreq = 'Daily';
                            _selectedDays = [];
                          },
                          icon: Icon(Icons.close)
                        )
                      ],
                    ),
                  ],
                );
              }
            );
          }
        ),
      ),
    );
  }

  TextFormField taskName() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: "Task Name",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter a task name';
        }
        return null;
      },
      onSaved: (value) {
        _newname = value!;
      },
    );
  }

  TextFormField taskDescription() {
    return TextFormField(
      maxLines: null,
      decoration: InputDecoration(
        hintText: "Task Description",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter a task name';
        }
        return null;
      },
      onSaved: (value) {
        _newdescription = value!;
      },
    );
  }

  DropdownButtonFormField<String> selectFrequancy(setStateForDialog) {
    return DropdownButtonFormField(
      value: _selectedFreq,
      decoration: InputDecoration(
        hintText: "Task Name",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      items: freqdropdown.map((f){
        return DropdownMenuItem(
          value: f,
          child: Text(f),
        );
      }).toList(),
      onChanged: (value) {
        setStateForDialog(() {
          _selectedFreq = value!;
        });
      },
      onSaved: (value){
        _newfreq = value!;
      },
    );
  }

  Expanded listSelectedTimes(setStateForDialog){
    if(_newtimes.isNotEmpty){
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          
          itemCount: _newtimes.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Card(
                child: ListTile(
                  title: Text(_newtimes[index]!.format(context)),
                  trailing: IconButton(
                    onPressed: (){
                      setStateForDialog(() {
                        _newtimes.remove(_newtimes[index]);
                      });
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
    return Expanded(child: Text(''));
     
  }

  TextButton selectTime(setStateForDialog){

    return TextButton(
      onPressed: () async {
        final TimeOfDay? newtime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if(newtime != null){
          setStateForDialog(() {
            _newtimes.add(newtime);
            _newtimes.sort();
          });
        }
      },
      child: const Text('Select Time')
    );
  }

  Container weeklyDaySelector(setStateForDialog){
    List<String> daylist = ['Monday','Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if(_selectedFreq == "Weekly"){
      return Container(
        height: 85,
        child: Column(
          children: [
            Text("Day Selector"),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: MediaQuery.sizeOf(context).width / (daylist.length + .5), //this will adapt to any screen size horizontaly and the .5 is important for the side of the screen spacing
                scrollDirection: Axis.horizontal,
                itemCount: daylist.length,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index){
                  if(_selectedDays.any((s) => s.contains(daylist[index]))){
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: ListTile(
                            shape: CircleBorder(side: BorderSide()),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            visualDensity: VisualDensity(vertical: -4),
                            tileColor: Colors.red,
                            title: Text(
                              daylist[index].substring(0,3),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            onTap: () {
                              setStateForDialog(() {
                                _selectedDays.remove(daylist[index]);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  else{
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 35,
                          width: 35,
                          child: ListTile(
                            shape: CircleBorder(side: BorderSide()),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            visualDensity: VisualDensity(vertical: -4),
                            title: Text(
                              daylist[index].substring(0,3),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            onTap: () {
                              setStateForDialog(() {
                                _selectedDays.add(daylist[index]);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }
                }
              ),
            ),
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }

  TextFormField taskpoints(){
    return TextFormField(
      initialValue: "0",
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: "Task Point(s)",
        hintStyle: TextStyle(color: Colors.black, fontSize: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      validator: (value) {
        if(value == null || value.isEmpty){
          return 'Enter a task name';
        }
        return null;
      },
      onSaved: (value) {
        _points = int.parse(value!);
      },
    );
  }

  TextButton saveButton(Tasks tasklist){
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge, 
      ),
      onPressed: (){
        if (_formKey.currentState!.validate()){
          _formKey.currentState!.save();
          
          Task newtask = Task(_newname);
          newtask.newtask(
            frequency: _newfreq,
            description: _newdescription,
            completetimes: _newtimes,
            completedays: convertToDayInt(_selectedDays),
            points: _points,
          );
          tasklist.addTask(newtask);
          Navigator.of(context).pop();
          _newname = '';
          _newfreq = '';
          _newdescription = '';
          _newtimes = [];
          _selectedFreq = 'Daily';
          _selectedDays = [];
          _points = 0;
        }
      },
      child: const Text('Create'),
    );
  }

  List<int>? convertToDayInt(List<String> days){
    if(days.isEmpty){
      return null;
    }
    const Map<String, int> weekdays = {'Monday': 1,'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7};
    List<int>? intDays = [];
    for(String day in days){
      int convert = weekdays[day]!;
      intDays.add(convert);
    }
    intDays.sort();
    return intDays;
  }
} 