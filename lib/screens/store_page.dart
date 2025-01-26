import 'package:flutter/material.dart';
import 'package:taskmaster/models/comman_methods.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  CommanMethods cms = CommanMethods();

  @override
  Widget build(BuildContext context) {
    return Text("Points ${cms.getPoints()}");
  }
}