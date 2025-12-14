import 'package:flutter/material.dart';

class DescriptionInputWidget extends StatefulWidget {
  const DescriptionInputWidget({
    super.key,
    required this.description,
    required this.hint
  });

  final TextEditingController description;
  final String hint;

  @override
  State<DescriptionInputWidget> createState() => _DescriptionInputWidgetState();
}

class _DescriptionInputWidgetState extends State<DescriptionInputWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        controller: widget.description,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none
        )
      )
    );
  }
}