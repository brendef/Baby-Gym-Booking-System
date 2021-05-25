import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:flutter/material.dart';

class AddApointment extends StatefulWidget {
  @override
  _AddApointmentState createState() => _AddApointmentState();
}

class _AddApointmentState extends State<AddApointment> {
  DateTime? _date;
  TimeOfDay? _time;

  List<String> instructors = [
    "Instructor 1",
    "Instructor 2",
    "Instructor 3",
    "Instructor 4",
  ];

  String instructor = "Instructor 1";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make apointment'),
        backgroundColor: AppTheme.babygymPrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select instructor'),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: instructor,
              onChanged: (value) {
                setState(() {
                  instructor = value.toString();
                });
              },
              items: instructors.map<DropdownMenuItem<String>>((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(_date == null
                ? 'Select a date'
                : '${_date!.weekday} ${_date!.day} ${_date!.month} ${_date!.year}'),
          ),
          ElevatedButton(
            onPressed: () => showDatePicker(
              context: context,
              initialDate: _date ?? DateTime.now(),
              firstDate: DateTime(2021),
              lastDate: DateTime(2222),
            ).then((date) {
              setState(() {
                _date = date;
              });
            }),
            child: Text('Select a date'),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: Text(_time == null
                ? 'Select the time'
                : '${_time!.hour} : ${_time!.minute}'),
          ),
          ElevatedButton(
            onPressed: () => showTimePicker(
              context: context,
              initialTime: _time ?? TimeOfDay(hour: 9, minute: 0),
            ).then((time) {
              setState(() {
                _time = time;
              });
            }),
            child: Text('Select a time'),
          ),
          Container(
            child: MaterialButton(
              onPressed: () async {
                await addApointment(instructor, _time, _date);
                Navigator.of(context).pop();
              },
              child: Text('Book Apointment'),
            ),
          ),
        ],
      ),
    );
  }
}
