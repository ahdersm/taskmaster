import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:taskmaster/models/statefulvalues.dart';
import 'package:taskmaster/models/task.dart';
import 'package:taskmaster/models/tasks.dart';
import 'package:taskmaster/pages/Appbar.dart';

final _formKey = GlobalKey<FormState>();

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  

  @override
  State<TasksPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TasksPage> {
  //placeholder for private var
  String _name = '';
  //placeholder for private var
  String _freq = '';
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
    return Consumer<Tasks>(
      builder: (context, tasklist, child){
        return CustomScaffold(
          title: 'Tasks',
          body: Column( 
            children: [ 
              Expanded(
                child: ListView.builder(
                  itemCount: tasklist.items.length,
                  itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                      child: Card(
                        child: ListTile(
                          title: Text(tasklist.items[index].name),
                          subtitle: Text('Due next: ${tasklist.items[index].frequency}'),
                          trailing: IconButton(
                            onPressed: () {//Takes to viewing the task with all its details
                            },
                            icon: Icon(Icons.edit)
                          )
                        ),
                      ),
                    );
                  }
                ),
              ),
              Positioned(
                bottom: 250,
                right: 30,
                child: FloatingActionButton(
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
              ),
            ]
          )
        );
      }, 
      
    );
  }
  Consumer addTaskDialog(){
    return Consumer<Tasks>(
      builder: (context, tasklist, child){
        return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Task',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      taskName(),
                      selectFrequancy(),
                      frequancySelected(),
                      Row(
                        children: [
                          saveButton(context, tasklist),
                          IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.close))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        //scafold to scructure the form
          //new task form
            //close button
            //Task Name
            //Frequancy
            //Pick before time
            //Pick Days
            //Description of task
            //Rewards 1 point by default
            //Penalties / punishments
            //Amount completed will have 1 by default
            //save button
      }
    );
  }

  ///Start: Add Task Form fields
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
        _name = value!;
      },
    );
  }

  DropdownButtonFormField<String> selectFrequancy() {
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
        setState(() {
          _selectedFreq = value!;
        });
      },
      onSaved: (value){
        _freq = value!;
      },
    );
  }

  frequancySelected(){
    switch (_selectedFreq) {
      case 'Daily':
        return dailyFrequancy();
        break;
      case 'Weekly':
        return weeklyFrequancy();
        break;
      default:
        throw UnimplementedError('no widget for ${_selectedFreq}');
    };
  }

  dailyFrequancy(){
    return TimePickerDialog(initialTime: TimeOfDay.fromDateTime(DateTime.now()));
  }

  weeklyFrequancy(){
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
        _name = value!;
      },
    );
  }

  TextButton saveButton(BuildContext context, Tasks tasklist) {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge, 
      ),
      child: const Text('Create'),
      onPressed: (){
        if (_formKey.currentState!.validate()){
          _formKey.currentState!.save();
          Task newtask = Task(_name);
          newtask.newtask(frequency: _freq);
          tasklist.addTask(newtask);
          Navigator.of(context).pop();
        }
      },
    );
  }
///End: Diolog Add Task Form fields

}
