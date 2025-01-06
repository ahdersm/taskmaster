import 'package:flutter/material.dart';

///   Everything in thie file is to keep consistent across the
///   application so there is not much that needs to be changed

class CommanMethods{
  static const Color backgroundcolor = Color.fromARGB(255, 214, 228, 245);
  static const Color barcolor = Color.fromARGB(255, 123, 183, 209);
  static const Color tilecolor = Color.fromARGB(255, 164, 201, 223);
  static const Color selectorcolor = Color.fromARGB(255, 29, 100, 200);
  static const Color buttoncolor = Color.fromARGB(255, 74, 160, 196);
  static AppBar mainAppBar(String title){
    return AppBar(
      backgroundColor: barcolor,
      title: Text(title),
    );
  }

  static Drawer mainDrawer(context){
    return Drawer(
      backgroundColor: backgroundcolor,
      width: 250,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 80,
            child: DrawerHeader(
              decoration: BoxDecoration(color: barcolor),
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
