import 'package:babygym/firebase/flutterfire.dart';
import 'package:flutter/material.dart';

class AddApointment extends StatefulWidget {
  @override
  _AddApointmentState createState() => _AddApointmentState();
}

class _AddApointmentState extends State<AddApointment> {
  List<String> instructors = [
    "Instructor 1",
    "Instructor 2",
    "Instructor 3",
  ];

  String dropdownValue = "Instructor 1";
  TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          DropdownButton(
            value: dropdownValue,
            onChanged: (value) {
              setState(() {
                dropdownValue = value.toString();
              });
            },
            items: instructors.map<DropdownMenuItem<String>>((value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: TextFormField(
              controller: _timeController,
              decoration: InputDecoration(
                labelText: 'Apointment time',
              ),
            ),
          ),
          Container(
            child: MaterialButton(
              onPressed: () async {
                await addApointment(dropdownValue, _timeController.text);
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
