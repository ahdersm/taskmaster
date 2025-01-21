import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});
  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late final ValueNotifier<List<DateTime>> _selectedEvents;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  String _selectedFreq = '';
  Task _args = Task();
  final TaskProvider _tProvider = TaskProvider();

  @override
    void initState() {
      super.initState();

      _selectedDay = _focusedDay;
      _selectedEvents = ValueNotifier(getCompletesForDay(_selectedDay!));
    }

  @override
  Widget build(BuildContext context) {
    _args = ModalRoute.of(context)!.settings.arguments as Task;
    return Scaffold(
      backgroundColor: CommanMethods.backgroundcolor,
      appBar: CommanMethods.mainAppBar('Task Details: ${_args.name}'),
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return editTaskDialog();
                        }
                      );
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
                      _tProvider.deleteTask(_args.id!);
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
              descriptionbox(context, _args),
              frequancybox(_args),
              weeklyDaysgrid(_args),
              completetimes(_args),
              Text("Complete?: ${_args.complete}"),
              Text("Task Points: ${_args.points}"),
              Text("Completes: ${_args.completes}"),
              Text("Fails: ${_args.fails}"),
              
              Text("Completed Calendar"),
              TableCalendar(
                firstDay: DateTime.now().add(const Duration(days: -3650)),
                lastDay: DateTime.now().add(const Duration(days: 3650)),
                focusedDay: DateTime.now(),
                eventLoader: (day) {
                  return getCompletesForDay(day);
                },
                selectedDayPredicate: (day){
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay){
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  _selectedEvents.value = getCompletesForDay(selectedDay);
                },
                onPageChanged: (focusedDay){
                  _focusedDay = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if(events.isNotEmpty){
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.check_circle, color: Colors.green, size: 16,),
                      );
                    }
                    // Needs to have complete day and see if it does not contain the current day and mark it as something else
                    else if(_args.completedays.isNotEmpty && !_args.completedays.contains(day.weekday)){
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.cancel_outlined, color: Colors.grey, size: 16,),
                      );
                    }
                    else if(day.isAfter(DateTime.now().subtract(const Duration(days: 1))) || ((DateFormat.yMd().format(day) == DateFormat.yMd().format(DateTime.now()) && TimeOfDay.now().isBefore(_args.completetimes.last)))){
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.radio_button_off, color: Colors.grey, size: 16,),
                      );
                    }
                    else{
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Icon(Icons.cancel_outlined, color: Colors.red, size: 16,),
                      );
                    }
                  },
                ),
              ),
              ValueListenableBuilder<List<DateTime>>(
                valueListenable: _selectedEvents,
                builder: (context, value, _){
                  return ListView.builder(
                    itemCount: value.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      if(value.isEmpty){
                        return null;
                      }
                      return Container(
                        height: 40,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    }
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



  Dialog editTaskDialog(){
    const Map<int, String> weekdays = {1:'Monday',2:'Tuesday',3:'Wednesday',4:'Thursday',5:'Friday',6:'Saturday',7:'Sunday'};
    _selectedFreq = _args.frequency;
    List<TimeOfDay> newtimes = List.from(_args.completetimes);
    List<String> selectedDays = [];
    if(newtimes.isNotEmpty){
      for(int day in _args.completedays){
        selectedDays.add(weekdays[day]!);
      }
    }
    return Dialog.fullscreen(
      child: Form(
        key: _formKey,
        child: StatefulBuilder(
          builder: (context, setStateForDialog) {
            return Column(
              children: [
                Text('Add Task'),
                taskName(),
                taskDescription(),
                selectFrequancy(setStateForDialog),
                weeklyDaySelector(setStateForDialog, selectedDays),
                Text("Selected Times"),
                listSelectedTimes(setStateForDialog, newtimes),
                selectTime(setStateForDialog, newtimes),
                taskpoints(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    saveButton(selectedDays,newtimes),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: Icon(Icons.close)
                    )
                  ],
                ),
              ],
            );
          }
        ),
      ),
    );
  }

  TextFormField taskName() {
    return TextFormField(
      initialValue: _args.name,
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
        _args.name = value!;
      },
    );
  }

  TextFormField taskDescription() {
    return TextFormField(
      initialValue: _args.description,
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
        _args.description = value!;
      },
    );
  }

  DropdownButtonFormField<String> selectFrequancy(setStateForDialog) {
    List<String> freqdropdown = [
      'Daily',
      //'Every X Days',
      'Weekly',
      //'Monthly',
    ];
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
        _args.frequency = value!;
      },
    );
  }

  Expanded listSelectedTimes(setStateForDialog, newtimes){
    if(newtimes.isNotEmpty){
      return Expanded(
        child: ListView.builder(
          shrinkWrap: true,
          
          itemCount: newtimes.length,
          itemBuilder: (context, index){
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Card(
                child: ListTile(
                  title: Text(newtimes[index]!.format(context)),
                  trailing: IconButton(
                    onPressed: (){
                      setStateForDialog(() {
                        newtimes.remove(newtimes[index]);
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

  TextButton selectTime(setStateForDialog, newtimes){
    return TextButton(
      onPressed: () async {
        final TimeOfDay? newtime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if(newtime != null){
          setStateForDialog(() {
            newtimes.add(newtime);
            newtimes.sort();
          });
        }
      },
      child: const Text('Select Time')
    );
  }

  Container weeklyDaySelector(setStateForDialog, List<String>selectedDays){
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
                  if(selectedDays.any((s) => s.contains(daylist[index]))){
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
                                selectedDays.remove(daylist[index]);
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
                                selectedDays.add(daylist[index]);
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
      initialValue: _args.points.toString(),
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
        _args.points = int.parse(value!);
      },
    );
  }

  TextButton saveButton(List<String> selectedDays,List<TimeOfDay> newtimes){
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge, 
      ),
      onPressed: (){
        setState(() {
          if (_formKey.currentState!.validate()){
            _formKey.currentState!.save();
            _args.completetimes = newtimes;
            if(selectedDays.isNotEmpty){
              _args.completedays = convertToDayInt(selectedDays);
            }
            if(_args.frequency == 'Daily'){
              _args.completedays = [];
            }
            _tProvider.updateTask(_args);
            Navigator.of(context).pop();
          }
        });
      },
      child: const Text('Save'),
    );
  }

  List<int> convertToDayInt(List<String> days){
    const Map<String, int> weekdays = {'Monday': 1,'Tuesday': 2, 'Wednesday': 3, 'Thursday': 4, 'Friday': 5, 'Saturday': 6, 'Sunday': 7};
    List<int>? intDays = [];
    for(String day in days){
      int convert = weekdays[day]!;
      intDays.add(convert);
    }
    intDays.sort();
    return intDays;
  }
  
  List<DateTime> getCompletesForDay(DateTime day) {
    List<DateTime> events = [];
    for(DateTime complete in _args.datetimecompleted){
      if(complete.day == day.day && complete.month == day.month && complete.year == day.year){
        events.add(complete);
      }
    }
    return events; 
  }
}