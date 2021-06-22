import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/screens/Instructors.dart';
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
      case 'Find Instructor':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Instructors(),
          ),
        );
        break;
      case 'Logout':
        // addInstructors();
        signOut(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 1
          ? AppBar(
              title: Center(
                child: Text(_currentIndex == 0
                    ? 'Bookings'
                    : _currentIndex == 1
                        ? 'Instructors'
                        : _currentIndex == 2
                            ? 'Profile'
                            : ''),
              ),
              actions: [
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert),
                  onSelected: handleClick,
                  itemBuilder: (BuildContext context) {
                    if (_currentIndex == 0) {
                      return {'Find Instructor', 'Logout'}.map((String choice) {
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
            )
          : null,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: AppTheme.babygymSecondary,
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
                    builder: (context) => Instructors(),
                  ),
                );
              },
              child: Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }
}
