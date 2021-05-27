import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController _nameField = TextEditingController();

  TextEditingController _numberField = TextEditingController();

  bool _validateName = false;
  bool _validateNumber = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('Details')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: AppTheme.babygymPrimary,
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    height: 250.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.babygymSecondary,
                          AppTheme.babygymPrimary
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        StreamBuilder<String>(
                          stream: dowloadUrl().asStream(),
                          builder: (context, snapshot) {
                            return snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator(
                                    color: AppTheme.babygymGrey,
                                  )
                                : GestureDetector(
                                    onTap: uploadToStorage,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        snapshot.data.toString(),
                                      ),
                                      child: Container(
                                        alignment: Alignment.bottomRight,
                                        child: Icon(Icons.camera_alt),
                                      ),
                                      radius: 50.0,
                                    ),
                                  );
                          },
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          '${(document.data() as dynamic)['name']}',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          '${(document.data() as dynamic)['email']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Text(
                            'Edit Your Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Change Name',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              controller: _nameField,
                              decoration: InputDecoration(
                                labelText: "Enter Full Name",
                                errorText: _validateName
                                    ? 'Name Can\'t Be Empty'
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () {
                                  setState(() {
                                    if (_numberField.text.trim().isEmpty) {
                                      _validateName = true;
                                    } else {
                                      _validateName = false;
                                      bool changeName =
                                          updateName(_nameField.text);
                                      if (changeName) {
                                        _nameField.clear();
                                      }
                                    }
                                  });
                                },
                                child: Text(
                                  'Change Number',
                                  style: TextStyle(
                                    color: AppTheme.babygymGrey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Change Cellphone number',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              controller: _numberField,
                              decoration: InputDecoration(
                                labelText: "Enter Cellphone number",
                                errorText: _validateNumber
                                    ? 'Number Can\'t Be Empty'
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () {
                                  setState(() {
                                    if (_numberField.text.trim().isEmpty) {
                                      _validateNumber = true;
                                    } else {
                                      _validateNumber = false;
                                      bool changeNumber =
                                          updateCellphone(_numberField.text);
                                      if (changeNumber) {
                                        _numberField.clear();
                                      }
                                    }
                                  });
                                },
                                child: Text(
                                  'Change Number',
                                  style: TextStyle(
                                    color: AppTheme.babygymGrey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 25.0),
                          child: Text(
                            'Privacy settings',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Change Password',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Current Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          validator: (val) {
                            if (val!.length == 0) {
                              return "Current password field cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'New Password',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "New Password",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          validator: (val) {
                            if (val!.length == 0) {
                              return "New password field cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            'Confirm New Password',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Comfirm new Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (val) {
                                if (val!.length == 0) {
                                  return "Confirm new password field cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              obscureText: true,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () {},
                                child: Text(
                                  'Change Password',
                                  style: TextStyle(color: AppTheme.babygymGrey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
