import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:taskmaster/models/comman_methods.dart';
import 'package:taskmaster/models/storeitem.dart';
import 'package:intl/intl.dart';

final _formKey = GlobalKey<FormState>();

class StoreItemDetailPage extends StatefulWidget {
  const StoreItemDetailPage({super.key});
  @override
  State<StoreItemDetailPage> createState() => _StoreItemDetailPageState();
}

class _StoreItemDetailPageState extends State<StoreItemDetailPage> {
  late ValueNotifier<List<DateTime>> _selectedEvents;
  CommanMethods _cms = CommanMethods();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  StoreItem _args = StoreItem();
  final StoreItemsProvider _sProvider = StoreItemsProvider();

  @override
  @mustCallSuper
  void didChangeDependencies() {
    _args = ModalRoute.of(context)!.settings.arguments as StoreItem;
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(getBoughtForDay(_selectedDay!));
  }

  @override
  Widget build(BuildContext context) {
    _cms.getSettings();
    return Scaffold(
      backgroundColor: CommanMethods.backgroundcolor,
      appBar: CommanMethods.mainAppBar('Item Details: ${_args.name}'),
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
                      return editItemDialog();
                    }
                  );
                },
                child: Text(
                  "Edit Item",
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
                  "Delete Item",
                  style: TextStyle(color: Colors.white),  
                )
              )
            )
          ], 
        ),
      ),
      body: Column(
        children: [
          Text("Name: ${_args.name}"),
          Text("Description: ${_args.description}"),
          Text("Cost: ${_args.cost.toString()}"),
          calender(),
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
                    alignment: Alignment.centerLeft,
                    height: 60,
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
                      title: Text('${DateFormat('kk:mm').format(value[index])}'),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            _args.revokeItemBought(value[index]);
                            _sProvider.updateItem(_args);
                            _cms.addPoints(_args.cost!);
                            
                          });
                        },
                        icon: Icon(Icons.cancel)
                      ),
                    ),
                  );
                }
              );
            }
          ),
        ],
      )
    );
  } 
  TableCalendar calender(){
    return TableCalendar(
      firstDay: DateTime.now().add(const Duration(days: -3650)),
      lastDay: DateTime.now().add(const Duration(days: 3650)),
      focusedDay: DateTime.now(),
      eventLoader: (day) {
        return getBoughtForDay(day);
      },
      selectedDayPredicate: (day){
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay){
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        _selectedEvents.value = getBoughtForDay(selectedDay);
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
          else if(day.isAfter(DateTime.now().subtract(const Duration(days: 1))) || DateFormat.yMd().format(day) == DateFormat.yMd().format(DateTime.now())){
            return Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.radio_button_off, color: Colors.grey, size: 16,),
            );
          }
          // Needs to have bought day and see if it does not contain the current day and mark it as something else
          else{
            return Align(
              alignment: Alignment.topLeft,
              child: Icon(Icons.cancel_outlined, color: Colors.grey, size: 16,),
            );
          }
        },
      ),
    );
  }

  List<DateTime> getBoughtForDay(DateTime day) {
    List<DateTime> events = [];
    for(DateTime complete in _args.boughtlist){
      if(complete.day == day.day && complete.month == day.month && complete.year == day.year){
        events.add(complete);
      }
    }
    return events; 
  }
  
  Dialog editItemDialog() {
    return Dialog.fullscreen(
      child: Form(
        key: _formKey,
        child: StatefulBuilder(
          builder: (context, setStateForDialog) {
            return Column(
              children: [
                TextFormField(
                  initialValue: _args.name,
                  decoration: InputDecoration(
                    hintText: "Item Name",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Enter a item name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _args.name = value!;
                  },
                ),
                TextFormField(
                  initialValue: _args.description,
                  maxLines: null,
                  decoration: InputDecoration(
                    hintText: "Item Description",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Enter a item description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _args.description = value!;
                  },
                ),
                TextFormField(
                  initialValue: _args.cost.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: "Item cost",
                    hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Enter a item cast';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _args.cost = int.parse(value!);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //saveButton(selectedDays,newtimes),
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
        )
      ),
    );
  }
}