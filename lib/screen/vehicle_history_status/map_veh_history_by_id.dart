import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_vts/model/vehicle_history/get_veh_speed_response.dart';
import 'package:http/http.dart' as http;
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

// import '../../model/live/nextlocation_imei.dart';
import '../../model/live/start_location_response.dart';
// import '../../model/live/startlocation_imei.dart';
import '../../util/constant.dart';

class MapLiveTrackingDetailsScreen extends StatefulWidget {
  int transactionId;
  String araiNonarai;
  // double start_point_latitude;
  // double start_point_longitude;
  // double end_point_latitude;
  // double end_point_longitude;
  double fromlatitude;
  double fromlongitude;

  double tolatitude;
  double tolongitude;
  MapLiveTrackingDetailsScreen({
    Key? key,
    required this.transactionId,
    required this.araiNonarai,
    required this.fromlatitude,
    required this.fromlongitude,
    required this.tolatitude,
    required this.tolongitude,
  }) : super(key: key);

  @override
  _LiveTrackingDetailsScreenState createState() =>
      _LiveTrackingDetailsScreenState();
}

class _LiveTrackingDetailsScreenState
    extends State<MapLiveTrackingDetailsScreen> {
  Completer<GoogleMapController> controller1 = Completer();
  double _lat = 18.5204;
  double _lng = 73.8567;
  late CameraPosition currentPosition;
  late Timer timer;
  SolidController _controller = SolidController();
  bool toggleIcon = true;
  final Set<Marker> _marker = {};
  double? fromlatitude;
  double? fromlongitude;
  double? tolatitude;
  double? tolongitude;
  double? midlatitude;
  double? midlongitude;
  static late LatLng latLng = new LatLng(18.6298, 73.7997);
  late LatLng showLocation =
      LatLng(27.7089427, 85.3086209); //location to show in map
  late GoogleMapController mapController;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token = "";
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String arainumber = "arai";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 1;
  late int vendorid = 1;
  late String vehStatusList = "Inactive";
  late String vehList = "86";
  late String fromTime = "12%3A30";
  late String toTime = "18%3A30";
  late int pageNumber = 1;
  late int pageSize = 10;
  late String fromdate = "01-August-2022";
  late String todate = "31-August-2022";
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Completer<GoogleMapController> googleMapController = Completer();
  // List<StartLocationImei> startLocationResponseime = [];
  // List<NextLocationImei> nextlocationresponseime = [];
  double? livelat;
  double? livlong;
  double? nextlivelat;
  double? nextlivelng;
  List<SpeedData> speedDataList = [];
  List<LatLng> polylineCoordinates = [];
  late bool isPlayClick = false;
  List<Map<String, double>> midpointlist = [];
  List<VehicleHistoryByIdDetailResponse> vehiclehistorydetail = [];
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
  int index = 0;
  double distance = 0.0;
  var textselected;
  var time;
  double straightDistance = 0.0;
  String selectedvalue = '';
  @override
  initState() {
    setState(() {
      //// AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY
      fromlatitude = widget.fromlatitude;
      fromlongitude = widget.fromlongitude;
      tolatitude = widget.tolatitude;
      tolongitude = widget.tolongitude;
      // midpointlist = widget.coordinatesList;
    });

    // addMarkers();
    //  getDirections();
    _mainBloc = BlocProvider.of(context);
    getdata();

    _marker.add(Marker(
        //add second marker
        markerId: MarkerId(LatLng(fromlatitude!, fromlongitude!).toString()),
        position: LatLng(fromlatitude!,
            fromlongitude! /*27.7099116, 85.3132343*/ /*18.6298, 73.7997*/), //position of marker
        infoWindow: InfoWindow(
            //popup info
            // title: liveTrackingByIdRespons[0].driverName,
            // snippet: liveTrackingByIdRespons[0].vehicleRegNo,
            ),
        icon: BitmapDescriptor.defaultMarker));
    setState(() {});
    _mainBloc.add(VehicleHistoryByIdDetailEvents(
        token: token,
        vendorId: 1,
        branchId: 1,
        araiNoarai: "nonarai",
        fromDate: "01-August-2022",
        toDate: "31-August-2022",
        formTime: "12:30",
        toTime: "18:30",
        vehicleHistoryId: 2074));
    _getPolyline();
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    super.dispose();
  }

  //! GetDirection for Polyline---------------------
  getDirections() async {
    List<LatLng> polylineCoordinates = [];
    List<PolylineWayPoint> polylineWayPoints = midpointlist
        .map((point) => PolylineWayPoint(
            location: "${point['latitude']},${point['longitude']}"))
        .toList();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY",
      PointLatLng(fromlatitude!, fromlongitude!),
      PointLatLng(tolatitude!, tolongitude!),
      travelMode: TravelMode.driving,
      wayPoints: polylineWayPoints,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else if (result.errorMessage != null) {
      print("Error message: ${result.errorMessage}");
    } else {
      print(polylineWayPoints.toList().toString());
      print("No route found");
    }
    //polulineCoordinates is the List of longitute and latidtude.
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      double calculateDistance(lat1, lon1, lat2, lon2) {
        var p = 0.017453292519943295;
        var a = 0.5 -
            cos((lat2 - lat1) * p) / 2 +
            cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
        return 12742 * asin(sqrt(a));
      }

      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print(totalDistance);

    setState(() {
      distance = totalDistance;
      time = distance ~/ 80;
    });
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
          ),
          GestureDetector(
            onTap: () {
              // _callNumber( liveTrackingByIdRespons![0]
              //     .address!);
            },
            child: Container(
              // height: 2,
              // width: 36,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(20),
              //   color:  Colors.grey[500],
              // ),
              child: IconButton(
                icon: Icon(
                  Icons.play_circle,
                  color: Colors.grey.shade600,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    isPlayClick = true;
                    print("IS play value ============$isPlayClick");
                    _mainBloc.add(GetVehSpeedDataEvent(
                        token: token,
                        vendorId: vendorid,
                        branchid: branchid,
                        araino: arainumber,
                        fromdate: fromdate,
                        fromTime: fromTime,
                        toDate: todate,
                        toTime: toTime,
                        vehicleStatusList: vehStatusList,
                        vehicleList: vehList,
                        pagenumber: pageNumber,
                        pagesize: pageSize));
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          GestureDetector(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 10, bottom: 10, left: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade600,
                child: IconButton(
                  icon: Icon(Icons.settings_sharp, size: 20),
                  color: Colors.white,
                  onPressed: () {},
                ),
              ),
            ),
            // ),
          ),
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
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/paly_icon.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/pause_icon.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/stop_icon.png",
                        height: 40,
                        width: 40,
                      ),
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
                          color: MyColors.greyColorCode,
                        ),
                        child: DropdownButton<SpeedData>(
                          value: speedDataList[0],
                          underline: SizedBox(),
                          icon: Icon(Icons.keyboard_arrow_down),
                          items: speedDataList.map((SpeedData items) {
                            print(
                                "Speed data list are-------------${speedDataList.length}");
                            return DropdownMenuItem(
                              value: items,
                              child: Container(
                                  /* decoration: BoxDecoration(
                          border: Border.all(color:MyColors.text3greyColorCode )
                        ),*/
                                  padding: EdgeInsets.only(left: 8, right: 12),
                                  child: Text(items.speed.toString(),
                                      style: TextStyle(fontSize: 18))),
                            );
                          }).toList(),
                          onChanged: (SpeedData? newValue) {
                            setState(() {
                              dropdownvalue = newValue!.speed!;
                            });
                            _mainBloc.add(GetVehSpeedDataEvent(
                                token: token,
                                vendorId: vendorid,
                                branchid: branchid,
                                araino: arainumber,
                                fromdate: fromdate,
                                fromTime: fromTime,
                                toDate: todate,
                                toTime: toTime,
                                vehicleStatusList: vehStatusList,
                                vehicleList: vehList,
                                pagenumber: pageNumber,
                                pagesize: pageSize));
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

                              const SizedBox(
                                height: 13.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.50),
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
                                                color: MyColors.blackColorCode,
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
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),

                              Row(
                                children: [
                                  Expanded(
                                      child:
                                          // liveTrackingByIdRespons[0].address != null?
                                          // Text( liveTrackingByIdRespons[0]
                                          //     .address!
                                          //   // "State Bank of India - Ram Nagar Branch, Pune"
                                          // ):
                                          Text(
                                              "State Bank of India - Ram Nagar Branch, Pune")),
                                  SizedBox(
                                    height: 16,
                                  ),
                                ],
                              )
                              //     :
                              // Container(child: Text(  "State Bank of India - Ram Nagar Branch, Pune"),),
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
                              left: 24.0, top: 12.0, right: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              liveTrackingByIdRespons[0].address != null
                                  ? Row(
                                      children: [
                                        Expanded(
                                          child: Text(liveTrackingByIdRespons[0]
                                                  .address!
                                              // "State Bank of India - Ram Nagar Branch, Pune"
                                              ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // _callNumber( liveTrackingByIdRespons![0]
                                      //     .address!);
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
                                  Text(
                                      // liveTrackingByIdRespons[0].address!
                                      "+99 9999999999"),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Share.share(liveTrackingByIdRespons[0]
                                              .address! +
                                          "\n" +
                                          liveTrackingByIdRespons[0].address!);
                                    },
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        color: Colors.grey[500],
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
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                "License Expire On: 05-04-2022",
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
                                          color: liveTrackingByIdRespons![0]
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
                                              color: liveTrackingByIdRespons![0]
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
                                          color: liveTrackingByIdRespons![0]
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
                                            color: liveTrackingByIdRespons![0]
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
                                          color: liveTrackingByIdRespons![0]
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
                                              color: liveTrackingByIdRespons![0]
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
                                          color: liveTrackingByIdRespons![0]
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
                                              color: liveTrackingByIdRespons![0]
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
                                          color: liveTrackingByIdRespons![0]
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
                                              color: liveTrackingByIdRespons![0]
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
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue.shade50,
                                          minRadius: 15,
                                          child: Icon(
                                            Icons.speed_rounded,
                                            size: 16,
                                          ),
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
                                    const SizedBox(
                                      width: 48.0,
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          // "00:00",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 48.0,
                                    ),
                                    // Text(widget.vehicleHistoryByIdDetailResponse[0]
                                    //         .currentOdometer!
                                    //         .toString()

                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "",
                                          // "00:00",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "99999999",
                                          style: TextStyle(fontSize: 12),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
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
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue.shade50,
                                          minRadius: 15,
                                          child: Icon(
                                            Icons.local_parking_outlined,
                                            size: 16,
                                          ),
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
                                    const Divider(),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              liveTrackingByIdRespons![0]
                                                  .parking!
                                                  .atLastStop!
                                                  .toString(),
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "At last Stop",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
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
                                              liveTrackingByIdRespons![0]
                                                  .parking!
                                                  .total!
                                                  .toString(),
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
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
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue.shade50,
                                          minRadius: 15,
                                          child: Icon(
                                            Icons.watch_later_outlined,
                                            size: 16,
                                          ),
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
                                              liveTrackingByIdRespons![0]
                                                  .runningDuration!
                                                  .atLastStop!,
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "At last Stop",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
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
                                              liveTrackingByIdRespons![0]
                                                  .runningDuration!
                                                  .total!
                                                  .toString(),
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
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
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.blue.shade50,
                                          minRadius: 15,
                                          child: Icon(
                                            Icons.location_on_outlined,
                                            size: 16,
                                          ),
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
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "From last Stop",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
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
                                              liveTrackingByIdRespons![0]
                                                  .runningDistance!
                                                  .total!,
                                              // "00:00",
                                              style: TextStyle(fontSize: 14),
                                              textAlign: TextAlign.right,
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              "Total",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.right,
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
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.red.shade100,
                                          minRadius: 15,
                                          child: Icon(
                                            Icons.add_alert_rounded,
                                            size: 16,
                                            color: Colors.red.shade300,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
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
                                            liveTrackingByIdRespons![0]
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
    //! Bloc Listner Startfrom here----------------->
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetVehSpeedLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is GetVehSpeedLoadedState) {
          print("Enter in the loaded state speed data----------");
          setState(() {
            // _isLoading = false;
            // speedDataList.clear();
            print(
                "Speed data list in state-----------${state.getVehSpeedResponse.data!.length}");
            speedDataList.addAll(state.getVehSpeedResponse.data!);
            print(
                "${state.getVehSpeedResponse.data!}------Speeddatalist element are----------${speedDataList.length}");
          });
        } else if (state is GetVehSpeedErrorState) {
          setState(() {
            _isLoading = false;
          });
          //! Live Vehicle History by ID-------------------->
        } else if (state is VehicleHistoryByIdDetailLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is VehicleHistoryByIdDetailLoadedState) {
          print("Enter in the loaded state------->");
          vehiclehistorydetail.addAll(state.vehicleHistoryByIdDetailResponse);

          print("here is there----->" + vehiclehistorydetail[0].lat.toString());

          // var livelat = state.vehicleHistoryByIdDetailResponse[0].lat;
          // print("We have here the latlive--------->" + livelat.toString());
          // if(state.vehicleHistoryByIdDetailResponse.length==0){
          //
          // }else{

          // if(totalVehicleHistoryRecords==totalVehicleHistoryRecords.)
          //
          // if(data!.length-1>vehicleHistoryPosition){
          //   print("list loaded");
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (_) => BlocProvider(
          //               create: (context) {
          //                 return MainBloc(webService: WebService());
          //               },
          //               child: VehicleStatusDetailsScreen(vehicleHistoryByIdDetailResponse:state.vehicleHistoryByIdDetailResponse,latitude: data![vehicleHistoryPosition+1].latitude!,longitude: data![vehicleHistoryPosition+1].longitude!,))));
          // }else{
          //   print("list not loaded");
          //
          // }
        } else if (state is VehicleHistoryByIdDetailErrorState) {
          setState(() {
            _isLoading = false;
          });
        }
        if (state is LiveTrackingByIdLoadingState) {
        } else if (state is LiveTrackingByIdLoadedState) {
          setState(() {
            liveTrackingByIdRespons.addAll(state.liveTrackingByIdResponse);
          });

          showLocation = LatLng(
              double.parse(state.liveTrackingByIdResponse[0].latitude!),
              double.parse(state.liveTrackingByIdResponse[0].longitude!));

          if (liveTrackingByIdRespons.length != 0) {
            //  getstartlocation(state.liveTrackingByIdResponse[0].imei!);
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
        }
      },
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GoogleMap(
          initialCameraPosition:
              CameraPosition(target: LatLng(fromlatitude!, fromlongitude!)),
          markers: _marker,
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

  Set<Marker> getmarkers(double livelat, double livlong) {
    //markers to place on map
    print("here is yoiur lib----" + livelat.toString());

    setState(() {});

    return _marker;
  }

  void _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCzJ9rnQfwR2O7lfUnJt2UGwNicQP_eTUk",
      PointLatLng(fromlatitude!, fromlongitude!),
      PointLatLng(double.parse(fromlatitude!.toString()),
          double.parse(fromlatitude!.toString())),
      // PointLatLng(_originLatitude, _originLongitude),
      // PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  Set<Marker> getnextlocMarker(double nextlivelat, double nextlivelong) {
    setState(() async {
      // if (startLocationResponseime.length != 0) {
      _marker.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(nextlivelat,
            nextlivelong /*27.7099116, 85.3132343*/ /*18.6298, 73.7997*/), //position of marker
        infoWindow: InfoWindow(
            //popup info
            // title: startLocationResponseime[0].driverName,
            // snippet: startLocationResponseime[0].vehicleRegNo,
            ),
        icon: await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 1.0, size: Size(10, 10)),
            // startLocationResponseime[0].vehicleStatus == 'Stop'
            //     ? 'assets/stop_car.png'
            //     : startLocationResponseime[0].vehicleStatus == 'Running'
            //     ? 'assets/running_car.png'
            //     : startLocationResponseime[0].vehicleStatus == 'Idle'
            //     ? 'assets/idle_car.png':
            'assets/inactive_car.png'), //Icon for Marker
      ));
      // }
    });
    return _marker;
  }
}
