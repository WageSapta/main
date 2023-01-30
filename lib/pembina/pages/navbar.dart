import '../provider/presenst_provider_class.dart';
import 'package:provider/provider.dart';

import 'present.dart';
import 'homepage.dart';
import 'setting.dart';
import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import '/constant/color.dart';

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

  @override
  Widget build(BuildContext context) {
    var present = Provider.of<PresentsProviderClass>(context);
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          if (present.isMultiple) {
            present.isMultiple = false;
            present.selectedPresents.clear();
          }
          setState(() {
            _currentIndex = index;
          });
        },
        iconSize: 30,
        activeColor: primary,
        selectedIndex: _currentIndex,
        barItems: bar.toList(),
      ),
    );
  }
}
