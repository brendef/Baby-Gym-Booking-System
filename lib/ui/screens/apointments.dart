import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/ui/screens/apointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Apointments extends StatelessWidget {
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
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: AppTheme.babygymSecondary),
      child: Center(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('Apointments')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (snapshot.data!.docs.length > 0) {
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Apointment(
                              document.data(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width / 1.3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.babygymWhite,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Column(
                                  children: [
                                    Text(
                                      (document.data() as dynamic)['date']
                                              ['day']
                                          .toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${getMonthName((document.data() as dynamic)['date']['month'].toString())}' +
                                          ',',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      getWeekday((document.data()
                                              as dynamic)['date']['weekday']
                                          .toString()),
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    child: Text(
                                      (document.data()
                                          as dynamic)['instructor'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppTheme.babygymPrimary,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      ' Time: ${(document.data() as dynamic)['time']['hour'].toString()}:' +
                                          formatMinute((document.data()
                                                  as dynamic)['time']['minute']
                                              .toString()),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.babygymPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              return Text(
                "No Appointments Made Yet",
                style: TextStyle(
                  fontSize: 32,
                  color: AppTheme.babygymGrey,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
