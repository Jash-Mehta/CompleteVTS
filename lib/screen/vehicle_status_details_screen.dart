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
import 'package:share_plus/share_plus.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

// Starting point latitude
double _originLatitude = 6.5212402;
// Starting point longitude
double _originLongitude = 3.3679965;
// Destination latitude
double _destLatitude = 6.849660;
// Destination Longitude
double _destLongitude = 3.648190;

class VehicleStatusDetailsScreen extends StatefulWidget {
  String latitude;
  String longitude;
  List<VehicleHistoryByIdDetailResponse> vehicleHistoryByIdDetailResponse;
  VehicleStatusDetailsScreen({Key? key,required this.vehicleHistoryByIdDetailResponse,required this.latitude,required this.longitude}) : super(key: key);

  @override
  State<VehicleStatusDetailsScreen> createState() =>
      _VehicleStatusDetailsScreenState();
}

class _VehicleStatusDetailsScreenState
    extends State<VehicleStatusDetailsScreen> {
  SolidController _controller = SolidController();
  Completer<GoogleMapController> _googlecontroller = Completer();

  bool toggleIcon = true;
  final Set<Marker> _marker={};
  Map<MarkerId, Marker> markers = {};
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 9.4746,
  );
  static late LatLng latLng=new LatLng(18.6298, 73.7997);
  late LatLng showLocation =  LatLng(27.7089427, 85.3086209); //location to show in map
  late LatLng showStartLocation =  LatLng(27.7089427, 85.3086209); //location to show in map
  late LatLng showNextLastLocation =  LatLng(27.7089427, 85.3086209); //location to show in map

  late GoogleMapController mapController;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token = "";
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 0, vendorid = 0;
  late Timer ?timer;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  Completer<GoogleMapController> googleMapController = Completer();
  late bool isPlayClick=false;
  late LiveTrackingByIdResponse liveTrackingByIdResponse;
  List<String> speedList=['1','2','3','4','5','6','7','8','9','10'];
  List<String> speedMakerList=['10','9','8','7','6','5','4','3','2','1'];

  String dropdownvalue = '1';
  String speeddropdownvalue = '10';
  late bool isStop=false;



  List<PointLatLng> pointLatLngList=[];
  List<LatLng> polylineCoordinates = [];
  int makerMovePosition=0;
  String selectedSpeedPosition="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);
    print("-------------------${widget.vehicleHistoryByIdDetailResponse[0].lat}  , ${widget.vehicleHistoryByIdDetailResponse[0].lng}");

    print("-------------------${widget.latitude}  , ${widget.longitude}");
    getdata();
    setState(() {
      showLocation=LatLng(double.parse(widget.vehicleHistoryByIdDetailResponse[0].lat!),double.parse(widget.vehicleHistoryByIdDetailResponse[0].lng!)/*27.7089427, 85.3086209*/);
      showNextLastLocation=LatLng(double.parse(widget.latitude),double.parse(widget.longitude));

    });
    // getmarker();
    getmarkers();
    getNextLastLocation();
    _getPolyline();
  }

  @override
  void dispose() {
    print("cancel");
    if(isPlayClick){
      timer?.cancel();
    }
    super.dispose();
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

   

    if (token != "" ||
        vendorid != 0 ||
        branchid != 0 ||
        vendorName != "" ||
        branchName != "") {
      // getstartlocation();
      // getNextlocation();
      // getlivetackingByIdDetail();


    }
  }

  getlivetackingByIdDetail(){
    _mainBloc.add(LiveTrackingByIdEvents(vendorId: vendorid,branchId: branchid,token: token, araiNonarai: 'nonarai', transactionId: 3922));
  }

  getstartlocation(){
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    _mainBloc.add(StartLocationEvents(vendorId: vendorid,branchId: branchid,token: token, araiNonarai: 'arai'));
    // });
  }

  getNextlocation(){
    _mainBloc.add(NextLocationEvents(vendorId: vendorid,branchId: branchid,token: token, araiNonarai: 'arai'));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.textColorCode,
        centerTitle: true,
        title: Text(widget.vehicleHistoryByIdDetailResponse[0].driverName!.toUpperCase()),
        actions: [
          isPlayClick ? Container() :IconButton(
              onPressed: ()  {
                setState(() {
                  isPlayClick=true;
                  // _marker.removeWhere((element) => element.markerId==MarkerId(LatLng(polylineCoordinates[makerMovePosition].latitude, polylineCoordinates[makerMovePosition].longitude).toString()));
                  // makerMovePosition=0;

                });
                _locationMakerMove();
              },
              icon: const Icon(
                // controller.page == 2
                //?
                Icons.play_circle,
                //  : Icons.help_outline,
                size: 24,
                color: MyColors.whiteColorCode,
              )
          ),
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       // controller.page == 2
          //       //?
          //       Icons.settings,
          //       //  : Icons.help_outline,
          //       size: 24,
          //       color: MyColors.whiteColorCode,
          //     )
          // ),
          // const SizedBox(
          //   width: 8.0,
          // )
        ],
      ),

      backgroundColor: MyColors.blueColorCode,
      body:_vehicledetail(),  /*GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        polylines: Set<Polyline>.of(polylines.values),
        markers: Set<Marker>.of(markers.values),
        onMapCreated: (GoogleMapController controller) {
          _googlecontroller.complete(controller);
        },
      ),*/
      floatingActionButton: isPlayClick ? null :FloatingActionButton(
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
            _controller.isOpened ? _controller.hide() : _controller.show();
          }),
      bottomSheet: isPlayClick ? BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(

          padding: EdgeInsets.only(top : 10,left: 15,right: 15,bottom: 10),
          // height: 65,
          // color: MyColors.blackColorCode,
          child: Row(
            // mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                  onTap: (){
                    if(isStop){
                      _marker.removeWhere((element) => element.markerId==MarkerId(LatLng(polylineCoordinates[makerMovePosition-1].latitude, polylineCoordinates[makerMovePosition-1].longitude).toString()));

                      setState(() {
                        makerMovePosition=0;
                        isStop=false;
                      });
                    }


                    _locationMakerMove();
                  },
                  child: Image.asset("assets/paly_icon.png",height: 40,width: 40,)
              ),
              GestureDetector(
                  onTap: (){

                    setState(() {
                      timer?.cancel();
                    });
                  },
                  child: Image.asset("assets/pause_icon.png",height: 40,width: 40,)
              ),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      timer?.cancel();
                      isStop=true;
                    });

                  },
                  child: Image.asset("assets/stop_icon.png",height: 40,width: 40,)
              ),

              Text("Speed :",style: TextStyle(fontSize: 18),),
              SizedBox(
                width: 90,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: MyColors.dropdownGreyColorCode,
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: speedList.map((String items) {
                      // print("------selected item ${items}");
                      // setState(() {
                      //   selectedSpeedPosition=items;
                      // });
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          /* decoration: BoxDecoration(
                          border: Border.all(color:MyColors.text3greyColorCode )
                        ),*/
                            padding: EdgeInsets.only(left: 8,right: 12),
                            child: Text("X"+items,style: TextStyle(fontSize: 18))
                        ),
                      );

                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        timer?.cancel();
                        dropdownvalue = newValue!;
                        // speeddropdownvalue=newValue;

                        for(int i=0;i<speedList.length;i++){
                          if(speedList[i]==newValue){
                            speeddropdownvalue=speedMakerList[i];
                            print("------Selected item ${speeddropdownvalue}");


                          }
                        }

                        _locationMakerMove();
                      });
                    },
                  ),
                ),
              ),

            ],
          ),
        ),
      ):SolidBottomSheet(
        //elevation: 16,
        minHeight: MediaQuery.of(context).size.height / 4,
        maxHeight: MediaQuery.of(context).size.height / 1.5,
        controller: _controller,
        draggableBody: true,
        headerBar:/*Text("Google map"),*/ Container(
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
                            color: widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Stopped" ? MyColors.analyticStoppedColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Nodata" ? MyColors.analyticnodataColorCode : widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Overspeed" ? MyColors.analyticoverSpeedlColorCode:widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Running" ? MyColors.analyticGreenColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Idle" ? MyColors.analyticIdelColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Inactive" ? MyColors.analyticActiveColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Total" ? MyColors.yellowColorCode :MyColors.blackColorCode
                        ),
                      ),
                      Text(
                        widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus!,
                        // "Running",
                        style: TextStyle(color: widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Stopped" ? MyColors.analyticStoppedColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Nodata" ? MyColors.analyticnodataColorCode : widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Overspeed" ? MyColors.analyticoverSpeedlColorCode:widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Running" ? MyColors.analyticGreenColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Idle" ? MyColors.analyticIdelColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Inactive" ? MyColors.analyticActiveColorCode :widget.vehicleHistoryByIdDetailResponse[0].vehicleStatus=="Total" ? MyColors.yellowColorCode :MyColors.blackColorCode,
                            fontSize: 18,fontWeight: FontWeight.bold),
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
                            borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                          ),
                          child:  Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    widget.vehicleHistoryByIdDetailResponse[0].date!.toString()+"|"+widget.vehicleHistoryByIdDetailResponse[0].time.toString(),
                                    // "21-02-2022 | 13:16:12",
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
                            borderRadius:
                            const BorderRadius.all(Radius.circular(0)),
                          ),
                          child:  Center(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                    "Speed : "+widget.vehicleHistoryByIdDetailResponse[0].speed!.toString()+"- kph",
                                    // "Speed: 10 km/h",
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
        body: /*Container(
          child: Text("Google map"),
        )*/ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16.0, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.vehicleHistoryByIdDetailResponse[0].address!=null ? Row(
                    children: [
                      Expanded(
                        child: Text(
                            widget.vehicleHistoryByIdDetailResponse[0].address!
                          // "State Bank of India - Ram Nagar Branch, Pune"
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  ):Container(),
                  // widget.vehicleHistoryByIdDetailResponse[0].address!=null ?  const SizedBox(
                  //   height: 16.0,
                  // ):Container(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          _callNumber(widget.vehicleHistoryByIdDetailResponse[0].mobileNumber!) ;
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
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
                          widget.vehicleHistoryByIdDetailResponse[0].mobileNumber!
                        // "+99 9999999999"
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          Share.share(widget.vehicleHistoryByIdDetailResponse[0].address!+"\n"+widget.vehicleHistoryByIdDetailResponse[0].mobileNumber!);
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
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
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    "License Expire On: ${widget.vehicleHistoryByIdDetailResponse[0].licenseExpireDate!}",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: Colors.grey)),
                            child:  Icon(
                              Icons.power_settings_new_rounded,
                              size: 18,
                              color:
                              widget.vehicleHistoryByIdDetailResponse[0].ignition=="OFF"
                                  ? MyColors.text4ColorCode :
                              MyColors.analyticGreenColorCode,

                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("IGN",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: widget.vehicleHistoryByIdDetailResponse[0].ignition=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode
                              )
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100.0),
                              border: Border.all(color: Colors.grey),
                            ),
                            child:  Icon(
                              Icons.battery_charging_full_outlined,
                              size: 18,
                              color:widget.vehicleHistoryByIdDetailResponse[0].mainPowerStatus=="0"
                                  ? MyColors.text4ColorCode :
                              MyColors.analyticGreenColorCode,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("PWR",
                            style: TextStyle(
                                fontSize: 10,
                                color: widget.vehicleHistoryByIdDetailResponse[0].mainPowerStatus=="0" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode

                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: Colors.grey)),
                            child:  Icon(
                              Icons.ac_unit,
                              size: 18,
                              color:widget.vehicleHistoryByIdDetailResponse[0].ac=="OFF"
                                  ? MyColors.text4ColorCode :
                              MyColors.analyticGreenColorCode,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("AC",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: widget.vehicleHistoryByIdDetailResponse[0].ac=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode

                              ))
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: Colors.grey)),
                            child:  Icon(
                              Icons.car_rental,
                              size: 18,
                              color:widget.vehicleHistoryByIdDetailResponse[0].door=="OFF"
                                  ? MyColors.text4ColorCode :
                              MyColors.analyticGreenColorCode,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("DOOR",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: widget.vehicleHistoryByIdDetailResponse[0].door=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode

                              ))
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100.0),
                                border: Border.all(color: Colors.grey)),
                            child:  Icon(
                              Icons.wifi,
                              size: 18,
                              color:widget.vehicleHistoryByIdDetailResponse[0].gpsFix=="OFF"
                                  ? MyColors.text4ColorCode :
                              MyColors.analyticGreenColorCode,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text("GPS",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: widget.vehicleHistoryByIdDetailResponse[0].gpsFix=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode
                              ))
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Text(
                            widget.vehicleHistoryByIdDetailResponse[0].currentOdometer!.toString()
                          // "99999"
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                Text(
                                  widget.vehicleHistoryByIdDetailResponse[0].parking!.atLastStop!.toString(),
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                Text(
                                  widget.vehicleHistoryByIdDetailResponse[0].parking!.total!.toString(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                Text(
                                  widget.vehicleHistoryByIdDetailResponse[0].runningDuration!.atLastStop!,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                Text(
                                  widget.vehicleHistoryByIdDetailResponse[0].runningDuration!.total!.toString(),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                Text(
                                  widget.vehicleHistoryByIdDetailResponse[0].runningDistance!.fromLastStop!,
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
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children:  [
                                Text(
                                  widget.vehicleHistoryByIdDetailResponse[0].runningDistance!.total!,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => BlocProvider(
                                        create: (context) {
                                          return MainBloc(webService: WebService());
                                        },
                                        child: NotificationScreen(isappbar: true,))));

                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children:  [
                              Text(
                                widget.vehicleHistoryByIdDetailResponse[0].alerts!.length.toString(),
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

      // TabBarView(
      //     physics: const NeverScrollableScrollPhysics(),
      //     children: listScreens),
    );
  }

  _callNumber(String mobileNumber) async{
    const number = '9657431432'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(mobileNumber);
  }


  _vehicledetail(){
    return /*Column(
      // mainAxisAlignment: MainAxisAlignment.end,

      children: [
        FloatingActionButton(
          mini: true,
          onPressed: () {},
          backgroundColor: Colors.white,
          child: Icon(
            Icons.gps_not_fixed_sharp,
            color: Colors.grey,
          ),
        ),
        FloatingActionButton(
          mini: true,
          onPressed: () {},
          backgroundColor: Colors.white,
          child: Icon(
            Icons.map_rounded,
            color: Colors.grey,
          ),
        ),
      ],
    );*/WillPopScope(
      onWillPop: () async {
        setState(() {
          if(isPlayClick){
            print("Timer cancel");
            timer?.cancel();
          }
        });
        // Navigator.pop(context);
        return true;
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: MyColors.appDefaultColorCode,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child: BlocListener<MainBloc, MainState>(
          listener: (context,state){
            if (state is LiveTrackingByIdLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is LiveTrackingByIdLoadedState) {
              setState(() {
                _isLoading = false;
              });
              setState(() {
                // liveTrackingByIdResponse=state.liveTrackingByIdResponse
                // showLocation=LatLng(double.parse(state.liveTrackingByIdResponse.latitude!),double.parse(state.liveTrackingByIdResponse.longitude!)/*27.7089427, 85.3086209*/);
              });
              // getmarker();
              // getmarkers();
            }else if (state is LiveTrackingByIdErrorState) {
              setState(() {
                _isLoading = false;
              });
            }else
            if (state is StartLocationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is StartLocationLoadedState) {
              setState(() {
                _isLoading = false;
                showStartLocation=LatLng(double.parse(state.startLocationResponse[0].latitude!),double.parse(state.startLocationResponse[0].longitude!)/*27.7089427, 85.3086209*/);
              });

              // getStartLocationMakers(state.startLocationResponse[0].latitude!,state.startLocationResponse[0].longitude!);
              getNextlocation();
            }else if (state is StartLocationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }else
            if (state is NextLocationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is NextLocationLoadedState) {
              setState(() {
                _isLoading = false;
              });
            }else if (state is NextLocationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: Stack(
            children: [
              Container(
                // color: Colors.pink,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition( //innital position in map
                    target: showLocation, //initial position
                    zoom: 17.0, //initial zoom level
                  ),
                  // initialCameraPosition: _kGooglePlex,
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  compassEnabled: true,
                  scrollGesturesEnabled: true,
                  zoomGesturesEnabled: true,
                  polylines: Set<Polyline>.of(polylines.values),
                  markers: _marker/*Set<Marker>.of(markers.values)*/,
                  onMapCreated: (GoogleMapController controller) {
                    googleMapController.complete(controller);
                  },
                ), /*GoogleMap(
                  compassEnabled: true,
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition( //innital position in map
                    target: showLocation, //initial position
                    zoom: 18.0, //initial zoom level
                  ),
                  markers: getmarkers(), //markers to show on map
                  mapType: MapType.normal, //map type
                  // minMaxZoomPreference: MinMaxZoomPreference(13,17),
                  polylines: Set<Polyline>.of(polylines.values),
                  onMapCreated: (controller) { //method called when map is created
                    setState(() {
                      mapController = controller;
                    });
                  },
                ),
              ),*/
                // Positioned(
                //     top: 16,
                //     right: 16,
                //     child: Column(
                //       children: [
                //         FloatingActionButton(
                //           mini: true,
                //           onPressed: () {},
                //           backgroundColor: Colors.white,
                //           child: Icon(
                //             Icons.gps_not_fixed_sharp,
                //             color: Colors.grey,
                //           ),
                //         ),
                //         FloatingActionButton(
                //           mini: true,
                //           onPressed: () {},
                //           backgroundColor: Colors.white,
                //           child: Icon(
                //             Icons.map_rounded,
                //             color: Colors.grey,
                //           ),
                //         ),
                //       ],
                //     )
              )
            ],
          ),
        ),
      ),
    );
  }

  _locationMakerMove(){

    // _marker.removeWhere((element) => element.markerId==MarkerId(LatLng(polylineCoordinates[0].latitude, polylineCoordinates[0].longitude).toString()));

    print("Selected Speed ----------${speeddropdownvalue}");
    timer = Timer.periodic(Duration(seconds: int.parse(speeddropdownvalue)), (Timer t) {
      if(makerMovePosition==0){
        _marker.add(Marker( //add second marker
          markerId: MarkerId(LatLng(polylineCoordinates[0].latitude, polylineCoordinates[0].longitude).toString()),
          position: LatLng(polylineCoordinates[0].latitude, polylineCoordinates[0].longitude), //position of marker
          icon: BitmapDescriptor.defaultMarkerWithHue(90), //Icon for Marker
        ));
        makerMovePosition=1;

      }else{
        // setState(() {
        _marker.removeWhere((element) => element.markerId==MarkerId(LatLng(polylineCoordinates[makerMovePosition-1].latitude, polylineCoordinates[makerMovePosition-1].longitude).toString()));
        // });

        if(polylineCoordinates.length>makerMovePosition){
          _marker.add(Marker( //add second marker
            markerId: MarkerId(LatLng(polylineCoordinates[makerMovePosition].latitude, polylineCoordinates[makerMovePosition].longitude).toString()),
            position: LatLng(polylineCoordinates[makerMovePosition].latitude, polylineCoordinates[makerMovePosition].longitude), //position of marker
            icon: BitmapDescriptor.defaultMarkerWithHue(90), //Icon for Marker
          ));
          setState(() {
            makerMovePosition++;
          });

          print("DAMINI 1--------------------");

        }else{
          setState(() {
            makerMovePosition=0;
          });
          print("DAMINI 2--------------------");

        }
      }

    });

    // getstartlocation();

    // _showBottomPopup();
  }

  Set<Marker> getmarkers() { //markers to place on map
    setState(() {
      _marker.add(Marker( //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(double.parse(widget.vehicleHistoryByIdDetailResponse[0].lat!),double.parse(widget.vehicleHistoryByIdDetailResponse[0].lng!)/*27.7099116, 85.3132343*//*18.6298, 73.7997*/), //position of marker
        infoWindow: InfoWindow( //popup info
          title:widget.vehicleHistoryByIdDetailResponse[0].driverName,
          snippet:widget.vehicleHistoryByIdDetailResponse[0].vehicleRegNo,
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return _marker;
  }

  Set<Marker> getStartLocationMakers(String lat,String log) { //markers to place on map
    setState(() {
      _marker.add(Marker( //add second marker
        markerId: MarkerId(showStartLocation.toString()),
        position: LatLng(double.parse(lat),double.parse(log)/*27.7099116, 85.3132343*//*18.6298, 73.7997*/), //position of marker
        infoWindow: InfoWindow( //popup info
          title:widget.vehicleHistoryByIdDetailResponse[0].driverName,
          snippet:widget.vehicleHistoryByIdDetailResponse[0].vehicleRegNo,
        ),

        icon: BitmapDescriptor.defaultMarker, //Icon for Marker

      ));
    });
    return _marker;
  }

  Set<Marker> getNextLastLocation() { //markers to place on map
    setState(() {
      _marker.add(Marker( //add second marker
        markerId: MarkerId(showNextLastLocation.toString()),
        position: LatLng(double.parse(widget.latitude),double.parse(widget.longitude)/*27.7099116, 85.3132343*//*18.6298, 73.7997*/), //position of marker
        // infoWindow: InfoWindow( //popup info
        //   title:widget.vehicleHistoryByIdDetailResponse[0].driverName,
        //   snippet:widget.vehicleHistoryByIdDetailResponse[0].vehicleRegNo,
        // ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return _marker;
  }

  getmarker(){
    _addMarker(
      LatLng(_originLatitude, _originLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(_destLatitude, _destLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _getPolyline();

  }

  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  void _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyCzJ9rnQfwR2O7lfUnJt2UGwNicQP_eTUk",
      PointLatLng(double.parse(widget.vehicleHistoryByIdDetailResponse[0].lat!), double.parse(widget.vehicleHistoryByIdDetailResponse[0].lng!)),
      PointLatLng(double.parse(widget.latitude), double.parse(widget.longitude)),
      // PointLatLng(_originLatitude, _originLongitude),
      // PointLatLng(_destLatitude, _destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        // });

        print("Polyline route ------------------------"+point.latitude.toString()+" ,"+point.longitude.toString());
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      color: MyColors.routeColorCode,
      width: 8,
    );
    polylines[id] = polyline;
    if(polylineCoordinates.length!=0){
      setState(() {

        _marker.add(Marker( //add second marker
          markerId: MarkerId(LatLng(polylineCoordinates[0].latitude, polylineCoordinates[0].longitude).toString()),
          position: LatLng(polylineCoordinates[0].latitude, polylineCoordinates[0].longitude), //position of marker
          icon: BitmapDescriptor.defaultMarkerWithHue(90), //Icon for Marker
        ));
        makerMovePosition=1;



      });
    }


  }

  void _showBottomPopup() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0))),
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                'Sort by',
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
              ListTile(
                title: new Text('Popular'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: new Text('Price: lowest to high'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}