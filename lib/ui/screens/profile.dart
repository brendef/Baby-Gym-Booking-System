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
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _newPasswordField = TextEditingController();
  TextEditingController _confirmPasswordField = TextEditingController();

  bool _validateName = false;
  bool _validateNumber = false;
  bool _validatePassword = false;
  bool _validateNewPassword = false;
  bool _validateConfirmPassword = false;
  bool _notStrong = false;
  bool _passwordsMatch = false;
  String _currentPassword = "false";
  bool _currentPassBool = false;

  Text passwordMessage = Text('');

  bool checkPasswordsMatch(String newPassword, String confirmPassword) {
    if (newPassword == confirmPassword) {
      return true;
    } else {
      setState(() {
        passwordMessage = Text(
          'Passwords do not match',
          style: TextStyle(
            color: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  Text getPasswordError(String password) {
    if (password.length < 6) {
      setState(() {
        _notStrong = true;
      });
      return Text(
          'Password is too short, please enter a password longer than 6 characters');
    } else if (!password.contains(new RegExp(r'[A-Z]'))) {
      setState(() {
        _notStrong = true;
      });
      return Text('Password contains no capital letters');
    } else if (!password.contains(new RegExp(r'[0-9]'))) {
      setState(() {
        _notStrong = true;
      });
      return Text('Password is too weak, it has no numbers');
    } else if (password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      setState(() {
        _notStrong = true;
      });
      return Text('Password contains no special characters, eg: * # & @ !');
    }
    setState(() {
      _notStrong = false;
    });
    return Text('');
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
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
              print(document);
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
                                    if (_nameField.text.isEmpty) {
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
                            'Change Cellphone Number',
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextFormField(
                              controller: _numberField,
                              decoration: InputDecoration(
                                labelText: "Enter Cellphone Number",
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
                          controller: _passwordField,
                          decoration: InputDecoration(
                            labelText: "Current password",
                            errorText: _validatePassword
                                ? 'Current password Can\'t Be Empty'
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
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
                          controller: _newPasswordField,
                          decoration: InputDecoration(
                            labelText: "New password",
                            errorText: _validateNewPassword
                                ? 'Confrim password Can\'t Be Empty'
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
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
                              controller: _confirmPasswordField,
                              decoration: InputDecoration(
                                labelText: "Confirm new password",
                                errorText: _validateConfirmPassword
                                    ? 'Confrim password Can\'t Be Empty'
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              obscureText: true,
                            ),
                            passwordMessage,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: MaterialButton(
                                color: AppTheme.babygymPrimary,
                                onPressed: () async {
                                  _currentPassword = await signIn(
                                      FirebaseAuth.instance.currentUser!.email
                                          .toString(),
                                      _passwordField.text);
                                  setState(() {
                                    if (_passwordField.text.isEmpty) {
                                      _validatePassword = true;
                                    } else {
                                      _validatePassword = false;
                                    }
                                    if (_newPasswordField.text.isEmpty) {
                                      _validateNewPassword = true;
                                    } else {
                                      _validateNewPassword = false;
                                    }
                                    if (_confirmPasswordField.text.isEmpty) {
                                      _validateConfirmPassword = true;
                                    } else {
                                      _validateConfirmPassword = false;
                                    }
                                  });
                                  passwordMessage = getPasswordError(
                                    _newPasswordField.text,
                                  );
                                  _passwordsMatch = checkPasswordsMatch(
                                    _newPasswordField.text,
                                    _confirmPasswordField.text,
                                  );
                                  if (!(_currentPassword == "true")) {
                                    passwordMessage = Text(
                                      'Current password is incorrect',
                                      style: TextStyle(color: Colors.red),
                                    );
                                  }
                                  if (_currentPassword == "true") {
                                    _currentPassBool = true;
                                  }
                                  if (!_validatePassword &&
                                      !_validateNewPassword &&
                                      !_validateConfirmPassword &&
                                      !_notStrong &&
                                      _passwordsMatch &&
                                      _currentPassBool) {
                                    bool didChange = await changePassword(
                                      _newPasswordField.text,
                                    );
                                    if (didChange) {
                                      setState(() {
                                        passwordMessage = Text(
                                          'Password has been changed sucessfully',
                                          style: TextStyle(color: Colors.green),
                                        );
                                        _passwordField.clear();
                                        _newPasswordField.clear();
                                        _confirmPasswordField.clear();
                                      });
                                    } else {
                                      setState(() {
                                        passwordMessage = Text(
                                          'Password not changed',
                                          style: TextStyle(color: Colors.red),
                                        );
                                      });
                                    }
                                  }
                                },
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
