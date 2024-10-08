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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import '../../model/date_wise_travel_history/date_wise_drivercode.dart';
import '../../model/date_wise_travel_history/date_wise_travel_filter.dart';
import '../../model/date_wise_travel_history/date_wise_travel_history.dart';
import '../../model/date_wise_travel_history/search_datewise_travel_history_response.dart';
import '../../model/report/over_speed_report_response.dart';
import '../../model/report/search_datewise_travel_history_response.dart';
import '../../model/report/vehicle_vsrno.dart';
import '../../model/searchString.dart';
import '../../util/search_bar_field.dart';

class DateWiseTravelHistory extends StatefulWidget {
  const DateWiseTravelHistory({Key? key}) : super(key: key);

  @override
  _DateWiseTravelHistoryState createState() => _DateWiseTravelHistoryState();
}

class _DateWiseTravelHistoryState extends State<DateWiseTravelHistory> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  bool isData = false;
   List<DatewiseTravelHistoryData> pdfdatalist = [];
  List<DatewiseTravelHistoryData>? dwth = [];
  List<DatewiseTravelFilterData>? dwthfilter = [];
  List<DatewiseTravelHistorySearchData>? dwthsearch = [];
  // List<DateWiseDriverCodeData>? datewisedrivercode = [];
  List<VehicleVSrNoData>? datewisedrivercode = [];
  // List<VehicleVSrNoData>? osvfdata = [];
  bool isosvf = false;
  var osvfvehno;
  var osvfvehnolisttiletext;
  bool isdwdc = false;
  var dwdcdeviceno;
  int value = 0;
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
  late String srNo = "";
  late String vehicleRegNo = "";
  late String imeino = "", branchName = "", userType = "", arai = "arai";
  late SharedPreferences sharedPreferences;
  late String token = "";

  SearchStringClass searchClass = SearchStringClass(searchStr: '');
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;

  bool isDataAvailable = false;
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
      fromDate = "01-sep-2022",
      toDate = "30-sep-2022",
      searchText = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataDT();
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

  getdataDT() async {
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
    _mainBloc.add(DateWiseTravelHistoryEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        arainonarai: arai,
        fromdate: fromDate,
        todate: toDate,
        imeino: imeino,
        pageSize: pageSize,
        pageNumber: pageNumber));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter ? Text("Date Wise Travel History") : Text("Filter"),
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
    print("" +
        vehicleRegNo.toString() +
        " " +
        imeino.toString() +
        " " +
        latitude.toString() +
        " " +
        longitude.toString() +
        " " +
        address.toString() +
        " " +
        transDate.toString() +
        " " +
        transTime.toString() +
        " " +
        speed.toString() +
        " " +
        overSpeed.toString() +
        " " +
        updatedOn.toString() +
        " " +
        distancetravel.toString() +
        " " +
        speedLimit.toString() +
        " " +
        searchText);

    if (token != "" ||
        vehicleRegNo != 0 ||
        imeino != 0 ||
        transDate != "" ||
        overSpeed != "") {
      // _getOverSpeedCreatedetail();
    }
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
                  datewisedrivercode!.clear();
                  datewisedrivercode!.addAll(state.vehiclevsrnoresponse.data!);
                }
              } else if (state is VehicleVSrNoErorrState) {
                print("Something went Wrong  data VehicleVSrNoErorrState");
                Fluttertoast.showToast(
                  msg: state.msg,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
              //! date wise travel history search data !! ----------
              if (state is SearchDatewiseTravelReportLoadingState) {
                print("Entering in SearchDatewiseTravelReportLoadingState");
                setState(() {
                  _isLoading = true;
                });
              } else if (state is SearchDatewiseTravelReportLoadedState) {
                print("Entering in SearchDatewiseTravelReportLoadedState");
                setState(() {
                  _isLoading = false;
                  dwthsearch!.clear();
                });
                if (state.searchResponse.data != null) {
                  dwthsearch!.addAll(state.searchResponse.data!);
                }
              } else if (state is SearchDatewiseTravelReportErrorState) {
                print("Search Datewise Travel Report ErrorState ");
                setState(() {
                  _isLoading = false;
                });
              }
              // date wise travel history filter data !! ----------
              if (state is DateWiseTravelFilterLoadingState) {
                print("Entering in DateWiseTravelFilterLoadingState");
                setState(() {
                  _isLoading = true;
                });

                // setState(() {
                //   if (dwthfilter!.length == null) {
                //     _isLoading = false;
                //     print("No data found in this filter");
                //   }else{
                //      print("some data found in this Date Wise Travel Filter Loading State");
                //        _isLoading = true;
                //   }
                // });
              } else if (state is DateWiseTravelFilterLoadedState) {
                print("Entering in DateWiseTravelFilterLoadedState");
                setState(() {
                  _isLoading = false;
                  dwthfilter!.clear();
                  dwthfilter!.addAll(state.dateWiseTravelFilterResponse.data!);
                });
              } else if (state is DateWiseTravelFilterErrorState) {
                print("Date wise travel filter data Error");
                setState(() {
                  _isLoading = false;
                });
              } else if (state is DateWiseTravelHistoryLoadingState) {
                print("Entering in loading state");
                setState(() {
                  _isLoading = true;
                });
              } else if (state is DateWiseTravelHistoryLoadedState) {
                if (state.datedisetravelhistoryresponse.data != null) {
                  pageNumber++;
                  print("Date wise travel data loaded");
                  setState(() {
                    _isLoading = false;
                    value = state.datedisetravelhistoryresponse.totalRecords!;
                  });
                  dwth!.addAll(state.datedisetravelhistoryresponse.data!);
                }
              } else if (state is DateWiseTravelHistoryErrorState) {
                setState(() {
                  _isLoading = false;
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
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0,
                                  top: 16.0),
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
                                            osvfvehnolisttiletext = "-select-";
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
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          color: /*isapplybtnvisible ?*/ Colors
                                              .blue, /*: MyColors.blueColorCode.withOpacity(0.5)*/
                                        ),
                                        child: TextButton(
                                            child: const Text("Apply",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              print("Applyy clicked");
                                              _mainBloc.add(
                                                  DateWiseTravelFilterEvent(
                                                      token: token,
                                                      vendorId: vendorid,
                                                      branchid: branchid,
                                                      arai: arai,
                                                      fromdate:
                                                          fromDateController,
                                                      todate: toDateController,
                                                      vehiclelist: dwdcdeviceno
                                                                  .toString() ==
                                                              null
                                                          ? "ALL"
                                                          : dwdcdeviceno
                                                              .toString(),
                                                      pagenumber: pageNumber,
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
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Vendor Name",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.0),
                                              child: Text("*",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .redColorCode)),
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
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    58,
                                                child: Text(items,
                                                    style: TextStyle(
                                                        fontSize: 18))),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Branch Name",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.0),
                                              child: Text("*",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .redColorCode)),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              MyColors.boxBackgroundColorCode,
                                          border: Border.all(
                                              color: MyColors
                                                  .textBoxBorderColorCode,
                                              width: 2)),
                                      child: IgnorePointer(
                                        ignoring: true,
                                        child: DropdownButtonFormField(
                                          isExpanded: true,
                                          value: dropdownvalue2,
                                          menuMaxHeight: 300,
                                          onChanged: (value) {},
                                          items:
                                              branchitems.map((String items) {
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
                                                      style: TextStyle(
                                                          fontSize: 18))),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Vehicle Number",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.0),
                                              child: Text("*",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .redColorCode)),
                                            )
                                          ],
                                        ),
                                      )),
                                  Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: MyColors.whiteColorCode,
                                          border: Border.all(
                                              color: MyColors
                                                  .textBoxBorderColorCode,
                                              width: 2)),
                                      child: ListTile(
                                        leading: Text(
                                          osvfvehnolisttiletext ?? "-select-",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        trailing:isdwdc ? IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up,
                                      ),  
                                      onPressed: () {
                                        isdwdc = false;
                                        setState(() {});
                                      },
                                    ): IconButton(
                                          icon: Icon(
                                            Icons.keyboard_arrow_down,
                                          ),
                                          onPressed: () {
                                            isdwdc = true;
                                            setState(() {});
                                          },
                                        ),
                                      )),
                                  isdwdc
                                      ? Container(
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  blurRadius: 5.0,
                                                  spreadRadius: 1),
                                            ],
                                            color: Colors.white,
                                            //  boxShadow:
                                          ),
                                          height: 200,
                                          width: double.infinity,
                                          child: ListView.builder(
                                            itemCount:
                                                datewisedrivercode!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              var article =
                                                  datewisedrivercode![index];
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
                                                    isdwdc = false;
                                                    setState(() {
                                                      dwdcdeviceno =
                                                          article.vsrNo;
                                                      osvfvehnolisttiletext =
                                                          article.vehicleRegNo;
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
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "From Date",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.0),
                                              child: Text("*",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .redColorCode)),
                                            )
                                          ],
                                        ),
                                      )),
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
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              print(pickedDate);
                                              String fromDate = DateFormat(
                                                      'dd-MMM-yyyy', 'en_US')
                                                  .format(pickedDate);
                                              fromDate = fromDate.replaceRange(
                                                  3,
                                                  6,
                                                  fromDate
                                                      .substring(3, 6)
                                                      .toLowerCase());
                                              fromDateController = fromDate;
                                              setState(() {
                                                fromdateInput.text =
                                                    fromDateController;
                                              });
                                            } else {}
                                          },
                                          enabled: true,
                                          readOnly: true,
                                          controller:
                                              fromdateInput, // to trigger disabledBorder
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: MyColors.whiteColorCode,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color:
                                                      MyColors.buttonColorCode),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.orange),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color:
                                                      MyColors.textColorCode),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                )),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: MyColors
                                                        .textBoxBorderColorCode)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 2,
                                                        color: MyColors
                                                            .buttonColorCode)),
                                            hintText: "DD/MM/YY",
                                            suffixIcon: Icon(
                                              Icons.calendar_today_outlined,
                                              size: 24,
                                              color: MyColors.dateIconColorCode,
                                            ),
                                            hintStyle: TextStyle(
                                                fontSize: 18,
                                                color: MyColors
                                                    .searchTextColorCode),
                                            errorText: "",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 20, top: 10)),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          children: const [
                                            Text(
                                              "To Date",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 3.0),
                                              child: Text("*",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: MyColors
                                                          .redColorCode)),
                                            )
                                          ],
                                        ),
                                      )),
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
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1950),
                                                    lastDate: DateTime(2100));

                                            if (pickedDate != null) {
                                              print(pickedDate);
                                              String toDate = DateFormat(
                                                      'dd-MMM-yyyy', 'en_US')
                                                  .format(pickedDate);
                                              toDate = toDate.replaceRange(
                                                  3,
                                                  6,
                                                  toDate
                                                      .substring(3, 6)
                                                      .toLowerCase());
                                              print("toDate is Set-----------");
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
                                            fillColor: MyColors.whiteColorCode,
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color:
                                                      MyColors.buttonColorCode),
                                            ),
                                            disabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color: Colors.orange),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4)),
                                              borderSide: BorderSide(
                                                  width: 1,
                                                  color:
                                                      MyColors.textColorCode),
                                            ),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                  width: 1,
                                                )),
                                            errorBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(4)),
                                                borderSide: BorderSide(
                                                    width: 1,
                                                    color: MyColors
                                                        .textBoxBorderColorCode)),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    borderSide: BorderSide(
                                                        width: 2,
                                                        color: MyColors
                                                            .buttonColorCode)),
                                            hintText: "DD/MM/YY",
                                            suffixIcon: Icon(
                                              Icons.calendar_today_outlined,
                                              size: 24,
                                              color: MyColors.dateIconColorCode,
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
                                    ],
                                  )
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
                    child: Column(children: [
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
                                pdfdatalist.addAll(dwth!);
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
                                      dwthfilter!.length.toString() +
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
                                          dwthsearch!.length.toString() +
                                              " Search Records found",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        );
                                      })
                                    : BlocBuilder<MainBloc, MainState>(
                                        builder: (context, state) {
                                        return Text(
                                          dwth!.length.toString() +
                                              " Records found",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        );
                                      }),
                            applyclicked
                                ? dwthfilter!.isEmpty
                                    ? Center(
                                        child: Text(
                                        "No data found",
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w500),
                                      ))
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: BlocBuilder<MainBloc, MainState>(
                                            builder: (context, state) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              controller:
                                                  vehicleRecordController,
                                              itemCount: dwthfilter!.length,
                                              itemBuilder: (context, index) {
                                                var article =
                                                    dwthfilter![index];
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
                                                                        "IMEI NO",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .vehicleRegNo!,
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }))
                                : !isSearch
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: BlocBuilder<MainBloc, MainState>(
                                            builder: (context, state) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              controller:
                                                  vehicleRecordController,
                                              itemCount: dwth!.length,
                                              itemBuilder: (context, index) {
                                                var article = dwth![index];
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
                                                                        "IMEI NO",
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }))
                                    : dwthsearch!.isEmpty
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
                                                child: BlocBuilder<MainBloc, MainState>(
                                                    builder: (context, state) {
                                                  return ListView.builder(
                                                      shrinkWrap: true,
                                                      controller:
                                                          vehicleRecordController,
                                                      itemCount:
                                                          dwthsearch!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        var article =
                                                            dwthsearch![index];
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
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 15,
                                                                    left: 14,
                                                                    right: 14,
                                                                    bottom: 15),
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
                                                                    bottom: 20),
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
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
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
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "IMEI NO",
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
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              15.0,
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
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
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              15.0,
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Distance Travel",
                                                                                  style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                ),
                                                                                Text(
                                                                                  article.distancetravel.toString(),
                                                                                  style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                ),
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
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              15.0,
                                                                          bottom:
                                                                              15),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Column(
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
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
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
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                })),
                          ],
                        ),
                      ),
                    ]),
                  )));
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        isSearch = false;
      });
      return;
    } else {
      setState(() {
        isSearch = true;
        searchClass.searchStr = text;
      });
      _mainBloc.add(SearchDatewiseTravelReportEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        arai: arai,
        fromDate:
            fromDateController == null ? "01-sep-2022" : fromDateController,
        todate: toDateController == null ? "30-sep-2022" : toDateController,
        searchText: searchClass.searchStr,
        pagenumber: pageNumber,
        pagesize: pageSize,
      ));
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(List<DatewiseTravelHistoryData> pdflist) async {
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
              child: pw.Text("DATE WISE TRAVEL HISTORY",
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
                            width: 20,
                            child: pw.Text("1",
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(article.imeino.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(article.transTime.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(article.speed.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(article.distancetravel.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(article.latitude.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
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
        ];
      },
    ));

    return PdfApi.saveDocument(name: 'DateWiseReport.pdf', pdf: pdf);
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
