import 'package:festapp/buyMerch.dart';
import 'package:festapp/home.dart';
import 'package:festapp/seeEvents.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

List<Widget> pages = [
  HomeScreen(),
  BuyMerch(),
  EventScreen(),
];

class InterScreen extends StatefulWidget {
  const InterScreen({Key? key}) : super(key: key);

  @override
  State<InterScreen> createState() => _InterScreenState();
}

class _InterScreenState extends State<InterScreen> {
  PageController _pageController = PageController();
  int _index = 0;
  var r;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _index);
    r = FirebaseMessaging.onMessage.listen((RemoteMessage m) {
      String info = m.notification!.body.toString();
      String title = m.notification!.title.toString();
      showTopSnackBar(
        context,
        CustomSnackBar.info(message: title + ": " + info),
        displayDuration: Duration(seconds: 1),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    r.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          type: BottomNavigationBarType.fixed,
          currentIndex: _index,
          onTap: (index) {
            setState(() {
              _index = index;
              _pageController.animateToPage(index,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Merch",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: "Events",
            ),
          ],
        ),
        body: PageView(
          children: pages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ));
  }

  void onPageChanged(int page) {
    setState(() {
      _index = page;
    });
  }
}
