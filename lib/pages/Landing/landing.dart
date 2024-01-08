import 'package:flutter/material.dart';

import 'components/nav_items.dart';
import 'components/nav_pages.dart';

class LandingPage extends StatefulWidget {

  LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          unselectedLabelStyle:
              TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          fixedColor: Color(0xffE40101),
          currentIndex: _currentIndex,
          onTap: (int newIndex) => setState(() {
            _currentIndex = newIndex;
          }),
          items: navItems,
        ),
      );
  }
}