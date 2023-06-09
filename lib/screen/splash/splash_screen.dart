import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vts/screen/onboarding/OnboardingScreen.dart';
import 'package:flutter_vts/util/MyColor.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gotonextpage();
  }

  gotonextpage() {
    Timer(Duration(seconds: 3), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => OnboardingScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Lottie.network(
                //     'https://assets4.lottiefiles.com/packages/lf20_b8ddk0iq.json',width: 128,height: 128),
                Image.asset(
                  "assets/vts_icon.png",
                  width: 194,
                  height: 75,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 37, right: 37, bottom: 45),
              child: Text(
                "@ Copy 2022 M-Tech Innovations Ltd Pune Vehicle Tracking System",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: MyColors.textColorCode),
              ),
            )
          ],
        ),
      ),
    );
  }
}
