import 'package:flutter/material.dart';

class NameInputWidget extends StatefulWidget {
  const NameInputWidget({
    super.key,
    required this.name,
    required this.hint
  });

  final TextEditingController name;
  final String hint;

  @override
  State<NameInputWidget> createState() => _NameInputWidgetState();
}

class _NameInputWidgetState extends State<NameInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: widget.name,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
        )
      )
    );
  }
}