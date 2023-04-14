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
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../model/report/search_vehicle_status_response.dart';
import '../../model/report/vehicle_status_filter_report.dart';
import '../../model/report/vehicle_status_group.dart';
import '../../model/report/vehicle_status_report.dart';
import '../../model/report/vehicle_status_report_drivercode.dart';
import '../../model/report/vehicle_vsrno.dart';
import '../../model/searchString.dart';
import '../../util/search_bar_field.dart';

class VehicleStatusReport extends StatefulWidget {
  const VehicleStatusReport({Key? key}) : super(key: key);

  @override
  _VehicleStatusReportState createState() => _VehicleStatusReportState();
}

class _VehicleStatusReportState extends State<VehicleStatusReport> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  TextEditingController searchController = new TextEditingController();

  late bool isSearch = false;
  bool isFilter = false;
  bool applyclick = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController,
      vehiclenumber;
  int pageNumber = 1;
  int pageSize = 10;
  int value = 0;
  late String srNo = "";
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
  TextEditingController fromtimeInput = TextEditingController();
  TextEditingController totimeInput = TextEditingController();
  late String vehicleRegNo = "";
  late String branchName = "", userType = "";
  String fromTime = "08:30",
      toDate = "30-sep-2022",
      fromDate = "01-sep-2022",
      toTime = "18:30";
  int imeino = 867322033819244;
  String arai = "arai";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 1, vendorid = 1;
  List<VehicleStatusReportData>? data = [];
  List<DatewiseTravelHoursDataItem>? searchData = [];
  List<VSRDCData>? vsrdcData = [];
  List<VehicleVSrNoData>? osvfdata = [];
  bool isvsrdc = false;
  var vsrdcvehicleno;
  var vsrdcvsrnolisttiletext;

  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  List<Datum>? allVehicleDetaildatalist = [];
  // List<Data>? searchData=[];

  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  List<ReportVehicleStatusFilter>? vehiclestatusfilterreport = [];
  SearchStringClass searchClass = SearchStringClass(searchStr: '');
  bool isSelected = false;

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
    _mainBloc.add(vehicleStatusReportEvent(
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

  // late SharedPreferences sharedPreferences;
  // late String token="";
  // late int branchid=0,vendorid=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isFilter ? Text("VEHICLE STATUS REPORT") : Text("Filter"),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                isFilter = true;
                isFilter
                    ? _mainBloc.add(VehicleVSrNoEvent(
                        token: token, vendorId: 1, branchId: 1))
                    : Text("Driver code not loaded");
              });
            },
            child: !isFilter
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
                            isFilter = false;
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
    print("branchid ${branchid}   Vendor id   ${vendorid}");

    //print(""+vendorid.toString()+" "+branchid.toString()+" "+userName+" "+vendorName+" "+branchName+" "+userType);

    if (token != "" ||
        vehicleRegNo != 0 ||
        imeino != 0 ||
        transDate != "" ||
        overSpeed != "") {}
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
          // Driver code -----------------
          if (state is VehicleStsRptDriverCodeLoadingState) {
            print("Entering in driver code filter Loading State");
          } else if (state is VehicleStsRptDriverCodeLoadedState) {
            print("Entering in driver code filter Loaded State");
            vsrdcData!.clear();
            vsrdcData!.addAll(state.dmfdriverCoderesponse.data!);
          } else if (state is VehicleStsRptDriverCodeErorrState) {
            print("Entering in driver code filter Error State");
          }
          // filter -----------------
          if (state is VehicleStatusFilterLoadingState) {
            print("Entering in filter Loading State");
            setState(() {
              _isLoading = true;
            });
          } else if (state is VehicleStatusFilterLoadedState) {
            print("Entering in filter Loaded State");
            setState(() {
              _isLoading = false;
              vehiclestatusfilterreport!.clear();
              vehiclestatusfilterreport!
                  .addAll(state.VehicleStatusReportResponse.data!);
            });
          } else if (state is VehicleStatuFilterErrorState) {
            print("Entering in filterError State");
            setState(() {
              _isLoading = false;
            });
          }
          // get data --------------
          if (state is VehicleStatusReportLoadingState) {
            setState(() {
              _isLoading = true;
            });
            print("Entering in Loading State");
          } else if (state is VehicleStatusReportLoadedState) {
            if (state.VehicleStatusReportResponse.data != null) {
              pageNumber++;
              print("Entering in Loaded State");
              setState(() {
                _isLoading = false;
                value = state.VehicleStatusReportResponse.totalRecords!;
              });
              data!.addAll(state.VehicleStatusReportResponse.data!);
            }
          } else if (state is VehicleStatusReportErrorState) {
            print("Entering in Error State");
            setState(() {
              _isLoading = false;
            });
          }
          //! Vehicle Status Search Report-------------------------------------
          if (state is SearchVehicleStatusReportLoadingState) {
            _isLoading = true;
          } else if (state is SearchVehicleStatusReportLoadedState) {
            setState(() {
              _isLoading = false;
              searchData!.clear();
              searchData!.addAll(state.searchvehicleStatusGroupResponse.data!);
            });
          } else if (state is SearchVehicleStatusReportErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: isFilter
            //! filterscreen clicked-----------------------------
            ? SingleChildScrollView(
                controller: notificationController,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
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
                                        totimeInput.text = "";
                                        fromtimeInput.text = "";
                                        todateInput.text = "";
                                        fromdateInput.text = "";
                                        vsrdcvsrnolisttiletext = "-select-";
                                        setState(() {});
                                        // Navigator.pop(context,{"FilterAlert":false});
                                      },
                                    ),
                                  ])),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                  height: 36,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.blue,
                                  ),
                                  child: TextButton(
                                      child: const Text("Apply",
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        print("Applyy clicked");
                                        _mainBloc.add(Vehiclestatusreportfilter(
                                          token: token,
                                          vendorId: vendorid,
                                          branchid: branchid,
                                          araino: arai,
                                          fromdate: fromDateController,
                                          fromTime: fromTimeController,
                                          toDate: toDateController,
                                          toTime: toTimeController,
                                          vehiclelist:
                                              vsrdcvehicleno.toString() == null
                                                  ? "ALL"
                                                  : vsrdcvehicleno.toString(),
                                          imeno: imeino,
                                          pagesize: pageSize,
                                          pagenumber: 1,
                                        ));
                                        setState(() {
                                          isFilter = false;
                                          applyclick = true;
                                        });
                                      })),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
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
                                            color: MyColors.redColorCode)),
                                  )
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
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
                                        width:
                                            MediaQuery.of(context).size.width -
                                                58,
                                        child: Text(items,
                                            style: TextStyle(fontSize: 18))),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          bottom: 20,
                        )),
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
                                            color: MyColors.redColorCode)),
                                  )
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Container(
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
                                  value: dropdownvalue2,
                                  menuMaxHeight: 300,
                                  onChanged: (value) {},
                                  items: branchitems.map((String items) {
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
                                              style: TextStyle(fontSize: 18))),
                                    );
                                  }).toList(),
                                ),
                              )),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                          bottom: 20,
                        )),
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
                                            color: MyColors.redColorCode)),
                                  )
                                ],
                              ),
                            )),
                        Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: MyColors.whiteColorCode,
                                border: Border.all(
                                    color: MyColors.textBoxBorderColorCode,
                                    width: 2)),
                            child: ListTile(
                              leading: Text(
                                vsrdcvsrnolisttiletext == null
                                    ? "-select-"
                                    : vsrdcvsrnolisttiletext,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                              trailing: isvsrdc
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.keyboard_arrow_up,
                                      ),
                                      onPressed: () {
                                        isvsrdc = false;
                                        setState(() {});
                                      },
                                    )
                                  : IconButton(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      onPressed: () {
                                        isvsrdc = true;
                                        setState(() {});
                                      },
                                    ),
                            )),
                        isvsrdc
                            ? Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(blurRadius: 5.0, spreadRadius: 1),
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
                                              fontWeight: FontWeight.w400),
                                        ),
                                        onTap: () {
                                          print(article.vehicleRegNo);
                                          setState(() {
                                            isvsrdc = false;
                                            vsrdcvehicleno =
                                                article.vsrNo.toString();
                                            print("This is vehicleregno - " +
                                                vsrdcvehicleno);
                                            vsrdcvsrnolisttiletext =
                                                article.vehicleRegNo.toString();
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SizedBox(),
                        Padding(
                            padding: EdgeInsets.only(
                          bottom: 20,
                        )),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: const [
                                  Text(
                                    "From Date/Time",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 3.0),
                                    child: Text("*",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: MyColors.redColorCode)),
                                  )
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100));

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String formattedDate =
                                          DateFormat('dd-MMM-yyyy', 'en_US')
                                              .format(pickedDate);
                                      formattedDate =
                                          formattedDate.replaceRange(
                                              3,
                                              6,
                                              formattedDate
                                                  .substring(3, 6)
                                                  .toLowerCase());
                                      print("FormatDate is Set-----------");
                                      print(formattedDate);
                                      fromDateController = formattedDate;
                                      setState(() {
                                        fromdateInput.text = fromDateController;
                                      });
                                    } else {}
                                  },
                                  readOnly: true,
                                  controller: fromdateInput,
                                  enabled: true,
                                  decoration: const InputDecoration(
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
                              // ignore: prefer_const_constructors
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: TextField(
                                    onTap: () async {
                                      final DateFormat formatter = DateFormat(
                                          'H:mm',
                                          Localizations.localeOf(context)
                                              .toLanguageTag());
                                      final TimeOfDay? picked =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now());
                                      builder:
                                      (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(
                                                    alwaysUse24HourFormat:
                                                        true),
                                            child: child!);
                                      };
                                      if (picked != null) {
                                        final String fromTime =
                                            formatter.format(DateTime(0, 1, 1,
                                                picked.hour, picked.minute));
                                        fromTimeController = fromTime;
                                        setState(() {
                                          fromtimeInput.text =
                                              fromTimeController;
                                        });
                                      }
                                    },
                                    readOnly: true,
                                    enabled: true, // to trigger disabledBorder
                                    decoration: const InputDecoration(
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
                                    controller: fromtimeInput,
                                    // onChanged: _authenticationFormBloc.onPasswordChanged,
                                    obscureText: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: const [
                                  Text(
                                    "To Date/Time",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 3.0),
                                    child: Text("*",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: MyColors.redColorCode)),
                                  )
                                ],
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: TextField(
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1950),
                                        lastDate: DateTime(2100));

                                    if (pickedDate != null) {
                                      print(pickedDate);
                                      String toDate =
                                          DateFormat('dd-MMM-yyyy', 'en_US')
                                              .format(pickedDate);
                                      toDate = toDate.replaceRange(3, 6,
                                          toDate.substring(3, 6).toLowerCase());
                                      print("toDate is Set-----------");
                                      toDateController = toDate;
                                      setState(() {
                                        todateInput.text = toDateController;
                                      });
                                    } else {}
                                  },
                                  readOnly: true,
                                  enabled: true,
                                  controller:
                                      todateInput, // to trigger disabledBorder
                                  decoration: const InputDecoration(
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
                                    onTap: () async {
                                      final DateFormat formatter = DateFormat(
                                          'H:mm',
                                          Localizations.localeOf(context)
                                              .toLanguageTag());
                                      final TimeOfDay? picked =
                                          await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now());
                                      builder:
                                      (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                            data: MediaQuery.of(context)
                                                .copyWith(
                                                    alwaysUse24HourFormat:
                                                        true),
                                            child: child!);
                                      };
                                      if (picked != null) {
                                        final String toTime = formatter.format(
                                            DateTime(0, 1, 1, picked.hour,
                                                picked.minute));
                                        toTimeController = toTime;
                                        setState(() {
                                          totimeInput.text = toTimeController;
                                        });
                                      }
                                    },
                                    readOnly: true,
                                    enabled: true, // to trigger disabledBorder
                                    decoration: const InputDecoration(
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
                                    controller: totimeInput,
                                    // onChanged: _authenticationFormBloc.onPasswordChanged,
                                    obscureText: false,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
                            Container(
                              margin: const EdgeInsets.only(left: 15),
                              padding: const EdgeInsets.only(
                                  top: 6.0, left: 15, right: 15, bottom: 6),
                              decoration: BoxDecoration(
                                  color: MyColors.lightblueColorCode,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: Row(
                                children: [
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

                          applyclick
                              ? BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                  return Text(
                                    vehiclestatusfilterreport!.length
                                            .toString() +
                                        " Filter Records found",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  );
                                })
                              : isSelected
                                  ? Text(
                                      searchData!.length.toString() +
                                          " Records found",
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
                          applyclick
                              ? Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 20),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      color: MyColors.bluereportColorCode,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                  : "30-sep-2022",
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
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text("MH12AB0015",
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Speed Limit",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                  Text("50",
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
                          // Padding(
                          //   padding: EdgeInsets.all(8),
                          //   child: Column(
                          //     children: [
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Center(
                          //           child: Text(
                          //             "Group By " +
                          //                 "(" +
                          //                 "MH12AA0011" +
                          //                 ")" +
                          //                 " Total :- " +
                          //                 "17:30:00",
                          //             style: TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         ),
                          //       ),
                          //       Center(
                          //         child: Text(
                          //           "Group By ( ${fromDateController ?? "01-sep-2022"} ) Total :- 17:30:56",
                          //           style: TextStyle(
                          //               fontSize: 18,
                          //               fontWeight: FontWeight.w600),
                          //         ),
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.all(8.0),
                          //         child: Center(
                          //           child: Text(
                          //             " Total Over Speed Distance Travel " +
                          //                 "17:30:56",
                          //             style: TextStyle(
                          //                 fontSize: 18,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          applyclick
                              ? vehiclestatusfilterreport!.isEmpty
                                  ? Center(
                                      child: Text(
                                      "No data found",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500),
                                    ))
                                  : BlocBuilder<MainBloc, MainState>(
                                      builder: (context, state) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          controller: vehicleRecordController,
                                          itemCount:
                                              vehiclestatusfilterreport!.length,
                                          itemBuilder: (context, index) {
                                            var article =
                                                vehiclestatusfilterreport![
                                                    index];
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
                                                                      "1",
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
                                                                    "IMEI",
                                                                    style: TextStyle(
                                                                        color: MyColors
                                                                            .textprofiledetailColorCode,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    article
                                                                        .imei!,
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
                                                                      "Vendor Reg No",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .vehicleregNo!,
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
                                                                    "GPsFix",
                                                                    style: TextStyle(
                                                                        color: MyColors
                                                                            .textprofiledetailColorCode,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    "1",
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
                                                                      "Start Time",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .startTime!,
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
                                                                    "End Time",
                                                                    style: TextStyle(
                                                                        color: MyColors
                                                                            .textprofiledetailColorCode,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    article
                                                                        .endTime!,
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
                                                                      "Ignition",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      "1",
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
                                                                    "Speed",
                                                                    style: TextStyle(
                                                                        color: MyColors
                                                                            .textprofiledetailColorCode,
                                                                        fontSize:
                                                                            18),
                                                                  ),
                                                                  Text(
                                                                    "005",
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
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .vehicleStatus!,
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
                                                                    "vehicle Status Time",
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
                                    })
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
                                                                        "1",
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
                                                                      "IMEI",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .imei!,
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
                                                                        "Vendor Reg No",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .vehicleregNo!,
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
                                                                      "GPsFix",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      "1",
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
                                                                        "Start Time",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        article
                                                                            .startTime!,
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
                                                                      "End Time",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      article
                                                                          .endTime!,
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
                                                                        "Ignition",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        "1",
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
                                                                      "Speed",
                                                                      style: TextStyle(
                                                                          color: MyColors
                                                                              .textprofiledetailColorCode,
                                                                          fontSize:
                                                                              18),
                                                                    ),
                                                                    Text(
                                                                      "005",
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
                                                                      "vehicle Status Time",
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
                                      ? SizedBox()
                                      : _isLoading
                                          ? Text(
                                              "Please Wait for data..",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            )
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
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.imei!,
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
                                                                                "Vendor Reg No",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.vehicleregNo!,
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
                                                                              "GPsFix",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              "1",
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
                                                                                "Start Time",
                                                                                style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                              ),
                                                                              Text(
                                                                                article.startTime!,
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
                                                                              "End Time",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.endTime!,
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
                                                                                "Ignition",
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
                                                                              "Speed",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              "005",
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
                                                                                article.vehicleStatus!,
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
                                                                              "vehicle Status Time",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              article.vehicleStatusTime!,
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
                                              )
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
        isSelected = false;
      });
      return;
    } else {
      if (text.isNotEmpty || text.length > 0) {
        setState(() {
          isSelected = true;
          searchClass.searchStr = text;
        });

        _mainBloc.add(SearchVehicleStatusEvent(
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
            pagesize: pageSize));
      }
    }
  }
}
