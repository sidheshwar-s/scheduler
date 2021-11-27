import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:scheduler_flutter/Signin.dart';
import 'package:scheduler_flutter/addtask.dart';
import 'package:scheduler_flutter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin fltrNotification =
    new FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<QueryDocumentSnapshot<Object?>>? docs1;
  String uid = "";
  getuid() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  bool isTrophyEnabled = false;
  int points = 0;

  getPoints() async {
    var pointsDoc = FirebaseFirestore.instance.collection('points').doc(uid);
    var cur = await pointsDoc.get();
    setState(() {
      points = cur.data()?['points'];
    });
  }

  reducePoints(int index) async {
    await getPoints();
    var newPoints = points - 10;
    await FirebaseFirestore.instance
        .collection('points')
        .doc(uid)
        .set({"points": newPoints}).then(
      (value) => print("reduced points"),
    );
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(docs1![index]['time'])
        .delete()
        .then(
          (value) => print("successfully deleted"),
        );
  }

  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              color: Colors.blue,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            )));
      }
    });
    super.initState();
    getuid();
    getPoints();

    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);

    fltrNotification.initialize(
      initilizationsSettings,
    );
  }

  Future _showNotification(DateTime t, String title) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "hello", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);
    var scheduledTime = t;
    fltrNotification.schedule(
      1,
      "Oops!",
      "your missed your task $title ",
      scheduledTime,
      generalNotificationDetails,
    );
  }

  // void testNotify() {
  //   flutterLocalNotificationsPlugin.show(
  //       1213,
  //       "Test",
  //       "body",
  //       NotificationDetails(
  //           android: AndroidNotificationDetails(
  //         channel.id,
  //         channel.name,
  //         channel.description,
  //         color: Colors.blue,
  //         playSound: true,
  //         icon: '@mipmap/ic_launcher',
  //       )));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      drawer: buildDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Scheduler",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            if (key.currentState!.isDrawerOpen) {
              Navigator.pop(context);
            } else {
              key.currentState?.openDrawer();
            }
          },
          icon: Icon(Icons.menu),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        onPressed: () {
          // testNotify();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        icon: Icon(Icons.add),
        label:
            // Icon(Icons.add),
            Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text("Add task"),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(uid)
            .collection('mytasks')
            .orderBy("time", descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            docs1 = snapshot.data?.docs;

            return Stack(
              children: [
                ListView.builder(
                  itemCount: docs1!.length,
                  itemBuilder: (context, index) {
                    if (DateTime.now().compareTo(
                                DateTime.parse(docs1?[index]['time'])) >
                            0 &&
                        docs1![index]['regular'] != true) {
                      FirebaseFirestore.instance
                          .collection('tasks')
                          .doc(uid)
                          .collection('mytasks')
                          .doc(docs1?[index]['time'])
                          .delete()
                          .then((value) => print("success"));
                      reducePoints(index);
                    }

                    var time = DateTime.parse(docs1![index]['time']);
                    // for (int i = 0; i < docs1!.length.toInt(); i++) {
                    //   _showNotification(DateTime.parse(docs1![i]['time']),
                    //       docs1![i]['title']);
                    // }
                    // print(docs1![index]['regular']);
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: SizedBox(
                            child: InkWell(
                              onTap: () {},
                              child: Card(
                                semanticContainer: true,
                                color: docs1![index]['regular'] == true
                                    ? Color(0xff457b9d)
                                    : Color(0xffe7717d),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                margin: EdgeInsets.only(bottom: 10),
                                // decoration: BoxDecoration(
                                //     color: Colors.blue,
                                //     borderRadius: BorderRadius.circular(10)),
                                // height: 90,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  "Title : ${docs1![index]['title']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 320,
                                                margin:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  "Description : ${docs1![index]['description']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(left: 20),
                                              child: Text(
                                                docs1![index]['regular']
                                                    ? "${DateFormat.jm().format(time)}"
                                                    : "${DateFormat.yMd().add_jm().format(time)}",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20),
                                              child: Text(
                                                "${docs1![index]['regular'] ? "Regular task" : "Particular task"}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            // DateFormat.yMd().add_jm().format(time)));
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 0,
                          child: SizedBox(
                            child: PopupMenuButton(
                              onSelected: (value) async {
                                if (value == "delete") {
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(docs1![index]['time'])
                                      .delete()
                                      .then(
                                        (value) =>
                                            print("successfully deleted"),
                                      );
                                } else {
                                  setState(() {
                                    isTrophyEnabled = true;
                                  });
                                  getPoints();
                                  var newPoints = points + 10;
                                  await FirebaseFirestore.instance
                                      .collection('points')
                                      .doc(uid)
                                      .set({"points": newPoints}).then(
                                    (value) => print("added points"),
                                  );
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(docs1![index]['time'])
                                      .delete()
                                      .then(
                                        (value) =>
                                            print("successfully deleted"),
                                      );
                                  await Future.delayed(
                                      Duration(seconds: 1, milliseconds: 50));
                                  setState(() {
                                    isTrophyEnabled = false;
                                  });
                                }
                              },
                              offset: Offset(-15, 5),
                              padding: EdgeInsets.only(),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: "delete",
                                  padding: EdgeInsets.only(),
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "DELETE",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(Icons.delete)
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "completed",
                                  padding: EdgeInsets.only(),
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "COMPLETED",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green[600],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.done,
                                          color: Colors.green[600],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                if (isTrophyEnabled)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20)),
                      child: LottieBuilder.asset(
                        'assets/lotties/trophy.json',
                      ),
                    ),
                  )
              ],
            );
          }
        },
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Icon(
              Icons.person_pin,
              size: 140,
            ),
          ),
          Center(
            child: Text(
              FirebaseAuth.instance.currentUser!.phoneNumber
                  .toString()
                  .substring(3, 13),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Points - " + points.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: SizedBox(
              height: 180,
              child: LottieBuilder.asset(
                "assets/lotties/productive.json",
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Center(
            child: Text(
              "Be Productive and Acheive your goals",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove("token");
                sharedPreferences.remove("usercredential");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => SignIn()));
              },
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: Text("HELPPIER", style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
