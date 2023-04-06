

import 'dart:convert';

import 'package:flutter/material.dart' hide Key;
import 'package:flutter/rendering.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/analytic_report/analytic_report_by_id_detail_response.dart';
import 'package:flutter_vts/model/analytic_report/analytic_report_click_response.dart';
import 'package:flutter_vts/model/analytic_report/search_analytic_report_status_click_response.dart';
import 'package:flutter_vts/model/login/forget_password_request.dart';
import 'package:flutter_vts/model/user/create_user/assign_menu_list_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/screen/comman_screen/multi_select_vehicle_screen.dart';
import 'package:flutter_vts/screen/login/login_screen.dart';
import 'package:flutter_vts/screen/master/alert/add_alert_master_screen.dart';
import 'package:flutter_vts/screen/notification/filter_alert_notification_screen.dart';
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
import 'package:flutter_vts/model/analytic_report/analytic_report_click_response.dart';

class VehicleAnalyticsReportsStatusScreen extends StatefulWidget {
  late String analyticTiltle;
  late Color colorCode;
  late String truckImage;

  VehicleAnalyticsReportsStatusScreen({required this.analyticTiltle,required this.colorCode,required this.truckImage});

  @override
  _VehicleAnalyticsReportsStatusScreenState createState() => _VehicleAnalyticsReportsStatusScreenState();
}

class _VehicleAnalyticsReportsStatusScreenState extends State<VehicleAnalyticsReportsStatusScreen> {
  ScrollController analyticreportScrollController=new ScrollController();
  TextEditingController searchController=new TextEditingController();

  ScrollController notificationController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> items = ["aaa", "bb", "cc", "dd", "ee"];

  bool isSelected = false;
  String radiolist = "radio";
  late int value = 0;
  late bool _isLoading = false;
  late MainBloc mainBloc;
  late String userName="";
  late int pageNumber=1;
  late String vendorName="",branchName="",userType="",lastlogin="";
  late SharedPreferences sharedPreferences;
  late String token="", vendorname;
  late int branchid=0,vendorid=0;
  List<Datum>? data=[];
  List<AnalytivReportDatum>? searchData=[];
  late bool isSearch=false;
  late int totalAnalyticsRecords=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = BlocProvider.of(context);
    getData();


    analyticreportScrollController.addListener(() {
      if(analyticreportScrollController.position.maxScrollExtent==analyticreportScrollController.offset){
        setState(() {
          print("Scroll ${pageNumber}");
          getanalyticreport();
        });
      }
    });

  }


  getanalyticreport() async {
    mainBloc.add(AnalyticsReportsStatusEvents(token:token,vendorId: vendorid,branchId: branchid,openClick:/*widget.analyticTiltle=="TOTAL" ? "DIVTOTAL_COUNT" : */widget.analyticTiltle/*"RUNNING_COUNT"*/,araiNoarai: 'nonarai', username: userName,pageNumber:pageNumber,pageSize: 10));
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
      // drawer: MenuDrawer().getMenuDrawer(context),
      // appBar:AppBar(
      //   backgroundColor: MyColors.textColorCode,
      //   title: Text(widget.analyticTiltle),
      //   actions: [
      //     GestureDetector(
      //       onTap: (){
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: (_) =>
      //                     BlocProvider(
      //                         create: (context) {
      //                           return MainBloc(
      //                               webService: WebService());
      //                         },
      //                         child: FilterAlertNotificationScreen())
      //             )
      //         );
      //       },
      //       child: Container(
      //         margin: EdgeInsets.only(right: 10),
      //         /*width: 30,
      //         height: 30,
      //         decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           color: MyColors.filterbackgroundColorCode
      //         ),*/
      //         child:Image.asset("assets/filter.png",height: 40,width: 40,) ,
      //       ),
      //     )
      //   ],
      // ),

      appBar:CustomAppBar().getCustomAppBar(widget.analyticTiltle, _scaffoldKey,0,context),
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
              pageNumber++;
              totalAnalyticsRecords=state.analyticReportStatusClickResponse.gridViewResponse!.totalRecords!;
              if(state.analyticReportStatusClickResponse.gridViewResponse!.data!.length!=0){
                  // data=state.analyticReportStatusClickResponse.gridViewResponse!.data!;
                  data!.addAll(state.analyticReportStatusClickResponse.gridViewResponse!.data!);

              }else{

              }

            });

          }else if (state is AnalyticsReportsStatusErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something Went Wrong,please try again",
            );
          }else if (state is SearchAnalyticsReportsStatusLoadingState) {
            setState(() {
              _isLoading = true;
            });

          }else if (state is SearchAnalyticsReportsStatusLoadedState) {
            setState(() {
              searchData!.clear();
              _isLoading = false;
              if(state.searchAnalyticReportStatusClickResponse.data!=null){
                searchData!.addAll(state.searchAnalyticReportStatusClickResponse.data!);
              }
            });

          }else if (state is SearchAnalyticsReportsStatusErrorState) {
            setState(() {
              _isLoading = false;
            });
           /* Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Error",
            );*/
          }else if (state is AnalyticsReportsDetailsLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AnalyticsReportsDetailsLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if(state.analyticReportDetailsResponse.succeeded!){
              analyticReportDetail(context,state.analyticReportDetailsResponse.data!);
            }else{
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.analyticReportDetailsResponse.message!,
              );
            }
          }else if (state is AnalyticsReportsDetailsErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          controller: analyticreportScrollController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: searchController,
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
                        hintText: "Enter Vehicle Number",
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
                      onChanged: (value){
                        if(searchController.text.isEmpty){
                          setState(() {
                            isSearch=false;
                          });
                        }else{
                          setState(() {
                            isSearch=true;
                          });
                          mainBloc.add(SearchAnalyticsReportsStatusEvents(token: token,vendorId: 1,branchId :1,openClick: widget.analyticTiltle,araiNoarai:"nonarai",username:userName,vehicleNo:searchController.text));
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(!isSearch ? data!.length!=0 ?  "Showing 1 to ${data!.length} Out of ${totalAnalyticsRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalAnalyticsRecords}" :"0 RECORDS",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                    ),
                    !isSearch ? data!.length==0 ? Container() : ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              print("click");
                              mainBloc.add(AnalyticsReportsDetailsEvents(token:token,vendorId: vendorid,branchId: branchid,openClick: /*"total"*/widget.analyticTiltle,araiNoarai: 'nonarai', username: userName,vehiclesrno:int.parse(data![index].vehicleSrNo!) ));
                            },
                            child: Card(
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
                                                        child:Row(
                                                          children: [
                                                            Text(data![index].date!=null ? data![index].date! : ""),
                                                            Text("|"),
                                                            Text(data![index].time!=null ? data![index].time! : ""),

                                                          ],
                                                        ) ,
                                                      ) ,
                                                    ):Container(),
                                                    data![index].speedLimit!=null ? Expanded(
                                                      flex:2,
                                                      child: Container(
                                                        // padding: const EdgeInsets.all(7.0),
                                                        padding: const EdgeInsets.only(left: 4.0,right: 2,top: 4,bottom: 4),
                                                        decoration: BoxDecoration(
                                                          color:MyColors.lightblueColorCode,
                                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                                        ),
                                                        child:Text("Speed :${data![index].speedLimit}km/h",style: TextStyle(color: MyColors.linearGradient2ColorCode,fontSize: 13 ),) ,
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
                            ),
                          );
                        }):ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: searchData!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              mainBloc.add(AnalyticsReportsDetailsEvents(token:token,vendorId: vendorid,branchId: branchid,openClick: /*"total"*/widget.analyticTiltle,araiNoarai: 'nonarai', username: userName,vehiclesrno:int.parse(searchData![index].vehicleSrNo! )));
                            },
                            child: Card(
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
                                                  Text(searchData![index].vehicleNo!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.circle,color: widget.colorCode,size: 12,),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 4.0,top: 6,bottom: 6),
                                                        child: Text(searchData![index].status!,style: TextStyle(color: widget.colorCode,fontSize: 18),),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      searchData![index].date!=null ? Expanded(
                                                        flex:3,
                                                        child:Container(
                                                          padding: const EdgeInsets.only(left: 4.0,right: 4,top: 4,bottom: 4),

                                                          decoration: BoxDecoration(
                                                            color:MyColors.textBoxColorCode,
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          ),
                                                          child:Row(
                                                            children: [
                                                              Text(searchData![index].date!=null ? searchData![index].date! : ""),
                                                              Text("|"),
                                                              Text(searchData![index].time!=null ? searchData![index].time! : ""),

                                                            ],
                                                          ) ,
                                                        ) ,
                                                      ):Container(),
                                                      data![index].speedLimit!=null ? Expanded(
                                                        flex:2,
                                                        child: Container(
                                                          // padding: const EdgeInsets.all(7.0),
                                                          padding: const EdgeInsets.only(left: 4.0,right: 2,top: 4,bottom: 4),
                                                          decoration: BoxDecoration(
                                                            color:MyColors.lightblueColorCode,
                                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                                          ),
                                                          child:Text("Speed :${searchData![index].speedLimit}km/h",style: TextStyle(color: MyColors.linearGradient2ColorCode,fontSize: 13 ),) ,
                                                        ),
                                                      ):Container(),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top:6.0,bottom: 6),
                                                    child: Text(searchData![index].driverName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
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
                                                        color: searchData![index].ignition=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode,
                                                      ),
                                                    ),
                                                    Text("IGN",style: TextStyle(color: searchData![index].ignition=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode))
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
                                                      color:searchData![index].mainPowerStatus=="0" ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode,
                                                    ),
                                                  ),
                                                  Text("PWR",style: TextStyle(color:searchData![index].mainPowerStatus=="0" ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode))

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
                                                      color:searchData![index].ac=="OFF" ? MyColors.text4ColorCode : MyColors.boxBackgroundColorCode,
                                                    ),
                                                  ),
                                                  Text("AC",style: TextStyle(color:searchData![index].ac=="OFF" ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode))

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
                                                      color: searchData![index].door=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode,
                                                    ),
                                                  ),
                                                  Text("DOOR",style: TextStyle(color: searchData![index].door=="OFF" ? MyColors.text4ColorCode :MyColors.analyticGreenColorCode))
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
                                                      color:searchData![index].gpsFix==0 ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode,
                                                    ),
                                                  ),
                                                  Text("GPS",style: TextStyle(color:searchData![index].gpsFix==0 ? MyColors.text4ColorCode : MyColors.analyticGreenColorCode))
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
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

   analyticReportDetail(BuildContext context,List<AnalyticREportDetailDatum>? analyticDetailsdata) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 400,
              width: MediaQuery.of(context).size.width - 20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                            child: Text(
                              // "Running Since 3 mins",
                              "Vehicle is in ${analyticDetailsdata![0].status!}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,color: MyColors.greenColorCode),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                                  child: Text(
                                    "Address :",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18,color: MyColors.textprofiledetailColorCode),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  analyticDetailsdata[0].address!,
                                  // "Baner near to orchid hotel",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                                  child: Text(
                                    "LatLng :",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18,color: MyColors.textprofiledetailColorCode),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  analyticDetailsdata[0].latitude.toString()+","+analyticDetailsdata[0].longitude.toString(),
                                  // "18.34556,45.34000",
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                                  child: Text(
                                    "Speed Limit :",
                                    // :${analyticDetailsdata![0].speedLimit!}
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18,color: MyColors.textprofiledetailColorCode),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  // "50 kph",
                                  analyticDetailsdata[0].speedLimit!.toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                                  child: Text(
                                    "Distance Travel :",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18,color: MyColors.textprofiledetailColorCode),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  // "33 kph",
                                  analyticDetailsdata[0].travelDistance!,

                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                          /*  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                              child: Text(
                                "No.of satellite :",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18,color: MyColors.textprofiledetailColorCode),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "-",

                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        ],
                      ),*/
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                                  child: Text(
                                    "Ignition :",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18,color: MyColors.textprofiledetailColorCode),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  // "ON",
                                  analyticDetailsdata[0].ignition.toString(),
                                  style: TextStyle(fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top:10.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color:MyColors.dateIconColorCode ),
                                borderRadius: BorderRadius.all(Radius.circular(10))
                              ),
                              child: Text("Close",
                                  style: TextStyle(
                                      color: MyColors.text4ColorCode,
                                      fontSize: 20)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
                          child: MaterialButton(
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



}
//-----------------------------------------------------------------
/*
class TravelDetailsScreen extends StatefulWidget {
  // const TravelDetailsScreen({Key? key}) : super(key: key);

  @override
  _TravelDetailsScreenState createState() => _TravelDetailsScreenState();
}

class _TravelDetailsScreenState extends State<TravelDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late bool _isLoading = false;
  String selectedVehicle = '';
  List data =[];
  String vehicletypedropdown = '';
  late int vehicleid=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()*/
/*.getMenuDrawer(context)*//*
,
      appBar: CustomAppBar().getCustomAppBar("TRAVEL DETAILS(DAIRY)",_scaffoldKey,0,context),
      body: _traveldetail(),
    );
  }

  _traveldetail(){
    return LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Color(0xFFCE4A6F),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child:BlocListener<MainBloc, MainState>(
          listener: (context,state){
            // if (state is AnalyticsReportsDetailsLoadingState) {
            //   setState(() {
            //     _isLoading = true;
            //   });
            // }else if (state is AnalyticsReportsDetailsLoadedState) {
            //   setState(() {
            //     _isLoading = true;
            //   });
            // }else if (state is AnalyticsReportsDetailsErrorState) {
            //   setState(() {
            //     _isLoading = true;
            //   });
            // }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text("Select Vehicle",style: TextStyle(fontSize: 18),),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                            )
                          ],
                        ),
                      )
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color:MyColors.whiteColorCode,

                    ),
                    width: MediaQuery.of(context).size.width,
                    child: FormHelper.dropDownWidget(
                      context,
                      // "Select product",
                      selectedVehicle=='' ?  "Select" :selectedVehicle,
                      this.vehicletypedropdown,
                      this.data,
                          (onChangeVal){
                        setState(() {
                          this.vehicletypedropdown=onChangeVal;
                          vehicleid=int.parse(onChangeVal);
                          print("Selected Product : $onChangeVal");
                        });

                      },
                          (onValidateval){
                        if(onValidateval==null){
                          return "Please select country";
                        }
                        return null;
                      },
                      borderColor:MyColors.whiteColorCode,
                      borderFocusColor: MyColors.whiteColorCode,
                      borderRadius: 10,
                      optionValue: "srNo",
                      optionLabel: "vehicleType",
                      // paddingLeft:20

                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(
                            left: 0.0,top: 10),
                        child: RichText(
                          text: const TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Text(
                                        "From Date / Time",style: TextStyle(fontSize: 18))),
                                WidgetSpan(
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                          color:
                                          Colors.red),
                                    )),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon:
                                const Icon(Icons
                                    .calendar_today_rounded),
                                isDense: true,

                                hintText:
                                "DD/MM/YYYY",

                                fillColor:
                                const Color(
                                    0xFFF2F2F2),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon:
                                const Icon(Icons
                                    .watch_later_outlined),
                                isDense: true,

                                hintText: "hh:mm:a",

                                fillColor:
                                const Color(
                                    0xFFF2F2F2),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    const BorderRadius
                                        .all(
                                        Radius.circular(
                                            4)),
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors
                                            .grey
                                            .withOpacity(
                                            0.5))),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(
                            left: 0.0),
                        child: RichText(
                          text: const TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Text(
                                        "To Date / Time",style: TextStyle(fontSize: 18))),
                                WidgetSpan(
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                          color:
                                          Colors.red),
                                    )),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon: const Icon(Icons
                                    .calendar_today_rounded),
                                isDense: true,
                                hintText: "DD/MM/YYYY",
                                fillColor: const Color(
                                    0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon:
                                const Icon(Icons
                                    .watch_later_outlined),
                                isDense: true,

                                hintText: "hh:mm:a",

                                fillColor:
                                const Color(
                                    0xFFF2F2F2),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    const BorderRadius
                                        .all(
                                        Radius.circular(
                                            4)),
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors
                                            .grey
                                            .withOpacity(
                                            0.5))),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Container(
                            padding: EdgeInsets.only(left: 15,right: 15),
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(8.0),
                              color: MyColors
                                  .blueColorCode,
                            ),
                            child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Show Location",
                                  style: TextStyle(
                                      color: Colors
                                          .white),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}*/
