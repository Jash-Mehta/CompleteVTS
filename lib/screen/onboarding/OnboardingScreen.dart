import 'package:flutter/material.dart';
import 'package:flutter_vts/screen/onboarding/explanation_data.dart';
import 'package:flutter_vts/screen/onboarding/explanation_page.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'bottom_buttons.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: PageView(
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      onPageChanged: (value) {
                        // _painter.changeIndex(value);
                        setState(() {
                          _currentIndex = value;
                        });
                        // notifyListeners();
                      },
                      children: data
                          .map((e) => ExplanationPage(data: e))
                          .toList())),
              flex: 4),
          Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(data.length,
                                (index) => createCircle(index: index)),
                      )),
                  Expanded(
                    child: BottomButtons(
                      currentIndex: _currentIndex,
                      dataLength: data.length,
                      controller: _controller,
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }

  createCircle({required int index}) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 100),
        margin: EdgeInsets.only(right: 4),
        height: 8,
        width: /*_currentIndex == index ? 39 :*/ 8,
        decoration: BoxDecoration(
            color:
            _currentIndex == index ? MyColors.textColorCode : Color(0xFFC4C4C4),
            borderRadius: BorderRadius.circular(15)));
  }
}



final List<ExplanationData> data = [
  ExplanationData(
    title:"Real Time Tracking" ,
    description:
   "See near real time GPS location and speed of vehicles.",
    localImageSrc: "assets/onboarding1.png",
  ),
  ExplanationData(
    title:"Reports" ,
    description: "Receive on-demand data including daily miles, fuel usage, speeding events and arrival times.",
    localImageSrc: "assets/onboarding2.png",
  ),
  ExplanationData(
    title:"Geofences" ,
    description:
    "Get alerted to activity for specific locations and times.",
    localImageSrc: "assets/onboarding3.png",
  ),
  ExplanationData(
    title:"Alerts" ,
    description:
    "Get SMS or email alerts for key events such as speeding or excessive idling.",
    localImageSrc: "assets/onboarding4.png",
  ),
];

