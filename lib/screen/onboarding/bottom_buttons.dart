import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/home/home_screen.dart';
import 'package:flutter_vts/screen/login/login_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomButtons extends StatelessWidget {
  final int currentIndex;
  final int dataLength;
  final PageController controller;

  const BottomButtons(
      {Key? key,
      required this.currentIndex,
      required this.dataLength,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: currentIndex == dataLength - 1
            ? [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(MyColors.blueColorCode),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                      create: (context) {
                                        return MainBloc(
                                            webService: WebService());
                                      },
                                      child: HomeScreen())));
                                      // child: LoginScreen())));
                        },

                        //height: 50,
                        // materialTapTargetSize:
                        //     MaterialTapTargetSize.shrinkWrap, // add this
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(6),
                        //     side: BorderSide.none),
                        child: const Text(
                          "Get started",
                          style: TextStyle(
                              color: MyColors.whiteColorCode, fontSize: 20),
                        )),
                  ),
                )
              ]
            : [
                // ignore: deprecated_member_use
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlocProvider(
                                create: (context) {
                                  return MainBloc(webService: WebService());
                                },
                                child: LoginScreen())));
                  },
                  child: Row(
                    children: [
                      const Text(
                        "Skip",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: Color(0xFF666666),
                            fontWeight: FontWeight.w500),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5.0, top: 0),
                        child: const Icon(
                          Icons.arrow_forward_ios_sharp,
                          /*color: Color(0xFFCE4A6F),*/ size: 14,
                        ),
                      )
                    ],
                  ),
                ),
              ],
      ),
    );
  }
}
