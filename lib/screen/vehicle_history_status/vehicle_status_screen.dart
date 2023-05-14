import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert/vehicle_fill_srno_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/screen/vehicle_status_details_screen.dart';
import 'package:flutter_vts/screen/vehicle_status_filter_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:http/http.dart' as http;

import '../live_tracking/live_tracking_detail_screen.dart';
import 'map_veh_history_by_id.dart';

class VehicleStatusScreen extends StatefulWidget {
  // const VehicleStatusScreen({Key? key}) : super(key: key);

  @override
  @override
  _VehicleStatusScreenState createState() => _VehicleStatusScreenState();
}

class _VehicleStatusScreenState extends State<VehicleStatusScreen> {
  ScrollController notificationController = new ScrollController();
  TextEditingController _fromdatecontroller = new TextEditingController();
  TextEditingController _fromTimecontroller = new TextEditingController();
  TextEditingController _todatecontroller = new TextEditingController();
  TextEditingController _toTimecontroller = new TextEditingController();
  TextEditingController searchController = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  DateTime currentdate = DateTime.now();
  late String date = '', todate = '', fromTime = '', toTime = '';
  var filterVehicleStatusResult;
  late int selectedVendorid = 0, selectedbranchid = 0;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> items = ["aaa", "bb", "cc", "dd", "ee"];
  final controller = ScrollController();

  bool isSelected = false;
  String radiolist = "radio";
  late int value = 0;
  late int vehicleHistoryPosition = 0;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token = "";
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 0, vendorid = 0;
  // List<String> list=[];
  List list = [];
  late bool isSearch = false;
  late bool isSearchClick = false;

  List<VehicleFillSrNoResponse> vehicleSrNolist = [];
  String selectedVehicle = "";
  String vehicledropdown = "";
  String selectedvehicleno = "";
  int pageNumber = 1;
  int FilterPageNumber = 0, searchFilterPageNumber = 1, searchPageNumber = 1;

  List<VehicleStatusDatum>? data = [];
  List<VehicleHistoryFilterDatum>? vehiclehistoryfilterdata = [];
  late bool isFilterAlertSearch = false;
  late bool searchFilter = false;
  late String searchText = '';
  List<String> selectedvehicleStatuslist = [];
  List<int> selectedvehicleSrNolist = [];
  int totalVehicleHistoryRecords = 0;
  String totalVehicleHistoryFilterRecords = "0";
  double _originLatitude = 18.522024549551766;
// Starting point longitude
  double _originLongitude = 73.85738994124968;
// Destination latitude
  double _destLatitude = 18.522024549551766;
// Destination Longitude
  double _destLongitude = 73.85738994124968;
  String selectedfromdate = "";
  String selectedTodate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    setState(() {
      todate = Jiffy(currentdate).format('d-MMMM-yyyy');
      date = Jiffy(currentdate).format('d-MMMM-yyyy');
      fromTime = currentdate.hour.toString() +
          ":" +
          currentdate.minute.toString() +
          ":" +
          currentdate.second.toString();
      toTime = currentdate.hour.toString() +
          ":" +
          currentdate.minute.toString() +
          ":" +
          currentdate.second.toString();
    });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        if (FilterPageNumber == 0) {
          setState(() {
            print("Scroll ${pageNumber}");
            getVehicleStatus();
          });
        } else {
          print("filter scroll");
          getVehicleHistoryFilter();
        }
      }
    });
    getdata();
  }

  getVehicleHistoryFilter() {
    if (searchFilter) {
      _mainBloc.add(VehicleHistorySearchFilterEvents(
        token: token,
        vendorId: selectedVendorid,
        branchId: selectedbranchid,
        araiNoarai: 'arai',
        fromDate: date,
        formTime: fromTime,
        toDate: todate,
        toTime: toTime,
        vehicleStatusList: selectedvehicleStatuslist,
        searchText: searchText,
        pageNumber: FilterPageNumber,
        pageSize: 10,
        vehicleList: selectedvehicleSrNolist,
      ));
    } else {
      _mainBloc.add(VehicleHistoryFilterEvents(
        token: token,
        vendorId: selectedVendorid,
        branchId: selectedbranchid,
        araiNoarai: 'nonarai',
        fromDate: date,
        formTime: fromTime,
        toDate: todate,
        toTime: toTime,
        vehicleStatusList: selectedvehicleStatuslist,
        pageNumber: FilterPageNumber,
        pageSize: 10,
        vehicleList: selectedvehicleSrNolist,
      ));
    }
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

    print("" +
        vendorid.toString() +
        " " +
        branchid.toString() +
        " " +
        userName +
        " " +
        vendorName +
        " " +
        branchName +
        " " +
        userType);

    if (token != "" ||
        vendorid != 0 ||
        branchid != 0 ||
        vendorName != "" ||
        branchName != "") {
      // print("")
      getvehiclelist();
    }
  }

  getVehicleStatus() {
    _mainBloc.add(VehicleSatusEvents(
        token: token,
        vendorId: vendorid,
        branchId: branchid,
        araiNoarai: "nonarai",
        fromDate: date,
        toDate: todate,
        formTime: fromTime,
        toTime: toTime,
        vehicleRegno: selectedvehicleno,
        pageNumber: pageNumber,
        pageSize: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: /*isSearchClick ? Container(
          height: 40,
          decoration: BoxDecoration(
              color:MyColors.whiteColorCode,
              borderRadius: BorderRadius.all(Radius.circular(4))
          ),
          child: TextFormField(
            controller:searchController,
            validator: (value) {
              if (value == "") {
                return "Please Enter Username";
              }
            },
            enabled: true, // to trigger disabledBorder
            decoration: const InputDecoration(
              isDense: true,
              prefixIcon: Icon(
                Icons.search,
                color: MyColors.blackColorCode,
              ),
              hintText: "Search",
              contentPadding: EdgeInsets.only(top: 6),
              fillColor: Color(0xFFF2F2F2),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                BorderSide(width: 1, color: Colors.grey),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                BorderSide(width: 1, color: Colors.orange),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                BorderSide(width: 0.3, color: Colors.grey),
              ),
              border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.all(Radius.circular(4)),
                  borderSide: BorderSide(
                    width: 0.5,
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
                  borderSide:
                  BorderSide(width: 1, color: Colors.grey)),
              // hintText: "HintText",
              alignLabelWithHint: true,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
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
              }
            },
          ),
        ) :*/
            Text("VEHICLES STATUS"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                selectedfromdate = selectedDate.year.toString() +
                    "/" +
                    selectedDate.month.toString() +
                    "/" +
                    selectedDate.day.toString();
                selectedTodate = selectedToDate.year.toString() +
                    "/" +
                    selectedToDate.month.toString() +
                    "/" +
                    selectedToDate.day.toString();
              });

              _validationfiltervehicle();
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
          // isSearchClick ? Container() :data!.length==0 ? Container() :IconButton(
          //     onPressed: (){
          //       setState(() {
          //         isSearchClick=true;
          //       });
          //     },
          //     icon: Icon(Icons.search,size: 30,color:MyColors.whiteColorCode ,)
          // ),
          // IconButton(
          //     onPressed: (){
          //     },
          //     icon: Icon(Icons.help_outline,size: 30,color:MyColors.whiteColorCode ,)
          // )
        ],
      ),
      // CustomAppBar().getCustomAppBar("VEHICLE STATUS", _scaffoldKey,0,context),
      body: _vehicleStatus(),
    );
  }

  _vehicleStatus() {
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: MyColors.appDefaultColorCode,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state is VehicleStatusLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleStatusLoadedState) {
            setState(() {
              // data!.clear();
              _isLoading = false;
              if (state.vehicleStatusResponse.totalRecords != null) {
                totalVehicleHistoryRecords =
                    state.vehicleStatusResponse.totalRecords!;
              }
            });
            if (state.vehicleStatusResponse.data != null) {
              print("here is your data class---------->" + data.toString());
              data!.addAll(state.vehicleStatusResponse.data!);
            }

            if (state.vehicleStatusResponse.succeeded != null) {
              if (!state.vehicleStatusResponse.succeeded) {
                Fluttertoast.showToast(
                  msg: state.vehicleStatusResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }

            // if (state.vehicleStatusResponse.data != null) {
            //   if (state.vehicleStatusResponse.data!.length == 0) {
            //     setState(() {
            //       pageNumber = 1;
            //       data!.clear();
            //       isSearch = false;
            //       isSearchClick = false;
            //     });
            //     Fluttertoast.showToast(
            //       msg: "Search result not found",
            //       toastLength: Toast.LENGTH_SHORT,
            //       timeInSecForIosWeb: 1,
            //     );
            //   } else {
            //     setState(() {

            //       pageNumber++;
            //     });
            //   }
            // }
          } else if (state is VehicleStatusErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              msg: state.msg,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          }
          if (state is VehicleHistoryFilterLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleHistoryFilterLoadedState) {
            setState(() {
              _isLoading = false;
              totalVehicleHistoryFilterRecords =
                  state.vehicleHistoryFilterResponse.totalRecords.toString();
            });
            if (state.vehicleHistoryFilterResponse.data != null) {
              if (state.vehicleHistoryFilterResponse.data!.length != 0) {
                FilterPageNumber++;
              }
            }
            if (state.vehicleHistoryFilterResponse.succeeded!) {
              vehiclehistoryfilterdata!
                  .addAll(state.vehicleHistoryFilterResponse.data!);
            } else {}
          } else if (state is VehicleHistoryFilterErrorState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is VehicleHistorySearchFilterLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleHistorySearchFilterLoadedState) {
            setState(() {
              _isLoading = false;
              if (state.vehicleHistoryFilterResponse.data != null) {
                if (state.vehicleHistoryFilterResponse.data!.length != 0) {
                  FilterPageNumber++;
                }
              }
              if (state.vehicleHistoryFilterResponse.succeeded!) {
                vehiclehistoryfilterdata!
                    .addAll(state.vehicleHistoryFilterResponse.data!);
              } else {
                if (state.vehicleHistoryFilterResponse.message != null) {
                  // Fluttertoast.showToast(
                  //   toastLength: Toast.LENGTH_SHORT,
                  //   timeInSecForIosWeb: 1,
                  //   msg: state.filterAlertNotificationResponse.message!,
                  // );
                }
              }
            });
          } else if (state is VehicleHistorySearchFilterErrorState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is VehicleHistoryByIdDetailLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleHistoryByIdDetailLoadedState) {
            setState(() {
              _isLoading = false;
            });

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
        },
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: MyColors.lightgreyColorCode,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: MyColors.shadowGreyColorCode)
                    ]),
                // width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(_fromdatecontroller.text.isEmpty
                              ? date
                              : _fromdatecontroller.text),
                          Text(_fromTimecontroller.text.isEmpty
                              ? fromTime
                              : _fromTimecontroller.text),
                        ],
                      ),
                    ),
                    Text("-"),
                    Expanded(
                      child: Column(
                        children: [
                          Text(_todatecontroller.text.isEmpty
                              ? todate
                              : _todatecontroller.text),
                          Text(_toTimecontroller.text.isEmpty
                              ? toTime
                              : _toTimecontroller.text),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeDatepopUp(context);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              color: MyColors.greyColorCode,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Text(
                            "Change",
                            style: TextStyle(
                                color: MyColors.text4ColorCode, fontSize: 18),
                          ),
                        ),
                      ),
                    )

                    // Text("10 NOTIFICATIONS",style: TextStyle(fontSize: 18),),
                    // Text("CLEAR ALL",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 15, right: 15, bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyColors.textBoxBorderColorCode,
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: MyColors.whiteColorCode,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: FormHelper.dropDownWidget(
                                    context,
                                    // "Select product",
                                    selectedVehicle == ''
                                        ? "Select"
                                        : selectedVehicle,
                                    this.vehicledropdown,
                                    this.list,
                                    (onChangeVal) {
                                      setState(() {
                                        this.vehicledropdown = onChangeVal;
                                        // vehicleid=int.parse(onChangeVal);
                                        print(
                                            "Selected Product : $onChangeVal");
                                        for (int i = 0; i < list.length; i++) {
                                          if (onChangeVal ==
                                              list[i]['vsrNo'].toString()) {
                                            print(list[i]['vehicleRegNo']);
                                            selectedvehicleno =
                                                list[i]['vehicleRegNo'];
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
                                ),
                                GestureDetector(
                                    onTap: () {
                                      print("click");
                                      setState(() {
                                        selectedVehicle = "";
                                        vehicledropdown = "";
                                        selectedvehicleno = "";
                                      });
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Icon(
                                        Icons.close,
                                        color: MyColors.blackColorCode,
                                        size: 20,
                                      ),
                                    ) /*Container(
                                      // alignment: Alignment.center,
                                      // decoration: BoxDecoration(
                                      //   shape: BoxShape.circle,
                                      //   color: MyColors.greyColorCode
                                      // ),
                                      //  padding: const EdgeInsets.only(right: 2.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6.0,top: 10),
                                        child: Icon(Icons.close,color: MyColors.blackColorCode,size: 20,),
                                      ),
                                    ),*/
                                    )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedfromdate = selectedDate.year.toString() +
                                  "/" +
                                  selectedDate.month.toString() +
                                  "/" +
                                  selectedDate.day.toString();
                              selectedTodate = selectedToDate.year.toString() +
                                  "/" +
                                  selectedToDate.month.toString() +
                                  "/" +
                                  selectedToDate.day.toString();
                            });

                            // if(selectedfromdate==selectedTodate){
                            //   print("same  ${selectedfromdate}  ${selectedTodate}");
                            // }else{
                            //   print("different   ${selectedfromdate}  ${selectedTodate}");
                            //
                            // }

                            validation();
                          },
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: MyColors.textBoxBorderColorCode,
                                  width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: MyColors.appDefaultColorCode,
                            ),
                            child: Icon(
                              Icons.send,
                              color: MyColors.whiteColorCode,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10, bottom: 6),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          !isFilterAlertSearch
                              ? data!.length != 0
                                  ? "Showing 1 to ${data!.length} Out of ${totalVehicleHistoryRecords}"
                                  : "0 RECORDS"
                              : vehiclehistoryfilterdata!.length != 0
                                  ? "Showing 1 to ${vehiclehistoryfilterdata!.length}  Out of ${totalVehicleHistoryFilterRecords}"
                                  : "0 RECORDS",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        )),
                    isFilterAlertSearch
                        ? ListView.builder(
                            controller: notificationController,
                            shrinkWrap: true,
                            itemCount: vehiclehistoryfilterdata!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  _mainBloc.add(VehicleHistoryByIdDetailEvents(
                                      token: token,
                                      vendorId: vendorid,
                                      branchId: branchid,
                                      araiNoarai: 'arai',
                                      fromDate: date,
                                      formTime: fromTime,
                                      toDate: todate,
                                      toTime: toTime,
                                      vehicleHistoryId:
                                          vehiclehistoryfilterdata![index]
                                              .transactionId));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1,
                                        color: MyColors.textBoxBorderColorCode),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        left: 14,
                                        right: 14,
                                        bottom: 10),
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: MyColors.whiteColorCode,
                                                border: Border.all(
                                                    color: MyColors
                                                        .boxBackgroundColorCode),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Image.asset(
                                                vehiclehistoryfilterdata![index]
                                                            .vehicleStatus ==
                                                        "Stopped"
                                                    ? "assets/stopped_truck.png"
                                                    : vehiclehistoryfilterdata![
                                                                    index]
                                                                .vehicleStatus ==
                                                            "Nodata"
                                                        ? "assets/no_data_truck.png"
                                                        : vehiclehistoryfilterdata![
                                                                        index]
                                                                    .vehicleStatus ==
                                                                "Overspeed"
                                                            ? "assets/overspeed_truck.png"
                                                            : vehiclehistoryfilterdata![
                                                                            index]
                                                                        .vehicleStatus ==
                                                                    "Running"
                                                                ? "assets/running_truck.png"
                                                                : vehiclehistoryfilterdata![index]
                                                                            .vehicleStatus ==
                                                                        "Idle"
                                                                    ? "assets/idle_truck.png"
                                                                    : vehiclehistoryfilterdata![index].vehicleStatus ==
                                                                            "Inactive"
                                                                        ? "assets/inactive_truck.png"
                                                                        : vehiclehistoryfilterdata![index].vehicleStatus ==
                                                                                "Total"
                                                                            ? "assets/idle_truck.png"
                                                                            : "assets/idle_truck.png",
                                                // "assets/driving_pin.png",
                                                width: 40,
                                                height: 40,
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      vehiclehistoryfilterdata![
                                                              index]
                                                          .vehicleRegNo!,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 20),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color:
                                                              // MyColors.greenColorCode,
                                                              vehiclehistoryfilterdata![
                                                                              index]
                                                                          .vehicleStatus ==
                                                                      "Stopped"
                                                                  ? MyColors
                                                                      .analyticStoppedColorCode
                                                                  : vehiclehistoryfilterdata![index]
                                                                              .vehicleStatus ==
                                                                          "Nodata"
                                                                      ? MyColors
                                                                          .analyticnodataColorCode
                                                                      : vehiclehistoryfilterdata![index].vehicleStatus ==
                                                                              "Overspeed"
                                                                          ? MyColors
                                                                              .analyticoverSpeedlColorCode
                                                                          : vehiclehistoryfilterdata![index].vehicleStatus == "Running"
                                                                              ? MyColors.analyticGreenColorCode
                                                                              : vehiclehistoryfilterdata![index].vehicleStatus == "Idle"
                                                                                  ? MyColors.analyticIdelColorCode
                                                                                  : vehiclehistoryfilterdata![index].vehicleStatus == "Inactive"
                                                                                      ? MyColors.analyticActiveColorCode
                                                                                      : vehiclehistoryfilterdata![index].vehicleStatus == "Total"
                                                                                          ? MyColors.yellowColorCode
                                                                                          : MyColors.blackColorCode,
                                                          size: 7,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 4.0,
                                                                  top: 6,
                                                                  bottom: 6),
                                                          child: Text(
                                                            vehiclehistoryfilterdata![
                                                                    index]
                                                                .vehicleStatus!,
                                                            style: TextStyle(
                                                                color:
                                                                    // MyColors.greenColorCode
                                                                    vehiclehistoryfilterdata![index].vehicleStatus ==
                                                                            "Stopped"
                                                                        ? MyColors
                                                                            .analyticStoppedColorCode
                                                                        : vehiclehistoryfilterdata![index].vehicleStatus ==
                                                                                "Nodata"
                                                                            ? MyColors.analyticnodataColorCode
                                                                            : vehiclehistoryfilterdata![index].vehicleStatus == "Overspeed"
                                                                                ? MyColors.analyticoverSpeedlColorCode
                                                                                : vehiclehistoryfilterdata![index].vehicleStatus == "Running"
                                                                                    ? MyColors.analyticGreenColorCode
                                                                                    : vehiclehistoryfilterdata![index].vehicleStatus == "Idle"
                                                                                        ? MyColors.analyticIdelColorCode
                                                                                        : vehiclehistoryfilterdata![index].vehicleStatus == "Inactive"
                                                                                            ? MyColors.analyticActiveColorCode
                                                                                            : vehiclehistoryfilterdata![index].vehicleStatus == "Total"
                                                                                                ? MyColors.yellowColorCode
                                                                                                : MyColors.blackColorCode),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 3,
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4.0,
                                                                    right: 4,
                                                                    top: 4,
                                                                    bottom: 4),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: MyColors
                                                                  .textBoxColorCode,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Text(vehiclehistoryfilterdata![
                                                                        index]
                                                                    .date
                                                                    .toString() +
                                                                " | " +
                                                                vehiclehistoryfilterdata![
                                                                        index]
                                                                    .time
                                                                    .toString()),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Container(
                                                            // padding: const EdgeInsets.all(7.0),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 4.0,
                                                                    right: 2,
                                                                    top: 2,
                                                                    bottom: 2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: MyColors
                                                                  .lightblueColorCode,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Text(
                                                              "Speed : ${vehiclehistoryfilterdata![index].speed} km/h",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .linearGradient2ColorCode),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 6.0,
                                                              bottom: 6),
                                                      child: Text(
                                                        vehiclehistoryfilterdata![
                                                                index]
                                                            .driverName!,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: Divider(
                                            height: 5,
                                            color: MyColors.greyColorCode,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, right: 10),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: 6),
                                                    width: 39,
                                                    height: 38,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                            color: MyColors
                                                                .boxBackgroundColorCode),
                                                        color: MyColors
                                                            .whiteColorCode),
                                                    child: Icon(
                                                      Icons.power_settings_new,
                                                      size: 20,
                                                      color: vehiclehistoryfilterdata![
                                                                      index]
                                                                  .ignition ==
                                                              "OFF"
                                                          ? MyColors
                                                              .text4ColorCode
                                                          : MyColors
                                                              .analyticGreenColorCode,
                                                    ),
                                                  ),
                                                  Text("IGN",
                                                      style: TextStyle(
                                                          color: vehiclehistoryfilterdata![
                                                                          index]
                                                                      .ignition ==
                                                                  "OFF"
                                                              ? MyColors
                                                                  .text4ColorCode
                                                              : MyColors
                                                                  .analyticGreenColorCode))
                                                ]),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 6),
                                                      width: 39,
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: MyColors
                                                                  .boxBackgroundColorCode),
                                                          color: MyColors
                                                              .whiteColorCode),
                                                      child: Icon(
                                                        Icons
                                                            .battery_charging_full_outlined,
                                                        size: 20,
                                                        color: vehiclehistoryfilterdata![
                                                                        index]
                                                                    .mainPowerStatus ==
                                                                "0"
                                                            ? MyColors
                                                                .text4ColorCode
                                                            : MyColors
                                                                .analyticGreenColorCode,
                                                      ),
                                                    ),
                                                    Text("PWR",
                                                        style: TextStyle(
                                                            color: vehiclehistoryfilterdata![
                                                                            index]
                                                                        .mainPowerStatus ==
                                                                    "0"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 6),
                                                      width: 39,
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: MyColors
                                                                  .boxBackgroundColorCode),
                                                          color: MyColors
                                                              .whiteColorCode),
                                                      child: Icon(
                                                        Icons.ac_unit,
                                                        size: 20,
                                                        color: vehiclehistoryfilterdata![
                                                                        index]
                                                                    .ac ==
                                                                "OFF"
                                                            ? MyColors
                                                                .text4ColorCode
                                                            : MyColors
                                                                .text4ColorCode,
                                                      ),
                                                    ),
                                                    Text("AC",
                                                        style: TextStyle(
                                                            color: vehiclehistoryfilterdata![
                                                                            index]
                                                                        .ac ==
                                                                    "OFF"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 6),
                                                      width: 39,
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: MyColors
                                                                  .boxBackgroundColorCode),
                                                          color: MyColors
                                                              .whiteColorCode),
                                                      child: Icon(
                                                        Icons.outdoor_grill,
                                                        size: 20,
                                                        color: vehiclehistoryfilterdata![
                                                                        index]
                                                                    .door ==
                                                                "OFF"
                                                            ? MyColors
                                                                .text4ColorCode
                                                            : MyColors
                                                                .analyticGreenColorCode,
                                                      ),
                                                    ),
                                                    Text("Door",
                                                        style: TextStyle(
                                                            color: vehiclehistoryfilterdata![
                                                                            index]
                                                                        .door ==
                                                                    "OFF"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode))
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          bottom: 6),
                                                      width: 39,
                                                      height: 38,
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                              color: MyColors
                                                                  .boxBackgroundColorCode),
                                                          color: MyColors
                                                              .whiteColorCode),
                                                      child: Icon(
                                                        Icons.wifi,
                                                        size: 20,
                                                        color: vehiclehistoryfilterdata![
                                                                        index]
                                                                    .gpsFix ==
                                                                "OFF"
                                                            ? MyColors
                                                                .text4ColorCode
                                                            : MyColors
                                                                .analyticGreenColorCode,
                                                      ),
                                                    ),
                                                    Text("GPS",
                                                        style: TextStyle(
                                                            color: vehiclehistoryfilterdata![
                                                                            index]
                                                                        .gpsFix ==
                                                                    "OFF"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode))
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
                        : data!.length == 0
                            ? Container()
                            : ListView.builder(
                                controller: notificationController,
                                shrinkWrap: true,
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      print("click");

                                      setState(() {
                                        vehicleHistoryPosition = index;
                                        //  print(
                                        //    "vehicleHistoryPosition----------------${data!.elementAt(index).la}");
                                        print(vehicleHistoryPosition + 1);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(
                                                          webService:
                                                              WebService());
                                                    },
                                                    child:
                                                        MapLiveTrackingDetailsScreen(
                                                      araiNonarai: 'arai',
                                                      transactionId:2074,
                                                         
                                                      fromlongitude:
                                                          double.parse(
                                                              data![index]
                                                                  .latitude!),
                                                      fromlatitude:
                                                          double.parse(
                                                              data![index]
                                                                  .longitude!),
                                                      tolatitude: double.parse(
                                                          data!
                                                              .elementAt(index)
                                                              .latitude!),
                                                      tolongitude: double.parse(
                                                          data!
                                                              .elementAt(index)
                                                              .longitude!),
                                                    )

                                                    // VehicleStatusDetailsINFOScreen(
                                                    //   fromlongitude:double.parse(data![vehicleHistoryPosition + 1].latitude!) ,
                                                    //   fromlatitude: double.parse( data![vehicleHistoryPosition + 1].longitude!),
                                                    //   tolatitude: double.parse(data!.elementAt(index).latitude!),
                                                    //   tolongitude: double.parse(data!.elementAt(index).longitude!),
                                                    // )
                                                    // VehicleStatusDetailsScreen(vehicleHistoryByIdDetailResponse:  data!,
                                                    //     latitude: data![vehicleHistoryPosition + 1].latitude!,
                                                    //     longitude: data![vehicleHistoryPosition + 1].longitude!,
                                                    // )

                                                    )));
                                      });
                                      _mainBloc.add(
                                          VehicleHistoryByIdDetailEvents(
                                              token: token,
                                              vendorId: vendorid,
                                              branchId: branchid,
                                              araiNoarai: 'nonarai',
                                              fromDate: date,
                                              formTime: fromTime,
                                              toDate: todate,
                                              toTime: toTime,
                                              vehicleHistoryId:
                                                  data![index].transactionId!));
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1,
                                            color: MyColors
                                                .textBoxBorderColorCode),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 10,
                                            left: 14,
                                            right: 14,
                                            bottom: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        MyColors.whiteColorCode,
                                                    border: Border.all(
                                                        color: MyColors
                                                            .boxBackgroundColorCode),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Image.asset(
                                                    data![index].vehicleStatus ==
                                                            "Stopped"
                                                        ? "assets/stopped_truck.png"
                                                        : data![index]
                                                                    .vehicleStatus ==
                                                                "Nodata"
                                                            ? "assets/no_data_truck.png"
                                                            : data![index]
                                                                        .vehicleStatus ==
                                                                    "Overspeed"
                                                                ? "assets/overspeed_truck.png"
                                                                : data![index]
                                                                            .vehicleStatus ==
                                                                        "Running"
                                                                    ? "assets/running_truck.png"
                                                                    : data![index].vehicleStatus ==
                                                                            "Idle"
                                                                        ? "assets/idle_truck.png"
                                                                        : data![index].vehicleStatus ==
                                                                                "Inactive"
                                                                            ? "assets/inactive_truck.png"
                                                                            : data![index].vehicleStatus == "Total"
                                                                                ? "assets/idle_truck.png"
                                                                                : "assets/idle_truck.png",
                                                    // "assets/driving_pin.png",
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          data![index]
                                                              .vehicleRegNo!,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.circle,
                                                              color:
                                                                  // MyColors.greenColorCode,
                                                                  data![index].vehicleStatus ==
                                                                          "Stopped"
                                                                      ? MyColors
                                                                          .analyticStoppedColorCode
                                                                      : data![index].vehicleStatus ==
                                                                              "Nodata"
                                                                          ? MyColors
                                                                              .analyticnodataColorCode
                                                                          : data![index].vehicleStatus == "Overspeed"
                                                                              ? MyColors.analyticoverSpeedlColorCode
                                                                              : data![index].vehicleStatus == "Running"
                                                                                  ? MyColors.analyticGreenColorCode
                                                                                  : data![index].vehicleStatus == "Idle"
                                                                                      ? MyColors.analyticIdelColorCode
                                                                                      : data![index].vehicleStatus == "Inactive"
                                                                                          ? MyColors.analyticActiveColorCode
                                                                                          : data![index].vehicleStatus == "Total"
                                                                                              ? MyColors.yellowColorCode
                                                                                              : MyColors.blackColorCode,
                                                              size: 7,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      top: 6,
                                                                      bottom:
                                                                          6),
                                                              child: Text(
                                                                data![index]
                                                                    .vehicleStatus!,
                                                                style: TextStyle(
                                                                    color:
                                                                        // MyColors.greenColorCode
                                                                        data![index].vehicleStatus == "Stopped"
                                                                            ? MyColors.analyticStoppedColorCode
                                                                            : data![index].vehicleStatus == "Nodata"
                                                                                ? MyColors.analyticnodataColorCode
                                                                                : data![index].vehicleStatus == "Overspeed"
                                                                                    ? MyColors.analyticoverSpeedlColorCode
                                                                                    : data![index].vehicleStatus == "Running"
                                                                                        ? MyColors.analyticGreenColorCode
                                                                                        : data![index].vehicleStatus == "Idle"
                                                                                            ? MyColors.analyticIdelColorCode
                                                                                            : data![index].vehicleStatus == "Inactive"
                                                                                                ? MyColors.analyticActiveColorCode
                                                                                                : data![index].vehicleStatus == "Total"
                                                                                                    ? MyColors.yellowColorCode
                                                                                                    : MyColors.blackColorCode),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            4.0,
                                                                        right:
                                                                            4,
                                                                        top: 4,
                                                                        bottom:
                                                                            4),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: MyColors
                                                                      .textBoxColorCode,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                ),
                                                                child: Text(data![
                                                                            index]
                                                                        .date! +
                                                                    " | " +
                                                                    data![index]
                                                                        .time!),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                // padding: const EdgeInsets.all(7.0),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            4.0,
                                                                        right:
                                                                            2,
                                                                        top: 2,
                                                                        bottom:
                                                                            2),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: MyColors
                                                                      .lightblueColorCode,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                ),
                                                                child: Text(
                                                                  "Speed : ${data![index].speed} km/h",
                                                                  style: TextStyle(
                                                                      color: MyColors
                                                                          .linearGradient2ColorCode),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 6.0,
                                                                  bottom: 6),
                                                          child: Text(
                                                            data![index]
                                                                .driverName!,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Divider(
                                                height: 5,
                                                color: MyColors.greyColorCode,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, right: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(children: [
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: 6),
                                                        width: 39,
                                                        height: 38,
                                                        decoration: BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                                color: MyColors
                                                                    .boxBackgroundColorCode),
                                                            color: MyColors
                                                                .whiteColorCode),
                                                        child: Icon(
                                                          Icons
                                                              .power_settings_new,
                                                          size: 20,
                                                          color: data![index]
                                                                      .ignition ==
                                                                  "OFF"
                                                              ? MyColors
                                                                  .text4ColorCode
                                                              : MyColors
                                                                  .analyticGreenColorCode,
                                                        ),
                                                      ),
                                                      Text("IGN",
                                                          style: TextStyle(
                                                              color: data![index]
                                                                          .ignition ==
                                                                      "OFF"
                                                                  ? MyColors
                                                                      .text4ColorCode
                                                                  : MyColors
                                                                      .analyticGreenColorCode))
                                                    ]),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 6),
                                                          width: 39,
                                                          height: 38,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: MyColors
                                                                      .boxBackgroundColorCode),
                                                              color: MyColors
                                                                  .whiteColorCode),
                                                          child: Icon(
                                                            Icons
                                                                .battery_charging_full_outlined,
                                                            size: 20,
                                                            color: data![index]
                                                                        .mainPowerStatus ==
                                                                    "0"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode,
                                                          ),
                                                        ),
                                                        Text("PWR",
                                                            style: TextStyle(
                                                                color: data![index]
                                                                            .mainPowerStatus ==
                                                                        "0"
                                                                    ? MyColors
                                                                        .text4ColorCode
                                                                    : MyColors
                                                                        .analyticGreenColorCode))
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 6),
                                                          width: 39,
                                                          height: 38,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: MyColors
                                                                      .boxBackgroundColorCode),
                                                              color: MyColors
                                                                  .whiteColorCode),
                                                          child: Icon(
                                                            Icons.ac_unit,
                                                            size: 20,
                                                            color: data![index]
                                                                        .ac ==
                                                                    "OFF"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .text4ColorCode,
                                                          ),
                                                        ),
                                                        Text("AC",
                                                            style: TextStyle(
                                                                color: data![index]
                                                                            .ac ==
                                                                        "OFF"
                                                                    ? MyColors
                                                                        .text4ColorCode
                                                                    : MyColors
                                                                        .analyticGreenColorCode))
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 6),
                                                          width: 39,
                                                          height: 38,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: MyColors
                                                                      .boxBackgroundColorCode),
                                                              color: MyColors
                                                                  .whiteColorCode),
                                                          child: Icon(
                                                            Icons.outdoor_grill,
                                                            size: 20,
                                                            color: data![index]
                                                                        .door ==
                                                                    "OFF"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode,
                                                          ),
                                                        ),
                                                        Text("Door",
                                                            style: TextStyle(
                                                                color: data![index]
                                                                            .door ==
                                                                        "OFF"
                                                                    ? MyColors
                                                                        .text4ColorCode
                                                                    : MyColors
                                                                        .analyticGreenColorCode))
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 6),
                                                          width: 39,
                                                          height: 38,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: MyColors
                                                                      .boxBackgroundColorCode),
                                                              color: MyColors
                                                                  .whiteColorCode),
                                                          child: Icon(
                                                            Icons.wifi,
                                                            size: 20,
                                                            color: data![index]
                                                                        .gpsFix ==
                                                                    "OFF"
                                                                ? MyColors
                                                                    .text4ColorCode
                                                                : MyColors
                                                                    .analyticGreenColorCode,
                                                          ),
                                                        ),
                                                        Text("GPS",
                                                            style: TextStyle(
                                                                color: data![index]
                                                                            .gpsFix ==
                                                                        "OFF"
                                                                    ? MyColors
                                                                        .text4ColorCode
                                                                    : MyColors
                                                                        .analyticGreenColorCode))
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
                                  /*Card(
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
                                          "assets/driving_pin.png",
                                          width: 40,
                                          height: 40,
                                        ) ,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("DL223245678",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                              Row(
                                                children: [
                                                  Icon(Icons.circle,color: MyColors.analyticGreenColorCode,size: 7,),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0,top: 6,bottom: 6),
                                                    child: Text("Running",style: TextStyle(color: MyColors.analyticGreenColorCode),),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex:3,
                                                    child:Container(
                                                      padding: const EdgeInsets.only(left: 4.0,right: 4,top: 4,bottom: 4),

                                                      decoration: BoxDecoration(
                                                        color:MyColors.textBoxColorCode,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child:Text("21-02-2022 | 13.:16:12") ,
                                                    ) ,
                                                  ),

                                                  Expanded(
                                                    flex:2,
                                                    child: Container(
                                                      // padding: const EdgeInsets.all(7.0),
                                                      padding: const EdgeInsets.only(left: 4.0,right: 2,top: 2,bottom: 2),
                                                      decoration: BoxDecoration(
                                                        color:MyColors.lightblueColorCode,
                                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                                      ),
                                                      child:Text("Speed : 10 km/h",style: TextStyle(color: MyColors.linearGradient2ColorCode),) ,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top:6.0,bottom: 6),
                                                child: Text("Ram Manoj Tiwari",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                                              ),
                                              Text("State Bank of India-Ram Nagar",),


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
                                      color: MyColors.greyColorCode,
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
                                                    color: MyColors.analyticGreenColorCode,
                                                  ),
                                                ),
                                                // Text("IGN",style: TextStyle(color: MyColors.analyticGreenColorCode))
                                              ]
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
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
                                              color: MyColors.analyticGreenColorCode,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
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
                                              color: MyColors.boxBackgroundColorCode,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
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
                                              color: MyColors.analyticGreenColorCode,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
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
                                              color: MyColors.analyticGreenColorCode,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );*/
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
                            controller: _fromdatecontroller,
                            enabled: true, // to trigger disabledBorder
                            decoration: const InputDecoration(
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
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _selectDate(context);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              controller: _fromTimecontroller,
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
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                _selectTime(context);
                              },
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
                            controller: _todatecontroller,
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
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              _toDate(context);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              controller: _toTimecontroller,
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
                              obscureText: false,
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                _selectToTime(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              // _fromdatecontroller.clear();
                              // _toTimecontroller.clear();
                              // _fromTimecontroller.clear();
                              // _todatecontroller.clear();
                              _fromdatecontroller.text = "";
                              _toTimecontroller.text = "";
                              _fromTimecontroller.text = "";
                              _todatecontroller.text = "";
                              setState(() {
                                // searchDateWiseData!.clear();
                                // isDateWiseSearch=false;
                              });
                            },
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
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
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
                              _validation();
                              // Navigator.of(context).pop();
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

  _validation() {
    if (_fromdatecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select From Date",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_fromTimecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select From Time",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_todatecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select To Date",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_toTimecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select To Time",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (selectedDate.compareTo(selectedToDate) == 1) {
      Fluttertoast.showToast(
        msg:
            "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (selectedDate.month != selectedToDate.month) {
      Fluttertoast.showToast(
        msg:
            "Please check Start & End date! Start date and end date Month Will be Same...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else {
      /*  Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );*/
      Navigator.pop(context);

      // _getdatewisealertnotification();
    }
  }

  validation() {
    /*if(_fromdatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select From Date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_fromTimecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select From Time...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_todatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select To Time...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_toTimecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select To Time...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/ /*if(date==todate){
      Fluttertoast.showToast(
      msg: "Please check Start & End date! Start date should be less than to End date...!",
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      );
    }else*/
    if (selectedDate.compareTo(selectedToDate) == 1) {
      Fluttertoast.showToast(
        msg:
            "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (selectedDate.month != selectedToDate.month) {
      Fluttertoast.showToast(
        msg:
            "Please check Start & End date! Start date and end date Month Will be Same...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (selectedvehicleno == "") {
      Fluttertoast.showToast(
        msg: "Please Select Vehicle Number...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else /* if(fromTime==toTime){
      Fluttertoast.showToast(
        msg: "Please check Start & End Time! Start Time should be less than to End Time...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/
    if (selectedfromdate == selectedTodate) {
      if (fromTime == toTime) {
        Fluttertoast.showToast(
          msg:
              "Please check Start & End Time! Start Time should be less than to End Time...!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      } else {
        getVehicleStatus();
      }
    } else {
      /*  Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );*/
      // Navigator.pop(context);
      getVehicleStatus();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // firstDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now());
    if (picked != null /*&& picked != selectedDate*/) {
      setState(() {
        selectedDate = picked;
        _fromdatecontroller.text = selectedDate.day.toString() +
            "/" +
            selectedDate.month.toString() +
            "/" +
            selectedDate.year.toString();
        // date=selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();
        date = Jiffy(selectedDate).format('d-MMMM-yyyy');
        print(date);
      });
    }
  }

  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        // firstDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now());
    if (picked != null /* && picked != selectedToDate*/) {
      setState(() {
        selectedToDate = picked;
        _todatecontroller.text = selectedToDate.day.toString() +
            "/" +
            selectedToDate.month.toString() +
            "/" +
            selectedToDate.year.toString();
        // todate=selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();
        todate = Jiffy(selectedToDate).format('d-MMMM-yyyy');
        print(todate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null /* && timeOfDay != selectedTime*/) {
      setState(() {
        selectedTime = timeOfDay;
        _fromTimecontroller.text =
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString();
        fromTime =
            selectedTime.hour.toString() + ":" + selectedTime.minute.toString();
        print(selectedTime);
      });
    }
  }

  Future<void> _selectToTime(BuildContext context) async {
    TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedToTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if (timeOfDay != null /* && timeOfDay != selectedToTime*/) {
      setState(() {
        selectedToTime = timeOfDay;
        _toTimecontroller.text = selectedToTime.hour.toString() +
            ":" +
            selectedToTime.minute.toString();
        print(selectedToTime);
        toTime = selectedToTime.hour.toString() +
            ":" +
            selectedToTime.minute.toString();
      });
    }
  }

  void _filterAlertList() async {
    filterVehicleStatusResult = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => BlocProvider(
                create: (context) {
                  return MainBloc(webService: WebService());
                },
                child: VehicleStatusFilterScreen(
                  fromdate: date,
                  fromTime: fromTime,
                  todate: todate,
                  toTime: toTime,
                ))));

    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('VehicleHistoryFilterList')) {
      setState(() {
        vehiclehistoryfilterdata =
            filterVehicleStatusResult["VehicleHistoryFilterList"];
        print(
            "Vehicle Status list : ${filterVehicleStatusResult["VehicleHistoryFilterList"]}");
        if (vehiclehistoryfilterdata!.length != 0) {
          isFilterAlertSearch = true;
        } else {
          isFilterAlertSearch = false;
        }
      });
    }
    //
    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('FilterAlert')) {
      setState(() {
        print(filterVehicleStatusResult["FilterAlert"]);
        selectedvehicleStatuslist.clear();
        vehiclehistoryfilterdata!.clear();
        FilterPageNumber = 0;
        isFilterAlertSearch = false;
      });
    }

    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('SearchFilter')) {
      searchFilter = filterVehicleStatusResult["SearchFilter"];
    }

    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('SearchText')) {
      searchText = filterVehicleStatusResult["SearchText"];
    }
    //
    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('FilterPageNumber')) {
      setState(() {
        FilterPageNumber = filterVehicleStatusResult["FilterPageNumber"];
      });
    }

    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('SelectedVehicleStatusList')) {
      selectedvehicleStatuslist =
          filterVehicleStatusResult["SelectedVehicleStatusList"];
    }

    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('SelectedVendorId')) {
      selectedVendorid = filterVehicleStatusResult["SelectedVendorId"];
    }
    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('SelectedBranchId')) {
      selectedbranchid = filterVehicleStatusResult["SelectedBranchId"];
    }
    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('SelectedVehicleList')) {
      selectedvehicleSrNolist =
          filterVehicleStatusResult["SelectedVehicleList"];
    }
    if (filterVehicleStatusResult != null &&
        filterVehicleStatusResult.containsKey('TotalFilterRecord')) {
      setState(() {
        totalVehicleHistoryFilterRecords =
            filterVehicleStatusResult["TotalFilterRecord"];
      });
    }
  }

  _validationfiltervehicle() async {
    // print(date+"  "+todate);
    // print(fromTime+"  "+toTime);

    /* if(date==''  && todate==''){
      Fluttertoast.showToast(
        msg:"Please select from Date & to Date",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else  if(fromTime=='' && toTime==''){
      Fluttertoast.showToast(
        msg:"Please select from Time & to Time",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/ /*else if(selectedDate.compareTo(selectedToDate)==1){
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/
    /*else if(date==todate*/ /*selectedDate.month!=selectedToDate.month*/ /*){
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/
    if (selectedfromdate == selectedTodate) {
      if (fromTime == toTime) {
        Fluttertoast.showToast(
          msg:
              "Please check Start & End Time! Start Time should be less than to End Time...!",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      } else {
        _filterAlertList();
      }
    } else {
      _filterAlertList();
    }
  }
}
