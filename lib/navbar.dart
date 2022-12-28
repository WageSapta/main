import 'screens/present.dart';
import 'screens/homepage.dart';
import 'screens/setting.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'constant/color.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final bar = <BarItem>[
    BarItem(
      icon: Icons.space_dashboard,
      title: 'Home',
    ),
    BarItem(
      icon: Icons.assignment_rounded,
      title: 'Present',
    ),
    BarItem(
      icon: Icons.settings_rounded,
      title: 'Settings',
    ),
  ];

  final screens = <Widget>[
    const Homepage(),
    const Presents(),
    const Setting(),
  ];
  // PageController? _pageController;
  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController();
  // }

  // @override
  // void dispose() {
  //   _pageController!.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_currentIndex],
      // PageView(
      //   physics: const NeverScrollableScrollPhysics(),
      //   controller: _pageController,
      //   onPageChanged: (index) {
      //     setState(() => _currentIndex = index);
      //   },
      //   children: screens.toList(),
      // ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          setState(() {
            _currentIndex = index;
          });
          // _pageController!.animateToPage(_currentIndex,
          //     duration: const Duration(milliseconds: 400),
          //     curve: Curves.easeOutQuad);
        },
        iconSize: 30,
        activeColor: primary,
        selectedIndex: _currentIndex,
        barItems: bar.toList(),
      ),
    );
  }
}
