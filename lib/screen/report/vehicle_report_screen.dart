import 'dart:core';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_vts/model/vehicle/all_vehicle_detail_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_vts/util/search_bar_field.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/searchString.dart';
import '../../model/vehicle_master/search_vehicle_report_data_response.dart';
import '../../model/vehicle_master/vehicle_master_filter.dart';
import '../../model/vehicle_master/vehicle_report_detail.dart';

class VehicleReportScreen extends StatefulWidget {
  const VehicleReportScreen({Key? key}) : super(key: key);

  @override
  _VehicleReportScreenState createState() => _VehicleReportScreenState();
}

class _VehicleReportScreenState extends State<VehicleReportScreen> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  ScrollController notificationController = new ScrollController();
  // TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 10;
  int pageSize = 1;
  int value = 0;
  late String srNo = "";
  late String vehicleRegNo = "";
  late String imeino = "", branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 1, vendorid = 1;
  List<AllVehicleDetailResponse>? data = [];
   List<VehicleInfo> pdfdatalist = [];
  List<VehicleFilterData>? filterData = [];
  // List<AllVehicleDetailResponse>? searchData = [];
  int totalVehicleRecords = 0;
  // late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;
  List<VehicleInfo>? allVehicleDetaildatalist = [];
  // List<Data>? searchData=[];
  // int index = 0;
  bool isDataAvailable = false;
  // List<String> items = List.generate(15, (index) => 'Item ${index + 1}');
  TextEditingController searhcontroller = new TextEditingController();
  bool isSelected = false;
  bool isvalue = false;
  List<SearchingVehItemInfo>? searchVehStrdata = [];
  SearchStringClass searchClass = SearchStringClass(searchStr: '');
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
  bool isValue = false;

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
    super.initState();
    getdataDM();
    setState(() {
      isValue = false;
    });
    notificationController.addListener(() {
      if (notificationController.position.maxScrollExtent ==
          notificationController.offset) {
        setState(() {
          print("Scroll ${pageNumber}");
          getdata();
          getallbranch();
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: !isfilter ? Text("VEHICLE REPORT ") : Text("Filter"),
        actions: [
          GestureDetector(
            onTap: () {
              isfilter = true;
              setState(() {});
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
  }

  // getallbranch() {
  //   _mainBloc.add(GetVehReportDetailsEvent(
  //       token: token,
  //       branchid: branchid,
  //       pageNumber: pageNumber,
  //       pageSize: pageSize,
  //       vendorid: vendorid));
  // }

  getallbranch() {
    _mainBloc.add(GetVehReportDetailsEvent(
        vendorid: vendorid,
        branchid: branchid,
        pageNumber: pageNumber,
        pageSize: pageSize,
        token: token));
  }

  _getSearchDataVehicledetailReport() {
    _mainBloc.add(SearchVehReportDetailsEvent(
        vendorid: vendorid,
        branchid: branchid,
        pageNumber: pageNumber,
        pageSize: pageSize,
        token: token,
        searchText: searchClass.searchStr));
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
          if (state is VehicleReportFilterLoadingState) {
            print("Vehicle Report Filter Loading state");
          } else if (state is VehicleReportFilterLoadedState) {
            print("Vehicle Report FILTER data loaded");
            filterData!.clear();
            filterData!.addAll(state.vehicleReportFilter.data!);
            print("This is filter data length" + filterData!.length.toString());
          } else if (state is VehicleReportFilterErorrState) {
            print("Vehicle Report Filter Error");
          }
          if (state is GetVehicleReportLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is GetVehicleReportLoadedState) {
            print("Enter in report  loaded state------------------");
            if (state.vehicleReportResponse.data != null) {
              pageSize++;
              setState(() {
                _isLoading = false;
                value = state.vehicleReportResponse.totalRecords!;
              });
              allVehicleDetaildatalist!
                    .addAll(state.vehicleReportResponse.data!);
            }
          } else if (state is GetVehicleReportErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
          //Handling search text of point of interest
          if (state is SearchVehicleReportLoadingState) {
            print("Enter in search loading======>");
            setState(() {
              _isLoading = true;
            });
          } else if (state is SearchVehicleReportLoadedState) {
            print("Search loaded state block");
            setState(() {
              if (_isLoading = false) {
                searchVehStrdata!.clear();
                searchVehStrdata!
                    .addAll(state.searchVehicleReportResponse.data!);

                print("Lenght of list is---${searchVehStrdata!.length}");
              } else {
                Text("No Data found.");
              }
            });
            if (state.searchVehicleReportResponse.data != null) {
              searchVehStrdata!.clear();
              searchVehStrdata!.addAll(state.searchVehicleReportResponse.data!);
            }
          } else if (state is SearchVehicleReportErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
          // Container() :
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
                                       
                                        setState(() {
                                          isfilter = false;
                                          applyclicked = true;
                                        });
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
                                          print("Apply button clicked ");
                                          _mainBloc
                                              .add(VehicleReportFilterEvent(
                                            token: token,
                                            vendorId: 1,
                                            branchid: 1,
                                            vsrno: 8,
                                            pagenumber: 1,
                                            pagesize: 10,
                                          ));
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
                                pdfdatalist.addAll(allVehicleDetaildatalist!);
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
                              controller: searhcontroller,
                              onChanged: onSearchTextChanged),
                          applyclicked
                              ? Text(
                                  "${filterData!.length} Filter Records found",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                              : isSelected
                                  ? Text(
                                      "${searchVehStrdata!.length} Search Records found",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold))
                                  : Text(
                                      "${allVehicleDetaildatalist!.length} Records found",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                          applyclicked
                              ? BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      controller: vehicleRecordController,
                                      itemCount: filterData!.length,
                                      itemBuilder: (context, index) {
                                        print("Entering in filter list");
                                        var article = filterData![index];
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
                                                                  "${filterData!.elementAt(index).vsrNo}",
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
                                                                "Vehicle RegNO",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article
                                                                    .vehicleRegNo!,
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
                                                                  "Vehicle Name",
                                                                  style: TextStyle(
                                                                      color: MyColors
                                                                          .textprofiledetailColorCode,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                Text(
                                                                  article
                                                                      .vehicleName!,
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
                                                                "Fuel Type",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article
                                                                    .fuelType!,
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
                                                                  "Speed Limit",
                                                                  style: TextStyle(
                                                                      color: MyColors
                                                                          .textprofiledetailColorCode,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                Text(
                                                                  article
                                                                      .speedLimit
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
                                                                "Vehicle Type",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article
                                                                    .vehicleType!,
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
                                                                  "Current Odometer",
                                                                  style: TextStyle(
                                                                      color: MyColors
                                                                          .textprofiledetailColorCode,
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                                Text(
                                                                  article
                                                                      .currentOdometer
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
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                })
                              : (isSelected == true)
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: (searchVehStrdata!.length != 0)
                                          ? ListView.builder(
                                              shrinkWrap: true,
                                              controller:
                                                  vehicleRecordController,
                                              itemCount:
                                                  searchVehStrdata!.length,
                                              itemBuilder: (context, index) {
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
                                                                          "${searchVehStrdata!.elementAt(index).vsrNo}",
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
                                                                        "Vehicle RegNO",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        "${searchVehStrdata!.elementAt(index).vehicleRegNo}",
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
                                                                          "Vehicle Name",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "${searchVehStrdata!.elementAt(index).vehicleName}",
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
                                                                        "Fuel Type",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        "${searchVehStrdata!.elementAt(index).fuelType}",
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
                                                                          "Speed Limit",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "${searchVehStrdata!.elementAt(index).speedLimit}",
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
                                                                        "Vehicle Type",
                                                                        style: TextStyle(
                                                                            color:
                                                                                MyColors.textprofiledetailColorCode,
                                                                            fontSize: 18),
                                                                      ),
                                                                      Text(
                                                                        "${searchVehStrdata!.elementAt(index).vehicleType}",
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
                                                                          "Current Odometer",
                                                                          style: TextStyle(
                                                                              color: MyColors.textprofiledetailColorCode,
                                                                              fontSize: 18),
                                                                        ),
                                                                        Text(
                                                                          "${searchVehStrdata!.elementAt(index).currentOdometer}",
                                                                          style: TextStyle(
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
                                              })
                                          : Text(
                                              "Data Not Found",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child:
                                          allVehicleDetaildatalist!.length != 0
                                              ? ListView.builder(
                                                  shrinkWrap: true,
                                                  controller:
                                                      vehicleRecordController,
                                                  itemCount:
                                                      allVehicleDetaildatalist!
                                                          .length,
                                                  itemBuilder:
                                                      (context, index) {
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
                                                                              "${allVehicleDetaildatalist!.elementAt(index).vsrNo}",
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
                                                                            "Vehicle RegNO",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            "${allVehicleDetaildatalist!.elementAt(index).vehicleRegNo}",
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
                                                                              "Vehicle Name",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              "${allVehicleDetaildatalist!.elementAt(index).vehicleName}",
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
                                                                            "Fuel Type",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            "${allVehicleDetaildatalist!.elementAt(index).fuelType}",
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
                                                                              "Speed Limit",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              "${allVehicleDetaildatalist!.elementAt(index).speedLimit}",
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
                                                                            "Vehicle Type",
                                                                            style:
                                                                                TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                          ),
                                                                          Text(
                                                                            "${allVehicleDetaildatalist!.elementAt(index).vehicleType}",
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
                                                                              "Current Odometer",
                                                                              style: TextStyle(color: MyColors.textprofiledetailColorCode, fontSize: 18),
                                                                            ),
                                                                            Text(
                                                                              "${allVehicleDetaildatalist!.elementAt(index).currentOdometer}",
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
                                                  })
                                              : const Text(
                                                  "Data Not Found..",
                                                  style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
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
      _mainBloc.add(SearchVehReportDetailsEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        pageNumber: pageNumber,
        pageSize: pageSize,
        searchText: searchClass.searchStr,
      ));
    }
    // traveldata!.forEach((userDetail) {
    //   if (userDetail.vehicleregNo!.contains(text)) searchdata!.add(userDetail);
    // });
  }
}


class PdfInvoiceApi {
  static Future<File> generate(List<VehicleInfo> pdflist) async {
    final pdf = pw.Document();
    double fontsize = 8.0;
    DateTime current_date = DateTime.now();
    pdf.addPage(pw.MultiPage(
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
      build: (context) {
        return <pw.Widget> [
          pw.Center(
              child: pw.Text("VEHICLE REPORT",
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
                          "Vehicle Name",
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
                          "Fuel Type",
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
                          "Speed Limit",
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
                          "Vehicle Type",
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
                          "Current odometer",
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
                    var article = pdflist[index];
                    return pw.Table(
                        border: pw.TableBorder.all(
                            color: PdfColors.black, width: 0.8),
                        children: [
                          pw.TableRow(children: [
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(article.vsrNo.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(article.vehicleRegNo.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(article.vehicleName.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(
                                    article.fuelType.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(article.speedLimit.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(article.vehicleType.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                            pw.Padding(
                              padding: pw.EdgeInsets.only(
                                  left: 5.0, top: 8.0, bottom: 8.0, right: 5.0),
                              child: pw.SizedBox(
                                width: 20,
                                child: pw.Text(article.currentOdometer.toString(),
                                    style: pw.TextStyle(fontSize: fontsize)),
                              ),
                            ),
                          ])
                        ]);
                  },
                  itemCount: pdflist.length)
                  // ),
              
        ];
      },
    )
    );

    return PdfApi.saveDocument(name: 'VehicleReport.pdf', pdf: pdf);
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
