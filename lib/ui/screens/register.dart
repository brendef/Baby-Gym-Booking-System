import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  var user = FirebaseAuth.instance.currentUser;
  TextEditingController _nameField = TextEditingController();
  TextEditingController _cellNumberField = TextEditingController();
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  bool _validateName = false;
  bool _validateNumber = false;
  bool _validateEmail = false;
  bool _validatePassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppTheme.babygymSecondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                controller: _nameField,
                decoration: InputDecoration(
                  labelText: "Enter Full Name",
                  errorText: _validateName ? 'Name Can\'t Be Empty' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                controller: _emailField,
                decoration: InputDecoration(
                  labelText: "Enter Email Address",
                  errorText: _validateEmail ? 'Email Can\'t Be Empty' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                controller: _cellNumberField,
                decoration: InputDecoration(
                  labelText: "Enter Cellphone number",
                  errorText: _validateNumber ? 'Number Can\'t Be Empty' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                controller: _passwordField,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  errorText:
                      _validatePassword ? 'Password Can\'t Be Empty' : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                obscureText: true,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 35,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppTheme.babygymPrimary,
              ),
              child: MaterialButton(
                onPressed: () {
                  setState(() async {
                    if (_cellNumberField.text.trim().isEmpty) {
                      _validateNumber = true;
                    } else {
                      _validateNumber = false;
                    }

                    if (_nameField.text.trim().isEmpty) {
                      _validateName = true;
                    } else {
                      _validateName = false;
                    }

                    if (_passwordField.text.trim().isEmpty) {
                      _validatePassword = true;
                    } else {
                      _validatePassword = false;
                    }

                    if (_emailField.text.trim().isEmpty) {
                      _validateEmail = true;
                    } else {
                      _validateEmail = false;
                    }

                    if (!_validateName &&
                        !_validateNumber &&
                        !_validateEmail &&
                        !_validatePassword) {
                      bool shouldNavigate = await register(
                        _nameField.text,
                        _cellNumberField.text,
                        _emailField.text,
                        _passwordField.text,
                      );
                      if (shouldNavigate) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Home(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  });
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Alreadt have an account? Sign in here.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 35,
            ),
          ],
        ),
      ),
    );
  }
}
