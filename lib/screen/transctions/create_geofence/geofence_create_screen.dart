import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/geofence/get_geofence_create_details_response.dart';
import 'package:flutter_vts/screen/transctions/create_geofence/create_geofence_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vts/model/geofence/search_geofence_create_response.dart';

class GeofenceCreateScreen extends StatefulWidget {
  const GeofenceCreateScreen({Key? key}) : super(key: key);

  @override
  _GeofenceCreateScreenState createState() => _GeofenceCreateScreenState();
}

class _GeofenceCreateScreenState extends State<GeofenceCreateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController geofenceRecordController = new ScrollController();
  ScrollController geofenceScrollController = new ScrollController();
  TextEditingController searchController = new TextEditingController();

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 0, vendorid = 0;
  List<GeofenceDatum>? data = [];
  List<Datum>? searchData = [];

  late bool isSearch = false;
  late int totalgeofenceCreateRecords = 0, deleteposition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);
    getdata();
    geofenceScrollController.addListener(() {
      if (geofenceScrollController.position.maxScrollExtent ==
          geofenceScrollController.offset) {
        if (isSearch) {
        } else {
          setState(() {
            print("Scroll ${pageNumber}");
            _getGeofenceCreatedetail();
          });
        }
      }
    });
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
    if (sharedPreferences.getString("Username") != null) {
      userName = sharedPreferences.getString("Username")!;
    }
    if (sharedPreferences.getString("VendorName") != null) {
      vendorName = sharedPreferences.getString("VendorName")!;
    }
    if (sharedPreferences.getString("BranchName") != null) {
      branchName = sharedPreferences.getString("BranchName")!;
    }
    if (sharedPreferences.getString("UserType") != null) {
      userType = sharedPreferences.getString("UserType")!;
    }

    print("branchid ${branchid}   Vendor id   ${vendorid}");

    print("" +
        vendorid.toString() +
        " " +
        branchid.toString() +
        " " +
        userName +
        " " +
        vendorName +
        " " +
        branchName +
        " " +
        userType);

    if (token != "" ||
        vendorid != 0 ||
        branchid != 0 ||
        vendorName != "" ||
        branchName != "") {
      _getGeofenceCreatedetail();
    }
  }

  _getGeofenceCreatedetail() {
    _mainBloc.add(GetGeofenceCreateDetailEvents(
        vendorId: vendorid,
        branchId: branchid,
        pageNumber: pageNumber,
        pageSize: pageSize,
        token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MenuDrawer().getMenuDrawer(context),
      appBar: CustomAppBar()
          .getCustomAppBar("GEOFENCE CREATE", _scaffoldKey, 0, context),
      body: _geofenceCreate(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.buttonColorCode,
        onPressed: () {
          print(data!.length);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: CreateGeofenceScreen())));
        },
        child: Icon(
          Icons.add,
          color: MyColors.whiteColorCode,
        ),
      ),
    );
  }

  _geofenceCreate() {
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
          if (state is GetGeofenceCreateDetailLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is GetGeofenceCreateDetailLoadedState) {
            setState(() {
              _isLoading = false;
              pageNumber++;
              totalgeofenceCreateRecords =
                  state.geofenceCreateDetailsResponse.totalRecords!;

              data!.addAll(state.geofenceCreateDetailsResponse.data!);
            });
          } else if (state is GetGeofenceCreateDetailErrorState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is DeleteGeofenceCreateLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is DelectGeofenceCreateLoadedState) {
            setState(() {
              _isLoading = false;
              data!.removeAt(deleteposition);
            });
          } else if (state is DeleteGeofenceCreateErrorState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is SearchGeofenceCreateLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is SearchGeofenceCreateLoadedState) {
            setState(() {
              searchData!.clear();
              _isLoading = false;
            });
            if (state.searchGeofenceCreateResponse.data != null) {
              searchData!.addAll(state.searchGeofenceCreateResponse.data!);
            }
          } else if (state is SearchGeofenceCreateErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          controller: geofenceScrollController,
          child: Padding(
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
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide:
                          BorderSide(width: 1, color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1, color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide:
                          BorderSide(width: 1, color: MyColors.textColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                          width: 1,
                        )),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)),
                    hintText: "Search Record",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.black,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 18, color: MyColors.searchTextColorCode),
                    errorText: "",
                  ),
                  obscureText: false,
                  onChanged: (value) {
                    if (searchController.text.isEmpty) {
                      setState(() {
                        isSearch = false;
                      });
                    } else {
                      setState(() {
                        isSearch = true;
                      });
                      _mainBloc.add(SearchGeofenceCreateEvents(
                          vendorId: vendorid,
                          branchId: branchid,
                          searchText: searchController.text,
                          token: token));
                    }
                  },
                ),
                Text(
                  !isSearch
                      ? data!.length != 0
                          ? "Showing 1 to ${data!.length} Out of ${totalgeofenceCreateRecords}"
                          : "0 RECORDS"
                      : searchData!.length != 0
                          ? "Showing 1 to ${searchData!.length} Out of ${totalgeofenceCreateRecords}"
                          : "0 RECORDS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                /* Text(
                  "10 RECORDS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),*/
                !isSearch
                    ? data!.length == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ListView.builder(
                                controller: geofenceRecordController,
                                shrinkWrap: true,
                                itemCount: data!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.only(bottom: 15),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color:
                                              MyColors.textBoxBorderColorCode),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          left: 14,
                                          right: 14,
                                          bottom: 15),
                                      width: MediaQuery.of(context).size.width,
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0, bottom: 15),
                                            child: Row(
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
                                                        "Sr.No",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          // "23",
                                                          data![index]
                                                              .srNo
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .text5ColorCode,
                                                              fontSize: 18),
                                                        ),
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
                                                      "Geofence Name",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        data![index]
                                                            .geofenceName
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
                                                      ),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Category",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        data![index]
                                                            .category
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
                                                      ),
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
                                                    "Tolerance",
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .textprofiledetailColorCode,
                                                        fontSize: 18),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      data![index]
                                                          .tolerance
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .text5ColorCode,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0, bottom: 15),
                                            child: Row(
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
                                                        "Vehicle Reg.No",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          data![index]
                                                              .vehicleRegno
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .text5ColorCode,
                                                              fontSize: 18),
                                                        ),
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
                                                      "Show Geofence",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        // "Yes",
                                                        data![index]
                                                            .showGeofence
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Description",
                                                style: TextStyle(
                                                    color: MyColors
                                                        .textprofiledetailColorCode,
                                                    fontSize: 18),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  data![index]
                                                      .description
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .text5ColorCode,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                deleteposition = index;
                                              });
                                              _deleteRecordConfirmation(
                                                  data![index].srNo!);
                                            },
                                            child: Container(
                                              height: 37,
                                              margin: EdgeInsets.only(top: 15),
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 6,
                                                  bottom: 6),
                                              decoration: BoxDecoration(
                                                  color: MyColors
                                                      .pinkBackgroundColorCode,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        MyColors.redColorCode,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                    : searchData!.length == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ListView.builder(
                                controller: geofenceRecordController,
                                shrinkWrap: true,
                                itemCount: searchData!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    margin: EdgeInsets.only(bottom: 15),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color:
                                              MyColors.textBoxBorderColorCode),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 15,
                                          left: 14,
                                          right: 14,
                                          bottom: 15),
                                      width: MediaQuery.of(context).size.width,
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0, bottom: 15),
                                            child: Row(
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
                                                        "Sr.No",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          // "23",
                                                          searchData![index]
                                                              .srNo
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .text5ColorCode,
                                                              fontSize: 18),
                                                        ),
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
                                                      "Geofence Name",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        searchData![index]
                                                            .geofenceName
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
                                                      ),
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
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Category",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        searchData![index]
                                                            .category
                                                            .toString(),
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
                                                      ),
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
                                                    "Tolerance",
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .textprofiledetailColorCode,
                                                        fontSize: 18),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      searchData![index]
                                                          .tolerance
                                                          .toString(),
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .text5ColorCode,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                ],
                                              ))
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0, bottom: 15),
                                            child: Row(
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
                                                        "Vehicle Reg.No",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          searchData![index]
                                                              .vehicleRegno
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .text5ColorCode,
                                                              fontSize: 18),
                                                        ),
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
                                                      "Show Geofence",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4.0),
                                                      child: Text(
                                                        // "Yes",
                                                        searchData![index]
                                                            .showGeofence
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .text5ColorCode,
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ],
                                                ))
                                              ],
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Description",
                                                style: TextStyle(
                                                    color: MyColors
                                                        .textprofiledetailColorCode,
                                                    fontSize: 18),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4.0),
                                                child: Text(
                                                  searchData![index]
                                                      .description
                                                      .toString(),
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .text5ColorCode,
                                                      fontSize: 18),
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                deleteposition = index;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  20.0)), //this right here
                                                      child: Container(
                                                        height: 200,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "Delete Record",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          20)),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10),
                                                                child: Text(
                                                                  "Are you sure want to delete records...??",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  MaterialButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child: Text(
                                                                      "No",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color:
                                                                              MyColors.whiteColorCode),
                                                                    ),
                                                                    color: MyColors
                                                                        .text3greyColorCode,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15.0),
                                                                    child:
                                                                        MaterialButton(
                                                                      // padding: const EdgeInsets.only(left:15.0,right: 15,top: 4,bottom: 4),
                                                                      onPressed:
                                                                          () {
                                                                        // Navigator.of(context).pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        searchData!
                                                                            .removeAt(deleteposition);
                                                                        _mainBloc.add(DeleteGeofenceCreateEvents(
                                                                            vendorId:
                                                                                vendorid,
                                                                            branchId:
                                                                                branchid,
                                                                            geofenceId:
                                                                                searchData![index].srNo,
                                                                            token: token));
                                                                      },
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                      child:
                                                                          Text(
                                                                        "Yes",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            color:
                                                                                MyColors.whiteColorCode),
                                                                      ),
                                                                      color: MyColors
                                                                          .redColorCode,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              height: 37,
                                              margin: EdgeInsets.only(top: 15),
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 6,
                                                  bottom: 6),
                                              decoration: BoxDecoration(
                                                  color: MyColors
                                                      .pinkBackgroundColorCode,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        MyColors.redColorCode,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteRecordConfirmation(int geofenceId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Delete Record",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Text(
                        "Are you sure want to delete records...??",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 18, color: MyColors.whiteColorCode),
                          ),
                          color: MyColors.text3greyColorCode,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: MaterialButton(
                            // padding: const EdgeInsets.only(left:15.0,right: 15,top: 4,bottom: 4),
                            onPressed: () {
                              // Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              searchData!.removeAt(geofenceId);
                              _mainBloc.add(DeleteGeofenceCreateEvents(
                                  vendorId: vendorid,
                                  branchId: branchid,
                                  geofenceId: geofenceId,
                                  token: token));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  fontSize: 18, color: MyColors.whiteColorCode),
                            ),
                            color: MyColors.redColorCode,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
