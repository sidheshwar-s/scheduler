import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'home.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin fltrNotification =
    new FlutterLocalNotificationsPlugin();

class addtask extends StatefulWidget {
  const addtask({Key? key}) : super(key: key);

  @override
  _addtaskState createState() => _addtaskState();
}

class _addtaskState extends State<addtask> {
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  // final control = GlobalKey();
  DateTime datetime = DateTime.now();
  addtasktofirebase() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    // var time = DateTime.now();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(datetime.toString())
        .set({
      'title': title.text,
      'description': description.text,
      'time': datetime.toString(),
    });
    // Fluttertoast.showToast(msg: 'Data Added');
    _showNotification(datetime, title.text);
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState

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
        "your task with title ${title} has passed at ${t.hour}: ${t.minute}",
        scheduledTime,
        generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Add task",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;
                String uid = user!.uid;

                CollectionReference notesItemCollection = FirebaseFirestore
                    .instance
                    .collection('tasks')
                    .doc(uid)
                    .collection('mytasks');
                print("***************");

                notesItemCollection.get().then((snapshot) {
                  snapshot.docs.forEach((doc) {
                    print(doc.get('title'));
                  });
                });
                print("***************");
                addtasktofirebase();
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  // color: Colors.white,
                ),
                // color: Colors.white,
                height: 60,
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  controller: title,
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                      hintText: "Enter the Title",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    // color: Colors.white,
                  ),
                  // color: Colors.white,
                  height: 60,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextFormField(
                    controller: description,
                    keyboardType: TextInputType.text,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: "Enter the Description",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              // TextButton(
              //     onPressed: () {
              //       DatePicker.showDatePicker(context,
              //           showTitleActions: true,
              //           minTime: DateTime.now(),
              //           maxTime: DateTime(2022, 6, 7), onChanged: (date) {
              //         print('change $date');
              //       }, onConfirm: (date) {
              //         print('confirm $date');
              //       }, currentTime: DateTime.now(), locale: LocaleType.en);
              //     },
              //     child: Text(
              //       'show date time picker (Chinese)',
              //       style: TextStyle(color: Colors.blue),
              //     ))
              DateTimePicker(
                // key: control,
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                // selectableDayPredicate: (DateTime date) {
                //   // Disable weekend days to select from the calendar
                //   if (date.weekday == 5 || date.weekday == 7) {
                //     return false;
                //   }

                //   return true;
                // },
                onChanged: (val) {
                  print(val);
                  print("**********");
                  setState(() {
                    DateTime dateTime =
                        dateFormat.parse(val ?? DateTime.now().toString());
                    print("hgvvu**********");
                    print(dateTime);
                    print("**********");
                    datetime = dateTime;
                  });
                  DateTime dateTime =
                      dateFormat.parse(val ?? DateTime.now().toString());
                  print(dateTime);
                  print(DateTime.now());
                  print(dateTime.hour);
                },
                validator: (val) {
                  print(val);
                  return "please select a date";
                },
                onSaved: (val) {
                  print(val);
                  print("**********");
                  DateTime dateTime =
                      dateFormat.parse(val ?? "2019-07-19 8:40");
                  print(dateTime);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
