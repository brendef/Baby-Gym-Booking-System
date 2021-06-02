import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/components/interact.dart';
import 'package:babygym/ui/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddApointment extends StatefulWidget {
  @override
  _AddApointmentState createState() => _AddApointmentState();

  Object? _document;

  AddApointment(Object? document) {
    this._document = document;
  }
}

class _AddApointmentState extends State<AddApointment> {
  DateTime? _date;
  TimeOfDay? _time;

  Object? instructor;

  void initState() {
    instructor = widget._document;
    super.initState();
  }

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

  String getAvailability(String days) {
    if (days == "") {
      return 'Monday to Sunday';
    } else {
      return days;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((instructor as dynamic)['name'].toString()),
        backgroundColor: AppTheme.babygymPrimary,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 30, left: 5, right: 5),
            height: 350.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFfffafa),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Image.network(
                          (instructor as dynamic)['photo_url'].toString(),
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            (instructor as dynamic)['name'].toString(),
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Cell phone number:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Interact.makeCall(
                                phoneNumber:
                                    (instructor as dynamic)['mobile_number']
                                        .toString()),
                            child: Text(
                              '${(instructor as dynamic)['mobile_number'].toString()} (Tap to call)',
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Email:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            '${(instructor as dynamic)['email'].toString()}',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              'Qualification:',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Text(
                            '${(instructor as dynamic)['qualification'].toString()}',
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bio:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        height: 120,
                        child: SingleChildScrollView(
                          child: Text(
                            (instructor as dynamic)['description'].toString(),
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Make an apointment',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${(instructor as dynamic)['name'].toString().split(" ").elementAt(0)}\'s ' +
                        'availability: ' +
                        '${getAvailability((instructor as dynamic)['days'].toString())}',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Text(_date == null
                        ? 'Select a date'
                        : '${getWeekday(_date!.weekday.toString())} ${_date!.day} ${getMonthName(_date!.month.toString())} ${_date!.year}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppTheme.babygymPrimary,
                    ),
                    child: MaterialButton(
                      onPressed: () => showDatePicker(
                        context: context,
                        initialDate: _date ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(Duration(days: 0)),
                        lastDate: DateTime.now().add(Duration(days: 60)),
                      ).then((date) {
                        setState(() {
                          _date = date;
                        });
                      }),
                      child: Text(
                        'select a date',
                        style: TextStyle(
                          color: AppTheme.babygymGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Text(_time == null
                        ? 'Select the time'
                        : '${_time!.hour}:${formatMinute(_time!.minute.toString())}'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppTheme.babygymPrimary,
                    ),
                    child: MaterialButton(
                      onPressed: () => showTimePicker(
                        context: context,
                        initialTime: _time ?? TimeOfDay(hour: 9, minute: 0),
                      ).then((time) {
                        setState(() {
                          _time = time;
                        });
                      }),
                      child: Text(
                        'select a time',
                        style: TextStyle(
                          color: AppTheme.babygymGrey,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80.0,
                    vertical: 15,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: AppTheme.babygymGrey,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        await addApointment(
                          (instructor as dynamic)['name'].toString(),
                          _time,
                          _date,
                        );
                        // replace with babygym instructor email
                        Interact.openEmail(
                          toEmail: 'brendan.defaria@gmail.com',
                          subject: 'Baby Gym Apointment - App',
                          body:
                              'Hello, \n \n ${(instructor as dynamic)['name'].toString()} I ${FirebaseAuth.instance.currentUser!.displayName} will be attending your ${_time!.hour}:${formatMinute(_time!.minute.toString())} session on ${getWeekday(_date!.weekday.toString())} the ${_date!.day} ${getMonthName(_date!.month.toString())} ${_date!.year}. \n \n Kind Regards \n ${FirebaseAuth.instance.currentUser!.displayName.toString().split(" ").elementAt(0)}',
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Home(),
                          ),
                          (route) => false,
                        );
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Home(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'Book Apointment Via Email',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.babygymPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 80.0,
                    vertical: 0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      // color: AppTheme.babygymGrey,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        await addApointment(
                          (instructor as dynamic)['name'].toString(),
                          _time,
                          _date,
                        );

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Home(),
                          ),
                          (route) => false,
                        );
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => Home(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'Book Apointment Via Whatsapp',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppTheme.babygymPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
