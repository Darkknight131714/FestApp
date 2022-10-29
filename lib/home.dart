import 'package:festapp/buyMerch.dart';
import 'package:festapp/main.dart';
import 'package:festapp/seeEvents.dart';
import 'package:festapp/seeRegistrations.dart';
import 'package:festapp/userOrders.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mainUser.fest != "") {
                Navigator.pop(context);
              }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        children: [
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return BuyMerch();
                  },
                ),
              );
            },
            child: Text("Buy Merch"),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return UserOrders();
                  },
                ),
              );
            },
            child: Text("See Your Orders"),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return EventScreen();
                  },
                ),
              );
            },
            child: Text("See Events"),
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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return SeeRegistrationScreen();
                  },
                ),
              );
            },
            child: Text("See Your Registrations"),
          ),
        ],
      ),
    );
  }
}
