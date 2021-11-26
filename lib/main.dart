import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:scheduler_flutter/bottomnavigationbar.dart';
import 'package:scheduler_flutter/getstarted.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'firestore';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var token = sharedPreferences.getString('token');

  print(token);
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "its my app",
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
    ),
    home: Scaffold(
      body: token == null ? startingscreen() : MyBottomBarDemo(),
      // body: uid == null ? startingscreen() : home(),
    ),
  ));
}
