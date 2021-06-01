import 'package:babygym/colors/app_theme.dart';
import 'package:babygym/firebase/flutterfire.dart';
import 'package:babygym/ui/screens/home.dart';
import 'package:babygym/ui/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var user = FirebaseAuth.instance.currentUser;
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();

  bool _validateEmail = false;
  bool _validatePassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.babygymSecondary,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppTheme.babygymSecondary,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text(
            //   'Welcome back to Baby Gym',
            //   style: TextStyle(color: Colors.white, fontSize: 25),
            // ),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: AppTheme.babygymGrey),
                    controller: _emailField,
                    decoration: InputDecoration(
                      labelText: "Enter Email Address",
                      labelStyle: TextStyle(
                        color: AppTheme.babygymGrey,
                      ),
                      errorText:
                          _validateEmail ? 'Email Can\'t Be Empty' : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white10,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: TextFormField(
                    style: TextStyle(color: AppTheme.babygymGrey),
                    controller: _passwordField,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: AppTheme.babygymGrey,
                      ),
                      labelText: "Enter Password",
                      errorText:
                          _validatePassword ? 'Password Can\'t Be Empty' : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white10,
                        ),
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
                    onPressed: () async {
                      setState(() {
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
                      });
                      if (!_validateEmail && !_validatePassword) {
                        bool shouldNavigate =
                            await signIn(_emailField.text, _passwordField.text);
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
                    },
                    child: Text(
                      'Login',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Register(),
                          ),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Sign up here.',
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
          ],
        ),
      ),
    );
  }
}
