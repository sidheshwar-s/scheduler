import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'dart:io';
import 'dart:async';
// import 'config.dart';

import 'dart:convert';

import 'package:scheduler_flutter/home.dart';
// import 'home.dart';

class MyBottomBarDemo extends StatefulWidget {
  @override
  _MyBottomBarDemoState createState() => new _MyBottomBarDemoState();
}

class _MyBottomBarDemoState extends State<MyBottomBarDemo> {
  int _pageIndex = 0;
  PageController _pageController = PageController();

  List<Widget> tabPages = [
    home(),
    // calender(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        onTap: onTabTapped,
        height: 50,
        // backgroundColor: Colors.white,
        items: [
          Icon(Icons.home),
          // Icon(Icons.calendar_today_rounded),
        ],
      ),
      body: PageView(
        children: tabPages,
        onPageChanged: onPageChanged,
        controller: _pageController,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.jumpToPage(index);
  }
}
