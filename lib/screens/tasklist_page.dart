import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/custom_logger.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';

final _formKey = GlobalKey<FormState>();

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  CommanMethods _cms = CommanMethods();
  late Future<List<Task>?> allTasks;
  final TaskProvider _tProvider = TaskProvider();

  @override
  void initState(){
    super.initState();
    allTasks = _tProvider.getAllTasks();
  }

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
  int currentList = 0;
  int _selectedIndex = 0;

  Color cardcolor = Colors.teal;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      allTasks = _tProvider.getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    _cms.checkLastClear();
    List<Widget> taskListOptions = <Widget>[
      uncompletedTaskList(),
      completedTaskList(),
      unavailableTaskList()
    ];
    return Scaffold(
      backgroundColor: CommanMethods.backgroundcolor,
      appBar: CommanMethods.mainAppBar('Tasks'),
      drawer: CommanMethods.mainDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context){
              getLogger("TaskListPage", "Build").t("User Pressed Create Task");
              return addTaskDialog();
            }
          );
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CommanMethods.barcolor,
        currentIndex: _selectedIndex,
        selectedItemColor: CommanMethods.selectorcolor,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outline_blank),
            label: 'Uncompleted',
            backgroundColor: Colors.blue
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box),
            label: 'Completed',
            backgroundColor: Colors.green
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.do_disturb),
            label: 'Unavailable',
            backgroundColor: Colors.grey
          ),
        ]
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0,),
        child: taskListOptions.elementAt(_selectedIndex)
      )
    );
  }

  FutureBuilder uncompletedTaskList(){
    return FutureBuilder<List<Task>?>(
      future: allTasks, 
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          default:
            if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            else if(snapshot.hasData){
              List<Task> uncompleted = filterToday(snapshot.data!.where((i) => i.complete == false).toList());
              if(uncompleted.isEmpty){
                return Center(child: Text("You have completed all tasks today!"));
              }
              return ListView.builder(
                itemCount: uncompleted.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                    child: Card(
                      child: ListTile(
                        title: Text(uncompleted[index].name),
                        subtitle: Text('Due next: ${findNextDue(uncompleted[index])}'),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/task',
                            arguments: uncompleted[index]
                          );
                          setState((){
                            allTasks = _tProvider.getAllTasks();
                          });
                        },
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              uncompleted[index].taskcomplete();
                              _tProvider.updateTask(uncompleted[index]);
                              _cms.addPoints(uncompleted[index].points);
                            });
                          },
                          icon: Icon(Icons.check_box_outline_blank)
                        )
                      ),
                    ),
                  );
                }
              );
            }
            else{
              return Center(child: Text("You have no tasks make one!"));
            }
        }
      }
    );
  }

  FutureBuilder completedTaskList(){
    return FutureBuilder<List<Task>?>(
      future: allTasks, 
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          default:
            if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            else if(snapshot.hasData){
              List<Task> completed = filterToday(snapshot.data!.where((i) => i.complete == true).toList());
              if(completed.isEmpty){
                return Center(child: Text("You have not completed anything today"));
              }
              return ListView.builder(
                itemCount: completed.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                    child: Card(
                      child: ListTile(
                        tileColor: Colors.tealAccent,
                        title: Text(completed[index].name),
                        subtitle: Text('Due next: ${findNextDue(completed[index])}'),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/task',
                            arguments: completed[index]
                          );
                          setState((){
                            allTasks = _tProvider.getAllTasks();
                          });
                        },
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              completed[index].taskuncomplete();
                              _tProvider.updateTask(completed[index]);
                              _cms.removePoints(completed[index].points);
                            });
                          },
                          icon: Icon(Icons.check_box)
                        )
                      ),
                    ),
                  );
                }
              );
            }
            else{
              return Center(child: Text("You have no tasks make one!"));
            }
        }
      }
    );
  }

  FutureBuilder unavailableTaskList(){
    return FutureBuilder<List<Task>?>(
      future: allTasks, 
      builder: (context, snapshot){
        switch(snapshot.connectionState){
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
          default:
            if(snapshot.hasError){
              return Text("${snapshot.error}");
            }
            else if(snapshot.hasData){
              List<Task> unavailable = filterOutToday(snapshot.data!.toList());
              if(unavailable.isEmpty){
                return Center(child: Text("Everything is available"));
              }
              return ListView.builder(
                itemCount: unavailable.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                    child: Card(
                      color: CommanMethods.tilecolor,
                      child: ListTile(
                        title: Text(unavailable[index].name),
                        subtitle: Text('Due next: ${findNextDue(unavailable[index]).split(' ')[0]} at 12:01 AM'),
                        onTap: () async {
                          await Navigator.pushNamed(
                            context,
                            '/task',
                            arguments: unavailable[index]
                          );
                          setState((){
                            allTasks = _tProvider.getAllTasks();
                          });
                        },
                      ),
                    ),
                  );
                }
              );
            }
            else{
              return Center(child: Text("You have no tasks make one!"));
            }
        }
      }
    );
  }

  List<Task> filterToday(List<Task> tasks){
    List<Task> available = [];
    DateTime now = DateTime.now();
    for(Task task in tasks){
      double timediff = timeDiff(task);
      // Finds Tasks that are available for the current day
      if(((task.frequency == 'Daily' || task.completedays.contains(now.weekday)) && timediff > 0) || (task.complete == true && timediff <= 0)){
        available.add(task);
        continue;
      }
    }
    return available;
  }

  List<Task> filterOutToday(List<Task> tasks){
    List<Task> unavailable = [];
    DateTime now = DateTime.now();
    for(Task task in tasks){
      double timediff = timeDiff(task);
      // Finds the tasks that would not be available after their time until the day they are available
      if(((task.frequency == 'Daily' && timediff <= 0) || (task.completedays.contains(DateTime.now().weekday) && timediff <= 0) || (task.frequency != 'Daily' && !task.completedays.contains(DateTime.now().weekday))) && task.complete == false){
        unavailable.add(task);
      }
    }
    return unavailable;
  }

  String findNextDue(Task task){
    switch(task.frequency){
      case "Daily":
        return dailyFreq(task);
      case "Weekly":
        return weekilyFreq(task);
      default:
        getLogger("TaskListPage", "findNextDue").e("A problem with a variable has happened", error: 'Variable outside of bounds for method');
        return "Check Error Logs";

    }
  }
  
  String dailyFreq(Task task){
    DateTime now = DateTime.now();
    var(double timediff, TimeOfDay? nextdue) = nextDue(task);
    if((task.completedays.contains(now.weekday) || timediff > 0) && (task.complete == false && task.fail == false)){
      return "Today at ${nextdue!.format(context)}";
    }
    return "Tomorrow at ${task.completetimes[0].format(context)}";

  }

  String weekilyFreq(Task task){
    const Map<int, String> weekdays = {1:'Monday', 2:'Tuesday', 3:'Wednesday', 4:'Thursday', 5:'Friday', 6:'Saturday', 7:'Sunday'};
    var(double timediff, TimeOfDay? nextdue) = nextDue(task);
    DateTime now = DateTime.now();
    if(task.completedays.contains(now.weekday) && timediff > 0){
      return "Today at ${nextdue!.format(context)}";
    }
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

  double timeDiff(Task task){
    TimeOfDay nowtime = TimeOfDay.now();
    double doublenowtime = nowtime.hour.toDouble() + (nowtime.minute.toDouble() / 60);
    double timediff = 0;
    // need get the next day also for daily and weekly currently
    for(TimeOfDay timecheck in task.completetimes){
      double doubletimecheck = timecheck.hour.toDouble() + (timecheck.minute.toDouble() / 60);
      if(doublenowtime < doubletimecheck || (timediff == 0)){
        double checkdiff = doubletimecheck - doublenowtime;
        if((checkdiff < timediff) || (timediff == 0)){
          timediff = checkdiff;
        }
      }
    }
    return timediff;
  }

  (double, TimeOfDay?) nextDue(Task task){
    TimeOfDay? nextdue;
    TimeOfDay nowtime = TimeOfDay.now();
    double doublenowtime = nowtime.hour.toDouble() + (nowtime.minute.toDouble() / 60);
    double timediff = 0;
    // need get the next day also for daily and weekly currently
    for(TimeOfDay timecheck in task.completetimes){
      double doubletimecheck = timecheck.hour.toDouble() + (timecheck.minute.toDouble() / 60);
      if(doublenowtime < doubletimecheck || (timediff == 0)){
        double checkdiff = doubletimecheck - doublenowtime;
        if((checkdiff < timediff) || (timediff == 0)){
          timediff = checkdiff;
          nextdue = timecheck;
        }
      }
    }
    return (timediff, nextdue);
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
                            getLogger('TaskListPage', "addTaskDialog").t("New Task Cancelled");
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
        setState(() {
          getLogger('TaskListPage', "addTaskDialog").t("New Task Created");
          if (_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            
            Task newtask = Task();
            newtask.newtask(
              name: _newname,
              frequency: _newfreq,
              description: _newdescription,
              completetimes: _newtimes,
              completedays: convertToDayInt(_selectedDays),
              points: _points,
            );
            _tProvider.createTask(newtask);
            allTasks = _tProvider.getAllTasks();
            Navigator.of(context).pop();
            _newname = '';
            _newfreq = '';
            _newdescription = '';
            _newtimes = [];
            _selectedFreq = 'Daily';
            _selectedDays = [];
            _points = 0;
          }
        });
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