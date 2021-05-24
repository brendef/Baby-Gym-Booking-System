import 'package:babygym/ui/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    print(name);
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
      'uid': user.uid
    });
  }
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
    return true;
  } catch (error) {
    print(error.toString());
    return false;
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

// Original add apointment
// Future<bool> addApointment(String instructor, String time) async {
//   try {
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     var value = double.parse(time);
//     DocumentReference documentReference = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uid)
//         .collection('Apointments')
//         .doc(instructor);
//     FirebaseFirestore.instance.runTransaction((transaction) async {
//       DocumentSnapshot snapshot = await transaction.get(documentReference);
//       if (!snapshot.exists) {
//         documentReference.set({'Time': value});
//         return true;
//       }
//       double newTime = (snapshot.data() as dynamic)['Time'] + value;
//       transaction.update(documentReference, {'Time': newTime});
//       return true;
//     });
//     throw ('error');
//   } catch (error) {
//     print(error);
//     return false;
//   }
// }

// original register method
// Future<bool> register(String email, String password) async {
//   try {
//     await FirebaseAuth.instance
//         .createUserWithEmailAndPassword(email: email, password: password);
//     return true;
//   } on FirebaseAuthException catch (error) {
//     if (error.code == 'weak-password') {
//       print('The password provided is too weak');
//     } else if (error.code == 'email-already-in-use') {
//       print('The account already exists for that email');
//     }
//     return false;
//   } catch (error) {
//     print(error.toString());
//     return false;
//   }
// }
