// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:babygym/ui/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } catch (error) {
    print(error.toString());
    return false;
  }
}

Future<bool> register(
    String name, String cellphone, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    updateUserDetails(name, cellphone);
    return true;
  } on FirebaseAuthException catch (error) {
    if (error.code == 'weak-password') {
      print('The password provided is too weak');
    } else if (error.code == 'email-already-in-use') {
      print('The account already exists for that email');
    }
    return false;
  } catch (error) {
    print(error.toString());
    return false;
  }
}

Future<void> signOut(context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context).pop();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Login(),
    ),
  );
}

void updateUserDetails(String name, String cellphone) {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Details')
        .doc(user.uid)
        .set({
      'name': name,
      'email': user.email,
      'cellphone': cellphone,
      'uid': user.uid,
      'photo_url': 'defaultPhoto.png'
    });
  }

  FirebaseAuth.instance.currentUser!.updateProfile(displayName: name);
}

Future<bool> updateName(String name) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Details')
          .doc(user.uid)
          .update({'name': name});
    }
    user!.updateProfile(displayName: name);
    return true;
  } catch (error) {
    print(error.toString());
    return false;
  }
}

Future<void> updateProfilePicture(String name) async {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Details')
          .doc(user.uid)
          .set({'photo_url': name}, SetOptions(merge: true));
    }
  } catch (error) {
    print(error.toString());
  }
}

Future<bool> addApointment(
    String instructor, TimeOfDay? time, DateTime? date) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Apointments')
        .doc(date.toString())
        .set({
      'Instructor': instructor,
      'Time': '${time!.hour} ${time.minute}',
      'Date': '${date!.day} ${date.month} ${date.year}'
    });
    throw ('error');
  } catch (error) {
    print(error);
    return false;
  }
}

Future<String> dowloadUrl() {
  return FirebaseStorage.instance
      .refFromURL('gs://baby-gym-new.appspot.com/' +
          FirebaseAuth.instance.currentUser!.uid)
      .child('profilePhoto')
      .getDownloadURL();
}

void uploadImage({required Function(File file) onSelected}) {
  FileUploadInputElement uploadInput = FileUploadInputElement();
  uploadInput.accept = 'image/*';
  uploadInput.click();

  uploadInput.onChange.listen(
    (event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    },
  );
}

void uploadToStorage() {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final path = '$uid/profilePhoto';
  uploadImage(onSelected: (file) {
    FirebaseStorage.instance
        .refFromURL('gs://baby-gym-new.appspot.com/')
        .child(path)
        .putBlob(file)
        .then((_) {
      updateProfilePicture(path);

      FirebaseAuth.instance.currentUser!.updateProfile(photoURL: path);
    });
  });
}

// Firestore Add instructors
void addInstructors() {
  FirebaseFirestore.instance.collection('Instructors').add({
    'istrcutor 1': {
      'name': 'Miley Cyrus',
      'age': '26',
      'location': 'Cape Town',
    },
    'istrcutor 2': {
      'name': 'Micheal Jackson',
      'age': '66',
      'location': 'Joburg'
    },
    'istrcutor 3': {
      'name': 'Bill Cosby',
      'age': '96',
      'location': 'America',
    },
  });
}
