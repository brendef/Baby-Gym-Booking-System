import 'package:babygym/cards/instuctorCard.dart';
import 'package:babygym/colors/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:babygym/model/instructor.dart';

class Instructors extends StatefulWidget {
  @override
  _Instructors createState() => _Instructors();
}

class _Instructors extends State<Instructors> {
  bool typing = false;
  TextEditingController _searchController = TextEditingController();
  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged());
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getInstructors();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var instSanp in _allResults) {
        var name = Instructor.fromSnapshot(instSanp).name.toLowerCase();
        var city = Instructor.fromSnapshot(instSanp).city.toLowerCase();
        if (name.contains(_searchController.text.toLowerCase()) ||
            city.contains(_searchController.text.toLowerCase())) {
          showResults.add(instSanp);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getInstructors() async {
    var items =
        await FirebaseFirestore.instance.collection('Instructors').get();
    setState(() {
      _allResults = items.docs;
    });
    searchResultsList();
    return "Complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: typing
            ? Center(
                child: Container(
                  alignment: Alignment.centerLeft,
                  color: AppTheme.babygymPrimary,
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: AppTheme.babygymGrey),
                    ),
                  ),
                ),
              )
            : Center(child: Text("Instructors")),
        backgroundColor: AppTheme.babygymPrimary,
        leading: IconButton(
          icon: Icon(typing ? Icons.done : Icons.search),
          onPressed: () {
            setState(() {
              typing = !typing;
              _searchController.clear();
            });
          },
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(color: AppTheme.babygymSecondary),
        child: Center(
          child: ListView.builder(
            itemCount: _resultsList.length,
            itemBuilder: (BuildContext contex, int index) =>
                buildInstructorCard(context, _resultsList[index]),
          ),
          /*
          StreamBuilder(
            stream: getInstructors(),
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
                                      "${(document.data() as dynamic)['name']} (" +
                                          "${(document.data() as dynamic)['city']})",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: AppTheme.babygymPrimary,
                                      ),
                                    ),
                                  ),
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
          ),*/
        ),
      ),
    );
  }
}
