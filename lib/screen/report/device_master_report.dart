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

import '../../model/report/device_master_filter.dart';
import '../../model/report/over_speed_report_response.dart';

class DeviceMasterReportScreen extends StatefulWidget {
  const DeviceMasterReportScreen({Key? key}) : super(key: key);

  @override
  _DeviceMasterReportScreenState createState() =>
      _DeviceMasterReportScreenState();
}

class _DeviceMasterReportScreenState extends State<DeviceMasterReportScreen> {
  @override
  void initState() {
    super.initState();
    getdata();
    setState(() {});
    _mainBloc = BlocProvider.of(context);
  }

  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  bool applyclicked = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  late String srNo = "";
  late String vehicleRegNo = "";
  late String imeino = "", branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 0, vendorid = 0;
  List<DeviceMasterData>? devicemasterdata = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: Text("Device Master"),
        actions: [
          GestureDetector(
              onTap: () {
                isfilter = true;
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
    if (token != "" || vendorid != 0 || branchid != 0) {
      print(token);
    }

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
          if (state is DeviceMasterFilterLoadingState) {
            print("Device Master filter is enter in the loading state");
          } else if (state is DeviceMasterFilterLoadedState) {
            print("Device Master Filter Loaded Satet is enter");
            devicemasterdata!.addAll(state.deviceMasterFilter.data!);
          }
          if (state is DeviceMasterReportLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is DeviceMasterReportLoadedState) {
            setState(() {
              _isLoading = false;
              pageNumber++;
              var totalOverSpeedCreateRecords =
                  state.DeviceMasterReportResponse.totalRecords!;

              // data!.addAll(state.getOverspeedREportResponse.data!);
            });
          } else if (state is DeviceMasterReportErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: isfilter
            ? SingleChildScrollView(
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
                                        setState(() {});
                                        // Navigator.pop(context,{"FilterAlert":false});
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
                                          _mainBloc.add(DeviceMasterFilter(
                                              token: token,
                                              vendorid: "1",
                                              branchid: "2",
                                              deviceno: "DC000012",
                                              pagenumber: 1,
                                              pagesize: 5));
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
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    value: dropdownvalue3,
                                    menuMaxHeight: 300,
                                    onChanged: (value) {
                                      setState(() {
                                        dropdownvalue3 = value!.toString();
                                      });
                                    },
                                    items: deviceitems.map((String items) {
                                      return DropdownMenuItem(
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
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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
                            onChanged: (value) {
                              //   if(searchController.text.isEmpty){
                              //     setState(() {
                              //       isSearch=false;
                              //     });
                              //   }else{
                              //     setState(() {
                              //       isSearch=true;
                              //     });
                              //
                              //     // SearchOverSpeedCreateEvents({required this.token,required this.vehicleRegNo,required this.imeino,required this.latitude,required this.longitude,required this.address,required this.transDate,
                              //     //   required this.transTime,required this.speed,required this.overSpeed,required this.updatedOn,required this.distancetravel,required this.speedLimit,required this.searchText, required int vendorId});
                              //     _mainBloc.add(SearchOverSpeedCreateEvents(vendorId: vendorid,vehicleRegNo :vehicleRegNo,searchText: searchController.text,token: token,  imeino: imeino, latitude: latitude, longitude: null));
                              //   }
                            },
                          ),
                          Text(
                            "10 RECORDS",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          applyclicked
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      controller: vehicleRecordController,
                                      itemCount: devicemasterdata!.length,
                                      itemBuilder: (context, index) {
                                        print("Enter in the filter list");
                                        var article = devicemasterdata![index];
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                                "Device No",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article.deviceNo
                                                                    .toString(),
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
                                                                  "Model No",
                                                                  style: TextStyle(
                                                                      color: MyColors
                                                                          .textprofiledetailColorCode,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                Text(
                                                                  article
                                                                      .modelNo
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
                                                                "Device Name",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article
                                                                    .branchName
                                                                    .toString(),
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
                                                                  "IMEINo",
                                                                  style: TextStyle(
                                                                      color: MyColors
                                                                          .textprofiledetailColorCode,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                Text(
                                                                  article.imeino
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
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                  //                       children: [
                                                  //                         TextField(
                                                  //                           controller: searchController,
                                                  //                           enabled: true, // to trigger disabledBorder
                                                  //                           decoration: InputDecoration(
                                                  //                             filled: true,
                                                  //                             fillColor: MyColors.whiteColorCode,
                                                  //                             focusedBorder: OutlineInputBorder(
                                                  //                               borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  //                               borderSide:
                                                  //                               BorderSide(width: 1, color: MyColors.buttonColorCode),
                                                  //                             ),
                                                  //                             disabledBorder: OutlineInputBorder(
                                                  //                               borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  //                               borderSide: BorderSide(width: 1, color: Colors.orange),
                                                  //                             ),
                                                  //                             enabledBorder: OutlineInputBorder(
                                                  //                               borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  //                               borderSide:
                                                  //                               BorderSide(width: 1, color: MyColors.textColorCode),
                                                  //                             ),
                                                  //                             border: OutlineInputBorder(
                                                  //                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  //                                 borderSide: BorderSide(
                                                  //                                   width: 1,
                                                  //                                 )),
                                                  //                             errorBorder: OutlineInputBorder(
                                                  //                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  //                                 borderSide: BorderSide(width: 1, color: Colors.black)),
                                                  //                             focusedErrorBorder: OutlineInputBorder(
                                                  //                                 borderRadius: BorderRadius.all(Radius.circular(4)),
                                                  //                                 borderSide:
                                                  //                                 BorderSide(width: 2, color: MyColors.buttonColorCode)),
                                                  //                             hintText: "Search Record",
                                                  //                             prefixIcon: Icon(
                                                  //                               Icons.search,
                                                  //                               size: 24,
                                                  //                               color: Colors.black,
                                                  //                             ),
                                                  //                             hintStyle: TextStyle(
                                                  //                                 fontSize: 18, color: MyColors.searchTextColorCode),
                                                  //                             errorText: "",
                                                  //                           ),
                                                  //                           obscureText: false,
                                                  //                           onChanged: (value){
                                                  //                             if(searchController.text.isEmpty){
                                                  //                               setState(() {
                                                  //                                 isSearch=false;
                                                  //                               });
                                                  //                             }else{
                                                  //                               setState(() {
                                                  //                                 isSearch=true;
                                                  //                               });
                                                  //                               _mainBloc.add(SearchGeofenceCreateEvents(vendorId: vendorid,branchId :branchid,searchText: searchController.text,token: token));
                                                  //                             }
                                                  //                           },
                                                  //                         ),
                                                  //                         Text(!isSearch ? data!.length!=0 ?  "Showing 1 to ${data!.length} Out of ${totalgeofenceCreateRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalgeofenceCreateRecords}" :"0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                                  //
                                                  //                         /* Text(
                                                  //   "10 RECORDS",
                                                  //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                  // ),*/
                                                  //                         !isSearch ? data!.length==0 ? Container() :Padding(
                                                  //                           padding: const EdgeInsets.only(top: 20.0),
                                                  //                           child: ListView.builder(
                                                  //                               // controller: overSpeedRecordController,
                                                  //                               shrinkWrap: true,
                                                  //                               itemCount: data!.length,
                                                  //                               itemBuilder: (context, index) {
                                                  //                                 return Card(
                                                  //                                   margin: EdgeInsets.only(bottom: 15),
                                                  //                                   shape: RoundedRectangleBorder(
                                                  //                                     side: BorderSide(
                                                  //                                         width: 1, color: MyColors.textBoxBorderColorCode),
                                                  //                                     borderRadius: BorderRadius.circular(10.0),
                                                  //                                   ),
                                                  //                                   child: Container(
                                                  //                                     padding: EdgeInsets.only(
                                                  //                                         top: 15, left: 14, right: 14, bottom: 15),
                                                  //                                     width: MediaQuery.of(context).size.width,
                                                  //                                     decoration: BoxDecoration(
                                                  //                                       borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  //                                     ),
                                                  //                                     child: Column(
                                                  //                                       mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                       crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                       children: [
                                                  //                                         Padding(
                                                  //                                           padding:
                                                  //                                           const EdgeInsets.only(top: 15.0, bottom: 15),
                                                  //                                           child: Row(
                                                  //                                             mainAxisAlignment:
                                                  //                                             MainAxisAlignment.spaceAround,
                                                  //                                             children: [
                                                  //                                               Expanded(
                                                  //                                                 child: Column(
                                                  //                                                   mainAxisAlignment:
                                                  //                                                   MainAxisAlignment.start,
                                                  //                                                   crossAxisAlignment:
                                                  //                                                   CrossAxisAlignment.start,
                                                  //                                                   children: [
                                                  //                                                     Text(
                                                  //                                                       "vehicleRegNo",
                                                  //                                                       style: TextStyle(
                                                  //                                                           color: MyColors
                                                  //                                                               .textprofiledetailColorCode,
                                                  //                                                           fontSize: 18),
                                                  //                                                     ),
                                                  //                                                     Padding(
                                                  //                                                       padding:
                                                  //                                                       const EdgeInsets.only(top: 4.0),
                                                  //                                                       child: Text(
                                                  //                                                         // "23",
                                                  //                                                         data![index].vehicleRegNo.toString(),
                                                  //                                                         style: TextStyle(
                                                  //                                                             color: MyColors.text5ColorCode,
                                                  //                                                             fontSize: 18),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ],
                                                  //                                                 ),
                                                  //                                               ),
                                                  //                                               Expanded(
                                                  //                                                   child: Column(
                                                  //                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                                     crossAxisAlignment:
                                                  //                                                     CrossAxisAlignment.start,
                                                  //                                                     children: [
                                                  //                                                       Text(
                                                  //                                                         "imeino",
                                                  //                                                         style: TextStyle(
                                                  //                                                             color: MyColors
                                                  //                                                                 .textprofiledetailColorCode,
                                                  //                                                             fontSize: 18),
                                                  //                                                       ),
                                                  //                                                       Padding(
                                                  //                                                         padding:
                                                  //                                                         const EdgeInsets.only(top: 4.0),
                                                  //                                                         child: Text(
                                                  //                                                           data![index].imeino.toString(),
                                                  //                                                           textAlign: TextAlign.left,
                                                  //                                                           style: TextStyle(
                                                  //                                                               color: MyColors.text5ColorCode,
                                                  //                                                               fontSize: 18),
                                                  //                                                         ),
                                                  //                                                       ),
                                                  //                                                     ],
                                                  //                                                   ))
                                                  //                                             ],
                                                  //                                           ),
                                                  //                                         ),
                                                  //                                         Row(
                                                  //                                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  //                                           children: [
                                                  //                                             Expanded(
                                                  //                                               child: Column(
                                                  //                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                                 crossAxisAlignment:
                                                  //                                                 CrossAxisAlignment.start,
                                                  //                                                 children: [
                                                  //                                                   Text(
                                                  //                                                     "Trans Time",
                                                  //                                                     style: TextStyle(
                                                  //                                                         color: MyColors
                                                  //                                                             .textprofiledetailColorCode,
                                                  //                                                         fontSize: 18),
                                                  //                                                   ),
                                                  //                                                   Padding(
                                                  //                                                     padding:
                                                  //                                                     const EdgeInsets.only(top: 4.0),
                                                  //                                                     child: Text(
                                                  //                                                       data![index].transTime.toString(),
                                                  //                                                       style: TextStyle(
                                                  //                                                           color: MyColors.text5ColorCode,
                                                  //                                                           fontSize: 18),
                                                  //                                                     ),
                                                  //                                                   ),
                                                  //                                                 ],
                                                  //                                               ),
                                                  //                                             ),
                                                  //                                             Expanded(
                                                  //                                                 child: Column(
                                                  //                                                   mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                                   crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                                   children: [
                                                  //                                                     Text(
                                                  //                                                       "Speed",
                                                  //                                                       style: TextStyle(
                                                  //                                                           color: MyColors
                                                  //                                                               .textprofiledetailColorCode,
                                                  //                                                           fontSize: 18),
                                                  //                                                     ),
                                                  //                                                     Padding(
                                                  //                                                       padding: const EdgeInsets.only(top: 4.0),
                                                  //                                                       child: Text(
                                                  //                                                         data![index].speed.toString(),
                                                  //                                                         textAlign: TextAlign.left,
                                                  //                                                         style: TextStyle(
                                                  //                                                             color: MyColors.text5ColorCode,
                                                  //                                                             fontSize: 18),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ],
                                                  //                                                 ))
                                                  //                                           ],
                                                  //                                         ),
                                                  //                                         Padding(
                                                  //                                           padding:
                                                  //                                           const EdgeInsets.only(top: 15.0, bottom: 15),
                                                  //                                           child: Row(
                                                  //                                             mainAxisAlignment:
                                                  //                                             MainAxisAlignment.spaceAround,
                                                  //                                             children: [
                                                  //                                               Expanded(
                                                  //                                                 child: Column(
                                                  //                                                   mainAxisAlignment:
                                                  //                                                   MainAxisAlignment.start,
                                                  //                                                   crossAxisAlignment:
                                                  //                                                   CrossAxisAlignment.start,
                                                  //                                                   children: [
                                                  //                                                     Text(
                                                  //                                                       "Over Speed kmph",
                                                  //                                                       style: TextStyle(
                                                  //                                                           color: MyColors
                                                  //                                                               .textprofiledetailColorCode,
                                                  //                                                           fontSize: 18),
                                                  //                                                     ),
                                                  //                                                     Padding(
                                                  //                                                       padding:
                                                  //                                                       const EdgeInsets.only(top: 4.0),
                                                  //                                                       child: Text(
                                                  //                                                         data![index].overSpeed.toString(),
                                                  //                                                         style: TextStyle(
                                                  //                                                             color: MyColors.text5ColorCode,
                                                  //                                                             fontSize: 18),
                                                  //                                                       ),
                                                  //                                                     ),
                                                  //                                                   ],
                                                  //                                                 ),
                                                  //                                               ),
                                                  //                                               Expanded(
                                                  //                                                   child: Column(
                                                  //                                                     mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                                     crossAxisAlignment:
                                                  //                                                     CrossAxisAlignment.start,
                                                  //                                                     children: [
                                                  //                                                       Text(
                                                  //                                                         "Distance travel",
                                                  //                                                         style: TextStyle(
                                                  //                                                             color: MyColors
                                                  //                                                                 .textprofiledetailColorCode,
                                                  //                                                             fontSize: 18),
                                                  //                                                       ),
                                                  //                                                       Padding(
                                                  //                                                         padding:
                                                  //                                                         const EdgeInsets.only(top: 4.0),
                                                  //                                                         child: Text(
                                                  //                                                           // "Yes",
                                                  //                                                           data![index].distancetravel.toString(),
                                                  //                                                           textAlign: TextAlign.left,
                                                  //                                                           style: TextStyle(
                                                  //                                                               color: MyColors.text5ColorCode,
                                                  //                                                               fontSize: 18),
                                                  //                                                         ),
                                                  //                                                       ),
                                                  //                                                     ],
                                                  //                                                   ))
                                                  //                                             ],
                                                  //                                           ),
                                                  //                                         ),
                                                  //                                         Column(
                                                  //                                           mainAxisAlignment: MainAxisAlignment.start,
                                                  //                                           crossAxisAlignment: CrossAxisAlignment.start,
                                                  //                                           children: [
                                                  //                                             Text(
                                                  //                                               "Latitude",
                                                  //                                               style: TextStyle(
                                                  //                                                   color:
                                                  //                                                   MyColors.textprofiledetailColorCode,
                                                  //                                                   fontSize: 18),
                                                  //                                             ),
                                                  //                                             Padding(
                                                  //                                               padding: const EdgeInsets.only(top: 4.0),
                                                  //                                               child: Text(
                                                  //                                                 data![index].latitude.toString(),
                                                  //                                                 textAlign: TextAlign.left,
                                                  //                                                 style: TextStyle(
                                                  //                                                     color: MyColors.text5ColorCode,
                                                  //                                                     fontSize: 18),
                                                  //                                               ),
                                                  //                                             ),
                                                  //             ]),
                                                  //                                 ],
                                                  //                                 ),
                                                  //                                 ),
                                                  //                                 );
                                                  //                               }),
                                                  //                         ):
                                                  //                       ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }))
                              : /* searchData!.length==0
                        ? Container() :*/
                              ListView.builder(
                                  controller: vehicleRecordController,
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: 5,
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
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                    Icons.circle,
                                                    size: 10,
                                                    color:
                                                        // searchData![index].acStatus=='Active' ? MyColors.greenColorCode:
                                                        MyColors.redColorCode,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    // searchData![index].acStatus=='Active' ? "Active" :
                                                    "Inactive",
                                                    style: TextStyle(
                                                        color:
                                                            // searchData![index].acStatus=='Active' ? MyColors.greenColorCode:
                                                            MyColors
                                                                .redColorCode,
                                                        fontSize: 20),
                                                  ),
                                                )),
                                                // GestureDetector(
                                                //   onTap: () async{
                                                //
                                                //       Navigator.push(context,
                                                //           MaterialPageRoute(builder: (_) =>
                                                //               BlocProvider(
                                                //                   create: (context) {
                                                //                     return MainBloc(webService: WebService());
                                                //                   },
                                                //                   child: AddVehicleMasterScreen(flag: 2,datum: allVehicleDetaildatalist![index],)
                                                //               )
                                                //           ));
                                                //
                                                //
                                                //     setState(() {
                                                //       pageNumber=1;
                                                //     });
                                                //     await Navigator.of(context)
                                                //         .push(
                                                //       new MaterialPageRoute(
                                                //           builder: (_) =>
                                                //               BlocProvider(
                                                //                   create: (context) {
                                                //                     return MainBloc(webService: WebService());
                                                //                   },
                                                //                   child: AddVehicleMasterScreen(flag: 2,searchText:true,datum: allVehicleDetaildatalist![0],searchData: searchData![index],)
                                                //               )
                                                //       ),
                                                //     )
                                                //         .then((val) {
                                                //       if(val!=null){
                                                //         if(val){
                                                //           setState(() {
                                                //             isSearch=false;
                                                //             allVehicleDetaildatalist!.clear();
                                                //             searchData!.clear();
                                                //             searchController.text="";
                                                //             _getvehicledetail();
                                                //
                                                //           });
                                                //
                                                //         }
                                                //       }
                                                //
                                                //       return false;
                                                //     }
                                                //       // val ? _getalldevice() : false
                                                //     );
                                                //
                                                //   },
                                                //   child: Container(
                                                //     padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                                                //     decoration: BoxDecoration(
                                                //         color:MyColors.notificationblueColorCode,
                                                //         borderRadius: BorderRadius.all(Radius.circular(20))
                                                //     ),
                                                //     child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0, bottom: 15),
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
                                                          "Vehicle ID",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .textprofiledetailColorCode,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          // searchData![index].vsrNo!=null ? searchData![index].vsrNo!.toString() :
                                                          "",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .text5ColorCode,
                                                              fontSize: 18),
                                                        ),
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
                                                        "Vehicle Number",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        // searchData![index].vehicleRegNo!=null ? searchData![index].vehicleRegNo! :
                                                        "",
                                                        textAlign:
                                                            TextAlign.left,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
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
                                                        "Vehicle Name",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        // searchData![index].vehicleName!=null ? searchData![index].vehicleName! :
                                                        "",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
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
                                                      "Fuel Type",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      // searchData![index].fuelType!=null ? searchData![index].fuelType! :
                                                      "",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .text5ColorCode,
                                                          fontSize: 18),
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
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
                                                          "Vehicle Type",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .textprofiledetailColorCode,
                                                              fontSize: 18),
                                                        ),
                                                        Text(
                                                          // searchData![index].vehicleType!=null ? searchData![index].vehicleType! :
                                                          "",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .text5ColorCode,
                                                              fontSize: 18),
                                                        ),
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
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        // searchData![index].speedLimit!=null ? searchData![index].speedLimit!.toString() :
                                                        "",
                                                        textAlign:
                                                            TextAlign.left,
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
                                    );
                                  }),
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
