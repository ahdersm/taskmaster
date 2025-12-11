import 'package:flutter/material.dart';

const Color backgroundcolor = Color.fromARGB(255, 214, 228, 245);
const Color barcolor = Color.fromARGB(255, 123, 183, 209);

Drawer mainDrawer(context){
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
          ListTile(
            title: const Text('Store'),
            onTap: (){
              //onItemTapped(0);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/store');
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: (){
              //onItemTapped(0);
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      )
    );
  }