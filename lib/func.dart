import 'dart:convert';
import 'dart:io';

import 'package:festapp/registerTeam.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<String> signIn(String email, String password) async {
  if (email == "" || password == "") {
    return "Please Fill both the fields.";
  }
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return "True";
  } catch (e) {
    return "Invalid User Credentials";
  }
}

Future<String> register(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return "True";
  } catch (e) {
    return e.toString();
  }
}

Future<void> addUser(
    String email, String name, String roll, String mobile) async {
  await FirebaseFirestore.instance.collection('users').add({
    'name': name,
    'email': email,
    'roll': roll,
    'mobile': mobile,
    'fest': "",
  });
  mainUser.changeUser(name, email, mobile, roll, "");
}

Future<String> keepLoggedIn(String email) async {
  String fest = "";
  await firestore
      .collection('users')
      .where('email', isEqualTo: email)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((documentSnapshot) {
      fest = documentSnapshot['fest'];
      mainUser.changeUser(
          documentSnapshot['name'],
          email,
          documentSnapshot['mobile'],
          documentSnapshot['roll'],
          documentSnapshot['fest']);
    });
  });
  return fest;
}

Future<String> checkPower(String email) async {
  await firestore
      .collection('users')
      .where('email', isEqualTo: email)
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((documentSnapshot) {
      return documentSnapshot['fest'];
    });
  });
  return "";
}

Future<String> upload(File file) async {
  var uuid = Uuid();
  String uid = uuid.v4();
  String down = "";
  FirebaseStorage _storage = FirebaseStorage.instance;
  Reference reference = _storage.ref().child("images/$uid");
  UploadTask uploadTask = reference.putFile(file);
  await uploadTask.then((res) async {
    int count = 0;
    down = await res.ref.getDownloadURL();
  });
  return down;
}

Future<void> addMerch(String fest, String name, String price,
    List<String> colors, List<String> links) async {
  await FirebaseFirestore.instance
      .collection(fest)
      .doc('merch')
      .collection('merch')
      .add({
    'name': name,
    'price': price,
    'colors': colors,
    'links': links,
    'available': true
  });
}

Future<void> addOrder(String fest, String merchName, String paymentID,
    String color, String size) async {
  await FirebaseFirestore.instance.collection('orders').add({
    'fest': fest,
    'merchName': merchName,
    'name': mainUser.name,
    'roll': mainUser.roll,
    'phone': mainUser.mobile,
    'email': mainUser.email,
    'delivered': false,
    'paymentID': paymentID,
    'color': color,
    'size': size,
  });
}

Future<void> uploadEvent(String title, String desc, String venue, String link,
    DateTime? selec, String time) async {
  FirebaseFirestore.instance.collection('events').add({
    'fest': mainUser.fest[0] + mainUser.fest[1] + mainUser.fest[2],
    'title': title,
    'desc': desc,
    'venue': venue,
    'link': link,
    'date': selec,
    'time': time,
    'register': false,
    'archive': false
  });
}

Future<void> uploadRegisterEvent(
    String title,
    String desc,
    String venue,
    String link,
    DateTime? selec,
    String time,
    DateTime? deadline,
    int teamSize) async {
  FirebaseFirestore.instance.collection('events').add({
    'fest': mainUser.fest[0] + mainUser.fest[1] + mainUser.fest[2],
    'title': title,
    'desc': desc,
    'venue': venue,
    'link': link,
    'date': selec,
    'time': time,
    'register': true,
    'deadline': deadline,
    'teamSize': teamSize,
    'emails': [],
    'registrations': [],
    'archive': false
  });
}

Future<int> checkEmails(List<String> emails) async {
  int count = 0;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  await users.get().then((snap) {
    for (var doc in snap.docs) {
      if (emails.contains(doc['email'])) {
        for (int i = 0; i < emails.length; i++) {
          if (doc['email'] == emails[i]) {
            names[i] = doc['name'];
          }
        }
        count++;
      }
    }
  });
  return count;
}

Future<String> checkAlreadyRegistered(List<String> emails, String docID) async {
  bool cond = true;
  String email = "";
  DocumentReference event =
      FirebaseFirestore.instance.collection('events').doc(docID);
  await event.get().then((snap) {
    print(snap['emails']);
    for (int i = 0; i < emails.length; i++) {
      if (snap['emails'].contains(emails[i])) {
        cond = false;
        email = emails[i];
      }
    }
  });
  if (cond) {
    return '@accepted';
  } else {
    return email;
  }
}

Future sendNotif(String title, String info) async {
  Map<String, dynamic> m = {
    "to": "/topics/student",
    "notification": {
      "body": info,
      "title": title,
    },
    "body": info,
    "title": title,
    "mutable_content": true,
    "sound": "Tri-tone"
  };
  Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  var resp = await http.post(url, body: jsonEncode(m), headers: {
    "Authorization":
        "key=AAAAfQgzZLc:APA91bErrTyOqy_tQYphJRhE8sKtjGV1le8GFOQIWmbsFvoJ2HkefKTBt67FbQUgB9NY8ZMCLM9hFQ6X0kqdndRzV8pISQ7jH2o4qpMseb5L46HzpoqbI5t7HI61EWyNzFvRehUymnkx",
    "Content-Type": "application/json"
  });
}

Future sendTaskNotif(String title, String info, String fest) async {
  Map<String, dynamic> m = {
    "to": "/topics/${fest}",
    "notification": {
      "body": info,
      "title": title,
    },
    "body": info,
    "title": title,
    "mutable_content": true,
    "sound": "Tri-tone"
  };
  Uri url = Uri.parse("https://fcm.googleapis.com/fcm/send");
  var resp = await http.post(url, body: jsonEncode(m), headers: {
    "Authorization":
        "key=AAAAfQgzZLc:APA91bErrTyOqy_tQYphJRhE8sKtjGV1le8GFOQIWmbsFvoJ2HkefKTBt67FbQUgB9NY8ZMCLM9hFQ6X0kqdndRzV8pISQ7jH2o4qpMseb5L46HzpoqbI5t7HI61EWyNzFvRehUymnkx",
    "Content-Type": "application/json"
  });
}
