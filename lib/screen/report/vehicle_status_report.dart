import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/alert/all_alert_master_response.dart';

import '../../model/report/vehicle_status_filter_report.dart';
import '../../model/report/vehicle_status_group.dart';
import '../../model/report/vehicle_status_report.dart';

class VehicleStatusReport extends StatefulWidget {
  const VehicleStatusReport({Key? key}) : super(key: key);

  @override
  _VehicleStatusReportState createState() => _VehicleStatusReportState();
}

class _VehicleStatusReportState extends State<VehicleStatusReport> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _branchNamecontroller = new TextEditingController();
  late bool isSearch = false;
  bool filtericonclicked = false;
  bool filterlist = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController,
      vehiclenumber;
  int pageNumber = 1;
  int pageSize = 10;
  late String srNo = "";
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
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
  late int branchid = 0, vendorid = 0;
  List<VehicleStatusReportData>? data = [];
  List<VehicleStatusReportData>? searchData = [];

  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  List<Datum>? allVehicleDetaildatalist = [];
  // List<Data>? searchData=[];

  bool isDataAvailable = false;
  List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  List<ReportVehicleStatusFilter>? vehiclestatusfilterreport = [];
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
    filterlist = false;
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          getdataVS();
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
        title: Text("VEHICLE STATUS REPORT"),
        actions: [
          GestureDetector(
              onTap: () {
                filtericonclicked = true;
                setState(() {});
              },
              child: Icon(Icons.filter))
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
          //! filter------------------------------
          if (state is VehicleStatusFilterLoadingState) {
            print("Entering in filter Loading State");
          } else if (state is VehicleStatusFilterLoadedState) {
            print("Entering in filter Loaded State");
            vehiclestatusfilterreport!.clear();
            vehiclestatusfilterreport!
                .addAll(state.VehicleStatusReportResponse.data!);
          } else if (state is VehicleStatuFilterErrorState) {
            print("Entering in filterError State");
          }
          //! get dataaa------------------------------------------
          if (state is VehicleStatusReportLoadingState) {
            print("Entering in Loading State");
          } else if (state is VehicleStatusReportLoadedState) {
            print("Entering in Loaded State");
            data!.addAll(state.VehicleStatusReportResponse.data!);
          } else if (state is VehicleStatusReportErrorState) {
            print("Entering in Error State");
          }
          if (state is SearchOverSpeedCreateLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is SearchOverSpeedCreateLoadedState) {
            setState(() {
              // searchData!.clear();
              _isLoading = false;
            });
            // if(state.search_overspeed_response.data!=null){
            //   searchData!.addAll(state.search_overspeed_response.data!);
            // }
          } else if (state is SearchOverSpeedCreateErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: filtericonclicked
            //! filterscreen clicked-----------------------------
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Text(
                                "Vendor Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text("*",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: MyColors.redColorCode)),
                              )
                            ],
                          ),
                        )),
                    TextField(
                      controller: _vendorNamecontroller,
                      enabled: false, // to trigger disabledBorder
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.whiteColorCode,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: MyColors.buttonColorCode),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: MyColors.textBoxBorderColorCode),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: MyColors.textBoxBorderColorCode)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 2, color: MyColors.buttonColorCode)),
                        hintText: "Type here",
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: MyColors.textFieldHintColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      // onChanged: _authenticationFormBloc.onPasswordChanged,
                      obscureText: false,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 17, bottom: 8),
                          child: Row(
                            children: [
                              Text(
                                "Branch Name",
                                style: TextStyle(fontSize: 18),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text("*",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: MyColors.redColorCode)),
                              )
                            ],
                          ),
                        )),
                    TextField(
                      controller: _branchNamecontroller,
                      enabled: false, // to trigger disabledBorder
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.whiteColorCode,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: MyColors.buttonColorCode),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide:
                              BorderSide(width: 1, color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          borderSide: BorderSide(
                              width: 1, color: MyColors.textBoxBorderColorCode),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 1,
                                color: MyColors.textBoxBorderColorCode)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                                width: 2, color: MyColors.buttonColorCode)),
                        hintText: "Type here",
                        hintStyle: TextStyle(
                            fontSize: 16,
                            color: MyColors.textFieldHintColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      // onChanged: _authenticationFormBloc.onPasswordChanged,
                      obscureText: false,
                    ),
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
                                formattedDate = formattedDate.replaceRange(
                                    3,
                                    6,
                                    formattedDate
                                        .substring(3, 6)
                                        .toLowerCase());
                                print("FormatDate is Set-----------");
                                print(formattedDate);
                                fromDateController = formattedDate;
                                setState(() {});
                              } else {}
                            },
                            controller: fromdateInput,
                            enabled: true,
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
                                final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                builder:
                                (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!);
                                };
                                if (picked != null) {
                                  final String fromTime = formatter.format(
                                      DateTime(
                                          0, 1, 1, picked.hour, picked.minute));
                                  fromTimeController = fromTime;
                                  setState(() {});
                                }
                              },
                              enabled: true, // to trigger disabledBorder
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
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 10),
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
                                toDate = toDate.replaceRange(
                                    3, 6, toDate.substring(3, 6).toLowerCase());
                                print("toDate is Set-----------");
                                toDateController = toDate;
                                setState(() {});
                              } else {}
                            },
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
                              onTap: () async {
                                final DateFormat formatter = DateFormat(
                                    'H:mm',
                                    Localizations.localeOf(context)
                                        .toLanguageTag());
                                final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());
                                builder:
                                (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                      data: MediaQuery.of(context).copyWith(
                                          alwaysUse24HourFormat: true),
                                      child: child!);
                                };
                                if (picked != null) {
                                  final String toTime = formatter.format(
                                      DateTime(
                                          0, 1, 1, picked.hour, picked.minute));
                                  toTimeController = toTime;
                                  setState(() {});
                                }
                              },
                              enabled: true, // to trigger disabledBorder
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
                            children: const [
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
                            children: const [
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
                              _mainBloc.add(Vehiclestatusreportfilter(
                                  token: token,
                                  vendorId: 1,
                                  branchid: 1,
                                  araino: "",
                                  fromdate: fromDateController,
                                  fromTime: fromTimeController,
                                  toDate: toDateController,
                                  toTime: toTimeController,
                                  vehiclelist: "",
                                  pagesize: 10,
                                  pagenumber: 1,
                                  imeno: 0));
                              setState(() {
                                filtericonclicked = false;
                                filterlist = true;
                              });
                            },
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: const Padding(
                              padding: EdgeInsets.only(
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
              )
            : SingleChildScrollView(
                controller: controller,
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
                          TextField(
                            controller: searchController,
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
                              hintText: "Search By...",
                              prefixIcon: Icon(
                                Icons.search,
                                size: 24,
                                color: MyColors.text3greyColorCode,
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.searchTextColorCode),
                              errorText: "",
                            ),
                            // controller: _passwordController,
                            onChanged: (value) {},
                          ),
                          isSearch
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
                                    data!.length.toString() + " Records found",
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
                                    Text("From Date  -  To Date",
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Text("09/03/2022 - 09/03/2022",
                                    style: TextStyle(fontSize: 18)),
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
                          ),

                          // allVehicleDetaildatalist!.length==0 ?
                          // Container() :
                          Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                return ListView.builder(
                                    shrinkWrap: true,
                                    controller: vehicleRecordController,
                                    itemCount: filterlist
                                        ? vehiclestatusfilterreport!.length
                                        : data!.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        margin: EdgeInsets.only(bottom: 15),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          child: SingleChildScrollView(
                                            // controller: overSpeedScrollController,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20.0,
                                                  left: 15,
                                                  right: 15,
                                                  bottom: 20),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              filterlist
                                                                  ? vehiclestatusfilterreport![
                                                                          index]
                                                                      .imei!
                                                                  : data![index]
                                                                      .imei!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .text5ColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                filterlist
                                                                    ? vehiclestatusfilterreport![
                                                                            index]
                                                                        .vehicleregNo!
                                                                    : data![index]
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
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              "1",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .text5ColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                filterlist
                                                                    ? vehiclestatusfilterreport![
                                                                            index]
                                                                        .startTime!
                                                                    : data![index]
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
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              filterlist
                                                                  ? vehiclestatusfilterreport![
                                                                          index]
                                                                      .endTime!
                                                                  : data![index]
                                                                      .endTime!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .text5ColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              "005",
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .text5ColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                          ],
                                                        ))
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
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
                                                                filterlist
                                                                    ? vehiclestatusfilterreport![
                                                                            index]
                                                                        .vehicleStatus!
                                                                    : data![index]
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
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              filterlist
                                                                  ? vehiclestatusfilterreport![
                                                                          index]
                                                                      .vehicleStatusTime!
                                                                  : data![index]
                                                                      .vehicleStatusTime!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .text5ColorCode,
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
                          /* searchData!.length==0
                        ? Container() :*/
                          // ListView.builder(
                          //     controller: vehicleRecordController,
                          //     shrinkWrap: true,
                          //     physics: ScrollPhysics(),
                          //     itemCount: 5,
                          //     itemBuilder: (context, index) {
                          //       return Card(
                          //         margin: EdgeInsets.only(bottom: 15),
                          //         shape: RoundedRectangleBorder(
                          //           side: BorderSide(
                          //               width: 1,
                          //               color: MyColors
                          //                   .textBoxBorderColorCode),
                          //           borderRadius:
                          //               BorderRadius.circular(10.0),
                          //         ),
                          //         child: Container(
                          //           padding: EdgeInsets.only(
                          //               top: 15,
                          //               left: 14,
                          //               right: 14,
                          //               bottom: 15),
                          //           width:
                          //               MediaQuery.of(context).size.width,
                          //           decoration: BoxDecoration(
                          //             borderRadius: BorderRadius.all(
                          //                 Radius.circular(10)),
                          //           ),
                          //           child: Column(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.start,
                          //             crossAxisAlignment:
                          //                 CrossAxisAlignment.start,
                          //             children: [
                          //               Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment
                          //                         .spaceBetween,
                          //                 children: [
                          //                   Container(
                          //                     child: Icon(
                          //                       Icons.circle,
                          //                       size: 10,
                          //                       color:
                          //                           // searchData![index].acStatus=='Active' ? MyColors.greenColorCode:
                          //                           MyColors.redColorCode,
                          //                     ),
                          //                   ),
                          //                   Expanded(
                          //                       child: Padding(
                          //                     padding:
                          //                         const EdgeInsets.only(
                          //                             left: 8.0),
                          //                     child: Text(
                          //                       // searchData![index].acStatus=='Active' ? "Active" :
                          //                       "Inactive",
                          //                       style: TextStyle(
                          //                           color:
                          //                               // searchData![index].acStatus=='Active' ? MyColors.greenColorCode:
                          //                               MyColors
                          //                                   .redColorCode,
                          //                           fontSize: 20),
                          //                     ),
                          //                   )),
                          //                   // GestureDetector(
                          //                   //   onTap: () async{
                          //                   //
                          //                   //       Navigator.push(context,
                          //                   //           MaterialPageRoute(builder: (_) =>
                          //                   //               BlocProvider(
                          //                   //                   create: (context) {
                          //                   //                     return MainBloc(webService: WebService());
                          //                   //                   },
                          //                   //                   child: AddVehicleMasterScreen(flag: 2,datum: allVehicleDetaildatalist![index],)
                          //                   //               )
                          //                   //           ));
                          //                   //
                          //                   //
                          //                   //     setState(() {
                          //                   //       pageNumber=1;
                          //                   //     });
                          //                   //     await Navigator.of(context)
                          //                   //         .push(
                          //                   //       new MaterialPageRoute(
                          //                   //           builder: (_) =>
                          //                   //               BlocProvider(
                          //                   //                   create: (context) {
                          //                   //                     return MainBloc(webService: WebService());
                          //                   //                   },
                          //                   //                   child: AddVehicleMasterScreen(flag: 2,searchText:true,datum: allVehicleDetaildatalist![0],searchData: searchData![index],)
                          //                   //               )
                          //                   //       ),
                          //                   //     )
                          //                   //         .then((val) {
                          //                   //       if(val!=null){
                          //                   //         if(val){
                          //                   //           setState(() {
                          //                   //             isSearch=false;
                          //                   //             allVehicleDetaildatalist!.clear();
                          //                   //             searchData!.clear();
                          //                   //             searchController.text="";
                          //                   //             _getvehicledetail();
                          //                   //
                          //                   //           });
                          //                   //
                          //                   //         }
                          //                   //       }
                          //                   //
                          //                   //       return false;
                          //                   //     }
                          //                   //       // val ? _getalldevice() : false
                          //                   //     );
                          //                   //
                          //                   //   },
                          //                   //   child: Container(
                          //                   //     padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                          //                   //     decoration: BoxDecoration(
                          //                   //         color:MyColors.notificationblueColorCode,
                          //                   //         borderRadius: BorderRadius.all(Radius.circular(20))
                          //                   //     ),
                          //                   //     child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                          //                   //   ),
                          //                   // ),
                          //                 ],
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     top: 15.0, bottom: 15),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment
                          //                           .spaceAround,
                          //                   children: [
                          //                     Expanded(
                          //                       child: Column(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment
                          //                                 .start,
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment
                          //                                 .start,
                          //                         children: [
                          //                           Text(
                          //                             "Vehicle ID",
                          //                             style: TextStyle(
                          //                                 color: MyColors
                          //                                     .textprofiledetailColorCode,
                          //                                 fontSize: 18),
                          //                           ),
                          //                           Text(
                          //                             // searchData![index].vsrNo!=null ? searchData![index].vsrNo!.toString() :
                          //                             "",
                          //                             style: TextStyle(
                          //                                 color: MyColors
                          //                                     .text5ColorCode,
                          //                                 fontSize: 18),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                         child: Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment
                          //                               .start,
                          //                       children: [
                          //                         Text(
                          //                           "Vehicle Number",
                          //                           style: TextStyle(
                          //                               color: MyColors
                          //                                   .textprofiledetailColorCode,
                          //                               fontSize: 18),
                          //                         ),
                          //                         Text(
                          //                           // searchData![index].vehicleRegNo!=null ? searchData![index].vehicleRegNo! :
                          //                           "",
                          //                           textAlign:
                          //                               TextAlign.left,
                          //                           style: TextStyle(
                          //                               color: MyColors
                          //                                   .text5ColorCode,
                          //                               fontSize: 18),
                          //                         ),
                          //                       ],
                          //                     ))
                          //                   ],
                          //                 ),
                          //               ),
                          //               Row(
                          //                 mainAxisAlignment:
                          //                     MainAxisAlignment.spaceAround,
                          //                 children: [
                          //                   Expanded(
                          //                     child: Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment
                          //                               .start,
                          //                       children: [
                          //                         Text(
                          //                           "Vehicle Name",
                          //                           style: TextStyle(
                          //                               color: MyColors
                          //                                   .textprofiledetailColorCode,
                          //                               fontSize: 18),
                          //                         ),
                          //                         Text(
                          //                           // searchData![index].vehicleName!=null ? searchData![index].vehicleName! :
                          //                           "",
                          //                           style: TextStyle(
                          //                               color: MyColors
                          //                                   .text5ColorCode,
                          //                               fontSize: 18),
                          //                         ),
                          //                       ],
                          //                     ),
                          //                   ),
                          //                   Expanded(
                          //                       child: Column(
                          //                     mainAxisAlignment:
                          //                         MainAxisAlignment.start,
                          //                     crossAxisAlignment:
                          //                         CrossAxisAlignment.start,
                          //                     children: [
                          //                       Text(
                          //                         "Fuel Type",
                          //                         style: TextStyle(
                          //                             color: MyColors
                          //                                 .textprofiledetailColorCode,
                          //                             fontSize: 18),
                          //                       ),
                          //                       Text(
                          //                         // searchData![index].fuelType!=null ? searchData![index].fuelType! :
                          //                         "",
                          //                         textAlign: TextAlign.left,
                          //                         style: TextStyle(
                          //                             color: MyColors
                          //                                 .text5ColorCode,
                          //                             fontSize: 18),
                          //                       ),
                          //                     ],
                          //                   ))
                          //                 ],
                          //               ),
                          //               Padding(
                          //                 padding: const EdgeInsets.only(
                          //                     top: 15.0),
                          //                 child: Row(
                          //                   mainAxisAlignment:
                          //                       MainAxisAlignment
                          //                           .spaceAround,
                          //                   children: [
                          //                     Expanded(
                          //                       child: Column(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment
                          //                                 .start,
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment
                          //                                 .start,
                          //                         children: [
                          //                           Text(
                          //                             "Vehicle Type",
                          //                             style: TextStyle(
                          //                                 color: MyColors
                          //                                     .textprofiledetailColorCode,
                          //                                 fontSize: 18),
                          //                           ),
                          //                           Text(
                          //                             // searchData![index].vehicleType!=null ? searchData![index].vehicleType! :
                          //                             "",
                          //                             style: TextStyle(
                          //                                 color: MyColors
                          //                                     .text5ColorCode,
                          //                                 fontSize: 18),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                     ),
                          //                     Expanded(
                          //                         child: Column(
                          //                       mainAxisAlignment:
                          //                           MainAxisAlignment.start,
                          //                       crossAxisAlignment:
                          //                           CrossAxisAlignment
                          //                               .start,
                          //                       children: [
                          //                         Text(
                          //                           "Speed Limit",
                          //                           style: TextStyle(
                          //                               color: MyColors
                          //                                   .textprofiledetailColorCode,
                          //                               fontSize: 18),
                          //                         ),
                          //                         Text(
                          //                           // searchData![index].speedLimit!=null ? searchData![index].speedLimit!.toString() :
                          //                           "",
                          //                           textAlign:
                          //                               TextAlign.left,
                          //                           style: TextStyle(
                          //                               color: MyColors
                          //                                   .text5ColorCode,
                          //                               fontSize: 18),
                          //                         ),
                          //                       ],
                          //                     ))
                          //                   ],
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
