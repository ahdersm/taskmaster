import 'package:flutter/material.dart';
import 'package:taskmaster/features/tasks/models/task_form_model.dart';
import 'package:timezone_dropdown/timezone_dropdown.dart';

class TimeZoneWidget extends StatefulWidget {
  const TimeZoneWidget({super.key, required this.task});

  final TaskFormModel task;

  @override
  State<TimeZoneWidget> createState() => _TimeZoneWidgetState();
}

class _TimeZoneWidgetState extends State<TimeZoneWidget> {
  @override
  Widget build(BuildContext context) {
    return TimezoneDropdown(
      hintText: 'Select Timezone',
      onTimezoneSelected: (timeZone) => widget.task.changeTimeZone(timeZone),
    );
  }
}