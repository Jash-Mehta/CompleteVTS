import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:geocoding/geocoding.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/main_event.dart';
import '../../../model/getgeofence.dart/getroute_name_list.dart';
import '../../../model/getgeofence.dart/routes_detail_routename.dart';
import '../../../util/MyColor.dart';
import 'geofence_map.dart';
import 'package:loading_overlay/loading_overlay.dart';

class GettingRouteDetail extends StatefulWidget {
  GettingRouteDetail({Key? key}) : super(key: key);

  @override
  State<GettingRouteDetail> createState() => _GettingRouteDetailState();
}

late MainBloc _mainBloc;
late SharedPreferences sharedPreferences;
late String token = "";
bool forcontainer = false;
bool routedata = false;
var routeselect;
bool _isloading = false;
var routefromaddress, routetoaddress, midaddress;
List<RoutesNameDetailList>? routesnamedetaillist = [];
String formattedAddresses = '';
List<Map<String, double>> coordinatesList = [];

class _GettingRouteDetailState extends State<GettingRouteDetail> {
  @override
  void initState() {
    super.initState();
    getdata();
    setState(() {});
    _mainBloc = BlocProvider.of(context);
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "") {
      print(token);
      getBranch();
      setState(() {});
    } else {
      print("null");
    }
  }

  getBranch() {
    _mainBloc.add(GettingRouteGGR(token: token, vendorid: 1, branchid: 1));
  }

  double? fromlatitude;
  double? fromlongitude;
  double? tolatitude;
  double? tolongitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VTS GET GEOFENCING"),
        backgroundColor: Colors.black,
      ),
      body: LoadingOverlay(
        isLoading: _isloading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: MyColors.appDefaultColorCode,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child: BlocListener<MainBloc, MainState>(
            listener: (context, state) {
              //! Route Detial by routename list------------
              if (state is GetRoutesDetailLoadingState) {
                print(
                    "Your route name enter in the circular progress indicator");
                CircularProgressIndicator();
              } else if (state is GetRoutesDetailLoadedState) {
                if (state.routenamelist != null) {
                  print("Data is fetch by routes name");
                  setState(() {
                    routesnamedetaillist!.clear();
                    routefromaddress = "";
                    routetoaddress = "";
                  });
                  if (state.routenamelist.data != null) {
                    routesnamedetaillist!.addAll(state.routenamelist.data!);

                    routesnamedetaillist!.forEach((element) {
                      routefromaddress = element.routeFrom;
                      routetoaddress = element.routeTo;

                      if (element.latlang != null) {
                        coordinatesList.clear();
                        midaddress = element.latlang;
                        _midaddress(midaddress);
                      }
                      setState(() {
                        coordinatesList.clear();
                      });

                      _getRouteDetails(routefromaddress, routetoaddress);

                      print("Bloc Listner route select-----------" +
                          routefromaddress.toString());
                    });
                  }
                }
              } else if (state is GetRoutesDetailErrorState) {
                print("Error is occured in the routelist");
              }
              //! Route  list--------------------
              if (state is RouteNameListLoadingState) {
                print(
                    "Your route name enter in the circular progress indicator");
                CircularProgressIndicator();
              } else if (state is RouteNameListLoadedState) {
                if (state.routenamelist != null) {
                  routename;
                  print(routename);
                }
              } else if (state is RouteNameListErorrState) {
                print("Error is occured in the routelist");
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    "Routes",
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    forcontainer = true;

                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.0, right: 30.0, left: 30.0),
                    height: 40.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: ListTile(
                      leading: Text(routeselect ?? "All"),
                      trailing: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                ),
                forcontainer
                    ? Container(
                        margin: const EdgeInsets.only(
                            top: 2.0, right: 30.0, left: 30.0),
                        height: 200.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: ListView.builder(
                          itemCount: routename.length,
                          itemBuilder: (BuildContext context, int index) {
                            var article = routename[index];

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                  onTap: () async {
                                    routeselect = article.toString();
                                    print(routeselect);

                                    forcontainer = false;
                                    setState(() {});
                                    _mainBloc.add(
                                        RoutesDetailByRoutesNameEvents(
                                            token: token,
                                            vendorid: 1,
                                            branchid: 1,
                                            routename: routeselect.toString()));

                                    // if (midaddress != null) {
                                    //   _midaddress(midaddress);
                                    // }

                                    // setState(() {});
                                  },
                                  child: Text(article.toString())),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          _isloading = true;
                          setState(() {});
                          if (routeselect == null) {
                            final snackBar = SnackBar(
                              content: const Text("Select Route"),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }

                          Future.delayed(
                              Duration(
                                seconds: 8,
                              ), () {
                            _isloading = false;
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                          create: (context) {
                                            return MainBloc(
                                                webService: WebService());
                                          },
                                          child: VTSGeofenceMap(
                                            fromlatitude: fromlatitude!,
                                            fromlongitude: fromlongitude!,
                                            tolatitude: tolatitude!,
                                            tolongitude: tolongitude!,
                                            coordinatesList: coordinatesList,
                                            // coordinatesList: coordinatesList,
                                            // midlatitude: midlat1,
                                            // midlongatitude: midlat2,
                                          ),
                                        )));
                          });
                        },
                        child: Text("Get Route")))
              ],
            )),
      ),
    );
  }

  Future<void> _getRouteDetails(
      String routefromaddress, String routetoaddress) async {
    List<Location> locations =
        await locationFromAddress(routefromaddress.toString());
    // locations.clear();
    Location location = locations[0];
    fromlatitude = 0.0;
    fromlongitude = 0.0;
    fromlatitude = location.latitude;
    fromlongitude = location.longitude;
    setState(() {});
    print("Latitude: $fromlatitude, Longitude: $fromlongitude");
    print("Route From Address----------------" + routefromaddress.toString());
//!------------------------
    List<Location> tolocations = await locationFromAddress(routetoaddress
            .toString() ??
        "Dange Chowk Rd, Hinjawadi Village, Hinjawadi, Pimpri-Chinchwad, Maharashtra 411057, India");
    // tolocations.clear();

    Location tolocation = tolocations[0];

    tolatitude = tolocation.latitude;
    tolongitude = tolocation.longitude;
    setState(() {});

    print("ToLatitude: $tolatitude, ToLongitude: $tolongitude");
    //!---------------------------

    // Do something with the latitude and longitude values
  }

//! Mid address------------------
  Future<void> _midaddress(String midaddress) async {
    try {
      List<String> addressList = midaddress.split('\$');
      for (String address in addressList) {
        List<Location> locations = await locationFromAddress(address);
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;
        Map<String, double> coordinates = {
          "latitude": latitude,
          "longitude": longitude
        };

        coordinatesList.add(coordinates);
        setState(() {});

        print("Here is your coordinates list" + coordinatesList.toString());
      }
    } catch (e) {
      print("Data not found");
    }

    // List<Location> midlocations = await locationFromAddress(midaddress
    //         .toString() ??
    //     "Dange Chowk Rd, Hinjawadi Village, Hinjawadi, Pimpri-Chinchwad, Maharashtra 411057, India");

    // Location midlocation = midlocations[0];

    // midlat1 = midlocation.latitude;
    // midlat2 = midlocation.longitude;
    // setState(() {});

    // print("MidLatitude: $midlat1, MidLongitude: $midlat2");
  }
}
