import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

Future<bool> register(String name, String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    print(name);
    updateUserDetails(name);
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

void updateUserDetails(String name) {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .collection('Details')
        .doc(name)
        .set({'name': name, 'email': user.email, 'uid': user.uid});
  }
}

Future<bool> addApointment(String id, String time) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = double.parse(time);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Apointments')
        .doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if (!snapshot.exists) {
        documentReference.set({'Time': value});
        return true;
      }
      double newTime = (snapshot.data() as dynamic)['Time'] + value;
      transaction.update(documentReference, {'Time': newTime});
      return true;
    });
    throw ('error');
  } catch (error) {
    print(error);
    return false;
  }
}

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
