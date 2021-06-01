// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'package:babygym/ui/screens/splash.dart';
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
      builder: (context) => Splash(),
    ),
  );
}

Future<bool> changePassword(String password) async {
  try {
    await FirebaseAuth.instance.currentUser!.updatePassword(password);
    print('password chanegd');
    return true;
  } catch (error) {
    print(error);
    return false;
  }
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

bool updateName(String name) {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    if (user != null) {
      FirebaseFirestore.instance
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

bool updateCellphone(String cellphone) {
  User? user = FirebaseAuth.instance.currentUser;
  try {
    if (user != null) {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .collection('Details')
          .doc(user.uid)
          .update({'cellphone': cellphone});
    }
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
        .doc(date.toString() + time.toString())
        .set({
      'id': date.toString() + time.toString(),
      'instructor': instructor,
      'time': {
        'hour': time!.hour,
        'minute': time.minute,
      },
      'date': {
        'weekday': date!.weekday,
        'day': date.day,
        'month': date.month,
        'year': date.year,
      }
    }, SetOptions(merge: true));
    throw ('error in add apointment');
  } catch (error) {
    print(error);
    return false;
  }
}

Future<bool> removeApointment(String id) async {
  try {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('Apointments')
        .doc(id)
        .delete();
    return true;
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

// Future<List<String>> fetchInstructors() async {
//   final doc = await FirebaseFirestore.instance.collection('Instructors').get();
//   final instructors = doc;
//   print(instructors);
//   return [] ;
// }

// List fetchInstructors() {
//   List instructors = [];
//   FutureBuilder(
//     future: FirebaseFirestore.instance.collection('Instructors').get(),
//     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       if (!snapshot.hasData) {
//         return Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         );
//       }
//       snapshot.data!.docs[name].add;
//     },
//   );
// }

List populateInstructors() {
  List instructors = [];
  return instructors;
}

// Firestore Add instructors
void addInstructors() {
  print("Running");
  List instructors = [
    {
      'name': 'Anne Kruger',
      'description': "“Life is not measured by the number of breaths we " +
          "take, but by the moments that take our breath away“ - Maya Angelou." +
          "I believe being a BabyGym Instructor, my life will be filled with" +
          "a magnitude of moments that will take my breath away. At BabyGym" +
          "we stimulate our babies' senses, brain and muscles to ensure" +
          "that they develop optimally. It will be my great privilege to" +
          "share these special, intimate moments with many mom’s and" +
          "babies in Bloemfontein." +
          "\n" +
          "Ek is passievol oor vroeë kinderontwikkeling, en sien uit daarna" +
          "om met kennis, deernis en toewyding nuwe Mammas te lei om die" +
          "verskillende fases van ontwikkeling en leer saam met hul babas" +
          "te ontdek en te koester. Deur BabaGim stimuleer ons baba se " +
          "sintuie, brein en spiere vir optimale ontwikkeling. Ek sien" +
          "uit daarna om hierdie spesiale oomblikke met die mammas te deel.",
      'qualification':
          'BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Tuesdays, Wednesdays',
      'mobile_number': '084 585 5626',
      'email': 'annelie.kruger@babygym.co.za',
      'venue': 'Delano View,\n' + 'Lillyvale,\n' + 'Bloemfontein',
      'province': 'Free State',
      'city': 'Bloemfontein',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1602152369_upme_thumb_anne-carstens.jpg',
    },
    {
      'name': 'Anneri Naudé',
      'description': "It is a privilege to be able to live my passion and" +
          "love for babies, children and people through BabyGym. As a mom of" +
          "2 busy bees I know the heart of a mommy – we only want the best" +
          "for our children. Come and enjoy 5 weeks of fellowship and fun" +
          "with your baby, me and other mommies. Invest in your child’s future" +
          "and join the BabyGym family. I am looking forward to meeting you!" +
          "\n" +
          "Wat 'n voorreg om my passie en liefde vir babas, kinders en mense deur" +
          "BabaGim te kan uitleef. As 'n mamma van 'n 2 woelwaters weet ek" +
          "dat 'n mamma-hart net die beste vir haar kinders wil hê. Kom geniet " +
          "5 weke van kameraadskap en pret saam met jou baba, my en ander " +
          "mammas. Belê in jou kind se toekoms en sluit aan by die " +
          "BabaGim-familie. Ek sien uit daarna om julle te ontmoet!",
      'qualification':
          'BabyGym 1, BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Wednesdays',
      'mobile_number': '082 731 4764',
      'email': 'anneri.naude@babygym.co.za',
      'venue': 'VenueOmega 3\n' + 'Aanhou-Wen\n' + 'Stellenbosch\n' + '7600',
      'province': 'Western Cape',
      'city': 'Stellenbosch & Paarl',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1566914208_upme_thumb_anneri-naude-2.jpg',
    },
    {
      'name': 'Camilla Roux',
      'description': "Hi, I am a mom of 2 and did BabyGym 2 with both my" +
          "each week. Because I could see the value of this incredible " +
          "kids. I could see the difference in the development of my kids " +
          "program in the development of my children, I couldn’t wait to " +
          "become an instructor myself. So please join me in this informative, " +
          "practical, fun filled 5 week program that will forever make a " +
          "difference in your and your baby’s life. I can’t wait to start " +
          "this journey with you." +
          "\n" +
          "Ek is ñ mamma van 2 en het self BabaGim gedoen met beide my kinders." +
          "Ek kon elke week die ontwikkeling in my klein lyfies sien. So toe " +
          "ek die geleentheid kry om deel te wees van die fenomenale program " +
          "het ek dit met beide arms aangegryp. Ek het 'n ongelooflike passie " +
          "vir die ontwikkeling van babas en met my agtergrond waar ek vir " +
          "meer as 12 jaar met babas gewerk het, glo ek dat ek 'n aanwins " +
          "sal wees. Ek is ongelooflik opgewonde oor die nuwe hoofstuk in my lewe.",
      'qualification':
          'BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': '',
      'mobile_number': '084 582 2219',
      'email': 'camilla.roux@babygym.co.za',
      'venue': 'Roosmaryn Clinic,\n' +
          '47 Schumann Street,\n' +
          'Vanderbijlpark,\n' +
          '1911',
      'province': 'Gauteng',
      'city': 'Vanderbijlpark',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1588250592_upme_thumb_camilla-roux-2.jpg',
    },
    {
      'name': 'Celeste Muller',
      'description':
          "“Swangerskap, babas en hulle ontwikkeling is my passie. Ek is self ‘n ma van twee lieflike tiener-dogters, maar ek sal nooit die gevoel van oorweldiging vergeet na hulle geboorte nie. As BabaGim Instrukteer vind ek die grootste vreugde daarin om ouers te bemagtig met die “gereedskap” wat hulle nodig het om hulle babas te help ontspan, te stimuleer en te sien ontwikkel op 'n fisiese, emosionele, sosiale en kognitiewe vlak.”",
      'qualification':
          'BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': '',
      'mobile_number': '082 456 7630',
      'email': 'celeste.muller@babygym.co.za',
      'venue':
          'Baartman Street 52,\n' + 'Jordania,\n' + 'Bethlehem,\n' + '9701',
      'province': 'Free State',
      'city': 'Bethlehem',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1566913828_upme_thumb_celeste-muller-2.jpg',
    },
    {
      'name': 'Charlotte Gouws',
      'description':
          "I'm “Passionate” about BabyGym! Love, care and enthusiasm drive me. So, join me and have fun while stimulating your baby.",
      'qualification':
          'BabyGym 1, BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Wednesdays, Thursdays',
      'mobile_number': '084 901 4614',
      'email': 'charlotte.gouws@babygym.co.za',
      'venue': '22 Suikerbos Way,\n' + 'Durbanville Hills',
      'province': 'Western Cape',
      'city': 'Durbanville Hills',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1541399063_upme_thumb_charlotte-gouws-2.jpg',
    },
    {
      'name': 'Corné Kotze',
      'description':
          "It is always such an unbelievable privilege to work together with you as parents and your most precious gift – your baby. For me the development of babies and children has always been a passion. I really strive to empower and guide parents to help them to unlock their baby’s and child’s potential and also to insure a happy child. At BabyGym we take the first special guiding steps for parents and babies to achieve this. Pleases contact me if you want to be part of this wonderful journey. I am very excited and can’t wait to meet you." +
              "\n" +
              "Dit bly vir my ‘n ongelooflike voorreg om saam met ouers met hul kosbaarste besitting te werk. Ontwikkeling van babas en kinders is vir my ‘n passie en ek was nog altyd daarop ingestel om ouers te bemagtig om hul kind tot volle potensiaal te lei en te ontwikkel. BabaGim is waar die eerste reeks planne begin wat ‘n spesiale wegspringplek bied vir elke baba. Kontak my gerus sodat ons die reis kan begin. Ek is opgewonde om jou te ontmoet.",
      'qualification':
          'BabyGym 1, BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Wednesdays',
      'mobile_number': '082 971 3448',
      'email': 'corne.kotze@babygym.co.za',
      'venue': 'Hertzenberg 12\n' + 'Wilkoppies\n' + 'Klerksdorp',
      'province': 'North West',
      'city': 'Klerksdorp',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1588250027_upme_thumb_corne-kotze-2.jpg',
    },
    {
      'name': 'Cozette Laubser',
      'description':
          "I have been a part of the BabyGym team since 2007 and love the program more every day. Learning to appreciate pregnancy, birth and the first 14 months of a baby's life from a brain developmental point of view is such a refreshing and awe-inspiring perspective. My focus is BabyGym Instructor Training, BabyGym 1, and Play Learn Grow workshops. But you are welcome to contact me with any BabyGym related questions, I would love to help.",
      'qualification': 'BabyGym 1, Play Learn Grow, Instructor Training',
      'days': 'Saturdays',
      'mobile_number': '071 60 543 18',
      'email': 'cozette.dejager@babygym.co.za',
      'venue': 'BabyGym Institute\n' +
          'No 44 7th Street\n' +
          'Linden\n' +
          'Johannesburg',
      'province': 'Gauteng',
      'city': 'Linden',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1612513416_upme_thumb_babygym_advanced-babygym-instructor_cozette-laubser_.png',
    },
    {
      'name': 'Daneke Coetser',
      'description':
          "I am mom to two gorgeous boys. Before qualifying as a BabyGym Instructor I completed BabyGym 1 and BabyGym 2 with both my boys. I found the experience informative and highly beneficial, and would love to share the wonder of BabyGym with you. Contact me so that we can build those little brains." +
              "\n" +
              "Ek is ‘n mamma van 2 pragtige seuntjies en het self die BabaGim 1 en BabaGim 2 kursusse met beide van hulle gedoen. Ek sal graag die leersame ondervinding wat ek gehad het wil deel met mede mammas en babas. Kontak my gerus. Saam kan ons ‘n beter brein bou.",
      'qualification':
          'BabyGym 1, BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Tuesdays, Wednesdays, Thursdays',
      'mobile_number': '083 393 1102',
      'email': 'daneke.coetser@babygym.co.za',
      'venue':
          '18 Heritage Village,\n' + 'Premier Park,\n' + 'Tzaneen,\n' + '0850',
      'province': 'Limpopo',
      'city': 'Tzaneen & Hoedspruit',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1566914354_upme_thumb_daneke-coetser-2.jpg',
    },
    {
      'name': 'Elanza Nefdt',
      'description':
          "As an early childhood development practitioner, and a mom of 2, I have so much appreciation for understanding how young children learn and develop. I know how vulnerable we are as new moms (even if it is the 2nd or 3rd time around!) and I value the privilege to be able to guide moms to make the most of the first year with their babies. To have a support network and to be equipped with such practical and well researched tools as which BabyGym has to offer is priceless. Not only are we laying a firm foundation for learning, but mom and baby are bonding on a whole other level. I cannot wait to share this special journey with you!" +
              "\n" +
              "As ŉ vroeë kinderontwikkelingspraktisyn en ŉ mamma van 2, het ek soveel waardering om te verstaan hoe jong kinders leer en ontwikkel. Ek weet hoe kwesbaar ons is as nuwe mammas (al is dit al die 2de of 3de keer!) en ek waardeer die geleentheid om mammas te lei om net die heel beste te maak van die eerste jaar met hulle nuwe babas. Om ŉ ondersteuningsnetwerk te hê en om toegerus te wees met die praktiese en goed nagevorsde ‘gereedskap’ wat BabaGim bied, is van onskatbare waarde. Ons lê nie net ŉ ferm grondslag vir leer nie, maar mamma en baba bind op ŉ heel ander vlak. Ek kan nie wag om hierdie spesiale avontuur met jou te deel nie!",
      'qualification':
          'BabyGym 1, BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Tuesdays, Thursdays, Saturdays',
      'mobile_number': '072 422 0363',
      'email': 'elanza.nefdt@babygym.co.za',
      'venue': '826 Barnard Street,\n' + 'Wingate Park,\n' + 'Pretoria',
      'province': 'Gauteng',
      'city': 'Wingate Park, Pretoria',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1601540863_upme_thumb_elanza-nefdt.jpg',
    },
    {
      'name': 'Elzaan Naudé',
      'description':
          "I am absolutely thrilled to equip parents and caregivers in making the most of their baby’s vital early-life experiences with massage, movement and play. The BabyGym program provides the opportunity to bond with your baby and gain an understanding into their sensory world. Integrating the program as a lifestyle will surely develop firm foundations for future learning! “Children are not things to be molded, but are people to be unfolded” Jess Lair",
      'qualification':
          'BabyGym 1, BabyGym 2, BabyGym 3, Special Needs, Community Service, Friends of BabyGym Training',
      'days': 'Thursdays',
      'mobile_number': '082 575 3916',
      'email': 'elzaan.naude@babygym.co.za',
      'venue': '29 Glacier Drive,\n' +
          'Midstream Hill Estate,\n' +
          'Stand 3907,\n' +
          'Midstream,\n' +
          '1692',
      'province': 'Gauteng',
      'city': 'Midstream',
      'photo_url':
          'https://www.babygym.co.za/wp-content/uploads/upme/1614591562_upme_thumb_elzaan-naude-2.jpg',
    }
  ];
  print(instructors.length);
  for (int i = 0; i < instructors.length; i++) {
    FirebaseFirestore.instance
        .collection('Instructors')
        .doc(i.toString())
        .set(instructors[i]);
  }
}
