import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';

import '../../bloc/main_bloc.dart';
import '../../service/web_service.dart';
import '../live_tracking_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LiveMapSettingScreen extends StatefulWidget {
  @override
  _LiveMapSettingScreenState createState() => _LiveMapSettingScreenState();
}

class _LiveMapSettingScreenState extends State<LiveMapSettingScreen> {
  bool all = false;
  bool dummy = false;
  bool isCluster = false;
  bool isLabel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Settings"),
      ),
      body: _mapsetting(),
    );
  }

  _mapsetting() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Setting",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                      height: 36,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        color: /*isapplybtnvisible ?*/ Colors
                            .blue, /*: MyColors.blueColorCode.withOpacity(0.5)*/
                      ),
                      child: TextButton(
                          child: const Text("Apply",
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                        create: (context) {
                                          return MainBloc(
                                              webService: WebService());
                                        },
                                        child: LiveTrackingScreen(
                                          label: isLabel,
                                        ))));
                          })),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Divider(
                height: 3,
                color: MyColors.text3greyColorCode,
              ),
            ),
            Text(
              "Geofence",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Checkbox(
                    value: all,
                    onChanged: (checkvalue) {
                      setState(() {
                        all = checkvalue!;
                        print(checkvalue);
                      });
                    }),
                Expanded(child: Text("All")),
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: all,
                    onChanged: (checkvalue) {
                      setState(() {
                        all = checkvalue!;
                        print(checkvalue);
                      });
                    }),
                Expanded(child: Text("Dummy")),
              ],
            ),
            Divider(
              height: 3,
              color: MyColors.text3greyColorCode,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Show Cluster",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                Switch(
                  value: isCluster,
                  onChanged: (value) {
                    setState(() {
                      isCluster = value;
                      print(isCluster);
                    });
                  },
                  activeTrackColor: MyColors.skyblueColorCode,
                  activeColor: MyColors.blueColorCode,
                ),
              ],
            ),
            Divider(
              height: 3,
              color: MyColors.text3greyColorCode,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(
                  "Show Label",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
                Switch(
                  value: isLabel,
                  onChanged: (value) {
                    setState(() {
                      isLabel = value;
                      print(isLabel);
                    });
                  },
                  activeTrackColor: MyColors.skyblueColorCode,
                  activeColor: MyColors.blueColorCode,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
