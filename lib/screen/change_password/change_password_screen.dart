

import 'dart:convert';

import 'package:flutter/material.dart' hide Key;
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert/vehicle_fill_srno_response.dart';
import 'package:flutter_vts/model/dashbord/dashboard_response.dart';
import 'package:flutter_vts/model/login/forget_password_request.dart';
import 'package:flutter_vts/model/user/create_user/assign_menu_list_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/screen/comman_screen/multi_select_vehicle_screen.dart';
import 'package:flutter_vts/screen/login/login_screen.dart';
import 'package:flutter_vts/screen/master/alert/add_alert_master_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';
import 'package:encrypt/encrypt.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:jiffy/jiffy.dart';



import 'package:flutter/material.dart';
import 'package:flutter_vts/model/alert_notification/fill_alert_notification_vehicle_response.dart';
import 'package:flutter_vts/model/alert_notification/filter_notification_alert_type_response.dart';
import 'package:flutter_vts/model/filter/Vendor_response.dart';
import 'package:flutter_vts/model/filter/branch_response.dart';
import '../../model/alert_notification/filter_alert_notification_response.dart';


class ChangePasswordScreen extends StatefulWidget {
  // String userid ;
  // ChangePasswordScreen({required this.userid});
  // const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late SharedPreferences sharedPreferences;
  late String token;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  TextEditingController emailidcontroller=new TextEditingController();
  late int branchid = 0, vendorid = 0,userId=0;
  int pageNumber=1;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  TextEditingController _confirmpasswordcontroller = new TextEditingController();
  TextEditingController _newpasswordcontroller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainBloc = BlocProvider.of(context);
    getdata();
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

    if (sharedPreferences.getInt("UserID") != null) {
      userId = sharedPreferences.getInt("UserID")!;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CHANGE PASSWORD"),
      ),
      body: _changePassword(),
    );
  }



  _changePassword(){
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context,state){
          if (state is ForgetPasswordLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else   if (state is ForgetPasswordLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if (state.editDeviceResponse.succeeded != null) {
              if (state.editDeviceResponse.succeeded!) {
                Fluttertoast.showToast(
                  msg: state.editDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
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
                // CustomDialog()
                //     .popUp(context, state.checkForgetPasswordUserResponse.message!);
              } else {
                Fluttertoast.showToast(
                  msg:state.editDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }
          }else   if (state is ForgetPasswordErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              msg:"Something Went Wrong,Please try again",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          }
        },
        child: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:6.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("New Password",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  enabled: true, // to trigger disabledBorder
                  controller: _newpasswordcontroller,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: true,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:6.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("Confirm Password",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),

                TextField(
                  controller: _confirmpasswordcontroller,
                  enabled: true, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 148,
                        height: 48,
                        padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: MyColors.dateIconColorCode)
                        ),
                        child: Text("Close",style: TextStyle(color: MyColors.text4ColorCode,fontSize: 20)),
                      ),

                      GestureDetector(
                        onTap:(){
                          // _validation();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 148,
                          height: 48,
                          margin: const EdgeInsets.only(left: 15),
                          padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                          decoration: BoxDecoration(
                              color: MyColors.blueColorCode,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              border: Border.all(color: MyColors.textBoxBorderColorCode)
                          ),
                          child: Text("Save",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
                        ),
                      )

                    ],
                  ),
                ),
              ],
            ),
          ) ,
        ),
      ),
    );
  }

  _validation(){
    if(_newpasswordcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The User new password...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_confirmpasswordcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The User Confirm Password...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_newpasswordcontroller.text!=_confirmpasswordcontroller.text){
      Fluttertoast.showToast(
        msg:"New Password and Confirm Password should same...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else{
      // Fluttertoast.showToast(
      //   msg:"success",
      //   toastLength: Toast.LENGTH_SHORT,
      //   timeInSecForIosWeb: 1,
      // );
      _encrypt();

    }
  }


  _encrypt(){
    // final plainText = /*'Techno@123'*/_newpasswordcontroller.text;
    //
    // final key = Key.fromLength(16);
    // final iv = IV.fromLength(8);
    // final encrypter = Encrypter(AES(key));
    //
    // final newpasswordencrypted = encrypter.encrypt(plainText, iv: iv);
    // print(newpasswordencrypted.base64);
    // final newpassworddecrypted = encrypter.decrypt(newpasswordencrypted, iv: iv);
    // print(newpassworddecrypted);
    //
    // final confirmpasswordencrypted = encrypter.encrypt(_confirmpasswordcontroller.text, iv: iv);
    // print(confirmpasswordencrypted.base64);
    // final confirmpassworddecrypted = encrypter.decrypt(confirmpasswordencrypted, iv: iv);
    //
    // if(newpasswordencrypted!=null){
    //   // _mainBloc.add(LoginEvents(
    //   //     username: usernameController.text,
    //   //     password: encrypted.base64));
    //   _mainBloc.add(ForgetPasswordEvents(
    //       token: token,
    //       forgetPasswordRequest: ForgetPasswordRequest(
    //         userId:16/*int.parse(widget.userid)*/,
    //         vendorSrNo: vendorid,
    //         branchSrNo: branchid,
    //         newPassword: newpasswordencrypted.base64,
    //         confirmPassword: confirmpasswordencrypted.base64,
    //       )));
    //
    // }

    /*final encrypted1 = encrypter.encrypt("KJO4M39YLFf7WFiGo2z8cA==", iv: iv);

    final decrypted1 = encrypter.decrypt(encrypted1, iv: iv);
    print(decrypted1);*/
  }
}

//----------------------------------Assign menu rights------------------------------------




//---------------------------Setting ---------------------

/*
class SettingsScreen extends StatefulWidget {
  // const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<bool> isSelected=[];
  bool isSwitched = false;
  bool livetracking = false;
  bool vehiclestatus = false;
  bool trafficlayaer = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isSelected = [true, false];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColorCode,
      key: _scaffoldKey,
      drawer: MenuDrawer().getMenuDrawer(context),
      // endDrawer: MenuDrawer().getMenuDrawer(context) ,
      appBar: CustomAppBar().getCustomAppBar("SETTINGS",_scaffoldKey),
      body: _settingscreen(),
    );

  }


  _settingscreen(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _settingfield("Start Up Screen",1),
            _settingfield("Alerts",2),
            _settingfield("Map Settings",3),
            _settingfield("Support/Help",4),
          ],
        ),
      ),
    );
  }

  _settingfield(String title,int flag){
    return GestureDetector(
      onTap: (){
        if(flag==1){
          changestartupscreenpopUp(context);
        }else if(flag==2){
          changeAlertpopUp(context);
        }else if(flag==3){
          changeMapSettingpopUp(context);
        }else if(flag==4){
          // changeAlertpopUp(context);
        }
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
      },
      child: Card(
        margin: EdgeInsets.only(top:15),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
            padding: EdgeInsets.only(top:15,left:14,right:14,bottom: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,style: TextStyle(fontSize: 16),),
                Icon(Icons.arrow_forward_ios_sharp,color: MyColors.textColorCode,),
              ],
            )
        ),
      ),
    );
  }


  changestartupscreenpopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                      child: Text(
                        "Start Up Screen",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Dashboard")
                        ),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                              print(isSwitched);
                            });
                          },
                          activeTrackColor: MyColors.skyblueColorCode,
                          activeColor: MyColors.blueColorCode,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Live Tracking")
                        ),
                        Switch(
                          value: livetracking,
                          onChanged: (value) {
                            setState(() {
                              livetracking = value;
                              print(livetracking);
                            });
                          },
                          activeTrackColor: MyColors.skyblueColorCode,
                          activeColor: MyColors.blueColorCode,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Text("Vehicle Status")
                        ),
                        Switch(
                          value: vehiclestatus,
                          onChanged: (value) {
                            setState(() {
                              vehiclestatus = value;
                              print(vehiclestatus);
                            });
                          },
                          activeTrackColor: MyColors.skyblueColorCode,
                          activeColor: MyColors.blueColorCode,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);

                      },
                      child: Container(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 10,right: 10),
                            alignment: Alignment.bottomRight,
                             child: Text("Close",textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                      ),
                    )

                  ],
                ),
              );
            }));
      },
    );
  }



  changeAlertpopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text("Notification")
                            ),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  print(isSwitched);
                                });
                              },
                              activeTrackColor: MyColors.skyblueColorCode,
                              activeColor: MyColors.blueColorCode,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text("Vibrate")
                            ),
                            Switch(
                              value: livetracking,
                              onChanged: (value) {
                                setState(() {
                                  livetracking = value;
                                  print(livetracking);
                                });
                              },
                              activeTrackColor: MyColors.skyblueColorCode,
                              activeColor: MyColors.blueColorCode,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text("Sound")
                            ),
                            Switch(
                              value: vehiclestatus,
                              onChanged: (value) {
                                setState(() {
                                  vehiclestatus = value;
                                  print(vehiclestatus);
                                });
                              },
                              activeTrackColor: MyColors.skyblueColorCode,
                              activeColor: MyColors.blueColorCode,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: (){

                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 10,right: 10),
                            alignment: Alignment.bottomRight,
                            child: Text("Close",textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                          ),
                        )

                      ],
                    ),
                  );
                }));
      },
    );
  }



  changeMapSettingpopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    height: MediaQuery.of(context).size.height / 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                          child: Text(
                            "Map Settings",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Text("Traffic Layer")
                            ),
                            Checkbox(
                                value: trafficlayaer,
                                onChanged: (checkvalue){
                                  setState(() {
                                    trafficlayaer=checkvalue!;
                                    print(checkvalue);
                                  });
                                }
                            ),

                          ],
                        ),

                        GestureDetector(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 6.0, bottom: 10,right: 10),
                            alignment: Alignment.bottomRight,
                            child: Text("Close",textAlign: TextAlign.right,style: TextStyle(fontSize: 18),),
                          ),
                        )

                      ],
                    ),
                  );
                }));
      },
    );
  }

}
*/


// ------------------------------------------------------

// ----------------------------Vehicle Analytics Reports Status----------------------

/*class VehicleAnalyticsReportsStatusScreen extends StatefulWidget {
  late String analyticTiltle;
  late Color colorCode;
  late String truckImage;

  VehicleAnalyticsReportsStatusScreen({required this.analyticTiltle,required this.colorCode,required this.truckImage});

  @override
  _VehicleAnalyticsReportsStatusScreenState createState() => _VehicleAnalyticsReportsStatusScreenState();
}

class _VehicleAnalyticsReportsStatusScreenState extends State<VehicleAnalyticsReportsStatusScreen> {

  ScrollController notificationController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> items = ["aaa", "bb", "cc", "dd", "ee"];

  bool isSelected = false;
  String radiolist = "radio";
  late int value = 0;
  late bool _isLoading = false;
  late MainBloc mainBloc;
  late String userName="";

  late String vendorName="",branchName="",userType="",lastlogin="";
  late SharedPreferences sharedPreferences;
  late String token="", vendorname;
  late int branchid=0,vendorid=0;
  List<AnalytivReportDatum>? data=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = BlocProvider.of(context);
    getData();

  }


  getanalyticreport() async {
    mainBloc.add(AnalyticsReportsStatusEvents(token:token,vendorId: vendorid,branchId: branchid,openClick:"DIVTOTAL_COUNT"*//*"RUNNING_COUNT"*//*,araiNoarai: 'nonarai', username: userName,vehicleRegNo: "MH10AS2015"));
  }


  getData()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
      print("token ${token}");

    }
    if(sharedPreferences.getInt("VendorId")!=null){
      vendorid=sharedPreferences.getInt("VendorId")!;
    }
    if(sharedPreferences.getInt("BranchId")!=null){
      branchid=sharedPreferences.getInt("BranchId")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    if(sharedPreferences.getString("VendorName")!=null){
      vendorName=sharedPreferences.getString("VendorName")!;
    }
    if(sharedPreferences.getString("BranchName")!=null){
      branchName=sharedPreferences.getString("BranchName")!;
    }
    if(sharedPreferences.getString("UserType")!=null){
      userType=sharedPreferences.getString("UserType")!;
    }
    if(sharedPreferences.getString("LastLoginDateTime")!=null){
      lastlogin=sharedPreferences.getString("LastLoginDateTime")!;
    }

    if(token!="" || vendorid!=0 || branchid!=0 ||vendorName!="" || branchName!=""){
      getanalyticreport();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer().getMenuDrawer(context),
      appBar:
      CustomAppBar().getCustomAppBar(widget.analyticTiltle, _scaffoldKey),
      body: _vehicleStatus(),
    );
  }

  _vehicleStatus() {
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context,state){
          if (state is AnalyticsReportsStatusLoadingState) {
            setState(() {
              _isLoading = true;
            });

          }else if (state is AnalyticsReportsStatusLoadedState) {
            setState(() {
              _isLoading = false;
              data=state.analyticReportStatusClickResponse.data!;
            });
         *//*   Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Success",
            );*//*
          }else if (state is AnalyticsReportsStatusErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Error",
            );
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Container(
              //   padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              //   decoration: BoxDecoration(
              //       color: MyColors.lightgreyColorCode,
              //       boxShadow: [
              //         BoxShadow(blurRadius: 10, color: MyColors.shadowGreyColorCode)
              //       ]),
              //   // width: MediaQuery.of(context).size.width,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Column(
              //         children: [
              //           Text("22-02-2022"),
              //           Text("3:19:54 PM"),
              //         ],
              //       ),
              //       Text("-"),
              //       Column(
              //         children: [
              //           Text("26-02-2022"),
              //           Text("3:19:54 PM"),
              //         ],
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           changeDatepopUp(context);
              //         },
              //         child: Container(
              //           padding: EdgeInsets.only(
              //               left: 20, right: 20, top: 10, bottom: 10),
              //           decoration: BoxDecoration(
              //               color: MyColors.greyColorCode,
              //               borderRadius: BorderRadius.all(Radius.circular(20))),
              //           child: Text(
              //             "Change",
              //             style: TextStyle(
              //                 color: MyColors.text4ColorCode, fontSize: 18),
              //           ),
              //         ),
              //       )
              //
              //       // Text("10 NOTIFICATIONS",style: TextStyle(fontSize: 18),),
              //       // Text("CLEAR ALL",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
              //     ],
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 15, right: 15, bottom: 10),
                child: Column(
                  children: [
                    TextField(
                      enabled: true, // to trigger disabledBorder
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.whiteColorCode,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                          BorderSide(width: 1, color: MyColors.buttonColorCode),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(width: 1, color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                          BorderSide(width: 1, color: MyColors.textColorCode),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1, color: MyColors.textBoxBorderColorCode)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 2, color: MyColors.buttonColorCode)),
                        hintText: "Search Record",
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 18, color: MyColors.searchTextColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      // onChanged: _authenticationFormBloc.onPasswordChanged,
                      obscureText: false,
                    ),
                    data!.length==0 ? Container() : ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1, color: MyColors.textBoxBorderColorCode),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 10, left: 14, right: 14, bottom: 10),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color:MyColors.whiteColorCode,
                                          border: Border.all(color: MyColors.boxBackgroundColorCode),
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child:  Image.asset(
                                          widget.truckImage,
                                          width: 50,
                                          height: 50,
                                        ) ,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(data![index].vehicleNo!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                              Row(
                                                children: [
                                                  Icon(Icons.circle,color: widget.colorCode,size: 12,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0,top: 6,bottom: 6),
                                                    child: Text(data![index].status!,style: TextStyle(color: widget.colorCode,fontSize: 18),),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  data![index].date!=null ? Expanded(
                                                    flex:3,
                                                    child:Container(
                                                      padding: const EdgeInsets.only(left: 4.0,right: 4,top: 4,bottom: 4),

                                                      decoration: BoxDecoration(
                                                        color:MyColors.textBoxColorCode,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child:Text(data![index].date!=null ? data![index].date : "") ,
                                                    ) ,
                                                  ):Container(),
                                                  data![index].speedLimit!=null ? Expanded(
                                                    flex:2,
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(7.0),
                                                      padding: const EdgeInsets.only(left: 4.0,right: 2,top: 2,bottom: 2),
                                                      decoration: BoxDecoration(
                                                        color:MyColors.lightblueColorCode,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child:Text("Speed : ${data![index].speedLimit} km/h",style: TextStyle(color: MyColors.linearGradient2ColorCode),) ,
                                                    ),
                                                  ):Container(),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:6.0,bottom: 6),
                                                child: Text(data![index].driverName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                              ),
                                              // Text("State Bank of India-Ram Nagar",),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:8.0),
                                    child: Divider(
                                      height:5,
                                      color: MyColors.text4ColorCode,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:10.0,right:10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children:[
                                              Container(
                                                margin: EdgeInsets.only(bottom: 4),
                                                width:39,
                                                height:38,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: MyColors.boxBackgroundColorCode),
                                                    color:  MyColors.whiteColorCode
                                                ),
                                                child: Icon(
                                                  Icons.power_settings_new,
                                                  size: 20,
                                                  color: data![index].ignition=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode,
                                                ),
                                              ),
                                              Text("IGN",style: TextStyle(color: data![index].ignition=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode))
                                            ]
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(bottom: 4),
                                                width:39,
                                                height:38,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: MyColors.boxBackgroundColorCode),
                                                    color:  MyColors.whiteColorCode
                                                ),
                                                child: Icon(
                                                  Icons.battery_charging_full_outlined,
                                                  size: 20,
                                                  color:data![index].mainPowerStatus=="0" ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode,
                                                ),
                                              ),
                                              Text("PWR",style: TextStyle(color:data![index].mainPowerStatus=="0" ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode))

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(bottom: 4),
                                                width:39,
                                                height:38,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: MyColors.boxBackgroundColorCode),
                                                    color:  MyColors.whiteColorCode
                                                ),
                                                child: Icon(
                                                  Icons.ac_unit,
                                                  size: 20,
                                                  color:data![index].ac=="OFF" ? MyColors.text4ColorCode : MyColors.boxBackgroundColorCode,
                                                ),
                                              ),
                                              Text("AC",style: TextStyle(color:data![index].ac=="OFF" ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode))

                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(bottom: 4),
                                                width:39,
                                                height:38,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: MyColors.boxBackgroundColorCode),
                                                    color:  MyColors.whiteColorCode
                                                ),
                                                child: Icon(
                                                  Icons.outdoor_grill,
                                                  size: 20,
                                                  color: data![index].door=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode,
                                                ),
                                              ),
                                              Text("DOOR",style: TextStyle(color: data![index].door=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode))
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(bottom: 4),
                                                width:39,
                                                height:38,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(color: MyColors.boxBackgroundColorCode),
                                                    color:  MyColors.whiteColorCode
                                                ),
                                                child: Icon(
                                                  Icons.wifi,
                                                  size: 20,
                                                  color:data![index].gpsFix==0 ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode,
                                                ),
                                              ),
                                              Text("GPS",style: TextStyle(color:data![index].gpsFix==0 ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode))
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  changeDatepopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 310,
              width: MediaQuery.of(context).size.width - 20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                      child: Text(
                        "From Date/Time",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            enabled: true, // to trigger disabledBorder
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyColors.whiteColorCode,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.buttonColorCode),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.textColorCode),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.textBoxBorderColorCode)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: MyColors.buttonColorCode)),
                              hintText: "DD/MM/YY",
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                size: 24,
                                color: MyColors.dateIconColorCode,
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.searchTextColorCode),
                              errorText: "",
                            ),
                            // controller: _passwordController,
                            // onChanged: _authenticationFormBloc.onPasswordChanged,
                            obscureText: false,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              enabled: true, // to trigger disabledBorder
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: MyColors.whiteColorCode,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.buttonColorCode),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: MyColors.textColorCode),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                        MyColors.textBoxBorderColorCode)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: MyColors.buttonColorCode)),
                                hintText: "hh:mm:AM",
                                suffixIcon: Icon(
                                  Icons.watch_later_outlined,
                                  size: 24,
                                  color: MyColors.dateIconColorCode,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.searchTextColorCode),
                                errorText: "",
                              ),
                              // controller: _passwordController,
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                      child: Text(
                        "To Date/Time",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            enabled: true, // to trigger disabledBorder
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyColors.whiteColorCode,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.buttonColorCode),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.textColorCode),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.textBoxBorderColorCode)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: MyColors.buttonColorCode)),
                              hintText: "DD/MM/YY",
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                size: 24,
                                color: MyColors.dateIconColorCode,
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.searchTextColorCode),
                              errorText: "",
                            ),
                            // controller: _passwordController,
                            // onChanged: _authenticationFormBloc.onPasswordChanged,
                            obscureText: false,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              enabled: true, // to trigger disabledBorder
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: MyColors.whiteColorCode,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.buttonColorCode),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: MyColors.textColorCode),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                        MyColors.textBoxBorderColorCode)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: MyColors.buttonColorCode)),
                                hintText: "hh:mm:AM",
                                suffixIcon: Icon(
                                  Icons.watch_later_outlined,
                                  size: 24,
                                  color: MyColors.dateIconColorCode,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.searchTextColorCode),
                                errorText: "",
                              ),
                              // controller: _passwordController,
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phonelink_erase_rounded,
                                color: MyColors.text4ColorCode,
                              ),
                              Text("Clear",
                                  style: TextStyle(
                                      color: MyColors.text4ColorCode,
                                      decoration: TextDecoration.underline,
                                      fontSize: 20)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.close,
                                color: MyColors.text4ColorCode,
                              ),
                              Text("Close",
                                  style: TextStyle(
                                      color: MyColors.text4ColorCode,
                                      decoration: TextDecoration.underline,
                                      fontSize: 20)),
                            ],
                          ),
                        ),
                        // IconButton(
                        //     onPressed: (){
                        //
                        //     },
                        //     icon: Icon(Icons.)),
                        Expanded(
                          flex: 2,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 8, bottom: 8),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.whiteColorCode),
                              ),
                            ),
                            color: MyColors.buttonColorCode,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

}*/
//-----------------------------------------------------------------

// ---------------------------Overspeed report--------------------------------------------



//--------------------------------------------------------------------------------

/*class LiveTrackingFilterScreen extends StatefulWidget {
  // const LiveTrackingFilterScreen({Key? key}) : super(key: key);

  @override
  _LiveTrackingFilterScreenState createState() => _LiveTrackingFilterScreenState();
}

class _LiveTrackingFilterScreenState extends State<LiveTrackingFilterScreen> {
  late String userName="";
  late bool isSearch = false;
  bool activeStatus = false;

  TextEditingController searchController=new TextEditingController();
  ScrollController vehicleStatusController=new ScrollController();
  ScrollController vehicleController=new ScrollController();

  late String vendorName="",branchName="",userType="";
  late SharedPreferences sharedPreferences;
  late String token="";
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late int branchid=0,vendorid=0;
  late int selectedVendorid=0,selectedbranchid=0;
  // List<VendorDatum> vendorList=[];
  // List<BranchDatum> branchList=[];
  ScrollController vendorController=new ScrollController();
  ScrollController branchController=new ScrollController();
  List<int> selectedvehicleSrNolist=[];
  List<String> selectedVehicleStatusList=[];
  List<VehicleStatusResponse> vehicleStatuslisst=[];
  List<bool> _isChecked=[];


  List<String> vehicleStatusList=[];
  // List<VehicleHistoryFilterDatum>? data=[];
  // List<VehicleDatum>  vehicleSrNolist=[];
  List<bool> _isvehicleChecked=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);
    getdata();
  }


  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
      print("token ${token}");

    }
    if(sharedPreferences.getInt("VendorId")!=null){
      vendorid=sharedPreferences.getInt("VendorId")!;
    }
    if(sharedPreferences.getInt("BranchId")!=null){
      branchid=sharedPreferences.getInt("BranchId")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    if(sharedPreferences.getString("VendorName")!=null){
      vendorName=sharedPreferences.getString("VendorName")!;

    }
    if(sharedPreferences.getString("BranchName")!=null){
      branchName=sharedPreferences.getString("BranchName")!;
    }
    if(sharedPreferences.getString("UserType")!=null){
      userType=sharedPreferences.getString("UserType")!;
    }



    print("branchid ${branchid}   Vendor id   ${vendorid}");

    print(""+vendorid.toString()+" "+branchid.toString()+" "+userName+" "+vendorName+" "+branchName+" "+userType);


    if(token!="" || vendorid!=0 || branchid!=0 ||vendorName!="" || branchName!=""){
      // getCompanylist();
      // getVehicleStatus();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.textColorCode,
        centerTitle: true,
        title: Text("Filter".toUpperCase()),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context,{"FilterAlert":false});

                // Navigator.pop(context);
              },
              icon: const Icon(
                // controller.page == 2
                //?
                Icons.close,
                //  : Icons.help_outline,
                size: 24,
                color: MyColors.whiteColorCode,
              )),
          const SizedBox(
            width: 8.0,
          ),

        ],
      ),
      body: _liveTrackingFilter(),

    );
  }

  _liveTrackingFilter(){
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: MyColors.appDefaultColorCode,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener:  (context,state){

        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: const Text("Filter",style: TextStyle(color: MyColors.blackColorCode,fontSize: 18),),
                            onPressed: () {},
                          ),
                          TextButton(
                            child: const Text("Clear",style: TextStyle(fontSize: 18)),
                            onPressed: () {
                              setState(() {
                                // searchController.text="";
                                // selectedVendorid=0;
                                // selectedbranchid=0;
                                // activeStatus=false;
                                // branchList.clear();
                                // vehicleSrNolist.clear();
                                // selectedVehicleStatusList.clear();
                                // _isChecked = List<bool>.filled(vehicleStatuslisst.length, false);
                                // selectedvehicleSrNolist.clear();
                                // _isvehicleChecked = List<bool>.filled(vehicleSrNolist.length, false);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                        height: 36,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: Colors.blue),
                        child: TextButton(
                            child: const Text("Apply",
                                style: TextStyle(color: Colors.white,fontSize: 18)),
                            onPressed: () {
                              // applyFilter();

                            })
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}*/

//-----------------------------------------------------