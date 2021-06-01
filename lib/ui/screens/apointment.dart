import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/screens/home.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Apointment extends StatefulWidget {
  @override
  _ApointmentState createState() => _ApointmentState();

  Object? _document;

  Apointment(Object? document) {
    this._document = document;
  }
}

class _ApointmentState extends State<Apointment> {
  Object? apointment;

  void initState() {
    apointment = widget._document;
    super.initState();
  }

  bool _apointmentRemoved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((apointment as dynamic)['instructor'].toString()),
        backgroundColor: AppTheme.babygymPrimary,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 20),
            child: Text(
              'Are you sure you would like to cancel your apointment with ' +
                  (apointment as dynamic)['instructor']
                      .toString()
                      .split(" ")
                      .elementAt(0),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20),
            child: MaterialButton(
              color: Colors.red,
              onPressed: () async {
                _apointmentRemoved = await removeApointment(
                  (apointment as dynamic)['id'].toString(),
                );

                if (_apointmentRemoved) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(),
                    ),
                    (route) => false,
                  );
                }
              },
              child: Text(
                'Cancel Apointment',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
