import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;

  TextEditingController _nameField = TextEditingController();

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
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                          ),
                          radius: 50.0,
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
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (val) {
                                if (val!.length == 0) {
                                  return "Full Name cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () async {
                                  bool changeName =
                                      await updateName(_nameField.text);
                                  if (changeName) {
                                    _nameField.clear();
                                  }
                                },
                                child: Text(
                                  'Change Name',
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
                            'Change Email',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Enter Email",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (val) {
                                if (val!.length == 0) {
                                  return "Email cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () {},
                                child: Text(
                                  'Change Email',
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
                              decoration: InputDecoration(
                                labelText: "Enter Cellphone number",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              validator: (val) {
                                if (val!.length == 0) {
                                  return "Cellphone number cannot be empty";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () {},
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
// 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
