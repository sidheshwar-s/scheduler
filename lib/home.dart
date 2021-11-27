import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:scheduler_flutter/Signin.dart';
import 'package:scheduler_flutter/addtask.dart';
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin fltrNotification =
    new FlutterLocalNotificationsPlugin();

// import 'firestore';
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<QueryDocumentSnapshot<Object?>>? docs1;
  String uid = "";
  getuid() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      uid = user!.uid;
    });
  }

  @override
  void initState() {
    super.initState();
    getuid();

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
        "Reminder",
        "your task with title ${title} has passed",
        scheduledTime,
        generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Scheduler",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                sharedPreferences.remove("token");
                sharedPreferences.remove("usercredential");
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => signin()));
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.black,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => addtask()));
          },
          icon: Icon(Icons.add),
          label:
              // Icon(Icons.add),
              Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Add task"),
          )),
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

            int t = docs1!.length;
            return ListView.builder(
              itemCount: docs1!.length,
              itemBuilder: (context, index) {
                if (DateTime.now()
                        .compareTo(DateTime.parse(docs1?[index]['time'])) >
                    0) {
                  FirebaseFirestore.instance
                      .collection('tasks')
                      .doc(uid)
                      .collection('mytasks')
                      .doc(docs1?[index]['time'])
                      .delete()
                      .then((value) => print("success"));
                }
                var time = DateTime.parse(docs1![index]['time']);
                for (int i = 0; i < docs1!.length.toInt(); i++) {
                  _showNotification(
                      DateTime.parse(docs1![i]['time']), docs1![i]['title']);
                }
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: Card(
                        semanticContainer: true,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                        // decoration: BoxDecoration(
                        //     color: Colors.blue,
                        //     borderRadius: BorderRadius.circular(10)),
                        // height: 90,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Title : ${docs1![index]['title']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        width: 320,
                                        margin: EdgeInsets.only(left: 20),
                                        child: Text(
                                          "Description : ${docs1![index]['description']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 20),
                                      child: Text(
                                        DateFormat.yMd().add_jm().format(time),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      // DateFormat.yMd().add_jm().format(time)));
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                            ),
                            Container(
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                ),
                                onPressed: () async {
                                  print(docs1![index]['time']);
                                  await FirebaseFirestore.instance
                                      .collection('tasks')
                                      .doc(uid)
                                      .collection('mytasks')
                                      .doc(docs1![index]['time'])
                                      .delete()
                                      .then((value) => print("success"));
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
