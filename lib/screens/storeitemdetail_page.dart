import 'package:flutter/material.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/storeitem.dart';

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
  StoreItem _args = StoreItem();
  final StoreItemsProvider _sProvider = StoreItemsProvider();

  @override
  @mustCallSuper
  void didChangeDependencies() {
    _args = ModalRoute.of(context)!.settings.arguments as StoreItem;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(getCompletesForDay(_selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
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
              child: TextButton(
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
              )
            ),
            Container(
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child:TextButton(
                onPressed:(){
                  _sProvider.deleteItem(_args.id!);
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Delete Task",
                  style: TextStyle(color: Colors.white),  
                )
              )
            )
          ], 
        ),
      ),
      body: Text("PlaceHolder")
    );
  }