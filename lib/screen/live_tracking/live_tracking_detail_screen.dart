import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/live/live_tracking_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/screen/master/alert/alert_master_screen.dart';
import 'package:flutter_vts/screen/notification/notification_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LiveTrackingDetailsScreen extends StatefulWidget {
  int transactionId;
  String araiNonarai;
  LiveTrackingDetailsScreen(
      {Key? key, required this.transactionId, required this.araiNonarai})
      : super(key: key);

  @override
  _LiveTrackingDetailsScreenState createState() =>
      _LiveTrackingDetailsScreenState();
}

class _LiveTrackingDetailsScreenState extends State<LiveTrackingDetailsScreen> {
  Completer<GoogleMapController> controller1 = Completer();
  double _lat = 18.5204;
  double _lng = 73.8567;
  late CameraPosition currentPosition;

  SolidController _controller = SolidController();
  bool toggleIcon = true;
  final Set<Marker> _marker = {};
  Map<MarkerId, Marker> markers = {};

  static late LatLng latLng = new LatLng(18.6298, 73.7997);
  late LatLng showLocation =
      LatLng(27.7089427, 85.3086209); //location to show in map
  late GoogleMapController mapController;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token = "";
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 0, vendorid = 0;
  late Timer timer;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Completer<GoogleMapController> googleMapController = Completer();
  late bool isPlayClick = false;
  late List<LiveTrackingByIdResponse> liveTrackingByIdRespons = [];
  List<String> speedList = [
    'X1',
    'X2',
    'X3',
    'X4',
    'X5',
    'X6',
    'X7',
    'X8',
    'X9',
    'X10'
  ];
  String dropdownvalue = 'X1';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    currentPosition = CameraPosition(
      target: LatLng(_lat, _lng),
      zoom: 8,
    );
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(liveTrackingByIdRespons.length == 0
            ? ""
            : liveTrackingByIdRespons[0].driverName!),
        actions: [
          const SizedBox(
            width: 8.0,
          )
        ],
      ),
      floatingActionButton: isPlayClick
          ? null
          : liveTrackingByIdRespons.length == 0
              ? null
              : FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  child: _controller.isOpened
                      ? const Icon(
                          Icons.keyboard_arrow_up_sharp,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.keyboard_arrow_up_sharp,
                          color: Colors.grey,
                        ),
                  onPressed: () {
                    _controller.isOpened
                        ? _controller.hide()
                        : _controller.show();
                  }),
      bottomSheet: isPlayClick
          ? BottomAppBar(
              shape: CircularNotchedRectangle(),
              child: Container(
                padding:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                // height: 65,
                // color: MyColors.blackColorCode,
                child: Row(
                  // mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Image.asset(
                      "assets/paly_icon.png",
                      height: 40,
                      width: 40,
                    ),
                    Image.asset(
                      "assets/pause_icon.png",
                      height: 40,
                      width: 40,
                    ),
                    Image.asset(
                      "assets/stop_icon.png",
                      height: 40,
                      width: 40,
                    ),
                    Text(
                      "Speed :",
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      width: 90,
                      height: 40,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.green,
                        ),
                        child: DropdownButton(
                          value: dropdownvalue,
                          underline: SizedBox(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: speedList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Container(
                                  /* decoration: BoxDecoration(
                          border: Border.all(color:MyColors.text3greyColorCode )
                        ),*/
                                  padding: EdgeInsets.only(left: 8, right: 12),
                                  child: Text(items,
                                      style: TextStyle(fontSize: 18))),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : SolidBottomSheet(
              minHeight: MediaQuery.of(context).size.height / 4,
              maxHeight: MediaQuery.of(context).size.height / 1.5,
              controller: _controller,
              draggableBody: true,
              headerBar: liveTrackingByIdRespons.length == 0
                  ? Container()
                  : Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0))),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10),
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: liveTrackingByIdRespons[0]
                                                    .vehicleStatus ==
                                                "Stop"
                                            ? MyColors.analyticStoppedColorCode
                                            : liveTrackingByIdRespons[0]
                                                        .vehicleStatus ==
                                                    "Nodata"
                                                ? MyColors
                                                    .analyticnodataColorCode
                                                : liveTrackingByIdRespons[0]
                                                            .vehicleStatus ==
                                                        "Overspeed"
                                                    ? MyColors
                                                        .analyticoverSpeedlColorCode
                                                    : liveTrackingByIdRespons[0]
                                                                .vehicleStatus ==
                                                            "Running"
                                                        ? MyColors
                                                            .analyticGreenColorCode
                                                        : liveTrackingByIdRespons[
                                                                        0]
                                                                    .vehicleStatus ==
                                                                "Idle"
                                                            ? MyColors
                                                                .analyticIdelColorCode
                                                            : liveTrackingByIdRespons[
                                                                            0]
                                                                        .vehicleStatus ==
                                                                    "Inactive"
                                                                ? MyColors
                                                                    .analyticActiveColorCode
                                                                : liveTrackingByIdRespons[0]
                                                                            .vehicleStatus ==
                                                                        "Total"
                                                                    ? MyColors
                                                                        .yellowColorCode
                                                                    : MyColors
                                                                        .blackColorCode),
                                  ),
                                  Text(
                                    liveTrackingByIdRespons[0].vehicleStatus!,
                                    style: TextStyle(
                                        color: liveTrackingByIdRespons[0]
                                                    .vehicleStatus ==
                                                "Stop"
                                            ? MyColors.analyticStoppedColorCode
                                            : liveTrackingByIdRespons[0]
                                                        .vehicleStatus ==
                                                    "Nodata"
                                                ? MyColors
                                                    .analyticnodataColorCode
                                                : liveTrackingByIdRespons[0]
                                                            .vehicleStatus ==
                                                        "Overspeed"
                                                    ? MyColors
                                                        .analyticoverSpeedlColorCode
                                                    : liveTrackingByIdRespons[0]
                                                                .vehicleStatus ==
                                                            "Running"
                                                        ? MyColors
                                                            .analyticGreenColorCode
                                                        : liveTrackingByIdRespons[
                                                                        0]
                                                                    .vehicleStatus ==
                                                                "Idle"
                                                            ? MyColors
                                                                .analyticIdelColorCode
                                                            : liveTrackingByIdRespons[
                                                                            0]
                                                                        .vehicleStatus ==
                                                                    "Inactive"
                                                                ? MyColors
                                                                    .analyticActiveColorCode
                                                                : liveTrackingByIdRespons[0]
                                                                            .vehicleStatus ==
                                                                        "Total"
                                                                    ? MyColors
                                                                        .yellowColorCode
                                                                    : MyColors
                                                                        .blackColorCode,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.20),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0)),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            liveTrackingByIdRespons[0]
                                                    .date!
                                                    .toString() +
                                                "|" +
                                                liveTrackingByIdRespons[0]
                                                    .time
                                                    .toString(),
                                            style: TextStyle(
                                                color: MyColors.blueColorCode,
                                                fontSize: 12),
                                          )),
                                        ),
                                      )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.20),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(0)),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child: Text(
                                            "Speed : " +
                                                liveTrackingByIdRespons[0]
                                                    .speed!
                                                    .toString() +
                                                "- kph",
                                            style: TextStyle(
                                                color: MyColors.blueColorCode,
                                                fontSize: 12),
                                          )),
                                        ),
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              body: liveTrackingByIdRespons.length == 0
                  ? Container()
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 24.0, top: 16.0, right: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // widget.vehicleHistoryByIdDetailResponse[0].address!=null ?
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                        liveTrackingByIdRespons[0].address!),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              ),
                              // :Container(),
                              // widget.vehicleHistoryByIdDetailResponse[0].address!=null ?  const SizedBox(
                              //   height: 16.0,
                              // ):Container(),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // _callNumber(liveTrackingByIdRespons[0].!) ;
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          color: MyColors.greenColorCode,
                                        ),
                                        child: const Icon(
                                          Icons.phone,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    const Text(
                                        // widget.vehicleHistoryByIdDetailResponse[0].mobileNumber!
                                        "+99 9999999999"),
                                    const SizedBox(
                                      width: 16.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Share.share(liveTrackingByIdRespons[0]
                                                .address! +
                                            "\n" +
                                            liveTrackingByIdRespons[0]
                                                .vehicleRegNo!);
                                      },
                                      child: Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          color: Colors.grey[800],
                                        ),
                                        child: const Icon(
                                          Icons.share,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                // liveTrackingByIdRespons[0].expi
                                "License Expire On:",
                                style: TextStyle(color: MyColors.blueColorCode),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Icon(
                                          Icons.power_settings_new_rounded,
                                          size: 18,
                                          color: liveTrackingByIdRespons[0]
                                                      .ignition ==
                                                  "OFF"
                                              ? MyColors.text4ColorCode
                                              : MyColors.analyticGreenColorCode,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("IGN",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: liveTrackingByIdRespons[0]
                                                          .ignition ==
                                                      "OFF"
                                                  ? MyColors.text4ColorCode
                                                  : MyColors
                                                      .analyticGreenColorCode))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          border:
                                              Border.all(color: Colors.grey),
                                        ),
                                        child: Icon(
                                          Icons.battery_charging_full_outlined,
                                          size: 18,
                                          color: liveTrackingByIdRespons[0]
                                                      .mainPowerStatus ==
                                                  "0"
                                              ? MyColors.text4ColorCode
                                              : MyColors.analyticGreenColorCode,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text(
                                        "PWR",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: liveTrackingByIdRespons[0]
                                                        .mainPowerStatus ==
                                                    "0"
                                                ? MyColors.text4ColorCode
                                                : MyColors
                                                    .analyticGreenColorCode),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Icon(
                                          Icons.ac_unit,
                                          size: 18,
                                          color: liveTrackingByIdRespons[0]
                                                      .ac ==
                                                  "OFF"
                                              ? MyColors.text4ColorCode
                                              : MyColors.analyticGreenColorCode,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("AC",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: liveTrackingByIdRespons[0]
                                                          .ac ==
                                                      "OFF"
                                                  ? MyColors.text4ColorCode
                                                  : MyColors
                                                      .analyticGreenColorCode))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Icon(
                                          Icons.car_rental,
                                          size: 18,
                                          color: liveTrackingByIdRespons[0]
                                                      .door ==
                                                  "OFF"
                                              ? MyColors.text4ColorCode
                                              : MyColors.analyticGreenColorCode,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("DOOR",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: liveTrackingByIdRespons[0]
                                                          .door ==
                                                      "OFF"
                                                  ? MyColors.text4ColorCode
                                                  : MyColors
                                                      .analyticGreenColorCode))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        height: 36,
                                        width: 36,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            border:
                                                Border.all(color: Colors.grey)),
                                        child: Icon(
                                          Icons.wifi,
                                          size: 18,
                                          color: liveTrackingByIdRespons[0]
                                                      .gpsFix ==
                                                  "OFF"
                                              ? MyColors.text4ColorCode
                                              : MyColors.analyticGreenColorCode,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      Text("GPS",
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: liveTrackingByIdRespons[0]
                                                          .gpsFix ==
                                                      "OFF"
                                                  ? MyColors.text4ColorCode
                                                  : MyColors
                                                      .analyticGreenColorCode))
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              const Divider(),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.menu,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "Odometer",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Text(liveTrackingByIdRespons[0]
                                            .odometer!
                                            .toString()
                                        // "99999"
                                        )
                                  ],
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.menu,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "Parking",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons[0]
                                                  .parking!
                                                  .atLastStop!
                                                  .toString(),
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "At last Stop",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 48.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons[0]
                                                  .parking!
                                                  .total!
                                                  .toString(),
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.menu,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "Running Duration",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons[0]
                                                  .runningDuration!
                                                  .atLastStop!,
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "At last Stop",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 48.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons[0]
                                                  .runningDuration!
                                                  .total!
                                                  .toString(),
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.menu,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "Running Distance",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons[0]
                                                  .runningDistance!
                                                  .fromLastStop!,
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "From last Stop",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          width: 48.0,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons[0]
                                                  .runningDistance!
                                                  .total!,
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Divider(),
                              ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.menu,
                                          size: 16,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          "Alerts",
                                          style: TextStyle(fontSize: 14),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(
                                                          webService:
                                                              WebService());
                                                    },
                                                    child: NotificationScreen(
                                                      isappbar: true,
                                                    ))));
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            liveTrackingByIdRespons[0]
                                                .alerts!
                                                .length
                                                .toString(),
                                            // "4",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: MyColors.redColorCode),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            "View",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: MyColors.redColorCode),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
            ),
      body: _livetracking(),
    );
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
      print("token ${token}");
    }
    if (sharedPreferences.getInt("VendorId") != null) {
      vendorid = sharedPreferences.getInt("VendorId")!;
    }
    if (sharedPreferences.getInt("BranchId") != null) {
      branchid = sharedPreferences.getInt("BranchId")!;
    }
    if (sharedPreferences.getString("Username") != null) {
      userName = sharedPreferences.getString("Username")!;
    }
    if (sharedPreferences.getString("VendorName") != null) {
      vendorName = sharedPreferences.getString("VendorName")!;
    }
    if (sharedPreferences.getString("BranchName") != null) {
      branchName = sharedPreferences.getString("BranchName")!;
    }
    if (sharedPreferences.getString("UserType") != null) {
      userType = sharedPreferences.getString("UserType")!;
    }

    print("branchid ${branchid}   Vendor id   ${vendorid}");

    print("" +
        vendorid.toString() +
        " " +
        branchid.toString() +
        " " +
        userName +
        " " +
        vendorName +
        " " +
        branchName +
        " " +
        userType);

    if (token != "" ||
        vendorid != 0 ||
        branchid != 0 ||
        vendorName != "" ||
        branchName != "") {
      getlivetackingByIdDetail();
    }
  }

  getlivetackingByIdDetail() {
    _mainBloc.add(LiveTrackingByIdEvents(
        vendorId: vendorid,
        branchId: branchid,
        token: token,
        araiNonarai: widget.araiNonarai /*'nonarai'*/,
        transactionId: widget.transactionId));
  }

  _livetracking() {
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: const CircularProgressIndicator(
        backgroundColor: MyColors.appDefaultColorCode,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state is LiveTrackingByIdLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is LiveTrackingByIdLoadedState) {
            setState(() {
              _isLoading = false;
            });
            setState(() {
              liveTrackingByIdRespons.addAll(state.liveTrackingByIdResponse);
              showLocation = LatLng(
                  double.parse(state.liveTrackingByIdResponse[0].latitude!),
                  double.parse(state.liveTrackingByIdResponse[0].longitude!));
            });

            if (liveTrackingByIdRespons.length != 0) {
              getmarkers();
            } else {
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: "Record not found for given input ...!",
              );
            }
          } else if (state is LiveTrackingByIdErrorState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is StartLocationLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is StartLocationLoadedState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is StartLocationErrorState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is NextLocationLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is NextLocationLoadedState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is NextLocationErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: currentPosition,
            markers: getmarkers(),
            /*{
                  Marker(
                    markerId: MarkerId('current'),
                    position: LatLng(_lat, _lng),
                  )
                },*/
            onMapCreated: (GoogleMapController controller) {
              controller1.complete(controller);
            },
          ),
        ),
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      if (liveTrackingByIdRespons.length != 0) {
        _marker.add(Marker(
          //add second marker
          markerId: MarkerId(showLocation.toString()),
          position: LatLng(
              double.parse(liveTrackingByIdRespons[0].latitude!),
              double.parse(liveTrackingByIdRespons[0]
                  .longitude!) /*27.7099116, 85.3132343*/ /*18.6298, 73.7997*/), //position of marker
          infoWindow: InfoWindow(
            //popup info
            title: liveTrackingByIdRespons[0].driverName,
            snippet: liveTrackingByIdRespons[0].vehicleRegNo,
          ),
          icon: BitmapDescriptor.defaultMarker, //Icon for Marker
        ));
      }
    });
    return _marker;
  }
}
