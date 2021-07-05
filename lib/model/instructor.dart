import 'package:cloud_firestore/cloud_firestore.dart';

class Instructor {
  String city;
  String days;
  String desc;
  String email;
  String cellnum;
  String name;
  String photo;
  String province;
  String qual;
  String venue;

  Instructor(this.city, this.days, this.desc, this.email, this.cellnum,
      this.name, this.photo, this.province, this.qual, this.venue);

  Instructor.fromSnapshot(DocumentSnapshot snapshot)
      : city = snapshot['city'],
        days = snapshot['days'],
        desc = snapshot['description'],
        email = snapshot['email'],
        cellnum = snapshot['mobile_number'],
        name = snapshot['name'],
        photo = snapshot['photo_url'],
        province = snapshot['province'],
        qual = snapshot['qualification'],
        venue = snapshot['venue'];
}
