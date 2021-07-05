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
        ),
      ),
    );
  }
}
