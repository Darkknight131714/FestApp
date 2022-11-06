import 'package:festapp/buyMerch.dart';
import 'package:festapp/home.dart';
import 'package:festapp/seeEvents.dart';
import 'package:flutter/material.dart';

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: _index);
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
