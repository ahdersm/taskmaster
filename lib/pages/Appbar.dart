import 'package:flutter/material.dart';
import 'package:taskmaster/pages/tasksscreen.dart';


class CustomScaffold extends StatelessWidget{
  final Widget body;
  final String title;
  const CustomScaffold({required this.body, required this.title});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(title)
      ),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.all(0.0),
                child: Center(child: Text("Application Name")),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: (){
                //onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Tasks'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {return TasksPage();}));
                //onItemTapped(1);
              },
            ),
          ],
        )
      ),
      //This is for displaying the page that is using this appbar
      body: body,
    );
  }
}