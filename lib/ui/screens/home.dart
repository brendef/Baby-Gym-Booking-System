import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/screens/Instructors.dart';
import 'package:babygym/ui/screens/add_apointment.dart';
import 'package:babygym/ui/screens/apointments.dart';
import 'package:babygym/ui/screens/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> _pages = [
    Apointments(),
    Instructors(),
    Profile(),
  ];

  int _currentIndex = 0;

  void _incrementTab(index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Add Apointment':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddApointment(),
          ),
        );
        break;
      case 'Edit Profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddApointment(),
          ),
        );
        break;
      case 'Logout':
        signOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentIndex == 0
            ? 'Bookings'
            : _currentIndex == 1
                ? 'Instructors'
                : _currentIndex == 2
                    ? 'Profile'
                    : ''),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              if (_currentIndex == 0) {
                return {'Add Apointment', 'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              } else {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }
            },
          ),
        ],
        backgroundColor: AppTheme.babygymPrimary,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Instructors',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
        onTap: (index) {
          _incrementTab(index);
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              backgroundColor: AppTheme.babygymPrimary,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddApointment(),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
