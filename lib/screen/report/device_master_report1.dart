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
import 'package:permission_handler/permission_handler.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/device_master/search_device_master_report.dart';
import '../../model/report/device_master_filter.dart';
import '../../model/report/device_master_filter_drivercode.dart';
import '../../model/report/device_master_report.dart';
import '../../model/report/over_speed_report_response.dart';
import '../../model/searchString.dart';
import '../../util/search_bar_field.dart';
import 'package:csv/csv.dart';
import 'package:http/http.dart' as http;

class DeviceMasterReportScreen extends StatefulWidget {
  const DeviceMasterReportScreen({Key? key}) : super(key: key);

  @override
  _DeviceMasterReportScreenState createState() =>
      _DeviceMasterReportScreenState();
}

class _DeviceMasterReportScreenState extends State<DeviceMasterReportScreen> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  ScrollController filnotificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  bool applyclicked = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  int value = 0;
  String deviceno = "DC00001";
  late String srNo = "";
  late String vehicleRegNo = "";
  late String imeino = "", branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 1, vendorid = 1;
  List<DeviceMasterData>? devicemasterdata = [];
  List<DMDFData>? dmdfdata = [];
  List<DeviceData>? data = [];
  List<DeviceData> pdfdatalist = [];
  List<DeviceMasterData> pdffilterlist = [];
  List<SearchDMReportData> pdfsearchlist = [];
  List<SearchDMReportData>? searchData = [];
  SearchStringClass searchClass = SearchStringClass(searchStr: '');
  int filpagenumber = 1;

  bool isfilter = false;
  bool isdmdf = false;
  var dmdfdeviceno;
  var dmdfdevicenolisttext;
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

  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  // List<Datum>? allVehicleDetaildatalist = [];
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdataVS();
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
    _mainBloc.add(DeviceMasterReportEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        pagenumber: pageNumber,
        pagesize: pageSize));
  }

  getfilter() {
    _mainBloc.add(DeviceMasterFilter(
        token: token,
        vendorid: "1",
        branchid: "1",
        deviceno: dmdfdeviceno == null ? "All" : dmdfdeviceno,
        pagenumber: filpagenumber,
        pagesize: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter ? Text("DEVICE MASTER REPORT") : Text("Filter"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isfilter = true;
                dmdfdeviceno = "";
                dmdfdevicenolisttext = "";
                isfilter
                    ? _mainBloc.add(DeviceMasterDrivercode(
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
          if (state is SearchDeviceMasterReportLoadingState) {
            print("Search Device Master filter is enter in the loading state");
          } else if (state is SearchDeviceMasterReportLoadedState) {
            print("Search Device Master Filter Loaded Satet is enter");
            setState(() {
              searchData!.clear();
              searchData!.addAll(state.searchdmReportResponse.data!);
            });
          } else if (state is SearchDeviceMasterReportErrorState) {
            print("Search Device master error");
            setState(() {
              _isLoading = false;
            });
          }
          // device master driver code filter
          if (state is DMFDriverCodeLoadingState) {
            print(
                "Device Master filter driver code is enter in the loading state");
          } else if (state is DMFDriverCodeLoadedState) {
            print("Device Master Filter driver code Loaded Satet is enter");
            setState(() {
              dmdfdata!.clear();
              dmdfdata!.addAll(state.dmfdriverCoderesponse.data!);
            });
          }
          if (state is DeviceMasterFilterLoadingState) {
            print("Device Master filter is enter in the loading state");
            setState(() {
              _isLoading = true;
            });
          } else if (state is DeviceMasterFilterLoadedState) {
            print("Device Master Filter Loaded Satet is enter");
            if (state.deviceMasterFilter.data != null) {
              filpagenumber++;
              print("Device master data loaded");
              setState(() {
                _isLoading = false;
                devicemasterdata!.clear();
                value = state.deviceMasterFilter.totalRecords!;
              });
              devicemasterdata!.addAll(state.deviceMasterFilter.data!);
            } else {
              setState(() {
                _isLoading = false;
              });
            }
          } else if (state is DeviceMasterFilterErorrState) {
            print("Device master filter error");
            setState(() {
              _isLoading = false;
            });
          } else if (state is DeviceMasterReportLoadingState) {
            print("Device Master is enter in the loading state");
            setState(() {
              _isLoading = true;
            });
          } else if (state is DeviceMasterReportLoadedState) {
            if (state.deviceData.data != null) {
              pageNumber++;
              print("Device master data loaded");
              setState(() {
                _isLoading = false;
                value = state.deviceData.totalRecords!;
              });
              data!.addAll(state.deviceData.data!);
            }
          } else if (state is DeviceMasterReportErorrState) {
            print("Device master error");
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
                                        dmdfdeviceno = "";
                                        dmdfdevicenolisttext = "";
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
                                          if (dmdfdeviceno != "") {
                                            _mainBloc.add(DeviceMasterFilter(
                                                token: token,
                                                vendorid: "1",
                                                branchid: "1",
                                                deviceno: dmdfdeviceno == ""
                                                    ? "All"
                                                    : dmdfdeviceno,
                                                pagenumber: 1,
                                                pagesize: 200));
                                            setState(() {
                                              isfilter = false;
                                              applyclicked = true;
                                            });
                                          } else {
                                            Fluttertoast.showToast(
                                              msg: "Enter device name..!",
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
                                          "Device Name",
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
                                      dmdfdevicenolisttext == ""
                                          ? "-select-"
                                          : dmdfdevicenolisttext,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    trailing: isdmdf
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.keyboard_arrow_up,
                                            ),
                                            onPressed: () {
                                              isdmdf = false;
                                              setState(() {});
                                            },
                                          )
                                        : IconButton(
                                            icon: Icon(
                                              Icons.keyboard_arrow_down,
                                            ),
                                            onPressed: () {
                                              isdmdf = true;
                                              setState(() {});
                                            },
                                          ),
                                  )),
                              isdmdf
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
                                        shrinkWrap: true,
                                        controller: vehicleRecordController,
                                        itemCount: dmdfdata!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var article = dmdfdata![index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              child: Text(
                                                article.deviceName!.toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              onTap: () {
                                                print(article.deviceNo);
                                                isdmdf = false;
                                                setState(() {
                                                  dmdfdeviceno =
                                                      article.deviceNo;
                                                  dmdfdevicenolisttext =
                                                      article.deviceName;
                                                });
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  : SizedBox()
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
                                      print("get length " +
                                          data!.length.toString());
                                      print("Filter length " +
                                          devicemasterdata!.length.toString());
                                      shareDeviceData(data!, devicemasterdata!,
                                          applyclicked, searchData!, isSearch);
                                      Navigator.of(context)
                                          .popUntil((route) => route.isCurrent);
                                      /* final result = await FilePicker.platform
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
                                        Navigator.of(context).popUntil(
                                            (route) => route.isCurrent);
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: "Download the pdf first",
                                          toastLength: Toast.LENGTH_SHORT,
                                          timeInSecForIosWeb: 1,
                                        );
                                      } */
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
                                pdffilterlist.addAll(devicemasterdata!);
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
                                      isSearch);
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
                          BlocBuilder<MainBloc, MainState>(
                              builder: (context, state) {
                            return Text(
                              isSearch
                                  ? searchData!.isEmpty
                                      ? ""
                                      : searchData!.length.toString() +
                                          " Record found"
                                  : applyclicked
                                      ? devicemasterdata!.isEmpty
                                          ? ""
                                          : devicemasterdata!.length
                                                  .toString() +
                                              " Filter Records found"
                                      : data!.length.toString() +
                                          " Records found",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            );
                          }),
                          applyclicked
                              ? devicemasterdata!.isEmpty
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
                                                itemCount:
                                                    devicemasterdata!.length,
                                                itemBuilder: (context, index) {
                                                  print(
                                                      "Enter in the filter list");
                                                  var article =
                                                      devicemasterdata![index];
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
                                                                          "Device No",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .deviceNo
                                                                              .toString(),
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
                                                                            "Model No",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.modelNo.toString(),
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
                                                                          "Device Name",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          article
                                                                              .deviceName
                                                                              .toString(),
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
                                                                            "IMEINo",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.imeino.toString(),
                                                                            style:
                                                                                TextStyle(color: MyColors.text5ColorCode, fontSize: 18),
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
                              : !isSearch
                                  ? BlocBuilder<MainBloc, MainState>(
                                      builder: (context, state) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          controller: vehicleRecordController,
                                          itemCount: data!.length,
                                          itemBuilder: (context, index) {
                                            var sr = index + 1;
                                            var article = data![index];
                                            // print("Enter in the filter list");
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
                                                          Radius.circular(10)),
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
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .srNo
                                                                          .toString(),
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .text5ColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                                                                    "Device No",
                                                                    style: TextStyle(
                                                                        color: MyColors
                                                                            .textprofiledetailColorCode,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    article
                                                                        .deviceNo!,
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
                                                                      "Model No",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .modelNo!,
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .text5ColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
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
                                                                    "Device Name",
                                                                    style: TextStyle(
                                                                        color: MyColors
                                                                            .textprofiledetailColorCode,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    article
                                                                        .deviceName!,
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
                                                                      "IMEINo",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .imeino!,
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .text5ColorCode,
                                                                          fontSize:
                                                                              18),
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
                                          : BlocBuilder<MainBloc, MainState>(
                                              builder: (context, state) {
                                              return ListView.builder(
                                                  shrinkWrap: true,
                                                  controller:
                                                      vehicleRecordController,
                                                  itemCount: searchData!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    var sr = index + 1;
                                                    var article =
                                                        searchData![index];
                                                    // print("Enter in the filter list");
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
                                                                .circular(10.0),
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
                                                              BorderRadius.all(
                                                                  Radius
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
                                                                            "Device No",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.deviceNo!,
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
                                                                              "Model No",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.modelNo!,
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
                                                                            "Device Name",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            article.deviceName!,
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
                                                                              "IMEINo",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.imeino!,
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

  String convertDataToCsv(
      List<DeviceData> data,
      List<DeviceMasterData> filterdata,
      bool applyclicked,
      List<SearchDMReportData> searchdata,
      bool issearch) {
    List<List<dynamic>> rows = [];
    // Add headers
   applyclicked ?rows.add(["Device Master Filter "]) : isSearch ? rows.add(["Device Master Search"]) : rows.add(["Device Master Data"]);
    rows.add(['SrNo', 'DeviceNo', 'ModelNo', 'DeviceName', 'IMEINo']);

    // Add data rows
    if (applyclicked) {
      for (var fitem in filterdata) {
        // print("This is filter lenght");
        print("Filter data" + filterdata.toString());
        rows.add([
          fitem.srNo,
          fitem.deviceNo,
          fitem.modelNo,
          fitem.deviceName,
          fitem.imeino
        ]);
      }
    } else if (isSearch) {
      for (var item in searchdata) {
        // print("This is filter lenght");
        print("Search data" + searchdata.toString());
        rows.add([
          item.srNo,
          item.deviceNo,
          item.modelNo,
          item.deviceName,
          item.imeino
        ]);
      }
    } else {
      for (var item in data) {
        // print("This is filter lenght");
        print("Filter data" + filterdata.toString());
        rows.add([
          item.srNo,
          item.deviceNo,
          item.modelNo,
          item.deviceName,
          item.imeino
        ]);
      }
    }
    return ListToCsvConverter().convert(rows);
  }


  Future<File> saveCsvFile(
      String csvFilterData, bool applyclicked, bool issearch) async {
    final directory = await getTemporaryDirectory();
    final filePath = isSearch
        ? '${directory.path}/search_master.csv'
        : applyclicked
            ? '${directory.path}/Filter_master.csv'
            : '${directory.path}/device_master.csv';
    final file = File(filePath);
    return file.writeAsString(csvFilterData);
  }

  void shareCsvFile(File csvFilterFile) {
    Share.shareFiles([csvFilterFile.path],
        text: 'Sharing device data CSV file');
  }

  void shareDeviceData(
      List<DeviceData> deviceData,
      List<DeviceMasterData> filterdata,
      bool applyclicked,
      List<SearchDMReportData> searchdata,
      bool issearch) async {
    String csvData = convertDataToCsv(
        deviceData, filterdata, applyclicked, searchdata, issearch);
    File csvFile = await saveCsvFile(csvData, applyclicked, issearch);
    print("This is csv Filter data " + csvData);

    shareCsvFile(csvFile);
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
      _mainBloc.add(SearchDeviceMasterReportDetailsEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchText: searchClass.searchStr,
      ));
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(
      List<DeviceData> pdflist,
      List<DeviceMasterData> pdffilter,
      bool applyclicked,
      List<SearchDMReportData> pdfsearch,
      bool issearch) async {
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
              child: pw.Text("DEVICE MASTER REPORT",
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
                          "Device No",
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
                          "Model No",
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
                          "Device Name",
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
                          "IMEI No",
                          style: pw.TextStyle(
                              fontSize: 12.0, fontWeight: pw.FontWeight.bold),
                        ),
                      )),
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
                            width: 20,
                            child: pw.Text(sr.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                                applyclicked
                                    ? pdffilter[index].deviceNo.toString()
                                    : issearch
                                        ? pdfsearch[index].deviceNo.toString()
                                        : pdflist[index].deviceNo.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                                applyclicked
                                    ? pdffilter[index].modelNo.toString()
                                    : issearch
                                        ? pdfsearch[index].modelNo.toString()
                                        : pdflist[index].modelNo.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                                applyclicked
                                    ? pdffilter[index].deviceName.toString()
                                    : issearch
                                        ? pdfsearch[index].deviceName.toString()
                                        : pdflist[index].deviceName.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.only(
                              left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                          child: pw.SizedBox(
                            width: 20,
                            child: pw.Text(
                                applyclicked
                                    ? pdffilter[index].imeino.toString()
                                    : issearch
                                        ? pdfsearch[index].imeino.toString()
                                        : pdflist[index].imeino.toString(),
                                style: pw.TextStyle(fontSize: fontsize)),
                          ),
                        ),
                      ])
                    ]);
              },
              itemCount: applyclicked
                  ? pdffilter.length
                  : issearch
                      ? pdfsearch.length
                      : pdflist.length),
        ];
      },
    ));

    return PdfApi.saveDocument(
        name: applyclicked
            ? 'DeviceMasterFilterreport.pdf'
            : issearch
                ? 'DeviceMasterSearchreport.pdf'
                : 'DeviceMasterreport.pdf',
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
