import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/live/live_tracking_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/screen/master/alert/alert_master_screen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

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

import '../../model/live/nextlocation_imei.dart';
import '../../model/live/start_location_response.dart';
import '../../model/live/startlocation_imei.dart';
import '../../util/constant.dart';

class LiveTrackingDetailsScreen extends StatefulWidget {
  int transactionId;
  String araiNonarai;
  // double start_point_latitude;
  // double start_point_longitude;
  // double end_point_latitude;
  // double end_point_longitude;
  LiveTrackingDetailsScreen({
    Key? key,
    required this.transactionId,
    required this.araiNonarai,
    // required this.start_point_latitude,
    // required this.start_point_longitude,
    // required this.end_point_latitude,
    // required this.end_point_longitude
  }) : super(key: key);

  @override
  _LiveTrackingDetailsScreenState createState() =>
      _LiveTrackingDetailsScreenState();
}

class _LiveTrackingDetailsScreenState extends State<LiveTrackingDetailsScreen> {
  Completer<GoogleMapController> controller1 = Completer();
  double _lat = 18.5204;
  double _lng = 73.8567;
  late CameraPosition currentPosition;
  late Timer timer;
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
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Completer<GoogleMapController> googleMapController = Completer();
  List<StartLocationImei> startLocationResponseime = [];
  List<NextLocationImei> nextlocationresponseime = [];
  double? livelat;
  double? livlong;
  double? nextlivelat;
  double? nextlivelng;
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

    getdata();
    // timer = Timer.periodic(
    //     Duration(seconds: 10), (Timer t) => getlivetackingByIdDetail());
    print("We have call your getdata each and everytime 10 sec ");
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  //! NextLocation Ime Number------------------>
  getNextlocation(String imei, int transcationID, String prevTime,
      String prevDate, String prevImei) {
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
      print("Every 5 second-------");
      // _mainBloc.add(NextLocationEvents(vendorId: vendorid,branchId: branchid,token: token, araiNonarai: 'nonarai'));
      _mainBloc.add(NextLocationIMEIEvents(
          vendorId: vendorid,
          branchId: branchid,
          token: token,
          araiNonarai: 'arai',
          currentimeiNUmber: imei,
          prevTransactionId: transcationID,
          prevDate: prevDate,
          prevTime: prevTime,
          prevIMEINo: prevImei));
    });
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

  //! GetDirection for Polyline---------------------
  getDirections(double? fromlatitude, double? fromlongitude, double? tolatitude,
      double? tolongitude) async {
    List<LatLng> polylineCoordinates = [];
    print("Here is your polylines lat and long------>" +
        fromlatitude.toString() +
        "------->" +
        tolatitude.toString());
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY",
      PointLatLng(fromlatitude!, fromlongitude!),
      PointLatLng(tolatitude!, tolongitude!),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        setState(() {});
      });
    } else if (result.errorMessage != null) {
      print("Error message: ${result.errorMessage}");
    } else {
      print("No route found");
    }
    //polulineCoordinates is the List of longitute and latidtude.

    addPolyLine(polylineCoordinates);
  }

  //! Adding Polyline--------------------------------
  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.redAccent,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id] = polyline;
    setState(() {});
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

  //! Start Location by IMEI No.---------------------->
  getstartlocation(String imei) {
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    // _mainBloc.add(StartLocationEvents(vendorId: vendorid,branchId: branchid,token: token, araiNonarai: 'nonarai'));
    _mainBloc.add(StartLocationIMEIEvents(
        vendorId: vendorid,
        branchId: branchid,
        token: token,
        araiNonarai: 'arai',
        imeiNUmber: imei));
  }

  _livetracking() {
    //! Bloc Listner Startfrom here----------------->
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is LiveTrackingByIdLoadingState) {
        } else if (state is LiveTrackingByIdLoadedState) {
          setState(() {
            liveTrackingByIdRespons.addAll(state.liveTrackingByIdResponse);
          });

          showLocation = LatLng(
              double.parse(state.liveTrackingByIdResponse[0].latitude!),
              double.parse(state.liveTrackingByIdResponse[0].longitude!));

          if (liveTrackingByIdRespons.length != 0) {
            getstartlocation(state.liveTrackingByIdResponse[0].imei!);
            // callFirstApiThenSecondApi(
            //     token, 1, 1, "arai", state.liveTrackingByIdResponse[0].imei!);
            setState(() {
              livelat =
                  double.parse(state.liveTrackingByIdResponse[0].latitude!);
              livlong =
                  double.parse(state.liveTrackingByIdResponse[0].longitude!);

              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                      target: LatLng(livelat!, livlong!), zoom: 17)));
            });
          } else {
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Record not found for given input ...!",
            );
          }
        } else if (state is LiveTrackingByIdErrorState) {
          setState(() {});
        } else if (state is StartLocationIMEILoadingState) {
          print("Enter in the loading state--------------->");
          setState(() {
            _isLoading = true;
          });
        } else if (state is StartLocationIMEILoadedState) {
          print("Your Start location is there---------->");
          setState(() {
            _isLoading = false;

            startLocationResponseime = state.startLocationResponse;
            setState(() {
              livelat = double.parse(state.startLocationResponse[0].latitude);
              livlong = double.parse(state.startLocationResponse[0].longitude);
            });
            getNextlocation(
                state.startLocationResponse[0].imei,
                state.startLocationResponse[0].transactionId,
                state.startLocationResponse[0].date,
                state.startLocationResponse[0].previousTime,
                state.startLocationResponse[0].imei);
            //  getmarkers(livelat!, livlong!);
            // showStartLocation=LatLng(double.parse(state.startLocationResponse[0].latitude!),double.parse(state.startLocationResponse[0].longitude!)/*27.7089427, 85.3086209*/);
          });
          // BitmapDescriptor.fromAssetImage(
          //     const ImageConfiguration(devicePixelRatio: 2.0,size: Size(20,20)),
          //     'assets/stopped_truck.png')
          //     .then((onValue) {
          //       setState(() {
          //         LiveLocationStatusIcon = onValue;
          //       });
          // });

          // getStartLocationMakers(state.startLocationResponse[0].latitude!,state.startLocationResponse[0].longitude!);
        } else if (state is StartLocationIMEIErrorState) {
          setState(() {
            _isLoading = false;
          });
        } else if (state is NextLocationIMEILoadingState) {
          print("Enter in the next loading locationIMEI----------");
          setState(() {
            _isLoading = true;
          });
        } else if (state is NextLocationIMEILoadedState) {
          print("Enter in the next loaded locationIMEI----------");
          setState(() {
            _isLoading = false;

            setState(() {
              nextlivelat =
                  double.parse(state.startLocationResponse[0].latitude);
              nextlivelng =
                  double.parse(state.startLocationResponse[0].longitude);
            });
            mapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(nextlivelat!, nextlivelng!), zoom: 17)));

            print(livelat.toString() +
                livlong.toString() +
                "next location latitude and longitude start from here----------->" +
                nextlivelat.toString() +
                nextlivelng.toString());
            getDirections(livelat!, livlong!, nextlivelat!, nextlivelng!);
            getmarkers(livelat!, livelat!, nextlivelat!, nextlivelng!);
            setState(() {});
          });
        } else if (state is NextLocationIMEIErrorState) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(18.6298, 73.7997)),
          markers: _marker,
          polylines: Set<Polyline>.of(polylines.values),
          /*{
                Marker(
                  markerId: MarkerId('current'),
                  position: LatLng(_lat, _lng),
                )
              },*/
          onMapCreated: (GoogleMapController controller) {
            setState(() {
              mapController = controller;
            });
          },
        ),
      ),
    );
  }

  Set<Marker> getmarkers(
      double livelat, double livlong, double nextlivelat, nextlivelong) {
    //markers to place on map

    _marker.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(livelat,
            livlong /*27.7099116, 85.3132343*/ /*18.6298, 73.7997*/), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: startLocationResponseime[0].driverName,
          snippet: startLocationResponseime[0].vehicleRegNo,
        ),
        icon: BitmapDescriptor.defaultMarker));

    _marker.add(Marker(
      //add second marker
      markerId: MarkerId(showLocation.toString()),
      position: LatLng(nextlivelat,
          nextlivelong /*27.7099116, 85.3132343*/ /*18.6298, 73.7997*/), //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: startLocationResponseime[0].driverName,
        snippet: startLocationResponseime[0].vehicleRegNo,
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    return _marker;
  }
}
