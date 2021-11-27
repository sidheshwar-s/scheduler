import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler_flutter/models/Time.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final FlutterLocalNotificationsPlugin fltrNotification =
    new FlutterLocalNotificationsPlugin();

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool? checkedValue = true;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  var selectedSchedules = [];
  int id = 11;

  static List<TimeModel?> time = [
    TimeModel(title: "1 hour", time: 60),
    TimeModel(title: "45 mins", time: 45),
    TimeModel(title: "30 mins", time: 30),
    TimeModel(title: "15 min", time: 15),
  ];
  List<MultiSelectItem<TimeModel?>> _items = time
      .map(
        (curTime) => MultiSelectItem<TimeModel?>(curTime, curTime!.title),
      )
      .toList();
  DateTime datetime = DateTime.now();
  addtasktofirebase() async {
    try {
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
        'regular': checkedValue,
      });
      // Fluttertoast.showToast(msg: 'Data Added');
      print(selectedSchedules);

      selectedSchedules.forEach((value) {
        print(value);
        DateTime newTime = datetime.subtract(Duration(minutes: value.time));
        print(newTime);
        _showNotification(newTime, title.text, true, datetime);
      });
      _showNotification(datetime, title.text, false, datetime);
      Navigator.pop(context);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    print(checkedValue);
    var androidInitilize =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(
        android: androidInitilize, iOS: iOSinitilize);

    fltrNotification.initialize(
      initilizationsSettings,
    );
    super.initState();
  }

  Future _showNotification(
      DateTime t, String title, bool isScheduled, DateTime endTime) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "hello", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(android: androidDetails, iOS: iSODetails);
    var scheduledTime = t;
    print(isScheduled);
    fltrNotification.schedule(
      id,
      "Reminder!",
      "${isScheduled ? "$title within ${endTime.difference(t).inMinutes} minutes" : "your task with title $title has passed at ${t.hour}: ${t.minute}"}",
      scheduledTime,
      generalNotificationDetails,
    );
    setState(() {
      id += 1;
    });
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
                try {
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
                } catch (e) {
                  print(e);
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              // color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage('assets/welcome5.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
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
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pick your deadline :",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: DateTimePicker(
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
                    DateTime dateTime = dateFormat.parse(val);
                    print("hgvvu**********");
                    print(dateTime);
                    print("**********");
                    datetime = dateTime;
                  });
                  DateTime dateTime = dateFormat.parse(val);
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
              ),
            )
            // Checkbox(value: value, onChanged: onChanged)
            ,
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CheckboxListTile(
                activeColor: Colors.black,

                title: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Do you want to schedule the task Regularly?",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Container(
                width: MediaQuery.of(context).size.width / 1.1,
                child: MultiSelectChipField(
                  onTap: (values) {
                    setState(() {
                      selectedSchedules = values;
                    });
                  },
                  items: _items,
                  // initialValue: [time[0], time[1], time[2], time[3]],
                  title: Text("When Do you want reminders",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  headerColor: Color(0xffFF6363),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffFF6363), width: 1.8),
                  ),
                  selectedChipColor: Color(0xffFF6363),
                  selectedTextStyle: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
