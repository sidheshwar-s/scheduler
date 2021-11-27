import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:scheduler_flutter/Signin.dart';

class StartingScreen extends StatefulWidget {
  const StartingScreen({Key? key}) : super(key: key);

  @override
  _StartingScreenState createState() => _StartingScreenState();
}

class _StartingScreenState extends State<StartingScreen> {
  int currentPos = 0;
  int? index;
  CarouselController buttonCarouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 9),
          Container(
            // color: Colors.blue,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                image: AssetImage('assets/welcome1.png'),
                fit: BoxFit.fill,
                alignment: Alignment.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                "Welcome",
                style: GoogleFonts.amaticSc(
                  textStyle: TextStyle(
                    fontSize: 50,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(
              child: Text(
                "Your One-Stop Event Manager, where you can manage all you events",
                textAlign: TextAlign.center,
                style: GoogleFonts.amaticSc(
                  textStyle: TextStyle(
                    fontSize: 30,
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 9),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage('assets/welcome2.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Discover",
                  style: GoogleFonts.amaticSc(
                    textStyle: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Discover the Latest way to set event reminders",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amaticSc(
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 9),
            Container(
              // color: Colors.blue,
              // height: 400,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage('assets/welcome3.png'),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Stay Updated",
                  style: GoogleFonts.amaticSc(
                    textStyle: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Now you won't miss any of your events",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amaticSc(
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 9),
            Container(
              // color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 4,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage('assets/welcome4.png'),
                  // fit: BoxFit.cover,
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "All Set !",
                  style: GoogleFonts.amaticSc(
                    textStyle: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Center(
                child: Text(
                  "Your are ready to start your journey",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.amaticSc(
                    textStyle: TextStyle(
                      fontSize: 30,
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ];
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CarouselSlider.builder(
            itemCount: items.length,
            itemBuilder: (context, index, okay) {
              return items[index];
            },
            carouselController: buttonCarouselController,
            options: CarouselOptions(
                // autoPlay: true,
                autoPlayInterval: Duration(seconds: 6),
                enlargeCenterPage: true,
                viewportFraction: 0.97,
                aspectRatio: 1 / 1.5,
                initialPage: 0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    currentPos = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.map((url) {
              int index = items.indexOf(url);
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentPos == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
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
                  if (currentPos != 3) {
                    buttonCarouselController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  }
                },
                child: Container(
                  color: Colors.black,
                  child: Text(
                    "${currentPos != 3 ? "Next" : "Get Started"}",
                    style: GoogleFonts.amaticSc(
                      textStyle: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ]);
  }
}
// Text('→')