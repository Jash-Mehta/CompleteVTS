import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/alert/all_alert_master_response.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:file_picker/src/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/report/search_vehicle_status_summary.dart';
import '../../model/report/vehicle_status_summary.dart';
import '../../model/report/vehicle_status_summary_drivercode.dart';
import '../../model/report/vehicle_summary_filter.dart';
import '../../model/report/vehicle_summary_filtersearch.dart';
import '../../model/report/vehicle_vsrno.dart';
import '../../model/searchString.dart';
import '../../model/travel_summary/travel_summary.dart';
import '../../util/search_bar_field.dart';
import 'package:csv/csv.dart';

class VehicleStatusSummary extends StatefulWidget {
  const VehicleStatusSummary({Key? key}) : super(key: key);

  @override
  _VehicleStatusSummaryState createState() => _VehicleStatusSummaryState();
}

class _VehicleStatusSummaryState extends State<VehicleStatusSummary> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  bool isfilter = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int filpageNumber = 1;
  int pageSize = 10;
  int value = 0;
  late String srNo = "";
  late String vehicleRegNo = "";
  late String branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 1, vendorid = 1;
  String fromTime = "08:30",
      toDate = "30-sep-2022",
      fromDate = "01-sep-2022",
      toTime = "18:30";
  int imeino = 867322033819244;
  String arai = "arai";

  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController,
      vehiclenumber;
  int pagenumber = 1;
  int pagesize = 10;
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
  TextEditingController fromTimeInput = TextEditingController();
  TextEditingController toTimrInput = TextEditingController();
  String arainonari = "arai";
  String frampacketoption = "loginpacket";
  String searchtext = "MH12";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  SearchStringClass searchClass = SearchStringClass(searchStr: '');

  bool isSelected = false;

  late bool isdmdc = false;
  List<StatusSummaryData> pdfdatalist = [];
  List<VehicleSummaryFilterData> pdffilterlist = [];
  List<DatewiseStatusWiseTravelSummaryDatum> pdfsearchlist = [];
  List<StatusSummaryData>? data = [];
  List<DatewiseStatusWiseTravelSummaryDatum>? searchData = [];
  List<VehSummaryFilterSearchData>? filtersearchData = [];
  List<VehicleSummaryFilterData>? filterData = [];
  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  List<Datum>? allVehicleDetaildatalist = [];
  // List<Data>? searchData=[];
  // List<VehicleVSrNoData>? osvfdata = [];
  List<VehicleStatusSummaryDriverCode>? osvfdata = [];
  bool isvsrdc = false;
  var vsrdcvehicleno;
  var vsrdcvsrnolisttiletext;

  bool isDataAvailable = false;
  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');

  late String userName = "";
  late String vendorName = "",
      latitude = "",
      longitude = "",
      address = "",
      transDate = "",
      transTime = "",
      speed = "",
      overSpeed = "",
      updatedOn = "",
      distancetravel = "",
      speedLimit = "",
      searchText = "";

  bool applyclicked = false;
  var vendoritems = [
    'M-Tech',
    'M-Phasis',
    'Info',
    'M&M',
  ];
  String dropdownvalue1 = 'M-Tech';

  var branchitems = [
    'Hinjewadi',
    'Hadpsar',
    'Moshi',
    'Kharadi',
  ];

  String dropdownvalue2 = 'Hinjewadi';
  var deviceitems = [
    'All',
    'DC00001',
    'DC00002',
    'DC00003',
    'DC00004',
    'DC00005',
    'DC00006',
    'DC00007',
    'DC00008',
  ];
  String dropdownvalue3 = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataVS();
    notificationController.addListener(() {
      if (notificationController.position.maxScrollExtent ==
          notificationController.offset) {
        setState(() {
          // getdataVS();
          getallbranch();
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
  }

  getdataVS() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "" || vendorid != 0 || branchid != 0) {
      print(token);
      getallbranch();
      // getTravelSummaryFilter();
      setState(() {});
    } else {
      print("null");
    }
  }

  getallbranch() {
    _mainBloc.add(vehicleStatusSummaryEvent(
        token: token,
        vendorId: vendorid,
        branchid: branchid,
        araino: arai,
        fromdate: fromDate,
        fromTime: fromTime,
        toDate: toDate,
        toTime: toTime,
        imeno: imeino,
        pagenumber: pageNumber,
        pagesize: pageSize));
  }

  String formatDuration(String durationString) {
    List<String> components = durationString.split(', ');

    int hours = int.parse(components[0].split(' ')[0]);
    int minutes = int.parse(components[1].split(' ')[0]);
    int seconds = int.parse(components[2].split(' ')[0]);

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String durationString = vsstotalhrs ?? "585 Hours, 45 Minutes, 02 Seconds";
  // String durationString = vsstotalhrs ?? "585 Hours, 45 Minutes, 02 Seconds";

  // late SharedPreferences sharedPreferences;
  // late String token="";
  // late int branchid=0,vendorid=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter ? Text("VEHICLE STATUS SUMMARY ") : Text("Filter"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isfilter = true;
                isSearch = false;
                searchController.text = "";
                toTimrInput.text = "";
                todateInput.text = "";
                fromTimeInput.text = "";
                fromdateInput.text = "";
                vsrdcvsrnolisttiletext = "";
                isfilter
                    ? _mainBloc.add(VehicleStatusSummaryDrivercode(
                        token: token, vendorId: 1, branchId: 1))
                    // _mainBloc.add(VehicleVSrNoEvent(
                    //     token: token, vendorId: 1, branchId: 1))
                    : Text("Driver code not loaded");
              });
            },
            child: !isfilter
                ? Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "assets/filter.png",
                      height: 40,
                      width: 40,
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(right: 10),
                    child: IconButton(
                        onPressed: () {
                          setState(() {
                            isfilter = false;
                            searchController.text = "";
                          });
                        },
                        icon: Icon(Icons.close))),
          )
        ],
      ),
      body: _vehicleMaster(),
    );
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
      print("token ${token}");
    }
    if (sharedPreferences.getInt("SrNo") != null) {
      vendorid = sharedPreferences.getInt("SrNo")!;
    }
    if (sharedPreferences.getInt("vehicleRegNo") != null) {
      vendorid = sharedPreferences.getInt("vehicleRegNo")!;
    }
    if (sharedPreferences.getInt("imeino") != null) {
      branchid = sharedPreferences.getInt("imeino")!;
    }
    if (sharedPreferences.getString("latitude") != null) {
      userName = sharedPreferences.getString("latitude")!;
    }
    if (sharedPreferences.getString("longitude") != null) {
      vendorName = sharedPreferences.getString("longitude")!;
    }
    if (sharedPreferences.getString("address") != null) {
      branchName = sharedPreferences.getString("address")!;
    }
    if (sharedPreferences.getString("transDate") != null) {
      userType = sharedPreferences.getString("transDate")!;
    }
    if (sharedPreferences.getString("transTime") != null) {
      userType = sharedPreferences.getString("transTime")!;
    }
    if (sharedPreferences.getString("speed") != null) {
      userType = sharedPreferences.getString("speed")!;
    }
    if (sharedPreferences.getString("overSpeed") != null) {
      userType = sharedPreferences.getString("overSpeed")!;
    }
    if (sharedPreferences.getString("updatedOn") != null) {
      userType = sharedPreferences.getString("updatedOn")!;
    }
    if (sharedPreferences.getString("distancetravel") != null) {
      userType = sharedPreferences.getString("distancetravel")!;
    }
    if (sharedPreferences.getString("speedLimit") != null) {
      userType = sharedPreferences.getString("speedLimit")!;
    }
    if (sharedPreferences.getString("searchText") != null) {
      userType = sharedPreferences.getString("searchText")!;
    }

    print("branchid ${branchid}   Vendor id   ${vendorid}");

    //print(""+vendorid.toString()+" "+branchid.toString()+" "+userName+" "+vendorName+" "+branchName+" "+userType);
  }

  _vehicleMaster() {
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
          // if (state is VehicleVSrNoLoadingState) {
          //   const Center(
          //     child: CircularProgressIndicator(),
          //   );
          // } else if (state is VehicleVSrNoLoadedState) {
          //   if (state.vehiclevsrnoresponse.data != null) {
          //     print("overspeed vehicle filter data is Loaded state");
          //     osvfdata!.clear();
          //     osvfdata!.addAll(state.vehiclevsrnoresponse.data!);

          //     // overspeedfilter!.addAll(state.overspeedFilter.data!);
          //     osvfdata!.forEach((element) {
          //       print("Overspeed vehicle filter element is Printed");
          //     });
          //   }
          // } else if (state is VehicleVSrNoErorrState) {
          //   print("Something went Wrong  data VehicleVSrNoErorrState");
          //   Fluttertoast.showToast(
          //     msg: state.msg,
          //     toastLength: Toast.LENGTH_SHORT,
          //     timeInSecForIosWeb: 1,
          //   );
          // }

          if (state is VehicleStatusSummaryDriverCodeLoadingState) {
            const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is VehicleStatusSummaryDriverCodeLoadedState) {
            if (state.dmfdriverCoderesponse.data != null) {
              print("overspeed vehicle filter data is Loaded state");
              osvfdata!.clear();
              osvfdata!.addAll(state.dmfdriverCoderesponse.data!);
            }
          } else if (state is VehicleStatusSummaryDriverCodeErorrState) {
            print("Something went Wrong  data VehicleVSrNoErorrState");
            Fluttertoast.showToast(
              msg: state.msg,
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          }
          if (state is VehicleStatusSummaryLoadingState) {
            print("Entering in Loading State");
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleStatusSummaryLoadedState) {
            if (state.VehicleStatusSummaryResponse.data != null) {
              pageNumber++;
              print("Entering in Loaded State");
              setState(() {
                _isLoading = false;
                value = state.VehicleStatusSummaryResponse.totalRecords!;
              });
              data!.addAll(state.VehicleStatusSummaryResponse.data!);
            }
          } else if (state is VehicleStatusSummaryErrorState) {
            print("Entering in Error State");
            setState(() {
              _isLoading = false;
            });
          }
          // filter
          if (state is VehicleSummaryFilterLoadingState) {
            print("Vehicle Status Group filter Loading");
          } else if (state is VehicleSummaryFilterLoadedState) {
            print("Entering in Vehicle Status Group filter Loaded state");
            // filterData!.clear();
            // filterData!.addAll(state.vehiclesummaryFilterresponse.data!);
            if (state.vehiclesummaryFilterresponse.data != null) {
              setState(() {
                _isLoading = false;
                filterData!.clear();
                value = state.vehiclesummaryFilterresponse.totalRecords!;
              });
              filterData!.addAll(state.vehiclesummaryFilterresponse.data!);
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          } else if (state is VehicleSummaryFilterErorrState) {
            print("Vehicle Status Group filter Error");
          }
          //! Search vehicle-------------------
          if (state is SearchVehicleStatusSummaryLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is SearchVehicleStatusSummaryLoadedState) {
            // setState(() {
            //   _isLoading = false;
            //   searchData!.clear();
            // });
            // searchData!.addAll(state.searchVehicleStatusGroupResponse.data!);
            if (state.searchVehicleStatusGroupResponse.data != null) {
              setState(() {
                _isLoading = false;
                searchData!.clear();
                value = state.searchVehicleStatusGroupResponse.totalRecords!;
              });
              searchData!.addAll(state.searchVehicleStatusGroupResponse.data!);
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          } else if (state is SearchVehicleStatusSummaryErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
           // filter search
           if (state is VehSummaryFilterSearchLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehSummaryFilterSearchLoadedState) {
            if (state.searchvehicleSummaryResponse.data != null) {
              print("Entering in filter search Loaded state");
              setState(() {
                _isLoading = false;
                filtersearchData!.clear();
                value = state.searchvehicleSummaryResponse.totalRecords!;
              });
              filtersearchData!.addAll(state.searchvehicleSummaryResponse.data!);
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          } else if (state is VehSummaryFilterSearchErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: isfilter
            ? SingleChildScrollView(
                // controller: notificationController,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  //left: 8, top: 16.0, right: 8.0),
                  child: Container(
                    margin: const EdgeInsets.all(0.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: const Text(
                                        "Filter",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: MyColors.blackColorCode),
                                      ),
                                      onPressed: () {},
                                    ),
                                    TextButton(
                                      child: const Text(
                                        "Clear",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 18),
                                      ),
                                      onPressed: () {
                                        toTimrInput.text = "";
                                        todateInput.text = "";
                                        fromTimeInput.text = "";
                                        fromdateInput.text = "";
                                        vsrdcvsrnolisttiletext = "";
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  // applyFilter();
                                },
                                child: Container(
                                    height: 36,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.0),
                                      color: /*isapplybtnvisible ?*/ Colors
                                          .blue, /*: MyColors.blueColorCode.withOpacity(0.5)*/
                                    ),
                                    child: TextButton(
                                        child: const Text("Apply",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          searchController.text = "";
                                          if (fromDateController != null &&
                                              fromTimeController != null &&
                                              toDateController != null &&
                                              toTimeController != null &&
                                              vsrdcvehicleno != null &&
                                              fromdateInput.text.isNotEmpty &&
                                              todateInput.text.isNotEmpty &&
                                              fromTimeInput.text.isNotEmpty &&
                                              toTimrInput.text.isNotEmpty) {
                                            _mainBloc
                                                .add(vehicleSummaryFilterEvent(
                                              token: token,
                                              vendorId: branchid,
                                              branchid: vendorid,
                                              araino: arai,
                                              fromdate: fromDateController,
                                              fromTime: fromTime,
                                              toDate: toDateController,
                                              toTime: toTime,
                                              vehiclelist: vsrdcvehicleno
                                                          .toString() ==
                                                      null
                                                  ? "ALL"
                                                  : vsrdcvehicleno.toString(),
                                              pagenumber: 1,
                                              pagesize: 200,
                                            ));
                                            setState(() {
                                              isfilter = false;
                                              applyclicked = true;
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Enter required fields..!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              timeInSecForIosWeb: 1,
                                            );
                                          }
                                        })),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Vendor Name",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3.0),
                                          child: Text("*",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      MyColors.redColorCode)),
                                        )
                                      ],
                                    ),
                                  )),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    color: MyColors.boxBackgroundColorCode,
                                    border: Border.all(
                                        color: MyColors.textBoxBorderColorCode,
                                        width: 2)),
                                child: IgnorePointer(
                                  ignoring: true,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    focusColor: Colors.white70,
                                    value: dropdownvalue1,
                                    menuMaxHeight: 300,
                                    onChanged: (value) {
                                      // setState(() {
                                      //   dropdownvalue1 = value!.toString();
                                      //   isvalue = true;
                                      // });
                                      // _mainBloc.add(FilterDeviceMasterReportEvent(
                                      //     token: token,
                                      //     vendorid: vendorid,
                                      //     branchid: branchid,
                                      //     pageNumber: pageNumber,
                                      //     pageSize: pagesize,
                                      //     deviceNumber: deviceNo));
                                    },
                                    items: vendoritems.map((String items) {
                                      return DropdownMenuItem(
                                        enabled: false,
                                        value: items,
                                        child: Container(
                                            padding: EdgeInsets.only(left: 10),
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                58,
                                            child: Text(items,
                                                style:
                                                    TextStyle(fontSize: 18))),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20, top: 10)),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Branch Name",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3.0),
                                          child: Text("*",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      MyColors.redColorCode)),
                                        )
                                      ],
                                    ),
                                  )),
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: MyColors.boxBackgroundColorCode,
                                      border: Border.all(
                                          color:
                                              MyColors.textBoxBorderColorCode,
                                          width: 2)),
                                  child: IgnorePointer(
                                    ignoring: true,
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      value: dropdownvalue2,
                                      menuMaxHeight: 300,
                                      onChanged: (value) {
                                        // setState(() {
                                        //   dropdownvalue2 = value!.toString();
                                        //   isvalue = true;
                                        // });
                                        // _mainBloc.add(FilterDeviceMasterReportEvent(
                                        //     token: token,
                                        //     vendorid: vendorid,
                                        //     branchid: branchid,
                                        //     pageNumber: pageNumber,
                                        //     pageSize: pagesize,
                                        //     deviceNumber: deviceNo));
                                      },
                                      items: branchitems.map((String items) {
                                        return DropdownMenuItem(
                                          enabled: false,
                                          value: items,
                                          child: Container(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  58,
                                              child: Text(items,
                                                  style:
                                                      TextStyle(fontSize: 18))),
                                        );
                                      }).toList(),
                                    ),
                                  )),
                              Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20, top: 10)),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "Vehicle Number",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3.0),
                                          child: Text("*",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      MyColors.redColorCode)),
                                        )
                                      ],
                                    ),
                                  )),
                              Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: MyColors.whiteColorCode,
                                      border: Border.all(
                                          color:
                                              MyColors.textBoxBorderColorCode,
                                          width: 2)),
                                  child: ListTile(
                                    leading: Text(
                                      vsrdcvsrnolisttiletext == ""
                                          ? "-select-"
                                          : vsrdcvsrnolisttiletext,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: isdmdc
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.keyboard_arrow_up,
                                            ),
                                            onPressed: () {
                                              isdmdc = false;
                                              setState(() {});
                                            },
                                          )
                                        : IconButton(
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            onPressed: () {
                                              isdmdc = true;
                                              setState(() {});
                                            },
                                          ),
                                  )),
                              isdmdc
                                  ? Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              blurRadius: 5.0, spreadRadius: 1),
                                        ],
                                        color: Colors.white,
                                        //  boxShadow:
                                      ),
                                      height: 200,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemCount: osvfdata!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var article = osvfdata![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              child: Text(
                                                article.vehicleRegNo!,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onTap: () {
                                                print(article.vehicleRegNo);
                                                setState(() {
                                                  isdmdc = false;
                                                  vsrdcvsrnolisttiletext =
                                                      article.vehicleRegNo
                                                          .toString();
                                                  vsrdcvehicleno =
                                                      article.vehicleRegNo ==
                                                              "ALL"
                                                          ? "ALL"
                                                          : article.imeiNo
                                                              .toString();
                                                  print("This is vehicleregno - " +
                                                      vsrdcvsrnolisttiletext);
                                                  print("This is imeino - " +
                                                      vsrdcvehicleno);
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox(),
                              Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 20, top: 10)),
                              Container(
                                height: 310,
                                width: MediaQuery.of(context).size.width - 20,
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: const EdgeInsets.only(
                                            top: 2.0, bottom: 10),
                                        child: Text(
                                          "From Date/Time",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        // ignore: prefer_const_literals_to_create_immutables
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: TextField(
                                              // onChanged: (value) {
                                              //   fromDateController = value;
                                              // },
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1950),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (pickedDate != null) {
                                                  print(pickedDate);
                                                  String formattedDate =
                                                      DateFormat('dd-MMM-yyyy',
                                                              'en_US')
                                                          .format(pickedDate);
                                                  formattedDate = formattedDate
                                                      .replaceRange(
                                                          3,
                                                          6,
                                                          formattedDate
                                                              .substring(3, 6)
                                                              .toLowerCase());
                                                  print(
                                                      "FormatDate is Set-----------");
                                                  print(formattedDate);
                                                  fromDateController =
                                                      formattedDate;
                                                  setState(() {
                                                    fromdateInput.text =
                                                        fromDateController;
                                                  });
                                                } else {}
                                              },
                                              controller: fromdateInput,
                                              enabled: true,
                                              readOnly: true,
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    MyColors.whiteColorCode,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: MyColors
                                                          .buttonColorCode),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.orange),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: MyColors
                                                          .textColorCode),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                    )),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: MyColors
                                                            .textBoxBorderColorCode)),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: MyColors
                                                                .buttonColorCode)),
                                                hintText: "DD/MM/YY",
                                                suffixIcon: Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 24,
                                                  color: MyColors
                                                      .dateIconColorCode,
                                                ),
                                                hintStyle: TextStyle(
                                                    fontSize: 18,
                                                    color: MyColors
                                                        .searchTextColorCode),
                                                errorText: "",
                                              ),
                                              // controller: _passwordController,
                                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                                              obscureText: false,
                                            ),
                                          ),
                                          // ignore: prefer_const_constructors
                                          Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: TextField(
                                                // onChanged: (value) {
                                                //   fromTimeController = value;
                                                // },
                                                onTap: () async {
                                                  final DateFormat formatter =
                                                      DateFormat(
                                                          'H:mm',
                                                          Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .toLanguageTag());
                                                  final TimeOfDay? picked =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now());
                                                  builder:
                                                  (BuildContext context,
                                                      Widget? child) {
                                                    return MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                alwaysUse24HourFormat:
                                                                    true),
                                                        child: child!);
                                                  };
                                                  if (picked != null) {
                                                    final String fromTime =
                                                        formatter.format(
                                                            DateTime(
                                                                0,
                                                                1,
                                                                1,
                                                                picked.hour,
                                                                picked.minute));
                                                    fromTimeController =
                                                        fromTime;
                                                    setState(() {
                                                      fromTimeInput.text =
                                                          fromTimeController;
                                                    });
                                                  }
                                                },
                                                readOnly: true,
                                                enabled:
                                                    true, // to trigger disabledBorder
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor:
                                                      MyColors.whiteColorCode,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: MyColors
                                                            .buttonColorCode),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.orange),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: MyColors
                                                            .textColorCode),
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)),
                                                      borderSide: BorderSide(
                                                        width: 1,
                                                      )),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: MyColors
                                                              .textBoxBorderColorCode)),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color: MyColors
                                                                  .buttonColorCode)),
                                                  hintText: "hh:mm:AM",
                                                  suffixIcon: Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 24,
                                                    color: MyColors
                                                        .dateIconColorCode,
                                                  ),
                                                  hintStyle: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .searchTextColorCode),
                                                  errorText: "",
                                                ),
                                                controller: fromTimeInput,
                                                // controller: _passwordController,
                                                // onChanged: _authenticationFormBloc.onPasswordChanged,
                                                obscureText: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            top: 2.0, bottom: 10),
                                        child: Text(
                                          "To Date/Time",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: TextField(
                                              // onChanged: (value) {
                                              //   toDateController = value;
                                              // },
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                        context: context,
                                                        initialDate:
                                                            DateTime.now(),
                                                        firstDate:
                                                            DateTime(1950),
                                                        lastDate:
                                                            DateTime(2100));

                                                if (pickedDate != null) {
                                                  print(pickedDate);
                                                  String toDate = DateFormat(
                                                          'dd-MMM-yyyy',
                                                          'en_US')
                                                      .format(pickedDate);
                                                  toDate = toDate.replaceRange(
                                                      3,
                                                      6,
                                                      toDate
                                                          .substring(3, 6)
                                                          .toLowerCase());
                                                  print(
                                                      "toDate is Set-----------");
                                                  toDateController = toDate;
                                                  setState(() {
                                                    todateInput.text =
                                                        toDateController;
                                                  });
                                                } else {}
                                              },
                                              enabled: true,
                                              readOnly: true,
                                              controller:
                                                  todateInput, // to trigger disabledBorder
                                              decoration: const InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    MyColors.whiteColorCode,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: MyColors
                                                          .buttonColorCode),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.orange),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: MyColors
                                                          .textColorCode),
                                                ),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                      width: 1,
                                                    )),
                                                errorBorder: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: MyColors
                                                            .textBoxBorderColorCode)),
                                                focusedErrorBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    4)),
                                                        borderSide: BorderSide(
                                                            width: 2,
                                                            color: MyColors
                                                                .buttonColorCode)),
                                                hintText: "DD/MM/YY",
                                                suffixIcon: Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 24,
                                                  color: MyColors
                                                      .dateIconColorCode,
                                                ),
                                                hintStyle: TextStyle(
                                                    fontSize: 18,
                                                    color: MyColors
                                                        .searchTextColorCode),
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
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: TextField(
                                                onTap: () async {
                                                  final DateFormat formatter =
                                                      DateFormat(
                                                          'H:mm',
                                                          Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .toLanguageTag());
                                                  final TimeOfDay? picked =
                                                      await showTimePicker(
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now());
                                                  builder:
                                                  (BuildContext context,
                                                      Widget? child) {
                                                    return MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                alwaysUse24HourFormat:
                                                                    true),
                                                        child: child!);
                                                  };
                                                  if (picked != null) {
                                                    final String toTime =
                                                        formatter.format(
                                                            DateTime(
                                                                0,
                                                                1,
                                                                1,
                                                                picked.hour,
                                                                picked.minute));
                                                    toTimeController = toTime;
                                                    setState(() {
                                                      toTimrInput.text =
                                                          toTimeController;
                                                    });
                                                  }
                                                },
                                                readOnly: true,
                                                enabled:
                                                    true, // to trigger disabledBorder
                                                decoration:
                                                    const InputDecoration(
                                                  filled: true,
                                                  fillColor:
                                                      MyColors.whiteColorCode,
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: MyColors
                                                            .buttonColorCode),
                                                  ),
                                                  disabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: Colors.orange),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: MyColors
                                                            .textColorCode),
                                                  ),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)),
                                                      borderSide: BorderSide(
                                                        width: 1,
                                                      )),
                                                  errorBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  4)),
                                                      borderSide: BorderSide(
                                                          width: 1,
                                                          color: MyColors
                                                              .textBoxBorderColorCode)),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                          borderSide: BorderSide(
                                                              width: 2,
                                                              color: MyColors
                                                                  .buttonColorCode)),
                                                  hintText: "hh:mm:AM",
                                                  suffixIcon: Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 24,
                                                    color: MyColors
                                                        .dateIconColorCode,
                                                  ),
                                                  hintStyle: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .searchTextColorCode),
                                                  errorText: "",
                                                ),
                                                controller: toTimrInput,
                                                obscureText: false,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                controller: notificationController,
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 2,
                                  color: MyColors.shadowGreyColorCode)
                            ]),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: MyColors.analyticActiveColorCode,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      //  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                                      // FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions:FileType.custom(), );
                                      // final result = await FilePicker.platform
                                      //     .pickFiles(
                                      //         type: FileType.custom,
                                      //         allowedExtensions: ['pdf']);
                                      // FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions:FileType.custom(), );
                                      try {
                                        // List<String>? files = result?.files
                                        //     .map((file) => file.path)
                                        //     .cast<String>()
                                        //     .toList();
                                        // print("File path------${files}");
                                        //    List<String>? files = [
                                        //   "/data/user/0/com.vts.gps/cache/file_picker/DTwisereport.pdf"
                                        // ];
                                        // print("File path------${files}");
                                        shareDeviceData(
                                            data!,
                                            filterData!,
                                            applyclicked,
                                            searchData!,
                                            isSearch);
                                        Navigator.of(context).popUntil(
                                            (route) => route.isCurrent);
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: "Download the pdf first",
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 6.0,
                                          left: 15,
                                          right: 15,
                                          bottom: 6),
                                      decoration: BoxDecoration(
                                          color:
                                              MyColors.analyticActiveColorCode,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.file_copy_outlined,
                                            color: Colors.black,
                                          ),
                                          Text(
                                            "Export",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                pdfdatalist.clear();
                                pdfdatalist.addAll(data!);
                                pdffilterlist.clear();
                                pdffilterlist.addAll(filterData!);
                                pdfsearchlist.clear();
                                pdfsearchlist.addAll(searchData!);
                                setState(() {});

                                var status = await Permission.storage.status;
                                if (await Permission.storage
                                    .request()
                                    .isGranted) {
                                  final pdfFile = await PdfInvoiceApi.generate(
                                      pdfdatalist,
                                      pdffilterlist,
                                      applyclicked,
                                      pdfsearchlist,
                                      isSearch,
                                      fromDateController,
                                      toDateController);
                                  PdfApi.openFile(pdfFile);
                                } else {
                                  print("Request is not accepted");
                                  await Permission.storage.request();
                                }

                                // if (status.isDenied) {
                                // }
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 15),
                                padding: const EdgeInsets.only(
                                    top: 6.0, left: 15, right: 15, bottom: 6),
                                decoration: const BoxDecoration(
                                    color: MyColors.analyticActiveColorCode,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.file_copy_sharp,
                                      color: Colors.black,
                                    ),
                                    Text(
                                      "Download",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 15, right: 15, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBarScreen(
                              searchStrClass: searchClass,
                              controller: searchController,
                              onChanged: onSearchTextChanged),
                               (applyclicked && isSelected)
                              ? BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                  return Text(
                                    filtersearchData!.isEmpty
                                        ? ""
                                        : filtersearchData!.length.toString() +
                                            " Records found",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  );
                                })
                              :
                          applyclicked
                              ? BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                  return Text(
                                    filterData!.isEmpty
                                        ? ""
                                        : filterData!.length.toString() +
                                            " Filter Records found",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  );
                                })
                              : isSelected
                                  ? Text(
                                      searchData!.isEmpty
                                          ? ""
                                          : searchData!.length.toString() +
                                              " Search Records found",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : BlocBuilder<MainBloc, MainState>(
                                      builder: (context, state) {
                                      return Text(
                                        data!.length.toString() +
                                            " Records found",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 20),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                                color: MyColors.bluereportColorCode,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("From Date  ",
                                        style: TextStyle(fontSize: 18)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(" -  To Date",
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        fromDateController != null
                                            ? fromDateController + "  -  "
                                            : "01-sep-2022" + " - ",
                                        style: TextStyle(fontSize: 18)),
                                    Text(
                                        toDateController != null
                                            ? toDateController
                                            : "30-sep-2022",
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "VehicleRegNo",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                                vsrdcvsrnolisttiletext == null
                                                    ? "-"
                                                    : vsrdcvsrnolisttiletext,
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Speed Limit",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text("-",
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //         Padding(
                          //   padding: EdgeInsets.all(8),
                          //   child: Column(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Text(
                          //           "Group By(${vsrdcvsrnolisttiletext ?? "-"}) Total :- " +
                          //                         formatDuration(
                          //                             durationString),
                          //           // gbvehregth==null ? "-" : gbvehregth,
                          //           style: TextStyle(
                          //               fontSize: 18,
                          //               fontWeight: FontWeight.w600),
                          //         ),
                          //       ),
                          //       Text(
                          //         "Group By ( ${fromDateController ?? "01-sep-2022"} ) Total :-"
                          //        +formatDuration(
                          //                             durationString),
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //       Text(
                          //         "Total Over Speed Distance :- "+formatDuration(durationString),
                          //         //  vsrtotalhrs ==null ? "-" : vsrtotalhrs,
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             fontWeight: FontWeight.w600),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                         ( applyclicked && isSelected)
                              ? filtersearchData!.isEmpty
                                  ? Center(
                                      child: Text(
                                      "No data found",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ))
                                  : _isLoading
                                      ? Center(
                                          child: Text("Wait data is Loading.."))
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child:
                                              BlocBuilder<MainBloc, MainState>(
                                                  builder: (context, state) {
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                controller:
                                                    vehicleRecordController,
                                                itemCount: filtersearchData!.length,
                                                itemBuilder: (context, index) {
                                                  var article =
                                                      filtersearchData![index];
                                                  var sr = index + 1;
                                                  return Card(
                                                    margin: EdgeInsets.only(
                                                        bottom: 15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: MyColors
                                                              .textBoxBorderColorCode),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 15,
                                                          left: 14,
                                                          right: 14,
                                                          bottom: 15),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        // controller: overSpeedScrollController,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  left: 15,
                                                                  right: 15,
                                                                  bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Sr.No",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            sr.toString(),
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Date",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .tDate!,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "IMEI",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 10.0),
                                                                            child:
                                                                                Text(
                                                                              article.imei!,
                                                                              style: TextStyle(color: MyColors.text5ColorCode, fontSize: 16),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Vehicle Reg No",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .vehicleregNo!,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Vehicle Status",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.vehicleStatus!,
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Vehicle Status Time",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .vehicleStatusTime!,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }))
                              :
                          applyclicked
                              ? filterData!.isEmpty
                                  ? Center(
                                      child: Text(
                                      "No data found",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ))
                                  : _isLoading
                                      ? Center(
                                          child: Text("Wait data is Loading.."))
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child:
                                              BlocBuilder<MainBloc, MainState>(
                                                  builder: (context, state) {
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                controller:
                                                    vehicleRecordController,
                                                itemCount: filterData!.length,
                                                itemBuilder: (context, index) {
                                                  var article =
                                                      filterData![index];
                                                  var sr = index + 1;
                                                  return Card(
                                                    margin: EdgeInsets.only(
                                                        bottom: 15),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          width: 1,
                                                          color: MyColors
                                                              .textBoxBorderColorCode),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: Container(
                                                      padding: EdgeInsets.only(
                                                          top: 15,
                                                          left: 14,
                                                          right: 14,
                                                          bottom: 15),
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        // controller: overSpeedScrollController,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20.0,
                                                                  left: 15,
                                                                  right: 15,
                                                                  bottom: 20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Sr.No",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            sr.toString(),
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Date",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .tDate!,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "IMEI",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(right: 10.0),
                                                                            child:
                                                                                Text(
                                                                              article.imei!,
                                                                              style: TextStyle(color: MyColors.text5ColorCode, fontSize: 16),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Vehicle Reg No",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .vehicleregNo!,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "Vehicle Status",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.vehicleStatus!,
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                        child:
                                                                            Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Vehicle Status Time",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .vehicleStatusTime!,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ))
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                          }))
                              : !isSelected
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: BlocBuilder<MainBloc, MainState>(
                                          builder: (context, state) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            controller: vehicleRecordController,
                                            itemCount: data!.length,
                                            itemBuilder: (context, index) {
                                              var article = data![index];
                                              var sr = index + 1;
                                              return Card(
                                                margin:
                                                    EdgeInsets.only(bottom: 15),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: MyColors
                                                          .textBoxBorderColorCode),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      top: 15,
                                                      left: 14,
                                                      right: 14,
                                                      bottom: 15),
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: SingleChildScrollView(
                                                    // controller: overSpeedScrollController,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20.0,
                                                              left: 15,
                                                              right: 15,
                                                              bottom: 20),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    bottom: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Sr.No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        sr.toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Date",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .tDate!,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .text5ColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    bottom: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "IMEI",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .imei!,
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Vehicle Reg No",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .vehicleregNo!,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .text5ColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 15.0,
                                                                    bottom: 15),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Vehicle Status",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .vehicleStatus!,
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                    child:
                                                                        Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Vehicle Status Time",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .vehicleStatusTime!,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .text5ColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ],
                                                                ))
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      }))
                                  : searchData!.isEmpty
                                      ? Center(
                                          child: Text(
                                          "No data found",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w500),
                                        ))
                                      : _isLoading
                                          ? Center(
                                              child: Text(
                                                  "Wait data is Loading.."))
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0),
                                              child:
                                                  // (searchData!.length != 0 ||
                                                  //         searchData!.isNotEmpty)
                                                  //     ?
                                                  BlocBuilder<MainBloc, MainState>(
                                                      builder:
                                                          (context, state) {
                                                return ListView.builder(
                                                    shrinkWrap: true,
                                                    controller:
                                                        vehicleRecordController,
                                                    itemCount:
                                                        searchData!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      print(
                                                          "Search dat list length are:---${searchData!.length}");
                                                      var article =
                                                          searchData![index];

                                                      return Card(
                                                        margin: EdgeInsets.only(
                                                            bottom: 15),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          side: BorderSide(
                                                              width: 1,
                                                              color: MyColors
                                                                  .textBoxBorderColorCode),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 15,
                                                                  left: 14,
                                                                  right: 14,
                                                                  bottom: 15),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                          ),
                                                          child:
                                                              SingleChildScrollView(
                                                            // controller: overSpeedScrollController,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 20.0,
                                                                      left: 15,
                                                                      right: 15,
                                                                      bottom:
                                                                          20),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const Text(
                                                                                "Sr.No",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.srNo.toString(),
                                                                                style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            const Text(
                                                                              "Date",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.tDate.toString(),
                                                                              textAlign: TextAlign.left,
                                                                              style: const TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              const Text(
                                                                                "IMEI",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.imei.toString(),
                                                                                style: const TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Vehicle Reg No",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.vehicleregNo!,
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            15.0,
                                                                        bottom:
                                                                            15),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Vehicle Status",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.vehicleStatus.toString(),
                                                                                style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                            child:
                                                                                Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Vehicle Status Time",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.vehicleStatusTime.toString(),
                                                                              textAlign: TextAlign.left,
                                                                              style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                            ),
                                                                          ],
                                                                        ))
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              })
                                              // : Text(
                                              //     "Data Not Found..",
                                              //     style: TextStyle(
                                              //         fontSize: 18,
                                              //         fontWeight: FontWeight.bold),
                                              //   )
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

  String convertDataToCsv(
      List<StatusSummaryData> data,
      List<VehicleSummaryFilterData> filterdata,
      bool applyclicked,
      List<DatewiseStatusWiseTravelSummaryDatum> searchdata,
      bool issearch) {
    List<List<dynamic>> rows = [];
    // Add headers
    applyclicked
        ? rows.add(["Vehicle Status Summary Filter "])
        : issearch
            ? rows.add(["Vehicle Status Summary Search"])
            : rows.add(["Vehicle Status Summary Data"]);
    rows.add([
      "Date :- ${fromDateController != null ? fromDateController : "01-sep-2022"} - ${toDateController != null ? toDateController : "30-sep-2022"}"
    ]);
    rows.add([
      'SrNo',
      'IMEINo',
      'VendorRegNo',
      'Start TIme',
      'End Time',
      'Vehicle Status',
      'Vehicle Status Time'
    ]);

    // Add data rows
    if (applyclicked) {
      for (var item in filterdata) {
        // print("This is filter lenght");
        print("Filter data" + filterdata.toString());
        rows.add([
          item.srNo,
          item.imei,
          item.vehicleregNo,
          "-",
          "-",
          item.vehicleStatus,
          item.vehicleStatusTime,
        ]);
      }
    } else if (issearch) {
      for (var item in searchdata) {
        // print("This is filter lenght");
        print("Search data" + searchdata.toString());
        rows.add([
          item.srNo,
          item.imei,
          item.vehicleregNo,
          "-",
          "-",
          item.vehicleStatus,
          item.vehicleStatusTime,
        ]);
      }
    } else {
      for (var item in data) {
        // print("This is filter lenght");
        print("Filter data" + filterdata.toString());
        rows.add([
          item.srNo,
          item.imei,
          item.vehicleregNo,
          "-",
          "-",
          item.vehicleStatus,
          item.vehicleStatusTime,
        ]);
      }
    }
    return ListToCsvConverter().convert(rows);
  }

  Future<File> saveCsvFile(
      String csvFilterData, bool applyclicked, bool issearch) async {
    final directory = await getTemporaryDirectory();
    final filePath = issearch
        ? '${directory.path}/search_vehiclestatussummary.csv'
        : applyclicked
            ? '${directory.path}/Filter_vehiclestatussummary.csv'
            : '${directory.path}/vehiclestatussummary.csv';
    final file = File(filePath);
    return file.writeAsString(csvFilterData);
  }

  void shareCsvFile(File csvFilterFile) {
    Share.shareFiles([csvFilterFile.path],
        text: 'Sharing device data CSV file');
  }

  void shareDeviceData(
      List<StatusSummaryData> data,
      List<VehicleSummaryFilterData> filterdata,
      bool applyclicked,
      List<DatewiseStatusWiseTravelSummaryDatum> searchdata,
      bool issearch) async {
    String csvData =
        convertDataToCsv(data, filterdata, applyclicked, searchdata, issearch);
    File csvFile = await saveCsvFile(csvData, applyclicked, issearch);
    print("This is csv Filter data " + csvData);

    shareCsvFile(csvFile);
  }

  onSearchTextChanged(String? text) async {
    if (text!.isEmpty || text.length < 0) {
      setState(() {
        isSelected = false;
      });
      return;
    } else {
      if (text.isNotEmpty || text.length > 0) {
        setState(() {
          isSelected = true;
          _isLoading = true;
          searchClass.searchStr = text;
          _isLoading = false;
        });

        (applyclicked && isSelected)
            ? _mainBloc.add(VehSummaryFilterSearchEvent(
                token: token,
                vendorId: vendorid,
                branchid: branchid,
                araino: arai,
                fromdate: fromDate,
                fromTime: fromTime,
                toDate: toDate,
                toTime: toTime,
                imeino: vsrdcvehicleno,
                searchText: searchClass.searchStr,
                pagenumber: pageNumber,
                pagesize: pageSize,
              ))
            : isSelected
                ? _mainBloc.add(SearchvehicleStatusSummaryEvent(
                    token: token,
                    vendorId: vendorid,
                    branchid: branchid,
                    araino: arai,
                    fromdate: fromDate,
                    fromTime: fromTime,
                    toDate: toDate,
                    toTime: toTime,
                    searchText: searchClass.searchStr,
                    pagenumber: 1,
                    pagesize: 200))
                : Text("Filter Search Error");
      }
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(
      List<StatusSummaryData> pdflist,
      List<VehicleSummaryFilterData> pdffilter,
      bool applyclicked,
      List<DatewiseStatusWiseTravelSummaryDatum> pdfsearch,
      bool issearch,
      var fromDateController,
      var toDateController) async {
    final pdf = pw.Document();
    double fontsize = 8.0;
    DateTime current_date = DateTime.now();
    pdf.addPage(pw.MultiPage(
      // header: (pw.Context context) {
      //   return pw.Text("header");
      // },
      footer: (pw.Context context) {
        return pw.Column(children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                "Printed by : Techno",
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                "Page : ${context.pageNumber} of ${context.pagesCount}",
                textDirection: pw.TextDirection.ltr,
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.Row(
            children: [
              pw.Text(
                "Printed on : " + current_date.toString(),
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              )
            ],
          )
        ]);
      },
      pageFormat: PdfPageFormat.a5,
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text("VEHICLE STATUS SUMMARY REPORT",
                  style: pw.TextStyle(
                      fontSize: 20.0, fontWeight: pw.FontWeight.bold))),
          pw.Center(
              child: pw.Text(
                  "Date :- ${fromDateController != null ? fromDateController : "01-sep-2022"} - ${toDateController != null ? toDateController : "30-sep-2022"}",
                  style: pw.TextStyle(fontSize: 18.0))),
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 0.8),
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Sr No",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 5.0, left: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Date",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 5.0, left: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "IMEI NO",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 5.0, left: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Vehicle RegNo",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 5.0, left: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Vehicle Status",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, right: 5.0, left: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Vehicle Status Time",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                ])
              ],
            ),
          ),
          // pw.Expanded(
          //     child:
          pw.ListView.builder(
              itemBuilder: (pw.Context context, int index) {
                // var article = pdflist[index];
                var sr = index + 1;
                return pw.Table(
                    border:
                        pw.TableBorder.all(color: PdfColors.black, width: 0.8),
                    children: [
                      pw.TableRow(children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(sr.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(
                                applyclicked
                                    ? pdflist[index].tDate.toString()
                                    : issearch
                                        ? pdflist[index].tDate.toString()
                                        : pdflist[index].tDate.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(
                                applyclicked
                                    ? pdflist[index].imei.toString()
                                    : issearch
                                        ? pdflist[index].imei.toString()
                                        : pdflist[index].imei.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(
                                applyclicked
                                    ? pdflist[index].vehicleregNo.toString()
                                    : issearch
                                        ? pdflist[index].vehicleregNo.toString()
                                        : pdflist[index]
                                            .vehicleregNo
                                            .toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(
                                applyclicked
                                    ? pdffilter[index].vehicleStatus.toString()
                                    : issearch
                                        ? pdfsearch[index]
                                            .vehicleStatus
                                            .toString()
                                        : pdflist[index]
                                            .vehicleStatus
                                            .toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(
                                applyclicked
                                    ? pdflist[index]
                                        .vehicleStatusTime
                                        .toString()
                                    : issearch
                                        ? pdflist[index]
                                            .vehicleStatusTime
                                            .toString()
                                        : pdflist[index]
                                            .vehicleStatusTime
                                            .toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        // pw.Padding(
                        //   padding: pw.EdgeInsets.only(
                        //       left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                        //   child: pw.SizedBox(
                        //     width: 20,
                        //     child: pw.Text(article.address.toString(),
                        //         style: pw.TextStyle(fontSize: fontsize)),
                        //   ),
                        // ),
                      ])
                    ]);
              },
              itemCount: applyclicked
                  ? pdffilter.length
                  : issearch
                      ? pdfsearch.length
                      : pdflist.length),
          // ),
          // pw.SizedBox(height: 15),
          // pw.Row(
          //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          //   children: [
          //     pw.Text(
          //       "Printed by : Techno",
          //       textAlign: pw.TextAlign.left,
          //       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          //     ),
          //     pw.Text(
          //       "Page : 1/1",
          //       textDirection: pw.TextDirection.ltr,
          //       textAlign: pw.TextAlign.left,
          //       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          //     ),
          //   ],
          // ),
          //  pw.SizedBox(height: 5),
          // pw.Row(
          //   children: [
          //     pw.Text(
          //       "Printed on : " + current_date.toString(),
          //       textAlign: pw.TextAlign.left,
          //       style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          //     )
          //   ],
          // )
        ];
      },
    ));

    return PdfApi.saveDocument(
        name: applyclicked
            ? 'vehiclesummaryFilterReport.pdf'
            : issearch
                ? 'vehiclesummarysSearchReport.pdf'
                : 'vehiclestatussummaryreport.pdf',
        pdf: pdf);
  }
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
