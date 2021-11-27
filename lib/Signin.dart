import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';
import 'auth.dart';
import 'dart:async';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter/cupertino.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  int start = 30;
  bool wait = false;
  String buttoname = "Send";
  String verificationIdFinal = "";
  String smsCode = "";
  late Timer _timer;
  void startTimer() {
    const onsec = Duration(seconds: 1);
    _timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  TextEditingController phone = TextEditingController();
  @override
  void dispose() {
    phone.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.black,
            centerTitle: true,
            title: Text(
              "SIGN IN",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2.8,
                    child: LottieBuilder.asset("assets/lotties/auth.json"),
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
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      maxLength: 10,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: phone,
                      decoration: InputDecoration(
                          counterText: "",
                          suffixIcon: TextButton(
                            child: Text(
                              "$buttoname",
                              style: TextStyle(color: Colors.black),
                            ),
                            onPressed: wait
                                ? null
                                : () {
                                    if (!mounted) {
                                      return;
                                    }
                                    startTimer();
                                    setState(() {
                                      start = 30;
                                      wait = true;
                                      buttoname = "Resend";
                                    });
                                    verification(
                                        "+91${phone.text}", context, setData);
                                  },
                          ),
                          suffixIconConstraints: BoxConstraints(maxHeight: 40),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "(+91)  ",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          prefixIconConstraints: BoxConstraints(maxHeight: 40),
                          hintText: "Enter Your Phone Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 15.0),
                            child: Divider(
                              color: Colors.grey,
                              height: 50,
                            )),
                      ),
                      Text(
                        "Enter 6 Digit OTP",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 15.0, right: 10.0),
                            child: Divider(
                              color: Colors.grey,
                              height: 50,
                            )),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      fieldWidth: MediaQuery.of(context).size.width * 0.15,
                      style: TextStyle(fontSize: 17),
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldStyle: FieldStyle.box,
                      onCompleted: (pin) {
                        setState(() {
                          smsCode = pin;
                        });
                        print("Completed: " + pin);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Send OTP again in ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        TextSpan(
                          text: "00:$start",
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        TextSpan(
                          text: " sec ",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 17,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                      ),
                      onPressed: () {
                        print("***********************");
                        print(verificationIdFinal);
                        print("***********************");
                        print(smsCode);
                        print("***********************");

                        print("***********************");
                        signInwithPhoneNumber(
                            verificationIdFinal, smsCode, context);
                        // FirebaseAuth _auth = FirebaseAuth.instance;
                        // signInWithPhoneNumber(
                        // verificationIdFinal, smsCode, context);
                      },
                      child: Container(
                        color: Colors.black,
                        child: Text(
                          "Verify",
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
