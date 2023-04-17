import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/live/live_tracking_filter_response.dart';
import 'package:flutter_vts/model/live/live_tracking_response.dart';
import 'package:flutter_vts/model/live/start_location_response.dart';
import 'package:flutter_vts/model/live/vehicle_status_with_count_response.dart';
import 'package:flutter_vts/model/pin_pull_info.dart';
import 'package:flutter_vts/screen/change_password/change_password_screen.dart';
import 'package:flutter_vts/screen/live_tracking/live_tracking_detail_screen.dart';
import 'package:flutter_vts/screen/live_tracking/live_tracking_filter_screen.dart';
import 'package:flutter_vts/screen/live_tracking/live_tracking_map_setting_screen.dart';
import 'package:flutter_vts/screen/vehicle_status_details_screen.dart';

import 'package:flutter_vts/service/map_pin_pull.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';
import 'dart:ui' as ui;

class NumberList {
  String number;
  int index;
  NumberList({required this.number, required this.index});
}

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LiveTrackingScreenState();
}

class LiveTrackingScreenState extends State<LiveTrackingScreen> {
  static const double cameraZoom = 16.0;
  static const double cameraTilt = 80;
  static const double cameraBearing = 30;
  static const LatLng sourceLocation = LatLng(18.6298, 73.7997);
  static const LatLng destLocation = LatLng(18.619970, 73.782850);
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = <Marker>{};
  final List<Marker> _markerlist = [];
  final Set<Marker> _searchmarkerlist = {};
  List list = [];
  String selectedVehicle = "";
  String vehicledropdown = "";
  String selectedvehicleno = "";

  List<LiveTrackingDetail>? liveTrackingDetails = [];
  List<LiveStatusCountList>? livetrackingstatus = [];

// for my drawn routes on the map
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints? polylinePoints;
  String googleAPIKey = "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY";
  //     "AIzaSyDep6h2RAS-sJyVdHogJMWxnK2NrqaVjkY";
  // 'AIzaSyDyF2jZu5TYaQlMgprBSLeWS5MJDTc2xFY';
// for my custom marker pins

  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? markerbitmap;
  BitmapDescriptor? destinationIcon;
  BitmapDescriptor? LiveLocationStatusIcon;

  LocationData? currentLocation;
  LocationData? destinationLocation;
  Location? location;
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(18.607809, 73.747849),
      locationName: '',
      labelColor: Colors.grey);
  PinInformation? sourcePinInfo;
  PinInformation? destinationPinInfo;
  bool selectedRadio = false;
  String radioItemHolder = 'Total';
  String radioItemHolder1 = '';

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  TextEditingController searchController = new TextEditingController();
  List<SearchLiveTrackingResponse> searchliveTrackingResponse = [];
  List<StartLocationResponse> startLocationResponse = [];

  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 1, vendorid = 1;
  late String token = "";
  List<VehicleStatusWithCountResponse> vehicleStatusWithCountResponse = [];
  late Timer timer;

  // Group Value for Radio Button.
  int id = 1;
  late int id1 = -1;

  LatLng showLocation =
      const LatLng(27.7089427, 85.3086209); //location to show in map
  LatLng searchLiveTrackingLocation =
      const LatLng(27.7089427, 85.3086209); //location to show in map

  int radioidValue = 1;
  late var filterLiveTrackingresult;

  late bool searchFilter = false;
  late bool searchVehicle = false;

  late LiveTrackingFilterResponse liveTrackingFilterResponse;
  List<int> selectedvehicleSrNolist = [];
  late String araiNonarai = "";

  @override
  void initState() {
    super.initState();
    _mainBloc = BlocProvider.of(context);

    setState(() {
      getmarkers(0);
    });
    getdata();
    googlemapImage();
    location = Location();
    polylinePoints = PolylinePoints();
    location!.onLocationChanged.listen((LocationData cLoc) {

      currentLocation = cLoc;

      updatePinOnMap();
    });
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
  }

  //! GetBytes from Assets--------------------------->
  static Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Set<Marker> getmarkers(int flag) {
    print("here is your flag value" + flag.toString());
    if (flag == 0) {
      _markerlist.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(18.6298, 73.7997), //position of marker
        infoWindow: InfoWindow(
            //popup info
            title: "",
            snippet: "",
            onTap: () {}),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
      //! FLAG = 1 is for get response data------------------ This all flag are give at bloc listner.
      //! From that part only it was decided----------------------
    } else if (flag == 1) {
      searchVehicle = false;

      setState(() async {
        for (LiveTrackingDetail location in liveTrackingDetails!) {
          print(location.driverName);
          double lat = double.parse(location.latitude!);
          double lng = double.parse(location.longitude!);
          print(location.vehicleRegNo!.length.toString() +
              "<-------lat+long------------->" +
              LatLng(lat, lng).toString());
          if (radioItemHolder1 == "TOTAL") {
            for (int i = 0; i < location.vehicleRegNo!.length; i++) {
              _markerlist.add(
                Marker(
                  markerId: MarkerId(LatLng(lat, lng).toString()),
                  position: LatLng(lat, lng),
                  infoWindow: InfoWindow(
                    title: location.vehicleRegNo,
                  ),
                  //   infoWindow: InfoWindow(
                  //       //popup info
                ),
              );
            }
            //! Get data Stop icon------------------
          } else if (radioItemHolder1 == "STOP") {
            Uint8List markerIcon =
                await _getBytesFromAsset("assets/stop_car.png", 85);
            _markerlist.add(
              Marker(
                icon: BitmapDescriptor.fromBytes(markerIcon),
                markerId: MarkerId(LatLng(lat, lng).toString()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                    title: location.vehicleRegNo,
                    snippet: location.driverName,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: LiveTrackingDetailsScreen(
                                    transactionId: location.transactionId,
                                    araiNonarai:
                                        'arai' /*liveTrackingDetails![i].transactionId*/,
                                  ))));
                    }),
                //   infoWindow: InfoWindow(
                //       //popup info
              ),
            );
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(lat, lng), zoom: 17)));
            setState(() {});
            //! Get data Inactive icon-----------------------
          } else if (radioItemHolder1 == "INACTIVE") {
            Uint8List markerIcon =
                await _getBytesFromAsset("assets/inactive_car.png", 85);
            _markerlist.add(
              Marker(
                icon: BitmapDescriptor.fromBytes(markerIcon),
                markerId: MarkerId(LatLng(lat, lng).toString()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                    title: location.vehicleRegNo,
                    snippet: location.driverName,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: LiveTrackingDetailsScreen(
                                    transactionId: location.transactionId,
                                    araiNonarai:
                                        'arai' /*liveTrackingDetails![i].transactionId*/,
                                  ))));
                    }),
                //   infoWindow: InfoWindow(
                //       //popup info
              ),
            );

            setState(() {});
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(lat, lng), zoom: 17)));
            //! Get data idle icon---------------------
          } else if (radioItemHolder1 == "IDLE") {
            Uint8List markerIcon =
                await _getBytesFromAsset("assets/idle_car.png", 85);
            _markerlist.add(
              Marker(
                icon: BitmapDescriptor.fromBytes(markerIcon),
                markerId: MarkerId(LatLng(lat, lng).toString()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                    title: location.vehicleRegNo,
                    snippet: location.driverName,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: LiveTrackingDetailsScreen(
                                    transactionId: location.transactionId,
                                    araiNonarai:
                                        'arai' /*liveTrackingDetails![i].transactionId*/,
                                  ))));
                    }),
                //   infoWindow: InfoWindow(
                //       //popup info
              ),
            );

            setState(() {});
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(lat, lng), zoom: 17)));
            //! Get data Running icon-----------------
          } else if (radioItemHolder1 == "RUNNING") {
            Uint8List markerIcon =
                await _getBytesFromAsset("assets/running_car.png", 85);
            _markerlist.add(
              Marker(
                icon: BitmapDescriptor.fromBytes(markerIcon),
                markerId: MarkerId(LatLng(lat, lng).toString()),
                position: LatLng(lat, lng),
                infoWindow: InfoWindow(
                    title: location.vehicleRegNo,
                    snippet: location.driverName,
                    onTap: () {
                      print("click");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: LiveTrackingDetailsScreen(
                                    transactionId: location.transactionId,
                                    araiNonarai:
                                        'arai' /*liveTrackingDetails![i].transactionId*/,
                                  ))));
                    }),
                //   infoWindow: InfoWindow(
                //       //popup info
              ),
            );

            setState(() {});
            mapController?.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(lat, lng), zoom: 17)));
          }
          
          // _markerlist.add(Marker(
          //   //add second marker
          //   markerId: MarkerId(LatLng(18.6598, 73.7497).toString()),
          //   position: LatLng(
          //       /*double.parse(liveTrackingDetails![i].latitude!),double.parse(liveTrackingDetails![i].longitude!)*/ /*27.7099116, 85.3132343*/ 18.6598,
          //       73.7497), //position of marker
          //   infoWindow: InfoWindow(
          //       //popup info
          //       title: 'Marker Title Second ',
          //       snippet: 'My Custom Subtitle',
          //       onTap: () {
          //         print("click");
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (_) => BlocProvider(
          //                     create: (context) {
          //                       return MainBloc(webService: WebService());
          //                     },
          //                     child: LiveTrackingDetailsScreen(
          //                       transactionId: 85680,
          //                       araiNonarai:
          //                           '' /*liveTrackingDetails![i].transactionId*/,
          //                     ))));
          //       }),
          //   onTap: () {
          //     print("click");
          //   },
          //   icon: BitmapDescriptor.defaultMarker, //Icon for Marker
          // ));
        }
      });
      //! FLAG = 2 is for filter response--------------------
    } else if (flag == 2) {
      setState(() {
        for (int i = 0; i < liveTrackingFilterResponse.data!.length; i++) {
          _markerlist.add(Marker(
            //add second marker
            markerId: MarkerId(showLocation.toString()),
            position: LatLng(
                liveTrackingFilterResponse.data![i].latitude == "0000000000"
                    ? 18.6298
                    : double.parse(
                        liveTrackingFilterResponse.data![i].latitude!),
                liveTrackingFilterResponse.data![i].longitude == "00000000000"
                    ? 73.7997
                    : double.parse(liveTrackingFilterResponse
                        .data![i].longitude!)), //position of marker
            infoWindow: InfoWindow(
                //popup info
                title: liveTrackingFilterResponse.data![i].driverName,
                snippet: liveTrackingFilterResponse.data![i].vehicleRegNo,
                onTap: () {
                  print("marker click");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: LiveTrackingDetailsScreen(
                                  transactionId: liveTrackingFilterResponse
                                      .data![i].transactionId,
                                  araiNonarai: 'arai'))));
                }),
            icon: BitmapDescriptor.defaultMarker, //Icon for Marker
          ));
        }
      });
      //! Flag == 3 is for search response------------------
    } else if (flag == 3) {
      _markerlist.clear();

      setState(() async {
        for (int i = 0; i < searchliveTrackingResponse.length; i++) {
          // Uint8List markerIconrunning =
          //       await _getBytesFromAsset("assets/running_car.png", 85);
          //        Uint8List markerIconstop =
          //       await _getBytesFromAsset("assets/stop_car.png", 85);
          //       Uint8List markerIconincative =
          //       await _getBytesFromAsset("assets/inactive_car.png", 85);
          _markerlist.add(Marker(
            //add second marker
            markerId: MarkerId(showLocation.toString()),
            position: LatLng(
                double.parse(searchliveTrackingResponse[i].latitude!),
                double.parse(searchliveTrackingResponse[i]
                    .longitude!)), //position of marker
            infoWindow: InfoWindow(
                //popup info
                title: searchliveTrackingResponse[i].driverName,
                snippet: searchliveTrackingResponse[i].vehicleRegNo,
                onTap: () {
                  print("marker click");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: LiveTrackingDetailsScreen(
                                  transactionId: searchliveTrackingResponse[i]
                                      .transactionId,
                                  araiNonarai: "arai"))));
                }),
            icon: await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(
                    devicePixelRatio: 1.0, size: Size(10, 10)),
                searchliveTrackingResponse[i].vehicleStatus == 'Stop'
                    ? 'assets/stop_car.png'
                    : searchliveTrackingResponse[i].vehicleStatus == 'Running'
                        ? 'assets/running_car.png'
                        : searchliveTrackingResponse[i].vehicleStatus == 'Idle'
                            ? 'assets/idle_car.png'
                            : 'assets/inactive_car.png'), //Icon for Marker
          ));
          mapController?.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      double.parse(searchliveTrackingResponse[i].latitude!),
                      double.parse(searchliveTrackingResponse[i].longitude!)),
                  zoom: 17)));
        }
      });
    } else {
      setState(() async {
        for (int i = 0; i < startLocationResponse.length; i++) {
          _searchmarkerlist.add(Marker(
            //add second marker
            markerId: MarkerId(showLocation.toString()),
            position: LatLng(
                double.parse(startLocationResponse[i].latitude!),
                double.parse(
                    startLocationResponse[i].longitude!)), //position of marker
            infoWindow: InfoWindow(
                //popup info
                title: startLocationResponse[i].driverName,
                snippet: startLocationResponse[i].vehicleRegNo,
                onTap: () {
                  print("marker click");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: LiveTrackingDetailsScreen(
                                  transactionId:
                                      startLocationResponse[i].transactionId!,
                                  araiNonarai: "arai"))));
                }),
            icon: await BitmapDescriptor.fromAssetImage(
                const ImageConfiguration(
                    devicePixelRatio: 2.0, size: Size(20, 20)),
                startLocationResponse[i].vehicleStatus == 'Stop'
                    ? 'assets/stop_car.png'
                    : startLocationResponse[i].vehicleStatus == 'Running'
                        ? 'assets/running_car.png'
                        : startLocationResponse[i].vehicleStatus == 'Idle'
                            ? 'assets/idle_car.png'
                            : 'assets/inactive_car.png') /*BitmapDescriptor.defaultMarker*/ /*BitmapDescriptor.defaultMarkerWithHue(90)*/ /*LiveLocationStatusIcon==null ? BitmapDescriptor.defaultMarker : LiveLocationStatusIcon!*/, //Icon for Marker
          ));
        }
      });
    }

    return searchVehicle ? _searchmarkerlist : Set<Marker>.of(_markerlist);

  }

  Future<BitmapDescriptor> _locationIcon() async {
    return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.0, size: Size(20, 20)),
        startLocationResponse[0].vehicleStatus == 'Stop'
            ? 'assets/stopped_truck.png'
            : 'assets/idle_truck.png');
  }

  _getVehicleStatusWithCount() {
    _mainBloc.add(VehicleStatusWithCountEvents(
        token: token,
        vendorId: vendorid,
        branchId: branchid,
        araiNonarai: "arai"));
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (sharedPreferences.getString("Username") != null) {
      userName = sharedPreferences.getString("Username")!;
    }
    vendorName = sharedPreferences.getString("VendorName")!;
    branchName = sharedPreferences.getString("BranchName")!;
    userType = sharedPreferences.getString("UserType")!;
    vendorid = sharedPreferences.getInt("VendorId")!;
    branchid = sharedPreferences.getInt("BranchId")!;
    if (token != "") {
      print("Token : ${token}");
      _getVehicleStatusWithCount();

      // getlivetrackingdetail("stop");
    }
  }

//! LIve Tracking data is here--------------------------->
  getlivetrackingdetail(String status) {
    _mainBloc.add(LiveTrackingEvents(
        token: token,
        vendorId: vendorid,
        branchId: branchid,
        TrackingStatus: status ?? "TOTAL",
        araiNonarai: "arai"));
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location!.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": destLocation.latitude,
      "longitude": destLocation.longitude
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: cameraZoom,
        tilt: cameraTilt,
        bearing: cameraBearing,
        target: sourceLocation);
    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target:
              LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          zoom: cameraZoom,
          tilt: cameraTilt,
          bearing: cameraBearing);
    }
    return Scaffold(
        drawer: MenuDrawer(),
        appBar: AppBar(
          title: searchVehicle
              ? Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: FormHelper.dropDownWidget(
                      context,
                      // "Select product",
                      selectedVehicle == '' ? "Select" : selectedVehicle,
                      this.vehicledropdown,
                      this.list,
                      (onChangeVal) {
                        setState(() {
                          this.vehicledropdown = onChangeVal;
                          // vehicleid=int.parse(onChangeVal);
                          print("Selected Product : $onChangeVal");
                          for (int i = 0; i < list.length; i++) {
                            if (onChangeVal == list[i]['vsrNo'].toString()) {
                              print(
                                  "Vehicle list was printed here-------------->" +
                                      list[i]['vehicleRegNo']);
                              selectedvehicleno = list[i]['vehicleRegNo'];
                              _mainBloc.add(SearchLiveTrackingEvents(
                                  token: token,
                                  vendorId: vendorid,
                                  branchId: branchid,
                                  araiNonarai: "arai",
                                  trackingStatus: "TOTAL" /*radioItemHolder1*/,
                                  searchText: list[i]['vehicleRegNo']));

                              if (selectedvehicleno != "") {
                                // getVehicleStatus();
                              }
                            }
                          }
                        });
                      },
                      (onValidateval) {
                        if (onValidateval == null) {
                          return "Please select country";
                        }
                        return null;
                      },
                      borderColor: MyColors.whiteColorCode,
                      borderFocusColor: MyColors.whiteColorCode,
                      borderRadius: 10,
                      optionValue: "vsrNo",
                      optionLabel: "vehicleRegNo",
                      // paddingLeft:20
                    ),
                    /*TextField(
              controller: searchController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        searchController.clear();
                      });
                       // Clear the search field
                    },
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none),
              onChanged: (value){
                if(searchController.text.isEmpty){
                  setState(() {
                    _searchmarkerlist.clear();
                    searchVehicle=false;
                  });
                }else{
                  setState(() {
                    _searchmarkerlist.clear();
                    searchVehicle=true;
                  });

                  print(searchController.text);
                  print(value);

                  _mainBloc.add(SearchLiveTrackingEvents(token: token,vendorId: vendorid,branchId :branchid,araiNonarai: "nonarai",trackingStatus : radioItemHolder1,searchText: searchController.text));
                }
              },
            ),*/
                  ),
                )
              : Text("LIVE TRACKING"),
          actions: [
            searchVehicle
                ? Container()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        searchVehicle = true;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10),
                      child: Image.asset(
                        "assets/search.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
            GestureDetector(
              onTap: () {
                _filterResult();
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/filter.png",
                  height: 40,
                  width: 40,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                            create: (context) {
                              return MainBloc(webService: WebService());
                            },
                            child: LiveMapSettingScreen())));
              },
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Image.asset(
                  "assets/setting.png",
                  height: 40,
                  width: 40,
                ),
              ),
            ),
          ],
        ),
        body: _livevehicletracking(
            initialCameraPosition) /*_livetracking(initialCameraPosition)*/
        );
  }

  _filterResult() async {
    filterLiveTrackingresult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) {
                  return MainBloc(webService: WebService());
                },
                child: LiveTrackingFilterScreen())));

    if (filterLiveTrackingresult != null &&
        filterLiveTrackingresult.containsKey('SearchFilter')) {
      searchFilter = filterLiveTrackingresult["SearchFilter"];
    }

    if (filterLiveTrackingresult != null &&
        filterLiveTrackingresult.containsKey('SelectedVehicleList')) {
      selectedvehicleSrNolist = filterLiveTrackingresult["SelectedVehicleList"];
    }

    if (filterLiveTrackingresult != null &&
        filterLiveTrackingresult.containsKey('LiveTrackingData')) {
      liveTrackingFilterResponse = filterLiveTrackingresult["LiveTrackingData"];
      setState(() {
        if (liveTrackingFilterResponse.data![0].latitude == "000000000" &&
            liveTrackingFilterResponse.data![0].longitude == "000000000") {
          getmarkers(0);
        } else {
          _markerlist.clear();
          getmarkers(2);
        }
      });
    }

    if (filterLiveTrackingresult != null &&
        filterLiveTrackingresult.containsKey('araiNonarai')) {
      araiNonarai = filterLiveTrackingresult["araiNonarai"];
    }
  }

  Future<String> getvehiclelist() async {
    setState(() {
      _isLoading = true;
    });
    String url = Constant.vehicleFillSrnoUrl +
        "" +
        vendorid.toString() +
        "/" +
        branchid.toString();

    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    var resBody = json.decode(response.body);
    // vehiclelist=vehicleFillSrNoResponseFromJson(response.body);
    // vehicleSrNolist=vehicleFillSrNoResponseFromJson(response.body);

    setState(() {
      vehicledropdown = resBody['data'][0]['vehicleRegNo'];
      list = resBody['data'];
      _isLoading = false;
    });
    /* for(int i=0;i<vehicleSrNolist.length;i++){
      list.add(vehicleSrNolist[i].vehicleRegNo!);
    }*/
    print("list legth 1 ${list.length}");
    print("list legth ${resBody['data'][0]['vehicleRegNo']}");

    return "Success";
  }

  // _livetracking(CameraPosition initialCameraPosition) {
  //   return Stack(
  //     children: <Widget>[
  //       GoogleMap(
  //         // myLocationEnabled: true,
  //         compassEnabled: true,
  //         // tiltGesturesEnabled: false,

  //         markers: _markers,
  //         polylines: _polylines,
  //         mapType: MapType.hybrid,
  //         initialCameraPosition: initialCameraPosition,
  //         onTap: (LatLng loc) {
  //           pinPillPosition = -100;
  //         },
  //         onMapCreated: (GoogleMapController controller) {
  //           controller.setMapStyle(Utils.mapStyles);
  //           _controller.complete(controller);
  //           // my map has completed being created;
  //           // i'm ready to show the pins on the map
  //           showPinsOnMap();
  //         },
  //       ),
  //       MapPinPillComponent(
  //           pinPillPosition: pinPillPosition,
  //           currentlySelectedPin: currentlySelectedPin)
  //     ],
  //   );
  // }
  //! Bloc Listner Start from hereeee---------------------
  _livevehicletracking(CameraPosition initialCameraPosition) {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        if (state is LiveTrackingLoadingState) {
          print(
              "Map is Enter in the loading state-----------------------------------2");
        } else if (state is LiveTrackingLoadedState) {
          setState(() {
            _isLoading = false;
            _markerlist.clear();
            liveTrackingDetails!.clear();
          });
          if (state.liveTrackingResponse.liveTrackingDetails != null) {
            // setState(() {
            //   // _markerlist.clear();
            // });
            print("VTSProject live data is ------------------------------");

            liveTrackingDetails!
                .addAll(state.liveTrackingResponse.liveTrackingDetails!);

            setState(() {});
            getmarkers(1);
          } else {
            if (state.liveTrackingResponse.message != null) {
              setState(() {
                _markerlist.clear();
              });
              getmarkers(0);

              print(
                  "VTSProject  1------------${state.liveTrackingResponse.message!}------------------");

              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.liveTrackingResponse.message!.toString(),
              );
            } else {
              getmarkers(0);

              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: "Record not found for given input ...!",
              );
              print("VTSProject 2-----------------------------");
            }
          }
        } else if (state is LiveTrackingErrorState) {
          setState(() {
            _isLoading = false;
          });
          //! Vehicle status count loading state------(idle,stop,.....)
        } else if (state is VehicleStatusWithCountLoadingState) {
          print("V is enter------------");
          setState(() {
            _isLoading = true;
          });
        } else if (state is VehicleStatusWithCountLoadedState) {
          setState(() {
            _isLoading = false;
          });
          if (state.vehicleStatusWithCountResponse.length != 0) {
            setState(() {
              id1 =
                  int.parse(state.vehicleStatusWithCountResponse[0].statusId!);
              radioItemHolder1 =
                  state.vehicleStatusWithCountResponse[0].status!;
            });
            print("RadioItemholder--------------------->" +
                radioItemHolder1.toString() +
                "------------>id1" +
                id1.toString());
          }
          vehicleStatusWithCountResponse = state.vehicleStatusWithCountResponse;
          getvehiclelist();
        } else if (state is VehicleStatusWithCountErrorState) {
          setState(() {
            _isLoading = false;
          });
        } else if (state is SearchLiveTrackingLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is SearchLiveTrackingLoadedState) {
          setState(() {
            _isLoading = false;
            searchliveTrackingResponse = state.searchliveTrackingResponse;
            _searchmarkerlist.clear();
            // searchLiveTrackingLocation=LatLng(double.parse(state.searchliveTrackingResponse[0].latitude!), double.parse(state.searchliveTrackingResponse[0].longitude!));

            // _markerlist.clear();
          });
          getmarkers(3);

          getstartlocation(state.searchliveTrackingResponse[0].imei!);
        } else if (state is SearchLiveTrackingErrorState) {
          setState(() {
            _isLoading = false;
          });

          Fluttertoast.showToast(
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            msg: "Record not found for given input ...!",
          );
        } else if (state is StartLocationLoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is StartLocationLoadedState) {
          setState(() {
            _isLoading = false;
            _searchmarkerlist.clear();
            startLocationResponse = state.startLocationResponse;
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
          getmarkers(4);

          // getStartLocationMakers(state.startLocationResponse[0].latitude!,state.startLocationResponse[0].longitude!);

          if (state.startLocationResponse[0].vehicleStatus == "Running") {
            getNextlocation(state.startLocationResponse[0].imei!);
          }
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
        } else if (state is StartLocationIMEILoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is StartLocationIMEILoadedState) {
          setState(() {
            _isLoading = false;
            _searchmarkerlist.clear();
            startLocationResponse = state.startLocationResponse;
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
          getmarkers(4);

          // getStartLocationMakers(state.startLocationResponse[0].latitude!,state.startLocationResponse[0].longitude!);

          if (state.startLocationResponse[0].vehicleStatus == "Running") {
            getNextlocation(state.startLocationResponse[0].imei!);
          }
        } else if (state is StartLocationIMEIErrorState) {
          setState(() {
            _isLoading = false;
          });
        } else if (state is NextLocationIMEILoadingState) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is NextLocationIMEILoadedState) {
          setState(() {
            startLocationResponse.clear();
            _isLoading = false;
            _searchmarkerlist.clear();
            startLocationResponse = state.startLocationResponse;
          });
          getmarkers(4);
        } else if (state is NextLocationIMEIErrorState) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      //! Radio button is present----------------------------
      child: Column(
        children: [
          vehicleStatusWithCountResponse.length == 0
              ? Container()
              : Expanded(
                  flex: 2,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: vehicleStatusWithCountResponse.length,
                      scrollDirection: Axis.horizontal,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, i) {
                        // return Center(child: VideoCard());

                        return Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 35,
                                child: Radio(
                                  // activeColor: Colors.green,
                                  value: id1,
                                  groupValue: int.parse(
                                      vehicleStatusWithCountResponse[i]
                                          .statusId!),
                                  onChanged: (value) {
                                    setState(() {
                                      radioItemHolder1 =
                                          vehicleStatusWithCountResponse[i]
                                              .status!;
                                      id1 = int.parse(
                                          vehicleStatusWithCountResponse[i]
                                              .statusId!);
                                      print(radioItemHolder1);
                                      _searchmarkerlist.clear();

                                      getlivetrackingdetail(
                                          radioItemHolder1.toString());
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Text(
                                      "(${vehicleStatusWithCountResponse[i].count.toString()})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold))),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    vehicleStatusWithCountResponse[i].status!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),

          // Expanded(
          //   flex: 2,
          //   child: ListView.builder(
          //       shrinkWrap: true,
          //       itemCount:nList.length,
          //       scrollDirection: Axis.horizontal,
          //       physics: ClampingScrollPhysics(),
          //       itemBuilder: (context,i){
          //         // return Center(child: VideoCard());
          //         return Padding(
          //           padding: const EdgeInsets.only(left: 10.0),
          //           child: Column(
          //             children: [
          //               SizedBox(
          //                 height:35,
          //                 child: Radio(
          //                     value:id,
          //                     groupValue: nList[i].index,
          //                     onChanged: (value) {
          //                       setState(() {
          //                         radioItemHolder = nList[i].number;
          //                         id = nList[i].index;
          //                         print(radioItemHolder);
          //                         print("------------${value}-----------------");
          //                         print("------------${id}-----------------");
          //                         print("------------${radioItemHolder}-----------------");
          //
          //                       });
          //                     },
          //                 ),
          //               ),
          //               Text("(${nList[i].index.toString()})",style: TextStyle(fontWeight: FontWeight.bold)),
          //               Padding(
          //                 padding: const EdgeInsets.only(top:4.0),
          //                 child: Text(nList[i].number,style: TextStyle(fontWeight: FontWeight.bold),),
          //               ),
          //             ],
          //           ),
          //         );
          //       }
          //   ),
          // ),
          Expanded(
              flex: 11,
              child: Container(
                // color: Colors.blue,
                child: /*GoogleMap( //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition( //innital position in map
                  target: showLocation, //initial position
                  zoom: 8.0, //initial zoom level
                ),
                markers:*/ /* getmarkers()_markers*/ /*searchVehicle ? _searchmarkerlist :_markerlist, //markers to show on map
                mapType: MapType.normal, //map type
                onMapCreated: (controller) { //method called when map is created
                  setState(() {
                    mapController = controller;
                  });
                },
              ),*/
                    //! Google Map------------------------------------------------------
                    GoogleMap(
                  markers: Set<Marker>.of(_markerlist),
                  onMapCreated: (controller) async {
                    setState(() {
                      mapController = controller;
                    });
                    
                  },
                  zoomControlsEnabled: true,
                  // initialCameraPosition: initialCameraPosition,
                  myLocationEnabled: true,
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: showLocation, //initial position
                    zoom: 8.0, //initial zoom level
                  ),
                ),
              ))
        ],
      ),
    );
  }
 
  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation!.latitude!, destinationLocation!.longitude!);

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: sourceLocation,
        pinPath: "assets/driving_pin.png",
        avatarPath: "assets/friend1.jpeg",
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: destLocation,
        pinPath: "assets/destination_map_marker.png",
        avatarPath: "assets/friend2.jpeg",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
      markerId: const MarkerId('sourcePin'),
      position: pinPosition,
      onTap: () {
        setState(() {
          currentlySelectedPin = sourcePinInfo!;
          pinPillPosition = 0;
        });
      }, /* icon: sourceIcon!*/
    ));
    // destination pin
    _markers.add(Marker(
      markerId: const MarkerId('destPin'),
      position: destPosition,
      onTap: () {
        setState(() {
          currentlySelectedPin = destinationPinInfo!;
          pinPillPosition = 0;
        });
      }, /*icon: destinationIcon!*/
    ));
    // _markers.add(Marker(markerId: MarkerId('1'),position: LatLng(17.4837, 78.3158),
    //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),));
    // _markers.add(Marker(markerId: MarkerId('2'),position: LatLng(17.5169, 78.3428),
    //     infoWindow: InfoWindow(
    //         title: "Miyapur",onTap: (){},snippet: "Miyapur"
    //     )));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  googlemapImage() async {
    markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/driving_pin.png",
    );
  }

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

  getNextlocation(String imei) {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      // _mainBloc.add(NextLocationEvents(vendorId: vendorid,branchId: branchid,token: token, araiNonarai: 'nonarai'));
      _mainBloc.add(NextLocationIMEIEvents(
          vendorId: vendorid,
          branchId: branchid,
          token: token,
          araiNonarai: 'nonarai',
          imeiNUmber: imei));
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
        "",
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(
            destinationLocation!.latitude!, destinationLocation!.longitude!),
        travelMode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "My Current Location")]);

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      setState(() {
        _polylines.add(Polyline(
            width: 120, // set the width of the polylines
            polylineId: const PolylineId("poly"),
            color: const Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates));
      });
    }
  }

  void updatePinOnMap() async {
    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: cameraZoom,
      tilt: cameraTilt,
      bearing: cameraBearing,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    setState(() {
      // updated position
      var pinPosition = LatLng(
          currentLocation!.latitude ?? 0, currentLocation!.longitude ?? 0);

      print("PinPOS: " +
          pinPosition.latitude.toString() +
          pinPosition.longitude.toString());

      print("AvatarPath: ${sourcePinInfo!.avatarPath}");
      print("LableColor: ${sourcePinInfo!.labelColor}");
      // print(sourcePinInfo!.location!.latitude);
      // print(sourcePinInfo!.location!.longitude);
      // print(sourcePinInfo!.locationName);
      // print(sourcePinInfo!.pinPath);

      //sourcePinInfo!.location = pinPosition;

      // print(
      //     "PINCODe: ${sourcePinInfo!.location!.latitude.toString()} ${sourcePinInfo!.location!.longitude.toString()}");

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      // _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      // _markers.add(Marker(
      //     markerId: const MarkerId('sourcePin'),
      //     onTap: () {
      //       setState(() {
      //         currentlySelectedPin = sourcePinInfo!;
      //         pinPillPosition = 0;
      //       });
      //     },
      //     position: pinPosition, // updated position
      //     icon: sourceIcon!));
    });
  }

  @override
  void dispose() {
    location!.onLocationChanged.listen((LocationData cLoc) {}).cancel();
    super.dispose();
  }
}

// class Utils {
//   static String mapStyles = '''[
//   {
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#f5f5f5"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.icon",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.stroke",
//     "stylers": [
//       {
//         "color": "#f5f5f5"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative.land_parcel",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#bdbdbd"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "road",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#ffffff"
//       }
//     ]
//   },
//   {
//     "featureType": "road.arterial",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#dadada"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "featureType": "road.local",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.line",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.station",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#c9c9c9"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   }
// ]''';
// }
// // import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter_vts/model/pin_pull_info.dart';
// import 'package:flutter_vts/service/map_pin_pull.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// const double CAMERA_ZOOM = 16;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
// const LatLng SOURCE_LOCATION = LatLng(22.7133, 75.8761);
// const LatLng DEST_LOCATION = LatLng(22.7182, 75.8553);

// class LiveTrackingScreen extends StatefulWidget {
//   const LiveTrackingScreen({Key? key}) : super(key: key);

//   @override
//   State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
// }

// class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
//   final Completer<GoogleMapController> _controller = Completer();
//   final Set<Marker> _markers = Set<Marker>();
// // for my drawn routes on the map
//   final Set<Polyline> _polylines = Set<Polyline>();
//   List<LatLng> polylineCoordinates = [];
//   PolylinePoints? polylinePoints;
//   String googleAPIKey = 'AIzaSyDyF2jZu5TYaQlMgprBSLeWS5MJDTc2xFY';
// // for my custom marker pins
//   BitmapDescriptor? sourceIcon;
//   BitmapDescriptor? destinationIcon;
// // the user's initial location and current location
// // as it moves
//   LocationData? currentLocation;
// // a reference to the destination location
//   LocationData? destinationLocation;
// // wrapper around the location API
//   Location? location;
//   double pinPillPosition = -100;
//   PinInformation currentlySelectedPin = PinInformation(
//       pinPath: '',
//       avatarPath: '',
//       location: const LatLng(0, 0),
//       locationName: '',
//       labelColor: Colors.grey);
//   PinInformation? sourcePinInfo;
//   PinInformation? destinationPinInfo;

//   @override
//   void initState() {
//     // create an instance of Location
//     location = Location();
//     polylinePoints = PolylinePoints();

//     // subscribe to changes in the user's location
//     // by "listening" to the location's onLocationChanged event
//     location!.onLocationChanged.listen((LocationData cLoc) {
//       // cLoc contains the lat and long of the
//       // current user's position in real time,
//       // so we're holding on to it
//       currentLocation = cLoc;
//       updatePinOnMap();
//     });
//     // set custom marker pins
//     setSourceAndDestinationIcons();
//     // set the initial location
//     setInitialLocation();
//     super.initState();
//   }

//   void setSourceAndDestinationIcons() async {
//     BitmapDescriptor.fromAssetImage(
//             const ImageConfiguration(devicePixelRatio: 1.0), 'assets/alert.png')
//         .then((onValue) {
//       sourceIcon = onValue;
//     });

//     BitmapDescriptor.fromAssetImage(
//             const ImageConfiguration(devicePixelRatio: 2.0), 'assets/gps.png')
//         .then((onValue) {
//       destinationIcon = onValue;
//     });
//   }

//   void setInitialLocation() async {
//     // set the initial location by pulling the user's
//     // current location from the location's getLocation()
//     currentLocation = await location!.getLocation();

//     // hard-coded destination for this example
//     destinationLocation = LocationData.fromMap({
//       "latitude": DEST_LOCATION.latitude,
//       "longitude": DEST_LOCATION.longitude
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     CameraPosition initialCameraPosition = const CameraPosition(
//         zoom: CAMERA_ZOOM,
//         tilt: CAMERA_TILT,
//         bearing: CAMERA_BEARING,
//         target: SOURCE_LOCATION);
//     if (currentLocation != null) {
//       initialCameraPosition = CameraPosition(
//           target:
//               LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//           zoom: CAMERA_ZOOM,
//           tilt: CAMERA_TILT,
//           bearing: CAMERA_BEARING);
//     }
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           GoogleMap(
//               myLocationEnabled: true,
//               compassEnabled: true,
//               tiltGesturesEnabled: false,
//               markers: _markers,
//               polylines: _polylines,
//               mapType: MapType.normal,
//               initialCameraPosition: initialCameraPosition,
//               onTap: (LatLng loc) {
//                 pinPillPosition = -100;
//               },
//               onMapCreated: (GoogleMapController controller) {
//                 controller.setMapStyle(Utils.mapStyles);
//                 _controller.complete(controller);
//                  // my map has completed being created;
//                 // i'm ready to show the pins on the map
//                 showPinsOnMap();
//               }),
//           MapPinPillComponent(
//               pinPillPosition: pinPillPosition,
//               currentlySelectedPin: currentlySelectedPin)
//         ],
//       ),
//     );
//   }

//   void showPinsOnMap() {
//     // get a LatLng for the source location
//     // from the LocationData currentLocation object
//     var pinPosition =
//         LatLng(currentLocation!.latitude!, currentLocation!.longitude!);
//     // get a LatLng out of the LocationData object
//     var destPosition =
//         LatLng(destinationLocation!.latitude!, destinationLocation!.longitude!);

//     sourcePinInfo = PinInformation(
//         locationName: "Start Location",
//         location: SOURCE_LOCATION,
//         pinPath: "assets/facebook.png",
//         avatarPath: "assets/game.png",
//         labelColor: Colors.blueAccent);

//     destinationPinInfo = PinInformation(
//         locationName: "End Location",
//         location: DEST_LOCATION,
//         pinPath: "assets/dashboard_icon.png",
//         avatarPath: "assets/vts_icon.png",
//         labelColor: Colors.purple);

//     // add the initial source location pin
//     _markers.add(Marker(
//         markerId: const MarkerId('sourcePin'),
//         position: pinPosition,
//         onTap: () {
//           setState(() {
//             currentlySelectedPin = sourcePinInfo!;
//             pinPillPosition = 0;
//           });
//         },
//         icon: sourceIcon!));
//     // destination pin
//     _markers.add(Marker(
//         markerId: const MarkerId('destPin'),
//         position: destPosition,
//         onTap: () {
//           setState(() {
//             currentlySelectedPin = destinationPinInfo!;
//             pinPillPosition = 0;
//           });
//         },
//         icon: destinationIcon!));
//     //icon: destinationIcon
//     // set the route lines on the map from source to destination
//     // for more info follow this tutorial
//     setPolylines();
//   }

//   void setPolylines() async {
//     PolylineResult result = await polylinePoints!.getRouteBetweenCoordinates(
//         'AIzaSyAerKv8ErrKOE62gtGsbOyrWoloK9WmeeE',
//         PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//         PointLatLng(
//             destinationLocation!.latitude!, destinationLocation!.longitude!),
//         travelMode: TravelMode.driving,
//         wayPoints: [PolylineWayPoint(location: "My Current Location")]);

//     if (result.points.isEmpty) {
//       for (var point in result.points) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       }

//       setState(() {
//         _polylines.add(Polyline(
//             width: 2, // set the width of the polylines
//             polylineId: const PolylineId("poly"),
//             color: const Color.fromARGB(255, 40, 122, 198),
//             points: polylineCoordinates));
//       });
//     }
//   }

//   void updatePinOnMap() async {
//     // create a new CameraPosition instance
//     // every time the location changes, so the camera
//     // follows the pin as it moves with an animation
//     CameraPosition cPosition = CameraPosition(
//       zoom: CAMERA_ZOOM,
//       tilt: CAMERA_TILT,
//       bearing: CAMERA_BEARING,
//       target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
//     );
//     final GoogleMapController controller = await _controller.future;
//     controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
//     // do this inside the setState() so Flutter gets notified
//     // that a widget update is due
//     setState(() {
//       // updated position
//       var pinPosition =
//           LatLng(currentLocation!.latitude!, currentLocation!.longitude!);

//       sourcePinInfo!.location = pinPosition;

//       // the trick is to remove the marker (by id)
//       // and add it again at the updated location
//       _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
//       _markers.add(Marker(
//           markerId: const MarkerId('sourcePin'),
//           onTap: () {
//             setState(() {
//               currentlySelectedPin = sourcePinInfo!;
//               pinPillPosition = 0;
//             });
//           },
//           position: pinPosition,
//           icon: sourceIcon! // updated position
//           ));
//     });
//   }
// }

// class Utils {
//   static String mapStyles = '''[
//   {
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#f5f5f5"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.icon",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.stroke",
//     "stylers": [
//       {
//         "color": "#f5f5f5"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative.land_parcel",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#bdbdbd"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "road",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#ffffff"
//       }
//     ]
//   },
//   {
//     "featureType": "road.arterial",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#dadada"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "featureType": "road.local",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.line",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#e5e5e5"
//       }
//     ]
//   },
//   {
//     "featureType": "transit.station",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#eeeeee"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#c9c9c9"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   }
// ]''';
// }

// -----------------------------------------------------------------------------------
