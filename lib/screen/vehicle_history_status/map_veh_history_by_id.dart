import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/main_state.dart';
import '../../model/vehicle_history/vts_history_speed_parameter.dart';

class MapLiveTrackingDetailsScreen extends StatefulWidget {
  double latitude;
  double longitude;
  String fromdate;
  String todate;
  String totime;
  String fromtime;
  String imei;
  MapLiveTrackingDetailsScreen({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.fromdate,
    required this.todate,
    required this.totime,
    required this.fromtime,
    required this.imei,
  }) : super(key: key);
  @override
  State<MapLiveTrackingDetailsScreen> createState() =>
      _MapLiveTrackingDetailsScreenState();
}

GoogleMapController? mapController;
final Set<Marker> _marker = {};
List<VTSHistorySpeedData> vtshistoryspeeddata = [];
late Timer timer;
late MainBloc _mainBloc;
PolylinePoints polylinePoints = PolylinePoints();
double? latitude;
double? long;
late String token = "";
Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
List<Map<String, double>> midpointlist = [];
int pagenumber = 1;
late SharedPreferences sharedPreferences;

class _MapLiveTrackingDetailsScreenState
    extends State<MapLiveTrackingDetailsScreen> {
  @override
  void initState() {
    super.initState();
    latitude = widget.latitude;
    long = widget.longitude;
    pagenumber = 1;
    _mainBloc = BlocProvider.of(context);
    _marker.clear();

    getdata();

    setState(() {});
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
      print("token ${token}");
    }

    if (token != "") {
      getVehicleStatus();
    }
  }

  //! GetDirection for Polyline---------------------
  getDirections(
      double fromlat, double fromlng, double nextlat, double nextlng) async {
    List<LatLng> polylineCoordinates = [];
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY",
      PointLatLng(fromlat, fromlng),
      PointLatLng(nextlng, nextlng),
      travelMode: TravelMode.driving,
      // wayPoints: polylineWayPoints,
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
      // print(polylineWayPoints.toList().toString());
      print(result.status);
    }
    //polulineCoordinates is the List of longitute and latidtude.

    //setState(() {});
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
    //setState(() {});
  }

  getVehicleStatus() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      _mainBloc.add(VTSHistorySpeedParameterEvent(
          token: token,
          vendorid: 1,
          branchid: 1,
          arainonarai: "arai",
          imei: widget.imei,
          fromdate: widget.fromdate,
          todate: widget.todate,
          fromtime: widget.fromtime,
          totime: widget.totime,
          pagenumber: pagenumber,
          pagesize: 10));
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<MainBloc, MainState>(
        listener: (context, state) async {
          if (state is VTSHistorySpeedParameterLoadingState) {
            print("Enter in the Loading state VTSSHistory--------->");
          } else if (state is VTSHistorySpeedParameterLoadedState) {
            print("Enter in the LOaded State--------->");
            if (state.vtsLiveGeo.details!.data!.length != null) {
              vtshistoryspeeddata.addAll(state.vtsLiveGeo.details!.data!);

              for (int i = 0; i < state.vtsLiveGeo.details!.data!.length; i++) {
                latitude =
                    double.parse(state.vtsLiveGeo.details!.data![i].latitude!);
                long =
                    double.parse(state.vtsLiveGeo.details!.data![i].longitude!);
                print("Marker is below---------->");

                _marker.add(Marker(
                    //add second marker
                    markerId:
                        MarkerId(LatLng(27.7089427, 85.3086209).toString()),
                    position: LatLng(
                        double.parse(
                            state.vtsLiveGeo.details!.data![i].latitude!),
                        double.parse(state.vtsLiveGeo.details!.data![i]
                            .longitude!)), //position of marker
                    infoWindow: InfoWindow(title: "${i}"),
                    icon: BitmapDescriptor.defaultMarker));
                mapController!.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(
                            double.parse(
                                state.vtsLiveGeo.details!.data![i].latitude!),
                            double.parse(
                                state.vtsLiveGeo.details!.data![i].longitude!)),
                        zoom: 17)));

                setState(() {});
              }
              getDirections(
                  widget.latitude, widget.longitude, latitude!, long!);
              setState(() {
                pagenumber++;
              });
            }
          } else if (state is VTSHistorySpeedParameterErrorState) {}
        },
        child: Stack(
          children: [
            SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: GoogleMap(
                  zoomGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    //innital position in map
                    target: LatLng(27.7089427, 85.3086209), //initial position
                    zoom: 10.0, //initial zoom level
                  ),
                  markers: _marker, //markers to show on map
                  polylines: Set<Polyline>.of(polylines.values), //polylines
                  mapType: MapType.normal, //map type
                  onMapCreated: (controller) {
                    setState(() {
                      mapController = controller;
                    });
                  },
                )),
            // SingleChildScrollView(
            //   child: Column(
            //     children: [
            //       Container(
            //           margin: EdgeInsets.only(
            //               top: MediaQuery.of(context).size.height / 2),
            //           height: MediaQuery.of(context).size.height / 2,
            //           width: double.infinity,
            //           child: Card(
            //             child: Column(children: [
            //               Expanded(
            //                 child: ListView.builder(
            //                   itemCount: vtshistoryspeeddata.length,
            //                   itemBuilder: (BuildContext context, int index) {
            //                     return Row(
            //                       children: [
            //                         // Container(
            //                         //     decoration: BoxDecoration(
            //                         //         border: Border.all(
            //                         //             color:
            //                         //                 Color.fromARGB(255, 207, 205, 205))),
            //                         //     child: Text(
            //                         //         vtshistoryspeeddata[index].speed.toString())),
            //                            Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Text(
            //                                   vtshistoryspeeddata[index].date.toString()),
            //                           ),
            //                            Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Text(
            //                                   vtshistoryspeeddata[index].time.toString()),
            //                           ),
            //                           Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Text(
            //                                   vtshistoryspeeddata[index].distancetravel.toString()),
            //                           ),
            //                           Padding(
            //                             padding: const EdgeInsets.all(8.0),
            //                             child: Text(
            //                                   vtshistoryspeeddata[index].speed.toString()),
            //                           )

            //                       ],
            //                     );
            //                   },
            //                 ),
            //               ),
            //             ]),
            //           )),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  Set<Marker> getmarkers(double livelat, double livlong, double nextlive,
      double nextlng, int count) {
    _marker.clear();

    setState(() {});

    return _marker;
  }
}
