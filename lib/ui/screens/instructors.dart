import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/ui/screens/add_apointment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Instructors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructors'),
        backgroundColor: AppTheme.babygymPrimary,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppTheme.babygymSecondary),
        child: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Instructors')
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
                    child: GestureDetector(
                      onTap: () {
                        // Take user to apointments
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddApointment(
                              document.data(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        width: MediaQuery.of(context).size.width / 1.3,
                        // height: MediaQuery.of(context).size.height / 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: AppTheme.babygymWhite,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.network(
                                (document.data() as dynamic)['photo_url'],
                                width: 130,
                                height: 130,
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${(document.data() as dynamic)['name']} (" + "${(document.data() as dynamic)['city']})",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppTheme.babygymPrimary,
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.all(5.0),
                                  //   child: Text(
                                  //     "${(document.data() as dynamic)['city']}",
                                  //     style: TextStyle(
                                  //       fontSize: 12,
                                  //       color: AppTheme.babygymPrimary,
                                  //     ),
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      (document.data() as dynamic)['venue'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.babygymPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
