import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/transctions/vts_get_geofence/getting_routedetail.dart';
import 'dart:math';
import '../../../bloc/main_event.dart';
import '../../../model/live/live_tracking_response.dart';
import '../../../model/report/vehicle_vsrno.dart';
import '../../../model/vehicle/all_vehicle_detail_response.dart';
import 'package:google_maps_webservice/directions.dart' as stepdirection;
import 'package:google_maps_webservice/places.dart' as places;

class VTSGeofenceMap extends StatefulWidget {
  double fromlatitude;
  double fromlongitude;
  double tolatitude;
  double tolongitude;
  List<Map<String, double>> coordinatesList;

  VTSGeofenceMap(
      {Key? key,
      required this.fromlatitude,
      required this.fromlongitude,
      required this.tolatitude,
      required this.tolongitude,
      required this.coordinatesList})
      : super(key: key);

  @override
  State<VTSGeofenceMap> createState() => _VTSGeofenceMapState();
}

LatLng showLocation = const LatLng(27.7089427, 85.3086209);
GoogleMapController? mapController; //contrller for Google map
PolylinePoints polylinePoints = PolylinePoints();

Set<Marker> markers = Set(); //markers for google map
Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
List<Map<String, double>> midpointlist = [];
List<VehicleVSrNoData>? osvfdata = [];
late MainBloc _mainBloc;
List<VechileDetailsbyID>? vehiclelistbyid = [];
bool containerselected = false;
List<SearchLiveTrackingResponse> searchliveTrackingResponse = [];
double distance = 0.0;
var textselected;
var time;
bool track = false;
var hour, min;
double straightDistance = 0.0;
late places.GoogleMapsPlaces _places;
List<String> stepsList = [];
var googlesteps,
    runningstatus,
    drivername,
    datetime,
    address,
    lat,
    lng,
    speedlimit,
    speed,
    distancetravel,
    ignition;

class _VTSGeofenceMapState extends State<VTSGeofenceMap> {
  double? fromlatitude;
  double? fromlongitude;
  double? tolatitude;
  double? tolongitude;

  double? midlatitude;
  double? midlongitude;
  @override
  void initState() {
    setState(() {
      //// AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY
      fromlatitude = widget.fromlatitude;
      fromlongitude = widget.fromlongitude;
      tolatitude = widget.tolatitude;
      tolongitude = widget.tolongitude;
      midpointlist = widget.coordinatesList;
    });
    print(fromlatitude.toString() + fromlongitude.toString());
    // LatLng midpoint = LatLng(midlatitude!, midlongitude!);

    markers.clear();
    getsteps();
    track = false;
    steps = false;
    //  containerselected = true;
    LatLng startingpoint = LatLng(fromlatitude!, fromlongitude!);
    LatLng destationpoint = LatLng(tolatitude!, tolongitude!);

    print("Here is your starting point" + startingpoint.toString());
    // midpointlist.forEach((element) {
    //   midlatitude = element['latitude'];
    //   midlongitude = element['longitude'];
    // });

    //! Markers are addeddd----------------

    for (int i = 0; i < midpointlist.length; i++) {
      int j = i + 1;

      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
          infoWindow: InfoWindow(title: "MidPoint ${j}"),
          position: LatLng(
              midpointlist[i]["latitude"]!, midpointlist[i]["longitude"]!),
        ),
      );
    }
    markers.add(Marker(
      //add start location marker
      markerId: MarkerId(startingpoint.toString()),
      position: LatLng(fromlatitude!, fromlongitude!), //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Starting Point ',
        snippet: 'Start Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    markers.add(Marker(
      //add distination location marker
      markerId: MarkerId(destationpoint.toString()),
      position: LatLng(tolatitude!, tolongitude!), //position of marker
      infoWindow: const InfoWindow(
        //popup info
        title: 'Destination Point ',
        snippet: 'Destination Marker',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));

    getDirections();
    _mainBloc = BlocProvider.of(context);
    getdata();
    setState(() {});

    super.initState();
    getmarker(0);
  }

  getmarker(int flag) {
    if (flag == 1) {
      setState(() async {
        for (int i = 0; i < searchliveTrackingResponse.length; i++) {
          // Uint8List markerIconrunning =
          //       await _getBytesFromAsset("assets/running_car.png", 85);
          //        Uint8List markerIconstop =
          //       await _getBytesFromAsset("assets/stop_car.png", 85);
          //       Uint8List markerIconincative =
          //       await _getBytesFromAsset("assets/inactive_car.png", 85);
          runningstatus = searchliveTrackingResponse[i].vehicleStatus;
          drivername = searchliveTrackingResponse[i].driverName;
          datetime = searchliveTrackingResponse[i].date;
          address = searchliveTrackingResponse[i].address;
          lat = searchliveTrackingResponse[i].latitude;
          lng = searchliveTrackingResponse[i].longitude;
          speedlimit = searchliveTrackingResponse[i].speedLimit;
          speed = searchliveTrackingResponse[i].speed;
          distancetravel = searchliveTrackingResponse[i].distancetravel;
          ignition = searchliveTrackingResponse[i].ignition;
          markers.add(Marker(
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
    }
  }

  bool steps = false;
  List<String> directions = [];
  List<String> turnsList = [];
  //! getData-------------------------
  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "") {
      _mainBloc.add(VehicleVSrNoEvent(token: token, vendorId: 1, branchId: 1));
    }
  }

//! Adding steps------------------
  List<Map<String, dynamic>> stepsList = [];
  List<stepdirection.Waypoint> waypoints = midpointlist
      .map((point) => stepdirection.Waypoint(
            value: "${point['latitude']},${point['longitude']}",
          ))
      .toList();
  getsteps() async {
    final googledirections = stepdirection.GoogleMapsDirections(
        apiKey: 'AIzaSyDlSSkw31UcsS-WeGTC2qRVvnZXBvYP3gs');
    final response = await googledirections.directionsWithLocation(
        stepdirection.Location(lat: fromlatitude!, lng: fromlongitude!),
        stepdirection.Location(lat: tolatitude!, lng: tolongitude!),
        travelMode: stepdirection.TravelMode.driving,
        waypoints: waypoints);

    if (response.isOkay) {
      final steps = response.routes.first.legs.expand((leg) => leg.steps);
//double totalDistance = response.routes.first.legs.fold(0, (sum, leg) => sum! + (leg.distance.value as int).toInt()) / 1000;
      double totalDistance = response.routes.first.legs.fold<double>(
          0, (sum, leg) => sum + (leg.distance.value ?? 0) / 1000);
      int totalTimeInSeconds = response.routes.first.legs
          .fold(0, (sum, leg) => sum + (leg.duration.value as int));

      setState(() {
        // distance = totalDistance / 1000; // convert to kilometers
        time = totalTimeInSeconds ~/ 60;
        hour = time ~/ 60;
        min = time % 60;
        print("here is your steps and time of the Api---------->" +
            waypoints.toString() +
            "-------------->" +
            min.toString());
      });
      // convert to minutes
      steps.forEach((step) {
        String instruction =
            step.htmlInstructions.replaceAll(RegExp(r'<[^>]*>'), '');
        String icon;
        switch (step.maneuver) {
          case "turn-left":
            icon = "assets/left.png";
            break;
          case "turn-right":
            icon = "assets/right.png";
            break;
          default:
            icon = "assets/straight.png";
            break;
        }
        stepsList.add({"instruction": instruction, "icon": icon});
      });
      setState(() {});
    } else {
      print('Error getting directions: ${response.errorMessage}');
    }
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
      // getsteps();
      //setState(() {});
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

      List<Map<String, dynamic>> stepsList = [];
      List<stepdirection.Waypoint> waypoints = midpointlist
          .map((point) => stepdirection.Waypoint(
                value: "${point['latitude']},${point['longitude']}",
              ))
          .toList();

      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    print("Total distance to calculate--------->" + totalDistance.toString());

    setState(() {
      distance = totalDistance;
      time = distance ~/ 60;
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
      appBar: steps
          ? AppBar(
              backgroundColor: Colors.black,
              title: const Text("Route Name"),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                      onTap: () {
                        steps = false;
                        setState(() {});
                      },
                      child: Icon(Icons.cancel)),
                )
              ],
            )
          : null,
      body: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          //! VechileId and vechile number in flutter---------------------
          if (state is VehicleVSrNoLoadingState) {
            print("Over speed enter in the loading sate");
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VehicleVSrNoLoadedState) {
            if (state.vehiclevsrnoresponse.data != null) {
              print("overspeed vehicle filter data is Loaded state");
              osvfdata!.clear();
              osvfdata!.addAll(state.vehiclevsrnoresponse.data!);

              // overspeedfilter!.addAll(state.overspeedFilter.data!);
              osvfdata!.forEach((element) {
                print("Overspeed vehicle filter element is Printed");
              });
            }
          } else if (state is VehicleVSrNoErorrState) {
            print("Something went Wrong  data VehicleVSrNoErorrState");
            Fluttertoast.showToast(
              msg: state.msg,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          } else if (state is SearchLiveTrackingLoadingState) {
            setState(() {});
          } else if (state is SearchLiveTrackingLoadedState) {
            print("Enter in the search loaded state--------->");

            setState(() {
              searchliveTrackingResponse = state.searchliveTrackingResponse;

              // searchLiveTrackingLocation=LatLng(double.parse(state.searchliveTrackingResponse[0].latitude!), double.parse(state.searchliveTrackingResponse[0].longitude!));

              // _markerlist.clear();
            });
            getmarker(1);
            // print("Your Start location is there---------->" +
            //     state.searchliveTrackingResponse[0].latitude.toString());
          } else if (state is SearchLiveTrackingErrorState) {
            setState(() {
              //  markers.clear();
            });

            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Record not found for given input ...!",
            );
          }
        },
        child: SafeArea(
          child: Stack(children: [
            SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GoogleMap(
                  //Map widget from google_maps_flutter package
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: LatLng(
                        fromlatitude!, fromlongitude!), //initial position
                    zoom: 10.0, //initial zoom level
                  ),
                  markers: markers, //markers to show on map
                  polylines: Set<Polyline>.of(polylines.values), //polylines
                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                )),
            SizedBox(
              child: steps
                  ? null
                  : Container(
                      height: 60.0,
                      width: double.infinity,
                      color: Colors.white,
                      child: ListTile(
                        leading: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        title: GestureDetector(
                          onTap: () {
                            containerselected = true;
                            setState(() {});
                          },
                          child: Container(
                              height: 50.0,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: ListTile(
                                title: Text(textselected ?? "Select Vehicle"),
                                trailing: Icon(Icons.keyboard_arrow_down),
                              )),
                        ),
                      ),
                    ),
            ),
            containerselected
                ? Container(
                    height: 200.0,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    margin: EdgeInsets.only(left: 80.0, right: 30.0, top: 50.0),
                    child: ListView.builder(
                      itemCount: osvfdata!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            containerselected = false;
                            textselected =
                                osvfdata![index].vehicleRegNo.toString();
                            _mainBloc.add(SearchLiveTrackingEvents(
                                token: token,
                                vendorId: 1,
                                branchId: 1,
                                araiNonarai: "arai",
                                trackingStatus: "TOTAL" /*radioItemHolder1*/,
                                searchText:
                                    osvfdata![index].vehicleRegNo.toString()));
                            setState(() {});
                          },
                          child: SizedBox(
                              height: 40.0,
                              width: 50.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                    osvfdata![index].vehicleRegNo.toString()),
                              )),
                        );
                      },
                    ),
                  )
                : SizedBox(),
            steps
                ? Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 2),
                    height: MediaQuery.of(context).size.height / 2,
                    width: double.infinity,
                    child: Card(
                      child: Column(children: [
                        SizedBox(
                          height: 50.0,
                          child: Center(
                            child: Text(
                                "Diatance: " +
                                    distance.toStringAsFixed(2) +
                                    " km" +
                                    " "
                                        "Duration:- " +
                                    hour.toString() +
                                    " hrs" +
                                    " " +
                                    min.toString() +
                                    "min",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w400)),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: stepsList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromARGB(
                                            255, 207, 205, 205))),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Image.asset(
                                          stepsList[index]["icon"],
                                          height: 20.0,
                                          width: 20.0,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            child: Text(stepsList[index]
                                                ["instruction"])),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                    ))
                : Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 1.22),
                    height: 140.0,
                    width: double.infinity,
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text(
                                    "Diatance: " +
                                        distance.toStringAsFixed(2) +
                                        " km" +
                                        " "
                                            "Duration:- " +
                                        hour.toString() +
                                        " hrs" +
                                        " " +
                                        min.toString() +
                                        "min",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (textselected != null) {
                                            track = true;
                                            steps = false;

                                            setState(() {});
                                          } else {
                                            Fluttertoast.showToast(
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                              msg:
                                                  "Please Select the Vehicle...!",
                                            );
                                          }
                                        },
                                        child: Text("Track")),
                                    ElevatedButton(
                                        onPressed: () {
                                          //  getsteps();
                                          track = false;
                                          steps = true;
                                          setState(() {});

                                          // setState(() {});
                                        },
                                        child: Text("Step")),
                                  ],
                                )
                              ],
                            ),
                          )),
                    )),
            track
                ? Container(
                    height: 300.0,
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: 15.0,
                        right: 15.0,
                        top: MediaQuery.of(context).size.height / 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Text(
                                runningstatus.toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 49, 113, 51),
                                    fontSize: 19.0,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                track = false;
                                setState(() {});
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 30.0),
                                child: Icon(
                                  Icons.cancel,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Driver Name",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                Text(
                                  drivername.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Date & Time",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                Text(
                                  datetime.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Address",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                SizedBox(
                                  height: 60.0,
                                  width: 100.0,
                                  child: Text(
                                    address.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Lat.Lng",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                Text(
                                  "${lat.toString()}| ${lng.toString()}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Speed Limit",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                Text(
                                  speedlimit.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Speed",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                Text(
                                  speed.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Distance Travel",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16.0),
                                ),
                                Text(
                                  distance.toString(),
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : SizedBox(),
          ]),
        ),
      ),
    );
  }
}
