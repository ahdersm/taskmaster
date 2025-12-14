import 'package:flutter/material.dart';
import 'package:taskmaster/features/tasks/models/task_form_model.dart';


class DaySelector extends StatefulWidget{
  const DaySelector({
    super.key,
    required this.frequency,
    required this.selectedDays
  });

  final TextEditingController frequency;
  final List<SelectorDays> selectedDays;
  @override
  State<DaySelector> createState() => _DaySelector();
}

class _DaySelector extends State<DaySelector>{
  @override
  void initState(){
    widget.frequency.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final List<SelectorDays> days = SelectorDays.values;
    if(widget.frequency.text == "Daily"){
      return SizedBox.shrink();
    }
    else{
      return Container(
        height: 85,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("Day Selector"),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: MediaQuery.sizeOf(context).width / (days.length + .5), //this will adapt to any screen size horizontaly and the .5 is important for the side of the screen spacing
                scrollDirection: Axis.horizontal,
                itemCount: days.length,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index){
                  final day = days[index];
                  if(widget.selectedDays.contains(day)){
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
                              day.name.substring(0,3),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                widget.selectedDays.remove(day);
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
                              day.name.substring(0,3),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 10
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                widget.selectedDays.add(day);
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  }
                }
              )
            )
          ],
        ),
      );
    }
  }
}