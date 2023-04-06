import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/model/login/login_response.dart';
import 'package:flutter_vts/screen/change_password/change_password_screen.dart';
import 'package:flutter_vts/screen/distance_summary/distance_summary_screen.dart';
import 'package:flutter_vts/screen/live_tracking_screen.dart';
import 'package:flutter_vts/screen/login/login_screen.dart';
import 'package:flutter_vts/screen/main/main_screen.dart';
import 'package:flutter_vts/screen/master/alert/alert_master_screen.dart';
import 'package:flutter_vts/screen/master/branch_master/branch_master_screen.dart';
import 'package:flutter_vts/screen/master/device_master/device_master_screen.dart';
import 'package:flutter_vts/screen/master/driver_master/driver_master_screen.dart';
import 'package:flutter_vts/screen/master/subscription_master/subscription_master_screen.dart';
import 'package:flutter_vts/screen/master/vehicle_master/vehicle_master_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_master_screen.dart';
import 'package:flutter_vts/screen/notification/notification_screen.dart';
import 'package:flutter_vts/screen/profile/profile_screen.dart';
import 'package:flutter_vts/screen/report/over_speed_report_screen.dart';
import 'package:flutter_vts/screen/report/vehicle_status_summary.dart';
import 'package:flutter_vts/screen/reset_password/reset_password_screen.dart';
import 'package:flutter_vts/screen/storage_summary/storage_summary_screen.dart';
import 'package:flutter_vts/screen/transctions/create_geofence/geofence_create_screen.dart';
import 'package:flutter_vts/screen/transctions/point_of_interest/point_of_interest_screen.dart';
import 'package:flutter_vts/screen/transctions/route_define/route_define_screen.dart';
import 'package:flutter_vts/screen/travel_details/travel_details_screen.dart';
import 'package:flutter_vts/screen/travel_summary/travel_summary_screen.dart';
import 'package:flutter_vts/screen/utility/assignMenu/assign_menu_right_screen.dart';
import 'package:flutter_vts/screen/vehicle_expiry/vehicle_expiry_screen.dart';
import 'package:flutter_vts/screen/vehicle_expiry_screen.dart';
import 'package:flutter_vts/screen/vehicle_history_status/vehicle_status_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screen/report/date_and_timewise_distance.dart';
import '../screen/report/date_wise_travel_history.dart';
import '../screen/report/device_master_report1.dart';
import '../screen/report/device_master_report1.dart';
import '../screen/report/driver_master_report_screen.dart';
import '../screen/report/driver_wise_vehicle_assign.dart';
import '../screen/report/frame_packet.dart';
import '../screen/report/frame_packet_grid.dart';
import '../screen/report/vehicle_report_screen.dart';
import '../screen/report/vehicle_status_group.dart';
import '../screen/report/vehicle_status_report.dart';
import '../screen/report/vehicle_wise_timewise_travel.dart';
import '../screen/report/vehicle_wise_travel_history.dart';
import '../screen/utility/create/create_user_screen.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  @override
  Widget build(BuildContext context) {
    return getMenuDrawer(context);
  }

  Future<LoginResponse> updateLogout(BuildContext context,String menuCaption,int vendorSrNo,int branchsrno,int userId,String sessionId,String token) async {
    print(Constant.updatelogoutUrl);
    final response = await http.post(
      Uri.parse(Constant.updatelogoutUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'menuCaption': menuCaption,
        'vendorSrNo': vendorSrNo.toString(),
        'branchSrNo': branchsrno.toString(),
        'userId': userId.toString(),
        'sessionId': sessionId.toString(),
      }),
    );
    print(response.body);

    if(response.statusCode==200){
      _removedata(context);
    }else{
      Fluttertoast.showToast(
        msg:"logout failed",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
    return LoginResponse.fromJson(jsonDecode(response.body));
  }


  getMenuDrawer(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //     image: AssetImage("assets/menu1.png"),
                  //     fit: BoxFit.cover
                  // )
                  color: MyColors.blueColorCode,
                ),
                child: Center(
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/profile.png",
                          width: 64,
                          height: 63,
                        ),
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Techno',
                                    style: TextStyle(
                                        color: MyColors.whiteColorCode, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6.0),
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                                 MaterialPageRoute(builder: (_) =>
                                                     ProfileScreen()
                                                 ));
                                        },
                                        child: const Text(
                                          "View Profile",
                                          style: TextStyle(
                                              decoration: TextDecoration.underline,
                                              color: MyColors
                                                  .linearGradientGrey2ColorCode),
                                        )),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 17,
                            color: MyColors.whiteColorCode,
                          ),
                        ),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: const MainScreen())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/dashboard_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Dashboard",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  print("click");
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: const LiveTrackingScreen())));

                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/live_tracking_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Live Tracking",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child:  VehicleStatusScreen())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/vehicle_status_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Vehicle Status",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child:  TravelSummaryScreen())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/travel_summary_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Travel Summary",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child:  NotificationScreen(isappbar: true,))));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/alerts_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Alerts",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: DistanceSummaryScreen())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/distance_summary_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Distance Summary Details",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              /* Container(
                     height: 2,
                     color: MyColors.driverColorCode,
                   ),
                   GestureDetector(
                     onTap: (){
                       Navigator.of(context).pop();
                     },
                     child: Padding(
                       padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                       child: Text("Notification",style: TextStyle(fontSize: 20),),
                     ),
                   ),*/
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/settings_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Settings",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child:  StorageSummaryScreen())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/storage_summary_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Storage Summary",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child:  VehicleExpiryScreen2())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/vehicle_expiry_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Vehicle Expiry (Deactive)",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child:  TravelDetailsScreen())));
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/travel_details_daily_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Travel Details (Daily)",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              ExpansionTile(
                leading: Image.asset(
                  'assets/master_icon.png',
                  height: 24,
                  width: 24,
                ),
                title: const Text(
                  "Master",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: VendorMasterScreen())));
                    },
                    child: _masterMenuText("Vendor Master","assets/vendor_master.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: BranchMasterScreen())));
                    },
                    child: _masterMenuText("Branch Master","assets/branch_master.png"),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BlocProvider(
                                    create: (context) {
                                      return MainBloc(webService: WebService());
                                    },
                                    child: DeviceMasterScreen())));
                      },
                      child: _masterMenuText("Device Config Master","assets/device_master.png")),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: DriverMasterScreen())));
                    },
                    child: _masterMenuText("Driver Entry Master","assets/driver_master.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: VehicleMasterScreen())));
                    },
                    child: _masterMenuText("Vehicle Entry Master","assets/vehicle_master.png"),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: SubscriptionMasterScreen())));
                    },
                    child: _masterMenuText("Subscription Setting","assets/subscription_master.png"),
                  ),
                  // _masterMenuText("Command Master"),

                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: AlertMasterScreen())));
                    },
                    child:  _masterMenuText("Alert Master","assets/alert_master.png"),
                  )
                ],
              ),
              const Divider(height: 0.5),
              ExpansionTile(
                leading: Image.asset(
                  'assets/transaction_icon.png',
                  height: 24,
                  width: 24,
                ),
                title: const Text(
                  "Transaction",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: GeofenceCreateScreen())));
                    },
                    child: _masterMenuText("Geofence Create","assets/transactions.png"),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: PointOfInterestScreen()))
                      );
                    },
                    child: _masterMenuText("Point of Interest","assets/transactions.png") ,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: RouteDefineScreen())));
                    },
                    child:_masterMenuText("Route Define","assets/transactions.png") ,
                  ),
                  GestureDetector(
                    onTap: (){

                    },
                    child: _masterMenuText("VTS Get Geofencing","assets/transactions.png"),
                  ),
                  /* _masterMenuText("VTS Live"),
                  _masterMenuText("VTS History"),
                  _masterMenuText("VTS Master"),
                  _masterMenuText("VTS Get Direction"),
                  _masterMenuText("VTS Get Multiple Routes"),
                  _masterMenuText("VTS Route Define"),
                  _masterMenuText("Street View Side By Side"),
                  _masterMenuText("OTA Command Setting"),
                  _masterMenuText("Geofence Create"),
                  _masterMenuText("Point Of Interest Create"),*/
                ],
              ),
              const Divider(height: 0.5),
              ExpansionTile(
                leading: Image.asset(
                  'assets/utility_icon.png',
                  height: 24,
                  width: 24,
                ),
                title: const Text(
                  "Utility",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child: const CreateUserScreen())));
                    },

                    child: _masterMenuText("Create User","assets/create_user.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                       Navigator.push(context,
                    MaterialPageRoute(builder: (_) => BlocProvider(
                        create: (context) {
                          return MainBloc(webService: WebService());
                        },
                        child: ChangePasswordScreen()
                    )));
                    },
                    child:_masterMenuText("Change Password","assets/change_password.png") ,
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  ResetPassword())));
                    },
                    child:  _masterMenuText("Reset Password","assets/reset_password.png"),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  AssignMenuRightScreen())));
                    },
                    child:  _masterMenuText("Menu Rights","assets/menu1.png"),
                  )

                ],
              ),
              const Divider(height: 0.5),
              ExpansionTile(
                leading: Image.asset(
                  'assets/reportmain.png',
                  height: 24,
                  width: 24,
                ),
                title: const Text(
                  "Reports",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  OverSpeedReportScreen()
                                //  child:  DeviceMasterReportScreen()
                              )));
                      },
                    child:_masterMenuText("Overspeed Report","assets/small_report.png"),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  DriverMasterReportScreen()
                              )));
                    },
                    child: _masterMenuText("Driver Master Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  VehicleReportScreen()
                              )));
                    },
                    child:

                    _masterMenuText("Vehicle Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  DateAndTimeWiseDistanceScreen()
                              )));
                    },
                    child: _masterMenuText("Date and Time Wise Distance Travel Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  DeviceMasterReportScreen()
                              )));
                    },
                    child: _masterMenuText("Device Master Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  DriverWiseVehicleAssignScreen()
                              )));
                    },
                    child: _masterMenuText("Driver Wise Vehicle Assign","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  DateWiseTravelHistory()
                              )));
                    },
                    child: _masterMenuText("Date Wise Travel History Report Screen","assets/small_report.png"),
                  ),


                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  VehicleWiseTravel()
                              )));
                    },
                    child: _masterMenuText("Vehicle Distance Travel Report","assets/small_report.png"),
                  ),


                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  VehicleWiseTimeWiseTravel()
                              )));
                    },
                    child: _masterMenuText("Vehicle Time Wise Distance Travel Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  FramePacket()
                              )));
                    },
                    child: _masterMenuText("Frame Packet Report","assets/small_report.png"),
                  ),
                  //FramePacketReportScreen

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  FramePacketGrid()
                              )));
                    },
                    child: _masterMenuText("Frame Packet Grid View Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  VehicleStatusReport()
                              )));
                    },
                    child: _masterMenuText("Vehicle Status Report","assets/small_report.png"),
                  ),

                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  VehicleStatusGroup()
                              )));
                    },
                    child: _masterMenuText("Vehicle Status Group By Report","assets/small_report.png"),
                  ),


                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                  create: (context) {
                                    return MainBloc(webService: WebService());
                                  },
                                  child:  VehicleStatusSummary()
                              )));
                    },
                    child: _masterMenuText("Vehicle Status Summary Report Screen","assets/small_report.png"),
                  ),


                 //  _masterMenuText("Driver Wise Vehicle Assign","assets/report.png"),
                 //  _masterMenuText("Vehicle Wise Over Speed Report","assets/report.png"),
                 //  _masterMenuText("Date Wise Travel History Report","assets/report.png"),
                 //  _masterMenuText("Time Wise Distance Travel Report","assets/report.png"),
                 //  _masterMenuText("Vehicle Distance Travel Report","assets/report.png"),
                 // // _masterMenuText("Vehicle Time Wise Distance Report","assets/report.png"),
                 //  //_masterMenuText("Frame Packet Report","assets/report.png"),
                 //  _masterMenuText("Frame Packet Grid View Report","assets/report.png"),
                 //  _masterMenuText("Data Packet Grid View Report","assets/report.png"),
                 //  _masterMenuText("Login Audio History Report","assets/report.png"),
                 //  _masterMenuText("Vehicle Status Report","assets/report.png"),
                 //  _masterMenuText("Vehicle Status Group By Report","assets/report.png"),
                 //  _masterMenuText("Vehicle Status Summary Report","assets/report.png"),
                ],
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/help_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Help",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              const Divider(height: 0.5),
              GestureDetector(
                onTap: () async{
                  // _removedata(context);
                  Navigator.of(context).pop();

                  SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
                  // print(sharedPreferences.getInt("UserID")!);
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          _buildPopupDialogforLogout(context,sharedPreferences)
                  );
                },
                child: ListTile(
                  leading: Image.asset(
                    'assets/logout_icon.png',
                    height: 24,
                    width: 24,
                  ),
                  title: const Text(
                    "Logout",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: MyColors.redColorCode),
                  ),
                ),
              ),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupDialogforLogout(BuildContext context, SharedPreferences sharedPreferences) {
    return new AlertDialog(
      // title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Logout",style: TextStyle(fontSize:20,color: MyColors.appDefaultColorCode,fontWeight: FontWeight.bold),),
          SizedBox(
            height: 20,
          ),
          Text("Are you sure you want to Logout VTS App?",style: TextStyle(fontSize: 18),),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text(
            'CANCEL',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        new TextButton(
          onPressed: () {
            Navigator.pop(context);
            updateLogout(context,"application",sharedPreferences.getInt("VendorId")!=null ? sharedPreferences.getInt("VendorId")!:0,sharedPreferences.getInt("BranchId")!=null ? sharedPreferences.getInt("BranchId")!:0,sharedPreferences.getInt("UserID")!,"123456789123456",sharedPreferences.getString("auth_token")!=null ? sharedPreferences.getString("auth_token")! : "").then((value)
            => print("--------------${value.message}--------------"));

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      BlocProvider(
                          create: (context){
                            return MainBloc(webService: WebService());
                          },
                          child:LoginScreen()
                      ),

                ),
                    (Route<dynamic> route) => false);
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text(
            'CONFIRM',
            style: TextStyle(
              fontSize: 14.0,
              color: MyColors.orangeColorCode,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  _masterMenuText(String title,String icon) {
    return  Padding(
      padding: const EdgeInsets.only(left: 35.0,bottom: 12),
      child: Row(
        children: [

          icon=="assets/report.png" ?
          Icon(Icons.insert_drive_file_outlined,color: MyColors.text3greyColorCode,)
              : Image.asset(
            icon,
            height: 24,
            width: 24,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(title, overflow:TextOverflow.ellipsis,maxLines:1,style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
    /*ListTile(
      leading: Image.asset(
        icon,
        height: 24,
        width: 24,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );*/
  }

  _dividerLine() {
    return Container(
      height: 2,
      color: MyColors.driverColorCode,
    );
  }

  _removedata(BuildContext context)async{
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    sharedPreferences.remove("auth_token");
    sharedPreferences.remove("Username");
    sharedPreferences.remove("VendorId");
    sharedPreferences.remove("BranchId");
    sharedPreferences.remove("VendorName");
    sharedPreferences.remove("BranchName");
    sharedPreferences.remove("UserType");
    sharedPreferences.remove("userId");

    sharedPreferences.remove("LastLoginDateTime");
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) =>
    //           BlocProvider(
    //               create: (context){
    //                 return MainBloc(webService: WebService());
    //               },
    //               child:LoginScreen()
    //           ),
    //
    //     ),
    //         (Route<dynamic> route) => false);

    /*Navigator.pushAndRemoveUntil(
         context,
         MaterialPageRoute(
           builder: (context) =>
               BlocProvider(
                 create: (context){
                   return MainBloc(webService: WebService());
                 },
                 child:LoginScreen(),
               ),
         ),
         ModalRoute.withName("/UserHome")
     );*/


  }
}

//
// class MenuDrawer {
//
//
//
//
//
// }







/*
import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/home/home_screen.dart';
import 'package:flutter_vts/screen/master/alert/alert_master_screen.dart';
import 'package:flutter_vts/screen/master/branch_master/branch_master_screen.dart';
import 'package:flutter_vts/screen/master/device_master/device_master_screen.dart';
import 'package:flutter_vts/screen/master/driver_master/driver_master_screen.dart';
import 'package:flutter_vts/screen/master/subscription_master/subscription_master_screen.dart';
import 'package:flutter_vts/screen/master/vehicle_master/vehicle_master_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_master_screen.dart';
import 'package:flutter_vts/screen/profile/profile_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class MenuDrawer{

     getMenuDrawer(BuildContext context){
       return Drawer(
         // backgroundColor: MyColors.appDefaultColorCode,
         child: ListView(
           children: [
             DrawerHeader(
               decoration: BoxDecoration(
                 color: MyColors.blueColorCode,
               ),
               child: Center(
                   child: Row(
                     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Image.asset("assets/profile.png",width: 64,height: 63,),
                       Expanded(
                           child: Padding(
                             padding: const EdgeInsets.only(left: 10.0),
                             child: Column(
                               mainAxisAlignment: MainAxisAlignment.center,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text('Techno',style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
                                 Padding(
                                   padding: const EdgeInsets.only(top:6.0),
                                   child: GestureDetector(
                                     onTap: (){
                                       */
/*Navigator.push(context,
                                           MaterialPageRoute(builder: (_) =>
                                               ProfileScreen()
                                           ));*//*

                                     },
                                       child: Text("View Profile",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.linearGradientGrey2ColorCode),)),
                                 ),

                               ],
                             ),
                           )
                       ),
                       Container(
                         width: 46,
                         height: 46,
                         decoration: BoxDecoration(
                           color:Colors.grey[400],
                           shape: BoxShape.circle,
                         ),
                         child: Icon(Icons.close,size: 17,color: MyColors.whiteColorCode,),
                       ),
                     ],
                   )
               ),
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
                 Navigator.push(context,
                     MaterialPageRoute(builder: (_) =>
                         BlocProvider(
                             create: (context) {
                               return MainBloc(webService: WebService());
                             },
                             child: HomeScreen()
                         )
                     ));
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Dashbord",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Live Tracking",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Vehicle Status",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Travel Summary",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Alerts",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Distance Summary Details",style: TextStyle(fontSize: 20,),),
               ),
             ),
            */
/* Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Notification",style: TextStyle(fontSize: 20),),
               ),
             ),*//*

             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Settings",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Storage Summary",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Vehicle Expiry (Deactive)",style: TextStyle(fontSize: 20),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Travel Details (Dolly)",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             ExpansionTile(
               title: Text("Master",style: TextStyle(fontSize: 20),),
               children: <Widget>[
                 GestureDetector(
                   onTap: (){
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: VendorMasterScreen()
                             )
                         ));
                   },
                   child:_masterMenuText("Vendor Master"),

                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: BranchMasterScreen()
                             )
                         ));
                   },
                   child: _masterMenuText("Branch Master"),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: DeviceMasterScreen()
                             )
                         ));
                   },
                   child:_masterMenuText("Device Master")
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: DriverMasterScreen()
                             )
                         ));
                   },
                   child:   _masterMenuText("Driver Entry Master"),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: VehicleMasterScreen()
                             )
                         ));
                   },
                   child: _masterMenuText("Vehicle Entry Master"),
                 ),
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: SubscriptionMasterScreen()
                             )
                         ));
                   },
                   child: _masterMenuText("Subscription Settings"),
                 ),
                 // _masterMenuText("Command Master"),
                 GestureDetector(
                   onTap: (){
                     Navigator.pop(context);
                     Navigator.push(context,
                         MaterialPageRoute(builder: (_) =>
                             BlocProvider(
                                 create: (context) {
                                   return MainBloc(webService: WebService());
                                 },
                                 child: AlertMasterScreen()
                             )
                         ));
                   },
                   child:_masterMenuText("Alert Master"),

                 )
               ],
             ),
             _dividerLine(),
             ExpansionTile(
               title: Text("Transaction",style: TextStyle(fontSize: 20),),
               children: <Widget>[
                 _masterMenuText("VTS Live"),
                 _masterMenuText("VTS History"),
                 _masterMenuText("VTS Master"),
                 _masterMenuText("VTS Get Direction"),
                 _masterMenuText("VTS Get Multiple Routes"),
                 _masterMenuText("VTS Route Define"),
                 _masterMenuText("Street View Side By Side"),
                 _masterMenuText("OTA Command Setting"),
                 _masterMenuText("Geofence Create"),
                 _masterMenuText("Point Of Interest Create"),
               ],
             ),
             _dividerLine(),
             ExpansionTile(
               title: Text("Utility",style: TextStyle(fontSize: 20),),
               children: <Widget>[
                 _masterMenuText("Create USer"),
                 _masterMenuText("Change Password"),
                 _masterMenuText("Reset Password"),
                 _masterMenuText("Menu Rights"),

               ],
             ),
             _dividerLine(),
             ExpansionTile(
               title: Text("Report",style: TextStyle(fontSize: 20),),
               children: <Widget>[
                 _masterMenuText("Device Master Report"),
                 _masterMenuText("Driver Report"),
                 _masterMenuText("Vehicle Report"),
                 _masterMenuText("Driver Wise Vehicle Assign"),
                 _masterMenuText("Vehicle Wise Over Speed Report"),
                 _masterMenuText("Data Wise Travel History Report"),
                 _masterMenuText("Time Wise Distance Travel Report"),
                 _masterMenuText("Vehicle Distance Travel Report"),
                 _masterMenuText("Vehicle Time Wise Distance Report"),
                 _masterMenuText("Frame Packet Report"),
                 _masterMenuText("Frame Packet Grid View Report"),
                 _masterMenuText("Data Packet Grid View Report"),
                 _masterMenuText("Login Audio History Report"),
                 _masterMenuText("Vehicle Status Report"),
                 _masterMenuText("Vehicle Status GRoup By Report"),
                 _masterMenuText("Vehicle Status Summary Report"),
               ],
             ),
             _dividerLine(),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Help",style: TextStyle(fontSize: 20),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),
             GestureDetector(
               onTap: (){
                 Navigator.of(context).pop();
               },
               child: Padding(
                 padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
                 child: Text("Logout",style: TextStyle(fontSize: 20,),),
               ),
             ),
             Container(
               height: 2,
               color: MyColors.driverColorCode,
             ),

           ],
         ),
       );
     }


     _masterMenuText(String title){
       return Column(
         children: [
           Padding(
             padding: const EdgeInsets.only(top: 10.0,bottom: 10),
             child: Row(
               children: [
                 Padding(
                   padding: const EdgeInsets.only(left: 10.0,right: 8),
                   child: Icon(Icons.account_circle_outlined),
                 ),
                 Expanded(
                     child: Text(title,maxLines: 1,overflow:TextOverflow.ellipsis,style: TextStyle(fontSize: 20),)
                 ),
               ],
             ),
           ),
           _dividerLine()
         ],
       );
     }

     _dividerLine(){
       return Container(
         height: 2,
         color: MyColors.driverColorCode,
       );
     }

}*/
