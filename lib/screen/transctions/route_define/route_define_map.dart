import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/transctions/vts_get_geofence/getting_routedetail.dart';
import 'dart:math';
import '../../../bloc/main_event.dart';
import '../../../model/vehicle/all_vehicle_detail_response.dart';
import 'package:google_maps_webservice/directions.dart' as stepdirection;
import 'package:google_maps_webservice/places.dart' as places;

class VTSRouteDefineMap extends StatefulWidget {
  double fromlatitude;
  double fromlongitude;
  double tolatitude;
  double tolongitude;
  String routename;
  List<Map<String, double>> coordinatesList;

  VTSRouteDefineMap(
      {Key? key,
      required this.fromlatitude,
      required this.fromlongitude,
      required this.tolatitude,
      required this.tolongitude,
      required this.routename,
      required this.coordinatesList})
      : super(key: key);

  @override
  State<VTSRouteDefineMap> createState() => _VTSRouteDefineMapState();
}

LatLng showLocation = const LatLng(27.7089427, 85.3086209);
GoogleMapController? mapController; //contrller for Google map
PolylinePoints polylinePoints = PolylinePoints();

Set<Marker> markers = Set(); //markers for google map
Map<PolylineId, Polyline> polylines = {}; //polylines to show direction
List<Map<String, double>> midpointlist = [];
late MainBloc _mainBloc;
List<VechileDetailsbyID>? vehiclelistbyid = [];
bool containerselected = false;
double distance = 0.0;
var textselected;
var time;
double straightDistance = 0.0;
late places.GoogleMapsPlaces _places;
List<String> stepsList = [];
var googlesteps;

class _VTSRouteDefineMapState extends State<VTSRouteDefineMap> {
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

    LatLng startingpoint = LatLng(fromlatitude!, fromlongitude!);
    LatLng destationpoint = LatLng(tolatitude!, tolongitude!);

    print("Here is your starting point" + startingpoint.toString());
    // midpointlist.forEach((element) {
    //   midlatitude = element['latitude'];
    //   midlongitude = element['longitude'];
    // });

    //! Markers are addeddd----------------

    for (int i = 0; i < midpointlist.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId(i.toString()),
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

    setState(() {});
    super.initState();
  }

  bool steps = false;
  List<String> directions = [];
  List<String> turnsList = [];

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
        backgroundColor: Colors.black,
        title: Text(
          widget.routename.toString(),
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(children: [
          SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: GoogleMap(
                //Map widget from google_maps_flutter package
                zoomGesturesEnabled: true, //enable Zoom in, out on map
                initialCameraPosition: CameraPosition(
                  //innital position in map
                  target:
                      LatLng(fromlatitude!, fromlongitude!), //initial position
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
        ]),
      ),
    );
  }
}
