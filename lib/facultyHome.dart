import 'package:festapp/addAdmin.dart';
import 'package:festapp/addEvent.dart';
import 'package:festapp/addMerch.dart';
import 'package:festapp/addRegisterEvent.dart';
import 'package:festapp/adminEventScreen.dart';
import 'package:festapp/adminMerch.dart';
import 'package:festapp/adminOrders.dart';
import 'package:festapp/facultyPower.dart';
import 'package:festapp/removePower.dart';
import 'package:festapp/sendNotif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// List<String> suggestions = [];

class FacultyHome extends StatefulWidget {
  const FacultyHome({Key? key}) : super(key: key);

  @override
  State<FacultyHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<FacultyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    mainUser.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              decoration: BoxDecoration(color: Colors.orange),
            ),
            Card(
              child: ListTile(
                title: const Text("Home"),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text("Give Privilege"),
              onTap: () async {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return FacultyPower();
                }));
              },
            ),
            ListTile(
              title: const Text("Remove Privilege"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) {
                  return RemovePower();
                }));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("Faculty Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              String temp = mainUser.email.replaceAll('@', '_');
              FirebaseMessaging.instance.unsubscribeFromTopic(temp);
              FirebaseMessaging.instance.unsubscribeFromTopic('student');
              if (mainUser.fest != "") {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red, Colors.deepOrange.shade300],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 60.0,
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: NetworkImage(
                            'https://aaa.iiita.ac.in/slideshow1/6.jpg'),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  mainUser.name,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "FACULTY",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'Email',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    mainUser.email,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Mobile Number',
                    style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    mainUser.mobile,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}



// ElevatedButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) {
//                 return addMerchScreen();
//               }));
//             },
//             child: Text("Merch"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) {
//                 return AddEventScreen();
//               }));
//             },
//             child: Text("Add Event"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (_) {
//                 return AddRegisterEventScreen();
//               }));
//             },
//             child: Text("Add Registerable Event"),
//           ),