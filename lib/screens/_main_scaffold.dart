import 'package:flutter/material.dart';

class MainScaffold extends StatelessWidget{
  final Widget body;
  final String title;
  const MainScaffold({required this.body, required this.title});

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
                child: Center(child: Text("Application Name!")),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: (){
                //onItemTapped(0);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Tasks'),
              onTap: (){
                //onItemTapped(0);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/tasks');
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