import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scheduler_flutter/bottomnavigationbar.dart';
import 'package:scheduler_flutter/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    changeRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              "Welcome to Scheduler",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text("Never miss your routine"),
            LottieBuilder.asset(
              "assets/lotties/splash_lottie.json",
            ),
            SizedBox(
              height: 150,
              child: LottieBuilder.asset(
                "assets/lotties/loading_lottie.json",
                fit: BoxFit.cover,
              ),
            ),
            Spacer(),
            Text(
              "HELPPIER",
              style: TextStyle(
                color: Colors.black54,
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

  void changeRoute() async {
    Future.delayed(Duration(seconds: 3))
        .whenComplete(() => Get.offAll(() => MyBottomBarDemo()));
  }
}
