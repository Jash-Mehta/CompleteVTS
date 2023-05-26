import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/home/home_screen.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/src/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Driver_Master/driver_master.dart';
import '../../model/Driver_Master/driver_master_drivercode.dart';
import '../../model/Driver_Master/search_driver_master_report_response.dart';
import '../../model/alert/all_alert_master_response.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import '../../model/Driver_Master/driver_master_filter.dart';
import '../../model/report/over_speed_report_response.dart';
import '../../model/searchString.dart';
import '../../util/search_bar_field.dart';

class DriverMasterReportScreen extends StatefulWidget {
  const DriverMasterReportScreen({Key? key}) : super(key: key);

  @override
  _DriverMasterReportScreenState createState() =>
      _DriverMasterReportScreenState();
}

class _DriverMasterReportScreenState extends State<DriverMasterReportScreen> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  late bool filtersearch = false;
  int value = 0;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  late String srNo = "";
  late String vehicleRegNo = "";
  late String imeino = "", branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 1, vendorid = 1;
  List<DriverMasterData>? data = [];
  List<DriverMasterData>? pdfdatalist = [];
  List<FilterData>? pdffilterlist = [];
  List<FindDriverMasterData>? pdfsearchlist = [];
  List<FindDriverMasterData>? searchData = [];
  SearchStringClass searchClass = SearchStringClass(searchStr: '');
  List<FilterData>? filterData = [];
  List<DMDCData>? dmdcData = [];
  bool isdmdc = false;
  var dmdcvehno;
  var dmdcvehnolisttiletext;

  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  List<Datum>? allVehicleDetaildatalist = [];
  // List<Data>? searchData=[];

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

  bool isfilter = false;
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

  String dropdownvalue3 = 'All';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataDM();
    notificationController.addListener(() {
      if (notificationController.position.maxScrollExtent ==
          notificationController.offset) {
        setState(() {
          getdata();
          getallbranch();
          // getfilter();
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
  }

  getdataDM() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "" || vendorid != 0 || branchid != 0) {
      print(token);
      getallbranch();
      // getfilter();
      // getTravelSummaryFilter();
      setState(() {});
    } else {
      print("null");
    }
  }

  getallbranch() {
    _mainBloc.add(DriverMasterEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        pageSize: pageSize,
        pageNumber: pageNumber));
  }

  // getfilter() {
  //   _mainBloc.add(DriverMasterFilterEvent(
  //     token: token,
  //     vendorId: vendorid,
  //     branchid: branchid,
  //     drivercode: "ALL",
  //     pagenumber: pageNumber,
  //     pagesize: pageSize,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter ? Text("DRIVER MASTER REPORT") : Text("Filter "),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isfilter = true;
                dmdcvehno = "";
                dmdcvehnolisttiletext = "";
                isfilter
                    ? _mainBloc.add(DriverMasterDriverCodeEvent(
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
            // Driver Code -----------------
            if (state is DriverMasterDriverCodeLoadingState) {
              print("Entering in Driver Code FILTER loading state");
            } else if (state is DriverMasterDriverCodeLoadedState) {
              print("Driver master Driver Code FILTER data loaded");
              dmdcData!.clear();
              dmdcData!.addAll(state.dmfdriverCoderesponse.data!);
            } else if (state is DriverMasterDriverCodeErorrState) {
              print("Driver master Driver Code Error");
            }
            // Filter--------------
            if (state is DriverMasterFilterLoadingState) {
              print("Entering in FILTER loading state");
              setState(() {
                _isLoading = true;
              });
            } else if (state is DriverMasterFilterLoadedState) {
              print("Driver master FILTER data loaded");
              if (state.driverMasterFilter.data != null) {
                setState(() {
                  _isLoading = false;
                  filterData!.clear();
                  value = state.driverMasterFilter.totalRecords!;
                });
                filterData!.addAll(state.driverMasterFilter.data!);
              } else {
                _isLoading = false;
              }
            } else if (state is DriverMasterFilterErorrState) {
              setState(() {
                _isLoading = false;
              });
            }
            if (state is DriverMasterLoadingState) {
              setState(() {
                _isLoading = true;
              });
              print("Entering in loading state");
            } else if (state is DriverMasterLoadedState) {
              print("Driver master data loaded");
              if (state.drivermasterreportresponse.data != null) {
                setState(() {
                  pageNumber++;
                  _isLoading = false;
                  value = state.drivermasterreportresponse.totalRecords!;
                });
                data!.addAll(state.drivermasterreportresponse.data!);
              }
            } else if (state is DriverMasterErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
            if (state is SearchDriverMasterReportLoadingState) {
              print("Entering in Search loading state");
              setState(() {
                _isLoading = true;
              });
            } else if (state is SearchDriverMasterReportLoadedState) {
              print("Entering in search Loaded state");
              setState(() {
                searchData!.clear();
                _isLoading = false;
                searchData!.addAll(state.searchResponse.data!);
              });
            } else if (state is SearchDriverMasterReportErrorState) {
              print("Entering in search error state");
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
                                          dmdcvehnolisttiletext = "";
                                          dmdcvehno = "";
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
                                            searchController.text = "";
                                            if (dmdcvehno != "") {
                                              _mainBloc
                                                  .add(DriverMasterFilterEvent(
                                                token: token,
                                                vendorId: vendorid,
                                                branchid: branchid,
                                                drivercode: dmdcvehno,
                                                pagenumber: 1,
                                                pagesize: 200,
                                              ));
                                              setState(() {
                                                isfilter = false;
                                                applyclicked = true;
                                                searchController.text = "";
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                msg: "Enter driver name..!",
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
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: const [
                                          Text(
                                            "Driver Name",
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
                                        dmdcvehnolisttiletext == ""
                                            ? "-select-"
                                            : dmdcvehnolisttiletext,
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
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down),
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
                                                blurRadius: 5.0,
                                                spreadRadius: 1),
                                          ],
                                          color: Colors.white,
                                        ),
                                        height: 200,
                                        width: double.infinity,
                                        child: ListView.builder(
                                          itemCount: dmdcData!.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            var article = dmdcData![index];
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: GestureDetector(
                                                child: Text(
                                                  article.driverCode!,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                onTap: () {
                                                  print(article.driverCode);
                                                  setState(() {
                                                    isdmdc = false;
                                                    dmdcvehno = article
                                                        .driverCode
                                                        .toString();
                                                    print(
                                                        "This is vehicleregno - " +
                                                            dmdcvehno);
                                                    dmdcvehnolisttiletext =
                                                        article.driverCode
                                                            .toString();
                                                  });
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : SizedBox(),
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
                              decoration: BoxDecoration(
                                  color: MyColors.analyticActiveColorCode,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      // final result = await FilePicker.platform
                                      //     .pickFiles(
                                      //         type: FileType.custom,
                                      //         allowedExtensions: ['pdf']);
                                      final result = await FilePicker.platform
                                          .pickFiles(
                                              type: FileType.custom,
                                              allowedExtensions: ['pdf']);
                                      // FilePicker.platform.pickFiles(allowMultiple: false,allowedExtensions:FileType.custom(),);
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
                                pdfdatalist!.clear();
                                pdfdatalist!.addAll(data!);
                                pdffilterlist!.clear();
                                pdffilterlist!.addAll(filterData!);
                                pdfsearchlist!.clear();
                                pdfsearchlist!.addAll(searchData!);
                                setState(() {});
                                var status = await Permission.storage.status;
                                if (await Permission.storage
                                    .request()
                                    .isGranted) {
                                  final pdfFile = await PdfInvoiceApi.generate(
                                      pdfdatalist!,
                                      pdffilterlist!,
                                      applyclicked,
                                      pdfsearchlist!,
                                      isSearch);
                                  PdfApi.openFile(pdfFile);
                                } else {
                                  print("Request is not accepted");
                                  await Permission.storage.request();
                                }
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
                          BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                            return Text(
                              // "10 RECORDS",
                              applyclicked
                                  ? filterData!.isEmpty
                                      ? ""
                                      : filterData!.length.toString() +
                                          " Filter Records found"
                                  : !isSearch
                                      ? data!.length != 0
                                          ? "${data!.length} Records found"
                                          : "0 Records found"
                                      : searchData!.isEmpty
                                          ? ""
                                          : "${searchData!.length} Search Records found",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          }),
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
                                      : BlocBuilder<MainBloc, MainState>(
                                          builder: (context, state) {
                                          return ListView.builder(
                                              shrinkWrap: true,
                                              controller:
                                                  vehicleRecordController,
                                              itemCount: filterData!.length,
                                              itemBuilder: (context, index) {
                                                var article =
                                                    filterData![index];
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
                                                                          article
                                                                              .srNo
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
                                                                        "Driver Code",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .driverCode!,
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
                                                                          "Driver Name",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .driverName!,
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
                                                                        "License No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .licenceNo!,
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
                                                                          "Mobile No",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .mobileNo!,
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
                                                                        "Date of join",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .doj!,
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
                                        })
                              : !isSearch
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
                                                                        article
                                                                            .srNo
                                                                            .toString(),
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
                                                                      "Driver Code",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .driverCode!,
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
                                                                        "Driver Name",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .driverName!,
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
                                                                      "License No",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .licenceNo!,
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
                                                                        "Mobile No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .mobileNo!,
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
                                                                      "Date of join",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .doj!,
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
                                              child: BlocBuilder<MainBloc,
                                                      MainState>(
                                                  builder: (context, state) {
                                                return ListView.builder(
                                                    shrinkWrap: true,
                                                    controller:
                                                        vehicleRecordController,
                                                    itemCount:
                                                        searchData!.length,
                                                    itemBuilder:
                                                        (context, index) {
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
                                                                              Text(
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
                                                                            Text(
                                                                              "Driver Code",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.driverCode!,
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
                                                                                "Driver Name",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.driverName!,
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
                                                                              "License No",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.licenceNo!,
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
                                                                                "Mobile No",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.mobileNo!,
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
                                                                              "Date of join",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.doj.toString(),
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
                                              }))
                          // : applyclicked == true && isSearch == true
                          //     ? searchData!.isEmpty
                          //         ? Center(
                          //             child: Text(
                          //             "No data found",
                          //             style: TextStyle(
                          //                 fontSize: 24,
                          //                 fontWeight:
                          //                     FontWeight.w500),
                          //           ))
                          //         : _isLoading
                          //             ? Center(child: Text("Wait data is Loading.."))
                          //             : Padding(
                          //                 padding: const EdgeInsets.only(top: 20.0),
                          //                 child: BlocBuilder<MainBloc, MainState>(builder: (context, state) {
                          //                   return ListView.builder(
                          //                       shrinkWrap: true,
                          //                       controller:
                          //                           vehicleRecordController,
                          //                       itemCount:
                          //                           searchData!
                          //                               .length,
                          //                       itemBuilder:
                          //                           (context,
                          //                               index) {
                          //                         var article =
                          //                             searchData![
                          //                                 index];
                          //                         return Card(
                          //                           margin: EdgeInsets
                          //                               .only(
                          //                                   bottom:
                          //                                       15),
                          //                           shape:
                          //                               RoundedRectangleBorder(
                          //                             side: BorderSide(
                          //                                 width: 1,
                          //                                 color: MyColors
                          //                                     .textBoxBorderColorCode),
                          //                             borderRadius:
                          //                                 BorderRadius
                          //                                     .circular(
                          //                                         10.0),
                          //                           ),
                          //                           child:
                          //                               Container(
                          //                             padding: EdgeInsets.only(
                          //                                 top: 15,
                          //                                 left: 14,
                          //                                 right: 14,
                          //                                 bottom:
                          //                                     15),
                          //                             width: MediaQuery.of(
                          //                                     context)
                          //                                 .size
                          //                                 .width,
                          //                             decoration:
                          //                                 BoxDecoration(
                          //                               borderRadius:
                          //                                   BorderRadius.all(
                          //                                       Radius.circular(10)),
                          //                             ),
                          //                             child:
                          //                                 SingleChildScrollView(
                          //                               // controller: overSpeedScrollController,
                          //                               child:
                          //                                   Padding(
                          //                                 padding: const EdgeInsets
                          //                                         .only(
                          //                                     top:
                          //                                         20.0,
                          //                                     left:
                          //                                         15,
                          //                                     right:
                          //                                         15,
                          //                                     bottom:
                          //                                         20),
                          //                                 child:
                          //                                     Column(
                          //                                   crossAxisAlignment:
                          //                                       CrossAxisAlignment.start,
                          //                                   children: [
                          //                                     Padding(
                          //                                       padding:
                          //                                           const EdgeInsets.only(top: 15.0, bottom: 15),
                          //                                       child:
                          //                                           Row(
                          //                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //                                         children: [
                          //                                           Expanded(
                          //                                             child: Column(
                          //                                               mainAxisAlignment: MainAxisAlignment.start,
                          //                                               crossAxisAlignment: CrossAxisAlignment.start,
                          //                                               children: [
                          //                                                 Text(
                          //                                                   "Sr.No",
                          //                                                   style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                          //                                                 ),
                          //                                                 Text(
                          //                                                   article.srNo.toString(),
                          //                                                   style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                          //                                                 ),
                          //                                               ],
                          //                                             ),
                          //                                           ),
                          //                                           Expanded(
                          //                                               child: Column(
                          //                                             mainAxisAlignment: MainAxisAlignment.start,
                          //                                             crossAxisAlignment: CrossAxisAlignment.start,
                          //                                             children: [
                          //                                               Text(
                          //                                                 "Driver Code",
                          //                                                 style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                          //                                               ),
                          //                                               Text(
                          //                                                 article.driverCode!,
                          //                                                 textAlign: TextAlign.left,
                          //                                                 style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                          //                                               ),
                          //                                             ],
                          //                                           ))
                          //                                         ],
                          //                                       ),
                          //                                     ),
                          //                                     Padding(
                          //                                       padding:
                          //                                           const EdgeInsets.only(top: 15.0, bottom: 15),
                          //                                       child:
                          //                                           Row(
                          //                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //                                         children: [
                          //                                           Expanded(
                          //                                             child: Column(
                          //                                               mainAxisAlignment: MainAxisAlignment.start,
                          //                                               crossAxisAlignment: CrossAxisAlignment.start,
                          //                                               children: [
                          //                                                 Text(
                          //                                                   "Driver Name",
                          //                                                   style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                          //                                                 ),
                          //                                                 Text(
                          //                                                   article.driverName!,
                          //                                                   style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                          //                                                 ),
                          //                                               ],
                          //                                             ),
                          //                                           ),
                          //                                           Expanded(
                          //                                               child: Column(
                          //                                             mainAxisAlignment: MainAxisAlignment.start,
                          //                                             crossAxisAlignment: CrossAxisAlignment.start,
                          //                                             children: [
                          //                                               Text(
                          //                                                 "License No",
                          //                                                 style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                          //                                               ),
                          //                                               Text(
                          //                                                 article.licenceNo!,
                          //                                                 textAlign: TextAlign.left,
                          //                                                 style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                          //                                               ),
                          //                                             ],
                          //                                           ))
                          //                                         ],
                          //                                       ),
                          //                                     ),
                          //                                     Padding(
                          //                                       padding:
                          //                                           const EdgeInsets.only(top: 15.0, bottom: 15),
                          //                                       child:
                          //                                           Row(
                          //                                         mainAxisAlignment: MainAxisAlignment.spaceAround,
                          //                                         children: [
                          //                                           Expanded(
                          //                                             child: Column(
                          //                                               mainAxisAlignment: MainAxisAlignment.start,
                          //                                               crossAxisAlignment: CrossAxisAlignment.start,
                          //                                               children: [
                          //                                                 Text(
                          //                                                   "Mobile No",
                          //                                                   style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                          //                                                 ),
                          //                                                 Text(
                          //                                                   article.mobileNo!,
                          //                                                   style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                          //                                                 ),
                          //                                               ],
                          //                                             ),
                          //                                           ),
                          //                                           Expanded(
                          //                                               child: Column(
                          //                                             mainAxisAlignment: MainAxisAlignment.start,
                          //                                             crossAxisAlignment: CrossAxisAlignment.start,
                          //                                             children: [
                          //                                               Text(
                          //                                                 "Date of join",
                          //                                                 style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                          //                                               ),
                          //                                               Text(
                          //                                                 article.doj.toString(),
                          //                                                 textAlign: TextAlign.left,
                          //                                                 style: TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
                          //                                               ),
                          //                                             ],
                          //                                           ))
                          //                                         ],
                          //                                       ),
                          //                                     ),
                          //                                   ],
                          //                                 ),
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         );
                          //                       });
                          //                 }))
                          //     : Container()
                        ],
                      ),
                    ),
                  ]))),
    );
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
        if (applyclicked == true && isSearch == true) {
          filtersearch == true;
          filtersearch ? filterData!.clear() : null;
        }
        searchClass.searchStr = text;
      });
      _mainBloc.add(SearchDriverMasterReportEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        searchText: searchClass.searchStr,
        pagenumber: pageNumber,
        pagesize: pageSize,
      ));
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(
      List<DriverMasterData> pdflist,
      List<FilterData> pdffilter,
      bool isfilter,
      List<FindDriverMasterData> pdfsearch,
      bool issearch) async {
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
              child: pw.Text("DRIVER MASTER REPORT",
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
                        width: 30,
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
                          "Driver Code",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Driver Name",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Licence No",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Mobile Number",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
                  pw.Padding(
                      padding: pw.EdgeInsets.only(
                          left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                      child: pw.SizedBox(
                        width: 50,
                        child: pw.Text(
                          "Date of join",
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
                // var article =  pdffilter[index];
                print("This is applyclicked---" + isfilter.toString());
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
                            child: pw.Text(
                                isfilter
                                    ? pdffilter[index].srNo.toString()
                                    : issearch
                                        ? pdfsearch[index].srNo.toString()
                                        : pdflist[index].srNo.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),

                        // pw.SizedBox(
                        //   width: 3.0,
                        // ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 40,
                            child: pw.Text(
                                isfilter
                                    ? pdffilter[index].driverCode.toString()
                                    : issearch
                                        ? pdfsearch[index].driverCode.toString()
                                        : pdflist[index].driverCode.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        // pw.SizedBox(
                        //   width: 3.0,
                        // ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 40,
                            child: pw.Text(
                                isfilter
                                    ? pdffilter[index].driverName.toString()
                                    : issearch
                                        ? pdfsearch[index].driverName.toString()
                                        : pdflist[index].driverName.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        // pw.SizedBox(
                        //   width: 3.0,
                        // ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 40,
                            child: pw.Text(
                                isfilter
                                    ? pdffilter[index].licenceNo.toString()
                                    : issearch
                                        ? pdfsearch[index].licenceNo.toString()
                                        : pdflist[index].licenceNo.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        // pw.SizedBox(
                        //   width: 3.0,
                        // ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 40,
                            child: pw.Text(
                                isfilter
                                    ? pdffilter[index].mobileNo.toString()
                                    : issearch
                                        ? pdfsearch[index].mobileNo.toString()
                                        : pdflist[index].mobileNo.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        // pw.SizedBox(
                        //   width: 3.0,
                        // ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 40,
                            child: pw.Text(
                                isfilter
                                    ? pdffilter[index].doj.toString()
                                    : issearch
                                        ? pdfsearch[index].doj.toString()
                                        : pdflist[index].doj.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        // pw.SizedBox(
                        //   width: 3.0,
                        // ),
                      ])
                    ]);
              },
              itemCount: isfilter
                  ? pdffilter.length
                  : issearch
                      ? pdfsearch.length
                      : pdflist.length)
          // ),
        ];
      },
    ));

    return PdfApi.saveDocument(
        name: isfilter
            ? 'DriverMasterFilterReport.pdf'
            : issearch
                ? 'DriverMasterSearchReport.pdf'
                : 'DriverMasterReport.pdf',
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
