import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/main.dart';
import 'package:babygym/ui/screens/add_apointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookings'),
        backgroundColor: AppTheme.babygymPrimary,
      ),
      body: Container(
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
              return ListView(
                children: snapshot.data!.docs.map((document) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      width: MediaQuery.of(context).size.width / 1.3,
                      // height: MediaQuery.of(context).size.height / 12,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppTheme.babygymWhite,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${(document.data() as dynamic)['Instructor']}',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppTheme.babygymPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Time: ${(document.data() as dynamic)['Time']}",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.babygymPrimary,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Date: ${(document.data() as dynamic)['Date']}",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppTheme.babygymPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
      ),
    );
  }
}
