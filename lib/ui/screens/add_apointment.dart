import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/screens/home.dart';
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
                          Text(
                            '${(instructor as dynamic)['mobile_number'].toString()}',
                            style: TextStyle(
                              fontSize: 13,
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
                        : '${_date!.weekday} ${_date!.day} ${_date!.month} ${_date!.year}'),
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
                        firstDate: DateTime(2021),
                        lastDate: DateTime(2222),
                      ).then((date) {
                        setState(() {
                          _date = date;
                        });
                      }),
                      child: Text(
                        'Select a date',
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
                        : '${_time!.hour} : ${_time!.minute}'),
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
                        'Select a time',
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
                    vertical: 25,
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
                        'Book Apointment',
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
