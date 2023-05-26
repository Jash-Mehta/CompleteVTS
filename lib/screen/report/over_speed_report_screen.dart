import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/model/report/overspeed_filter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:file_picker/src/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/report/over_speed_report_response.dart';
import '../../model/report/overspeed_vehicle_filter.dart';
import '../../model/report/vehicle_vsrno.dart';
import '../../model/searchString.dart';
import '../../util/search_bar_field.dart';

class OverSpeedReportScreen extends StatefulWidget {
  const OverSpeedReportScreen({Key? key}) : super(key: key);

  @override
  _OverSpeedReportScreenState createState() => _OverSpeedReportScreenState();
}

class _OverSpeedReportScreenState extends State<OverSpeedReportScreen> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  bool isvalue = false;
  bool isosvf = false;
  var osvfvehno;
  var osvfvehnolisttiletext;
  // List<OSFilterData>? osvfdata = [];

  final _text = TextEditingController();
  bool _validate = false;

  List<VehicleVSrNoData>? osvfdata = [];
  bool ispopup = false;
  bool isSelected = false;
  bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  int srNo = 1;
  int value = 0;
  String vehicleRegNo = "";
  String branchName = "", userType = "";
  int imeino = 862430050555255;
  int pagesize = 10;
  var fromDateController, toDateController, vehiclenumber;
  int vendorid = 1;
  int branchid = 1;
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
  TextEditingController fromTimeInput = TextEditingController();
  TextEditingController toTimrInput = TextEditingController();
  String fromdate = "01-sep-2022";
  String arainonari = "nonarai";
  String arai = "nonarai";
  String todate = "30-sep-2022";
  String searchtext = "MH12";
  String fromtime = "06:30";
  String totime = "18:00";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  late SharedPreferences sharedPreferences;
  late String token = "";
  List<OverSpeeddDetail>? overspeedlist = [];
  List<OverSpeedFilterDetail>? overspeedfilter = [];
  List<OverSpeeddDetailItem>? searchData = [];
  List<OverSpeeddDetail> pdfdatalist = [];
  List<OverSpeedFilterDetail> pdffilterlist = [];
  List<OverSpeeddDetailItem> pdfsearchlist = [];
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
  // bool isvalue = false;

  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  SearchStringClass searchClass = SearchStringClass(searchStr: '');

  bool isDataAvailable = false;
  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  bool applyclicked = false;
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
  @override
  void dispose() {
    todateInput.dispose();
    super.dispose();
  }

  // List<OverSpeeddSearchDetail>? overspeedsearchlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter ? Text("OVERSPEED REPORT") : Text("Filter"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isfilter = true;
                // toDateController = "";
                // fromDateController = "";
                todateInput.text = "";
                fromdateInput.text = "";
                osvfvehnolisttiletext = "-Select-";
                ispopup = true;
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

  @override
  void initState() {
    super.initState();
    getdataOS();
    // setState(() {});
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

  getdataOS() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "" || vendorid != 0 || branchid != 0) {
      print(token);
      getallbranch();
      setState(() {});
    } else {
      print("null");
    }
  }

  getallbranch() {
    _mainBloc.add(OverSpeedEvents(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        arai: arainonari,
        fromDate: fromdate,
        toDate: todate,
        imeno: imeino,
        pagenumber: pageNumber,
        pagesize: pageSize));
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
            // if (state is OverSpeedVehicleFilterLoadingState) {
            //   const Center(
            //     child: CircularProgressIndicator(),
            //   );
            // } else if (state is OverSpeedVehicleFilterLoadedState) {
            //   if (state.overspeedvehiclefilterresponse.data != null) {
            //     print("overspeed vehicle filter data is Loaded state");
            //     osvfdata!.clear();
            //     osvfdata!.addAll(state.overspeedvehiclefilterresponse.data!);

            //     // overspeedfilter!.addAll(state.overspeedFilter.data!);
            //     osvfdata!.forEach((element) {
            //       print("Overspeed vehicle filter element is Printed");
            //     });
            //   }
            // } else if (state is OverSpeedVehicleFilterErorrState) {
            //   print(
            //       "Something went Wrong  data OverSpeedVehicleFilterErorrState");
            //   Fluttertoast.showToast(
            //     msg: state.msg,
            //     toastLength: Toast.LENGTH_SHORT,
            //     timeInSecForIosWeb: 1,
            //   );
            // }
            // Overspeed vehicle filter-------------
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

            //! Overspeed filter Data is fetching--------------------
            if (state is OverSpeedFilterLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is OverSpeedFilterLoadedState) {
              // if (state.overspeedFilter.data != null) {
              //   print("overspeed filter data is Loaded state");
              //   setState(() {
              //     pageNumber++;
              //     _isLoading = false;
              //     overspeedfilter!.clear();
              //     overspeedfilter!.addAll(state.overspeedFilter.data!);
              //   });
              //   // overspeedfilter!.addAll(state.overspeedFilter.data!);
              //   overspeedfilter!.forEach((element) {
              //     print("Overspeed filter element is Printed");
              //   });
              // }
              if (state.overspeedFilter.data != null) {
                setState(() {
                  _isLoading = false;
                  overspeedfilter!.clear();
                  value = state.overspeedFilter.totalRecords!;
                });
                overspeedfilter!.addAll(state.overspeedFilter.data!);
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            } else if (state is OverSpeedFilterErorrState) {
              print("Something went Wrong  data OverSpeedFilterErorrState");
              // Fluttertoast.showToast(
              //   msg: "Record not found in given period..!",
              //   toastLength: Toast.LENGTH_SHORT,
              //   timeInSecForIosWeb: 1,
              // );
              setState(() {
                _isLoading = false;
              });
            }
            //! Overspeed search Data is fetching------------------
            if (state is SearchOverSpeedCreateLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is SearchOverSpeedCreateLoadedState) {
              setState(() {
                _isLoading = false;
                searchData!.clear();
              });
              if (state.searchOverSpeedCreateResponse.data != null) {
                searchData!.addAll(state.searchOverSpeedCreateResponse.data!);
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
              // if(state.search_overspeed_response.data!=null){
              //   searchData!.addAll(state.search_overspeed_response.data!);
              // }
            } else if (state is SearchOverSpeedCreateErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
            //! Overspeed all Data is fetching--------------------
            if (state is OverSpeedLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is OverSpeedLoadedState) {
              print("overspeed data is Loaded state!!");
              if (state.OverspeedReportResponse.data != null) {
                setState(() {
                  pageNumber++;
                  _isLoading = false;
                  // pageNumber++;
                  // overspeedlist!.clear();
                  value = state.OverspeedReportResponse.totalRecords!;
                });
                overspeedlist!.addAll(state.OverspeedReportResponse.data!);
              }
            } else if (state is OverSpeedErrorState) {
              print("Something went Wrong  data");
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                msg: "Smething went wrong",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }
          },
          child: isfilter
              ? SingleChildScrollView(
                  // controller: notificationController,
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
                                        todateInput.text = "";
                                        fromdateInput.text = "";
                                        osvfvehnolisttiletext = "";
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
                                onTap: () {},
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
                                          if (toDateController != null &&
                                              fromDateController != null &&
                                              osvfvehnolisttiletext != null && fromdateInput.text.isNotEmpty && todateInput.text.isNotEmpty) {
                                            _mainBloc.add(OverSpeedFilterEvents(
                                              token: token,
                                              vendorid: vendorid,
                                              branchid: branchid,
                                              arai: arai,
                                              fromDate:
                                                  fromDateController == null
                                                      ? ""
                                                      : fromDateController,
                                              toDate: toDateController == null
                                                  ? ""
                                                  : toDateController,
                                              vehiclelist: "8," + osvfvehno,
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
                                      osvfvehnolisttiletext == ""
                                          ? "-Select-"
                                          : osvfvehnolisttiletext,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: isosvf
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.keyboard_arrow_up,
                                            ),
                                            onPressed: () {
                                              isosvf = false;
                                              setState(() {});
                                            },
                                          )
                                        : IconButton(
                                            icon:
                                                Icon(Icons.keyboard_arrow_down),
                                            onPressed: () {
                                              isosvf = true;
                                              setState(() {});
                                            },
                                          ),
                                  )),
                              isosvf
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
                                                  isosvf = false;
                                                  osvfvehno =
                                                      article.vsrNo.toString();
                                                  print(
                                                      "This is vehicleregno - " +
                                                          osvfvehno);
                                                  osvfvehnolisttiletext =
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
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "From Date",
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
                                          String fromDate =
                                              DateFormat('dd-MMM-yyyy', 'en_US')
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
                                      decoration: InputDecoration(
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
                                                width: 1, color: Colors.orange),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 1,
                                                color: MyColors.textColorCode),
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
                                              color:
                                                  MyColors.searchTextColorCode),
                                          errorText: ""),
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
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: const [
                                        Text(
                                          "To Date",
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
                                          String toDate =
                                              DateFormat('dd-MMM-yyyy', 'en_US')
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
                                            todateInput.text = toDateController;
                                          });
                                        } else {}
                                      },
                                      enabled: true,
                                      readOnly: true,
                                      controller:
                                          todateInput, // to trigger disabledBorder
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: MyColors.whiteColorCode,
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: MyColors.buttonColorCode),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.orange),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: MyColors.textColorCode),
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
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            borderSide: BorderSide(
                                                width: 2,
                                                color:
                                                    MyColors.buttonColorCode)),
                                        hintText: "DD/MM/YY",
                                        suffixIcon: Icon(
                                          Icons.calendar_today_outlined,
                                          size: 24,
                                          color: MyColors.dateIconColorCode,
                                        ),
                                        hintStyle: TextStyle(
                                            fontSize: 18,
                                            color:
                                                MyColors.searchTextColorCode),
                                        errorText: '',
                                      ),
                                      // controller: _text,
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
                )
              : SingleChildScrollView(
                  controller: notificationController,
                  child: Column(children: [
                    Container(
                        decoration: const BoxDecoration(
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
                              decoration: const BoxDecoration(
                                  color: MyColors.analyticActiveColorCode,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      //  final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
                                      // FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions:FileType.custom(), );
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);
                                      // FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions:FileType.custom(), );
                                      try {
                                        List<String>? files = result?.files
                                            .map((file) => file.path)
                                            .cast<String>()
                                            .toList();
                                        print("File path------${files}");
                                        //    List<String>? files = [
                                        //   "/data/user/0/com.vts.gps/cache/file_picker/DTwisereport.pdf"
                                        // ];
                                        // print("File path------${files}");
                                        await Share.shareFiles(files!);
                                        Navigator.of(context).popUntil((route) => route.isCurrent);
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
                                pdfdatalist.addAll(overspeedlist!);
                                pdffilterlist.clear();
                                pdffilterlist.addAll(overspeedfilter!);
                                pdfsearchlist.clear();
                                pdfsearchlist.addAll(searchData!);
                                setState(() {});

                                var status = await Permission.storage.status;
                                if (await Permission.storage
                                    .request()
                                    .isGranted) {
                                  final pdfFile =
                                      await PdfInvoiceApi.generate(pdfdatalist,pdffilterlist,applyclicked,pdfsearchlist,isSelected);
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
                              applyclicked
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 20),
                                      padding: EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                          color: MyColors.bluereportColorCode,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("From Date  -  To Date",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                  fromDateController != null
                                                      ? fromDateController +
                                                          "  -  "
                                                      : "01-sep-2022" + "  -  ",
                                                  style:
                                                      TextStyle(fontSize: 18)),
                                              Text(
                                                  toDateController != null
                                                      ? toDateController
                                                      : "30-sep-2022",
                                                  style:
                                                      TextStyle(fontSize: 18)),
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "VehicleRegNo",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                          osvfvehnolisttiletext,
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Speed Limit",
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                      Text("-",
                                                          style: TextStyle(
                                                              fontSize: 18)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              BlocBuilder<MainBloc, MainState>(
                                builder: (context, state) {
                                  return applyclicked
                                      ? Text(
                                          overspeedfilter!.isEmpty
                                              ? ""
                                              : overspeedfilter!.length
                                                      .toString() +
                                                  " Filter Records found",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : isSelected
                                          ? Text(
                                              searchData!.isEmpty
                                                  ? ""
                                                  : searchData!.length
                                                          .toString() +
                                                      " Search Records found",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              "${overspeedlist!.length} RECORDS",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            );
                                },
                              ),
                              applyclicked
                                  ? overspeedfilter!.isEmpty
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
                                                        overspeedfilter!.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      print(
                                                          "Enter in the overspeed filter list");
                                                      var article =
                                                          overspeedfilter![
                                                              index];
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
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  left: 14,
                                                                  right: 14,
                                                                  bottom: 15),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          decoration:
                                                              const BoxDecoration(
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
                                                                              Text(
                                                                                "Sr.No",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                sr.toString(),
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
                                                                              "IMEI NO",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.imeino.toString(),
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
                                                                                "Trans Time",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.transTime.toString(),
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
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.speed.toString(),
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
                                                                                "Overspeed kmph",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.overSpeed.toString(),
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
                                                                              "Distance Travel",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.distancetravel.toString(),
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
                                                                                "Lattitude",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.latitude.toString(),
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
                                                                              "Longitude",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.longitude.toString(),
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
                                                                              const Text(
                                                                                "Address",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.address.toString(),
                                                                                style: const TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
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
                                      ? BlocBuilder<MainBloc, MainState>(
                                          builder: (context, state) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              controller:
                                                  vehicleRecordController,
                                              itemCount: overspeedlist!.length,
                                              itemBuilder: (context, index) {
                                                var article =
                                                    overspeedlist![index];
                                                var sr = index + 1;

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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 15,
                                                            left: 14,
                                                            right: 14,
                                                            bottom: 15),
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    decoration:
                                                        const BoxDecoration(
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
                                                                          sr.toString(),
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
                                                                            .imeino
                                                                            .toString(),
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
                                                                              .transTime
                                                                              .toString(),
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
                                                                            .speed
                                                                            .toString(),
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
                                                                          "Overspeed kmph",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .overSpeed
                                                                              .toString(),
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
                                                                        "Distance Travel",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .distancetravel
                                                                            .toString(),
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
                                                                          "Lattitude",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .latitude
                                                                              .toString(),
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
                                                                        "Longitude",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .longitude
                                                                            .toString(),
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
                                                                        const Text(
                                                                          "Address",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .address
                                                                              .toString(),
                                                                          style: const TextStyle(
                                                                              color: MyColors.text5ColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: BlocBuilder<MainBloc,
                                                      MainState>(
                                                    builder: (context, state) {
                                                      return ListView.builder(
                                                          shrinkWrap: true,
                                                          controller:
                                                              vehicleRecordController,
                                                          itemCount: searchData!
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            print(
                                                                "loading is $_isLoading");

                                                            // print("search data list item are---------------${searchData!.elementAt(index).distanceTravel.toString()}");
                                                            var article =
                                                                searchData!
                                                                    .elementAt(
                                                                        index);
                                                            var sr = index + 1;
                                                            return Card(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          15),
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
                                                                        left:
                                                                            14,
                                                                        right:
                                                                            14,
                                                                        bottom:
                                                                            15),
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  // controller: overSpeedScrollController,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        top:
                                                                            20.0,
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            15,
                                                                        bottom:
                                                                            20),
                                                                    child:
                                                                        Column(
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
                                                                                      sr.toString(),
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
                                                                                    "IMEI NO",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    "${article.imeino}",
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
                                                                                      "${article.transTime}",
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
                                                                                    "${article.speed}",
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
                                                                                      "Overspeed kmph",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      "${article.overSpeed}",
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
                                                                                    "Distance Travel",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    "${article.distancetravel}",
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
                                                                                      "Lattitude",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      "${article.latitude}",
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
                                                                                    "Longitude",
                                                                                    style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                  ),
                                                                                  Text(
                                                                                    "${article.longitude}",
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
                                                                                      "Address",
                                                                                      style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                                    ),
                                                                                    Text(
                                                                                      "-",
                                                                                      style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
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
                                                    },
                                                  ))
                            ]))
                  ])),
        ));
  }

  onSearchTextChanged(String text) async {
    if (text.isEmpty) {
      setState(() {
        isSelected = false;
      });
      return;
    } else {
      setState(() {
        isSelected = true;
        searchClass.searchStr = text;
      });
      _mainBloc.add(SearchOverSpeedCreateEvents(
          token: token,
          vendorId: vendorid,
          barnchId: branchid,
          arainonarai: arai,
          fromDate: fromdate,
          toDate: todate,
          searchText: searchClass.searchStr,
          pageNumber: pageNumber,
          pageSize: pageSize));
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(List<OverSpeeddDetail> pdflist, List<OverSpeedFilterDetail> pdffilter, bool applyclicked, List<OverSpeeddDetailItem> pdfsearch, bool issearch) async {
    final pdf = pw.Document();
    double fontsize = 8.0;
    DateTime current_date = DateTime.now();
    pdf.addPage(pw.MultiPage(
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
      build: (context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text("OVER SPEED REPORT",
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
                          "SrNo",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
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
                          top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Transtime",
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
                          "OverSpeed",
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
                          "Latittude",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Longitute",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  //  pw.Padding(
                  // padding: pw.EdgeInsets.only(
                  //     top: 8.0, bottom: 8.0, left: 5.0, right: 5.0),
                  // child: pw.SizedBox(
                  //   width: 50,
                  //   child: pw.Text(
                  //     "Address",
                  //     style: pw.TextStyle(
                  //         fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                  //   ),
                  // )),
                ])
              ],
            ),
          ),
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
                            child: pw.Text(applyclicked ? pdffilter[index].imeino.toString() : issearch ? pdfsearch[index].imeino.toString() : pdflist[index].imeino.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(applyclicked ? pdffilter[index].transTime.toString() : issearch ? pdfsearch[index].transTime.toString() : pdflist[index].transTime.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(applyclicked ? pdffilter[index].speed.toString() : issearch ? pdfsearch[index].speed.toString() : pdflist[index].speed.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(applyclicked ? pdffilter[index].overSpeed.toString() : issearch ? pdfsearch[index].overSpeed.toString() : pdflist[index].overSpeed.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(applyclicked ? pdffilter[index].distancetravel.toString() : issearch ? pdfsearch[index].distancetravel.toString() : pdflist[index].distancetravel.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(applyclicked ? pdffilter[index].latitude.toString() : issearch ? pdfsearch[index].latitude.toString() : pdflist[index].latitude.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 50,
                            child: pw.Text(applyclicked ? pdffilter[index].longitude.toString() : issearch ? pdfsearch[index].longitude.toString() : pdflist[index].longitude.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        //  pw.Padding(
                        //   padding: pw.EdgeInsets.only(
                        //       left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                        //   child: pw.SizedBox(
                        //     width: 50,
                        //     child: pw.Text(article.address.toString(),
                        //         style: pw.TextStyle(fontSize: fontsize)),
                        //   ),
                        // ),
                      ])
                    ]);
              },
              itemCount: applyclicked ? pdffilter.length : issearch ? pdfsearch.length : pdflist.length)
          // ),
        ];
      },
    ));

    return PdfApi.saveDocument(name:applyclicked ? 'OverSpeedFilterReport.pdf': issearch ? 'OverSpeedSearchReport.pdf': 'OverSpeedReport.pdf', pdf: pdf);
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
