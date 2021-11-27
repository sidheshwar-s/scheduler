import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scheduler_flutter/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import 'firestore';
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future verification(String str, BuildContext context, Function setdata) async {
  PhoneVerificationCompleted verificationCompleted =
      (PhoneAuthCredential phoneAuthCredential) async {
    showSnackBar(context, "Verification has been Completed");
  };
  PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException exception) {
    showSnackBar(context, exception.toString());
  };
  PhoneCodeSent codeSent = (String verificationID, [int? forceResnedingtoken]) {
    showSnackBar(context, "Verification Code sent on the phone number");
    setdata(verificationID);
  };

  PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationID) {
    showSnackBar(context, "Time out");
  };
  try {
    // firebaseAuth.getFirebaseAuthSettings().setAppVerificationDisabledForTesting(true);
    await firebaseAuth.verifyPhoneNumber(
        phoneNumber: str,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  } catch (e) {}
}

void storeTokenAndData(UserCredential userCredential) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  print("storing token and data");
  for (int i = 0; i < 3; i++) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    var time = DateTime.now().add(Duration(hours: i + 1)).toString();
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(uid)
        .collection('mytasks')
        .doc(time)
        .set({
      'title': "Demo Title",
      'description': "demo description",
      'time': time,
      'regular': false,
    });

    try {
      var points = FirebaseFirestore.instance.collection('points').doc(uid);
      await points.get().then((value) {
        if (value.exists) {
          print("exist");
        } else {
          FirebaseFirestore.instance.collection('points').doc(uid).set({
            'points': 0,
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
  sharedPreferences.setString(
      "token", userCredential.credential?.token.toString() ?? " ");
  sharedPreferences.setString("usercredential", userCredential.toString());
}

Future<void> signInwithPhoneNumber(
    String verificationId, String smsCode, BuildContext context) async {
  try {
    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);

    UserCredential userCredential =
        await firebaseAuth.signInWithCredential(credential);
    storeTokenAndData(userCredential);
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
    showSnackBar(context, "logged In");
  } catch (e) {
    showSnackBar(context, e.toString());
  }
}
