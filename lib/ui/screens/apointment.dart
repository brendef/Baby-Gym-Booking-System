import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/components/interact.dart';
import 'package:babygym/ui/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  String getMonthName(String month) {
    switch (month) {
      case '1':
        return 'January';
      case '2':
        return 'Febuary';
      case '3':
        return 'March';
      case '4':
        return 'April';
      case '5':
        return 'May';
      case '6':
        return 'June';
      case '7':
        return 'July';
      case '8':
        return 'August';
      case '9':
        return 'September';
      case '10':
        return 'October';
      case '11':
        return 'November';
      case '12':
        return 'December';
      default:
        return 'Month';
    }
  }

  String getWeekday(String weekday) {
    switch (weekday) {
      case '1':
        return 'Monday';
      case '2':
        return 'Tuesday';
      case '3':
        return 'Wednesday';
      case '4':
        return 'Thursday';
      case '5':
        return 'Friday';
      case '6':
        return 'Saturday';
      case '7':
        return 'Sunday';
      default:
        return 'Weekday';
    }
  }

  String formatMinute(String minute) {
    if (minute == '0') {
      return '00';
    } else {
      return minute;
    }
  }

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

                Interact.openEmail(
                  toEmail: 'brendan.defaria@gmail.com',
                  subject: 'Baby Gym Apointment - App',
                  body:
                      'Hello, \n \n ${(apointment as dynamic)['instructor'].toString()} I ${FirebaseAuth.instance.currentUser!.displayName} will unfortunatly have to cancel my apointment for your ${(apointment as dynamic)['time']['hour'].toString()}:${formatMinute((apointment as dynamic)['time']['minute'].toString())} session on ${getWeekday((apointment as dynamic)['date']['weekday'].toString())} the ${(apointment as dynamic)['date']['day'].toString()} ${getMonthName((apointment as dynamic)['date']['month'].toString())} ${(apointment as dynamic)['date']['year'].toString()}. \n \n Kind Regards \n ${FirebaseAuth.instance.currentUser!.displayName.toString().split(" ").elementAt(0)}',
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
