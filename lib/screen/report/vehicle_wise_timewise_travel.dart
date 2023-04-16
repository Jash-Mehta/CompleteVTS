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
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import '../../model/report/frame_filter.dart';
import '../../model/report/frame_packet_drivercode.dart';
import '../../model/report/frame_packet_report_response.dart';
import '../../model/report/search_frame_pckt_report.dart';
import '../../model/report/vehicle_vsrno.dart';
import '../../model/report/vehicle_wise_timewise_filter.dart';
import '../../model/report/vehicle_wise_timewise_search.dart';
import '../../model/report/vehicle_wise_timewise_travel.dart';
import '../../model/searchString.dart';
import '../../util/search_bar_field.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VehicleWiseTimeWiseTravel extends StatefulWidget {
  const VehicleWiseTimeWiseTravel({Key? key}) : super(key: key);

  @override
  _VehicleWiseTimeWiseTravelState createState() =>
      _VehicleWiseTimeWiseTravelState();
}

class _VehicleWiseTimeWiseTravelState extends State<VehicleWiseTimeWiseTravel> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  bool isincrement = false;
  bool count = false;
  int value = 0;
  late String srNo = "";
  late String vehicleRegNo = "";
  late String branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  int imeno = 867322033819244;
  List<VehicleWiseTimeWiseData> pdfdatalist = [];
  List<VehicleWiseTimeWiseData>? vehicledata = [];
  List<VehihcleWiseTimeWiseFilterData>? filterdata = [];
  List<VehicleWiseTimeWiseSearchData>? searchdata = [];
  List<FramePktDriverData>? fpdcdata = [];
  List<VehicleVSrNoData>? osvfdata = [];
  bool isvtwdvehicleno = false;
  var vtwdvehicleno;
  var vtwdvehiclenolisttiletext;
  bool applyclicked = false;
  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  bool isfilter = false;
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
  bool isvalue = false;

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

  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController,
      vehiclenumber;
  int vendorid = 1;
  int branchid = 1;
  int pagenumber = 1;
  int pagesize = 10;
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
  TextEditingController fromTimeInput = TextEditingController();
  TextEditingController toTimrInput = TextEditingController();
  String fromdate = "01-sep-2022";
  String arainonari = "arai";
  String frampacketoption = "loginpacket";
  String todate = "30-sep-2022";
  String searchtext = "MH12";
  String fromtime = "06:30";
  String totime = "18:00";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  SearchStringClass searchClass = SearchStringClass(searchStr: '');

  String SfromTime = "07:30";
  String StoTime = "20:00";
  String Sframpacketoption = "datapacket";
  // late SharedPreferences sharedPreferences;
  // late String token="";
  // late int branchid=0,vendorid=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getframedata();
    setState(() {
      // isvalue = false;
    });
    notificationController.addListener(() {
      if (notificationController.position.maxScrollExtent ==
          notificationController.offset) {
        setState(() {
          getdata();
          getallbranch();
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
  }

  getframedata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "" || vendorid != 0 || branchid != 0) {
      // print(token);
      getallbranch();
      setState(() {});
    } else {
      print("null");
    }
    if (token != "" || vendorid != 0 || branchid != 0 || searchText != "") {
      // getSearchData();
    }
  }

  getallbranch() {
    _mainBloc.add(VehicleWiseTimeWiseTravelEvents(
        token: token,
        vendorId: vendorid,
        branchid: branchid,
        araino: arainonari,
        fromdate: fromdate,
        fromTime: fromtime,
        toDate: todate,
        toTime: totime,
        imeno: imeno,
        pagenumber: pageNumber,
        pagesize: pageSize));
  }

  getSearchData() {
    _mainBloc.add(SearchFramePacktReportEvent(
        token: token,
        vendorId: vendorid,
        branchId: branchid,
        araiNonarai: arainonari,
        fromDate: fromdate,
        formTime: SfromTime,
        toDate: todate,
        toTime: StoTime,
        searchText: searchClass.searchStr,
        framepacketoption: Sframpacketoption,
        pageNumber: pageNumber,
        pageSize: pageSize));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter
            ? Text("Vehicle Time Wise Distance Travel")
            : Text("Filter"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isfilter = true;
                isfilter
                    ? _mainBloc.add(VehicleVSrNoEvent(
                        token: token, vendorId: 1, branchId: 1))
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

    if (token != "" || vehicleRegNo != 0 || imeno != 0 || transDate != "") {}
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
          if (state is VehicleVSrNoLoadingState) {
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
          }
          // Frame packet driver code
          if (state is FramePacketDriverCodeLoadingState) {
            print("Entering in frame packet Filter loading state");
          } else if (state is FramePacketDriverCodeLoadedState) {
            if (state.dmfdriverCoderesponse.data != null) {
              print("Frame packet Filter driver code loaded");
              fpdcdata!.clear();
              fpdcdata!.addAll(state.dmfdriverCoderesponse.data!);
              print("Frame packet Filter driver code loaded total = " +
                  fpdcdata!.length.toString());
            }
          } else if (state is FramePacketDriverCodeErorrState) {
            print("Frame packet Filter driver code error state");
          }
          if (state is VehicleWiseTimeWiseFilterLoadingState) {
            print("Entering in Vehicle wise time wise Filter loading state");
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleWiseTimeWiseFilterLoadedState) {
            if (state.vehiclewisetimewisefilterResponse.data != null) {
              print("Frame packet Filter data loaded");
              setState(() {
                _isLoading = false;
                filterdata!.clear();
                filterdata!
                    .addAll(state.vehiclewisetimewisefilterResponse.data!);
                print("Vehicle wise time wise Filter data loaded total = " +
                    filterdata!.length.toString());
              });
            }
          } else if (state is VehicleWiseTimeWiseFilterErrorState) {
            print("Vehicle wise time wise Filter data error state");
            setState(() {
              _isLoading = false;
            });
          }
          if (state is VehicleWiseTimeWiseTravelLoadingState) {
            print("Vehicle wise Time Wise  loading state");
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleWiseTimeWiseTravelLoadedState) {
            if (state.vehiclewisewimewisetravelResponse.data != null) {
              pageNumber++;
              print("Vehicle wise Time Wise  data loaded");
              setState(() {
                _isLoading = false;
                value = state.vehiclewisewimewisetravelResponse.totalRecords!;
              });
              vehicledata!
                  .addAll(state.vehiclewisewimewisetravelResponse.data!);
            }
          } else if (state is VehicleWiseTimeWiseTravelErrorState) {
            print("Vehicle wise Time Wise  error state");
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong,Please try again",
            );
          }
          if (state is VehicleWiseTimeWiseSearchLoadingState) {
            print("Entering in Search Vehicle Wise Time Wise loading state");
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleWiseTimeWiseSearchLoadedState) {
            print("Entering in Search Vehicle Wise Time Wise loaded state");
            setState(() {
              _isLoading = false;
              searchdata!.clear();
            });
            // if (state.vehiclewisetimewisesearchResponse.data != null) {
            // setState(() {
            //   _isLoading = false;
            //   searchdata!.clear();
            // });
            searchdata!.addAll(state.vehiclewisetimewisesearchResponse.data!);
            // }
          } else if (state is VehicleWiseTimeWiseSearchErrorState) {
            print("Search Vehicle Wise Time Wise error state");
            setState(() {
              _isLoading = false;
              searchdata!.clear();
            });
          }
        },
        child: isfilter
            ? SingleChildScrollView(
                controller: notificationController,
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
                                        vtwdvehiclenolisttiletext="-select-";
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
                                          print("Applyy clicked");
                                          _mainBloc.add(
                                              VehicleWiseTimeWiseFilterEvents(
                                                  token: token,
                                                  vendorId: vendorid,
                                                  branchid: branchid,
                                                  araino: arainonari,
                                                  fromdate: fromDateController,
                                                  fromTime: fromTimeController,
                                                  toDate: toDateController,
                                                  toTime: toTimeController,
                                                  vehiclelist:
                                                      vtwdvehicleno == null
                                                          ? "ALL"
                                                          : vtwdvehicleno,
                                                  pagenumber: 1,
                                                  pagesize: pageSize));
                                          setState(() {
                                            isfilter = false;
                                            applyclicked = true;
                                          });
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
                                    onChanged: (value) {},
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
                                      onChanged: (value) {},
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
                                      vtwdvehiclenolisttiletext == null
                                          ? "-select-"
                                          : vtwdvehiclenolisttiletext,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing:isvtwdvehicleno ? IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up,
                                      ),  
                                      onPressed: () {
                                        isvtwdvehicleno = false;
                                        setState(() {});
                                      },
                                    ): IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      onPressed: () {
                                        isvtwdvehicleno = true;
                                        setState(() {});
                                      },
                                    ),
                                  )),
                              isvtwdvehicleno
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
                                                article.vehicleRegNo!
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onTap: () {
                                                print(article.vsrNo);
                                                isvtwdvehicleno = false;
                                                setState(() {
                                                  vtwdvehicleno =
                                                      article.vsrNo.toString();
                                                  print(
                                                      "This is vehicleregno - " +
                                                          vtwdvehicleno);
                                                  vtwdvehiclenolisttiletext =
                                                      article.vehicleRegNo
                                                          .toString();
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
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 15, right: 15, bottom: 6),
                              decoration: BoxDecoration(
                                  color: MyColors.greyDividerColorCode,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                children: [
                                  Icon(Icons.file_copy_outlined),
                                  Text("Export"),
                                ],
                              ),
                            ),
                             GestureDetector(
                              onTap: () async {
                                pdfdatalist.addAll(vehicledata!);
                                setState(() {});

                                var status = await Permission.storage.status;
                                if (await Permission.storage
                                    .request()
                                    .isGranted) {
                                  final pdfFile =
                                      await PdfInvoiceApi.generate(pdfdatalist);
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
                                    color: MyColors.lightblueColorCode,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.file_copy_sharp,
                                      color: MyColors.analyticActiveColorCode,
                                    ),
                                    Text(
                                      "Download",
                                      style: TextStyle(
                                          color:
                                              MyColors.analyticActiveColorCode),
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
                          applyclicked
                              ? BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                  return Text(
                                    filterdata!.length.toString() +
                                        " Filter Records found",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  );
                                })
                              : isSearch
                                  ? BlocBuilder<MainBloc, MainState>(
                                      builder: (context, state) {
                                      return Text(
                                        searchdata!.length.toString() +
                                            " Search Records found",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      );
                                    })
                                  : BlocBuilder<MainBloc, MainState>(
                                      builder: (context, state) {
                                      return Text(
                                        vehicledata!.length.toString() +
                                            " Records found",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      );
                                    }),
                          applyclicked ? Container(
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
                                    Text("From Date  -  To Date",
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                        fromDateController != null
                                            ? fromDateController + "  -  "
                                            : "01-sep-2022" + "  -  ",
                                        style: TextStyle(fontSize: 18)),
                                    Text(
                                        toDateController != null
                                            ? toDateController
                                            : "30-sep-2022" + "  -  ",
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    // mainAxisAlignment: MainAxisAlignment.start,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                                            Text("MH12AB0015",
                                                style: TextStyle(fontSize: 18)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ):SizedBox(),
                          applyclicked
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: BlocBuilder<MainBloc, MainState>(
                                      builder: (context, state) {
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        controller: vehicleRecordController,
                                        itemCount: filterdata!.length,
                                        itemBuilder: (context, index) {
                                          var article = filterdata![index];
                                          return Card(
                                              margin:
                                                  EdgeInsets.only(bottom: 15),
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
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Sr.No",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "1",
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
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
                                                                        "IMEI",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .imeino!,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
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
                                                                      top: 15.0,
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
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Trans Time",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .transTime!,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
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
                                                                        "Speed",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .speed!,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
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
                                                                      top: 15.0,
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
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Distance Travel",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .distancetravel!,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
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
                                                                        "Lattitude",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .latitude!,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
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
                                                                      top: 15.0,
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
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Longitude",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .longitude!,
                                                                          style: TextStyle(
                                                                              color: MyColors.text5ColorCode,
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
                                                                        "Address",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .address!,
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.text5ColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                    ],
                                                                  ))
                                                                ],
                                                              ),
                                                            ),
                                                          ]),
                                                    ),
                                                  )));
                                        });
                                  }))
                              : !isSearch
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: BlocBuilder<MainBloc, MainState>(
                                          builder: (context, state) {
                                        return ListView.builder(
                                            shrinkWrap: true,
                                            controller: vehicleRecordController,
                                            itemCount: vehicledata!.length,
                                            itemBuilder: (context, index) {
                                              var article = vehicledata![index];
                                              return Card(
                                                  margin: EdgeInsets.only(
                                                      bottom: 15),
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15.0,
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
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              "1",
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
                                                                            "IMEI",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.imeino!,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ))
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15.0,
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
                                                                              "Trans Time",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.transTime!,
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
                                                                            "Speed",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.speed!,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ))
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15.0,
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
                                                                              "Distance Travel",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.distancetravel!,
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
                                                                            "Lattitude",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.latitude!,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ))
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 15.0,
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
                                                                              "Longitude",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.longitude!,
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
                                                                            "Address",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.address!,
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                          ),
                                                                        ],
                                                                      ))
                                                                    ],
                                                                  ),
                                                                ),
                                                              ]),
                                                        ),
                                                      )));
                                            });
                                      }))
                                  : searchdata!.isEmpty
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
                                              child: BlocBuilder<MainBloc,
                                                      MainState>(
                                                  builder: (context, state) {
                                                return ListView.builder(
                                                    shrinkWrap: true,
                                                    controller:
                                                        vehicleRecordController,
                                                    itemCount:
                                                        searchdata!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      var article =
                                                          searchdata![index];
                                                      return Card(
                                                          margin:
                                                              EdgeInsets.only(
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 15,
                                                                      left: 14,
                                                                      right: 14,
                                                                      bottom:
                                                                          15),
                                                              width:
                                                                  MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                // controller: overSpeedScrollController,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
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
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15.0,
                                                                              bottom: 15),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Sr.No",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      "1",
                                                                                      style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                  child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "IMEI",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    article.imeino!,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15.0,
                                                                              bottom: 15),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Trans Time",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      article.transTime!,
                                                                                      style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                  child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Speed",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    article.speed!,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15.0,
                                                                              bottom: 15),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Distance Travel",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      article.distancetravel!,
                                                                                      style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                  child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Lattitude",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    article.latitude!,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 15.0,
                                                                              bottom: 15),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceAround,
                                                                            children: [
                                                                              Expanded(
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Longitude",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      article.longitude!,
                                                                                      style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Expanded(
                                                                                  child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "Address",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    article.address!,
                                                                                    textAlign: TextAlign.left,
                                                                                    style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                  ),
                                                                                ],
                                                                              ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              )));
                                                    });
                                              }))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  onSearchTextChanged(String? text) async {
    if (text!.isEmpty || text.length < 0) {
      setState(() {
        isSearch = false;
      });
      return;
    } else {
      if (text.isNotEmpty || text.length > 0) {
        setState(() {
          isSearch = true;
          searchClass.searchStr = text;
        });

        _mainBloc.add(VehicleWiseTimeWiseSearchEvents(
          token: token,
          vendorId: vendorid,
          branchid: branchid,
          araino: arainonari,
          fromdate: fromdate,
          fromTime: SfromTime,
          toDate: todate,
          toTime: StoTime,
          searchtxt: searchClass.searchStr,
          pagenumber: 1,
          pagesize: pageSize,
        ));
      }
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(List<VehicleWiseTimeWiseData> pdflist) async {
    final pdf = pw.Document();
    double fontsize = 8.0;
    
    DateTime current_date = DateTime.now();
    pdf.addPage(pw.MultiPage(
      // header: (pw.Context context) {
      //   return pw.Text("header");
      // },
      footer: (pw.Context context) {
       return pw.Column(children:[ 
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
          ],),
           pw.Row(
            children: [
              pw.Text(
                "Printed on : " + current_date.toString(),
                textAlign: pw.TextAlign.left,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              )
            ],)
          ]);
      },
      pageFormat: PdfPageFormat.a5,
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text("VEHICLE WISE TIME WISE DISTANCE TRAVEL",
                  style: pw.TextStyle(
                      fontSize: 20.0, fontWeight: pw.FontWeight.bold))),
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
                          "Trans Time",
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
                          "Speed",
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
                          "Distance Travel",
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
                          "lattitude",
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
                          "longitude",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  // pw.Padding(
                  //     padding: pw.EdgeInsets.only(
                  //         top: 8.0, bottom: 8.0, right: 5.0, left: 5.0),
                  //     child: pw.SizedBox(
                  //       width: 50,
                  //       child: pw.Text(
                  //         "Address",
                  //         style: pw.TextStyle(
                  //             fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                  //       ),
                  //     )),
                ])
              ],
            ),
          ),
          // pw.Expanded(
          //     child:
          pw.ListView.builder(
              itemBuilder: (pw.Context context, int index) {
                var article = pdflist[index];
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
                            child: pw.Text("1",
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(article.imeino.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(article.transTime.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(article.speed.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(article.distancetravel.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(article.latitude.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(article.longitude.toString(),
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
              itemCount: pdflist.length),
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

    return PdfApi.saveDocument(name: 'vehiclewiseTWreport.pdf', pdf: pdf);
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
