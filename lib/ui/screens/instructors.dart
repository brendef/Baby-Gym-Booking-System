import 'package:babygym/firebase/flutterfire.dart';
import 'package:flutter/material.dart';

class Instructors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: MaterialButton(
      onPressed: () {
        addInstructors();
      },
      child: Text('get display name'),
    ));
  }
}
