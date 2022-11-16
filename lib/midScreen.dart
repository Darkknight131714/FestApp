import 'package:festapp/facultyHome.dart';
import 'package:festapp/home.dart';
import 'package:festapp/inter.dart';
import 'package:festapp/main.dart';
import 'package:flutter/material.dart';

import 'adminHome.dart';

class MidScreen extends StatefulWidget {
  const MidScreen({Key? key}) : super(key: key);

  @override
  State<MidScreen> createState() => _MidScreenState();
}

class _MidScreenState extends State<MidScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.orange,
              minimumSize: Size(120, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                ),
              ),
            ),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return InterScreen();
                  },
                ),
              );
            },
            child: Text("Login as Student"),
          ),
          if (mainUser.fest != "fac")
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                minimumSize: Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return AdminHome();
                    },
                  ),
                );
              },
              child: Text("Login as Fest Organizer"),
            ),
          if (mainUser.fest == "fac")
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange,
                minimumSize: Size(120, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return FacultyHome();
                    },
                  ),
                );
              },
              child: Text("Login as Faculty"),
            ),
        ],
      ),
    );
  }
}
