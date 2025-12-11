import 'package:flutter/material.dart';

const double appbarheight = 55;
const Color barcolor = Color.fromARGB(255, 123, 183, 209);

AppBar mainAppBar(String title){
  return AppBar(
    toolbarHeight: appbarheight,
    backgroundColor: barcolor,
    title: Text(title),
  );
}