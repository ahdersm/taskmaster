import 'package:flutter/material.dart';

///   Everything in thie file is to keep consistent across the
///   application so there is not much that needs to be changed

class CommanMethods{
  static AppBar mainAppBar(String title){
    return AppBar(
      title: Text(title),
    );
  }

  static Drawer mainDrawer(context){
    return Drawer(
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
      );
  }
}
