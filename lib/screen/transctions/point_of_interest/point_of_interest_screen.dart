import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/point_of_interest/create_point_of_interest.dart';
import 'package:flutter_vts/model/point_of_interest/search_point_of_interest.dart';
import 'package:flutter_vts/screen/transctions/point_of_interest/create_point_of_interest_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/custome_dialog.dart';
import '../../onboarding/OnboardingScreen.dart';

class PointOfInterestScreen extends StatefulWidget {
  const PointOfInterestScreen({Key? key}) : super(key: key);

  @override
  _PointOfInterestScreenState createState() => _PointOfInterestScreenState();
}

class _PointOfInterestScreenState extends State<PointOfInterestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vendorRecordController = new ScrollController();
  List<CreatePointOfInterest>? pointOfInterestListData = [];
  List<PointInterstData>? pointInterstDataitem = [];
  late SharedPreferences sharedPreferences;
  late String token = "";
  late MainBloc _mainBloc;
  TextEditingController searhcontroller = new TextEditingController();
  int vendorid = 1;
  int branchid = 1;
  int pagenumber = 1;
  int pagesize = 10;
  List<Datum>? searchdata = [];
  late bool _isLoading = false;
  late int totalCreatePointOfInterestRecords = 0, deleteposition = 0;
  bool isSelected = false;
  bool isvalue = false;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getdata();
    setState(() {
      isvalue = false;
    });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          print("Scroll ${pagenumber}");
          getdata();
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
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
      });
      _mainBloc.add(SearchPointOfInterestEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        searchStr: searhcontroller.text,
      ));
    }
    // traveldata!.forEach((userDetail) {
    //   if (userDetail.vehicleregNo!.contains(text)) searchdata!.add(userDetail);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  drawer: MenuDrawer().getMenuDrawer(context),
      appBar: CustomAppBar().getCustomAppBar(
          "POINT OF INTEREST CREATE", _scaffoldKey, 0, context),
      body: _pointOfInterestCreate(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.buttonColorCode,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: CreatePointOfInterestScreen())));
        },
        child: Icon(
          Icons.add,
          color: MyColors.whiteColorCode,
        ),
      ),
    );
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
    if (token != "" || vendorid != 0 || branchid != 0) {
      getallbranch();
    }
  }

  getallbranch() {
    _mainBloc.add(GetPointOfInterestEvent(
        token: token,
        branchid: branchid,
        pagenumber: pagenumber,
        pagesize: pagesize,
        vendorid: vendorid));
  }

  _pointOfInterestCreate() {
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
              if (state is PointOfInterestCreateLoadingState) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is PointOfInterestCreateLoadedState) {
                setState(() {
                  _isLoading = false;
                  pagenumber++;
                  totalCreatePointOfInterestRecords =
                      state.createPointOfInterest.totalRecords!;
                });
                if (state.createPointOfInterest.data != null) {
                  pointInterstDataitem!
                      .addAll(state.createPointOfInterest.data!);
                }
              } else if (state is PointOfInterestCreateErrorState) {
                setState(() {
                  _isLoading = false;
                });
              }
              //! Handling search text of point of interest
              if (state is SearchPointOfInterestLoadingState) {
                print("Enter in search loading======>");
                setState(() {
                  _isLoading = true;
                });
              } else if (state is SearchPointOfInterestLoadedState) {
                print("Search loaded block");
                setState(() {
                  searchdata!.clear();
                  _isLoading = false;
                });
                if (state.searchPointOfInterest.data != null) {
                  print("Lenght of list is---${searchdata!.length}");
                  searchdata!.addAll(state.searchPointOfInterest.data!);
                }
              } else if (state is SearchPointOfInterestErrorState) {
                setState(() {
                  _isLoading = false;
                });
              }
              //! Handling delete event in POI-----------------
              if (state is POIDeleteLoadingState) {
                setState(() {
                  _isLoading = true;
                });
              } else if (state is POIDeleteLoadedState) {
                setState(() {
                  _isLoading = false;
                  pointInterstDataitem!.removeAt(deleteposition);
                });
                searchdata!.removeAt(deleteposition);
              } else if (state is POIDeleteErrorState) {
                setState(() {
                  _isLoading = false;
                });
              }
            },
            child: SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, left: 15, right: 15, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      enabled: true, // to trigger disabledBorder
                      controller: searhcontroller,
                      onChanged: onSearchTextChanged,
                      keyboardType: TextInputType.text,

                      decoration: const InputDecoration(
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
                              width: 1, color: MyColors.textColorCode),
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
                        hintText: "Search Record",
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 18, color: MyColors.searchTextColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      // onChanged: _authenticationFormBloc.onPasswordChanged,
                      obscureText: false,
                    ),
                    isSelected
                        ? Text("${searchdata!.length} Records",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))
                        : Text(
                            "${pointInterstDataitem!.length} Records",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                    isSelected
                        ? searchdata!.length == null ||
                                searhcontroller.text.isEmpty
                            ? Text("No data found")
                            : Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: ListView.builder(
                                    controller: vendorRecordController,
                                    shrinkWrap: true,
                                    itemCount: searchdata!.length,
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
                                                            "Sr.No",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .textprofiledetailColorCode,
                                                                fontSize: 18),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 4.0),
                                                            child: Text(
                                                              "${searchdata!.elementAt(index).srNo}",
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
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "POI Name",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .textprofiledetailColorCode,
                                                              fontSize: 18),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${searchdata!.elementAt(index).poiname}",
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
                                                          "POI Type",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .textprofiledetailColorCode,
                                                              fontSize: 18),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${searchdata!.elementAt(index).poiTypeName}",
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
                                                        CrossAxisAlignment
                                                            .start,
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
                                                            const EdgeInsets
                                                                .only(top: 4.0),
                                                        child: Text(
                                                          "${searchdata!.elementAt(index).tolerance}",
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
                                                            "Vehicle Reg.No",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .textprofiledetailColorCode,
                                                                fontSize: 18),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 4.0),
                                                            child: Text(
                                                              "${searchdata!.elementAt(index).vehicleRegno}",
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
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Show POI",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .textprofiledetailColorCode,
                                                              fontSize: 18),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 4.0),
                                                          child: Text(
                                                            "${searchdata!.elementAt(index).showPoi}",
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4.0),
                                                    child: Text(
                                                      "${searchdata!.elementAt(index).description}",
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
                                                  deleteposition = index;
                                                  setState(() {});
                                                  //! --Delete Alert Box--------------------------------
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)), //this right here
                                                          child: Container(
                                                            height: 200,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      12.0),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Text(
                                                                      "Delete Record",
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20)),
                                                                  Padding(
                                                                    padding: const EdgeInsets
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
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        shape: const RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10))),
                                                                        child:
                                                                            const Text(
                                                                          "No",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              color: MyColors.whiteColorCode),
                                                                        ),
                                                                        color: MyColors
                                                                            .text3greyColorCode,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(left: 15.0),
                                                                        child:
                                                                            MaterialButton(
                                                                          // padding: const EdgeInsets.only(left:15.0,right: 15,top: 4,bottom: 4),
                                                                          onPressed:
                                                                              () {
                                                                            //! MainBloc Delete data---------

                                                                            _mainBloc.add(POIDeletedata(
                                                                                token: token,
                                                                                vendorid: 1,
                                                                                branchid: 1,
                                                                                srno: int.parse(pointInterstDataitem![index].srNo.toString())));
                                                                            CustomDialog().popUp(context,
                                                                                "Well done! Record Delete Successfully....!!");
                                                                          },
                                                                          shape:
                                                                              const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                                                          child:
                                                                              const Text(
                                                                            "Yes",
                                                                            style:
                                                                                TextStyle(fontSize: 18, color: MyColors.whiteColorCode),
                                                                          ),
                                                                          color:
                                                                              MyColors.redColorCode,
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
                                                  margin:
                                                      EdgeInsets.only(top: 15),
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
                                                              Radius.circular(
                                                                  20))),
                                                  child: Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: MyColors
                                                            .redColorCode,
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
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ListView.builder(
                                controller: vendorRecordController,
                                shrinkWrap: true,
                                itemCount: pointInterstDataitem!.length,
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
                                                          "${pointInterstDataitem!.elementAt(index).srNo}",
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
                                                      "POI Name",
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
                                                        "${pointInterstDataitem!.elementAt(index).poiname}",
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
                                                      "POI Type",
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
                                                        "${pointInterstDataitem!.elementAt(index).poiTypeName}",
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
                                                      "${pointInterstDataitem!.elementAt(index).tolerance}",
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
                                                          "${pointInterstDataitem!.elementAt(index).vehicleRegno}",
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
                                                      "Show POI",
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
                                                        "${pointInterstDataitem!.elementAt(index).showPoi}",
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
                                                  "${pointInterstDataitem!.elementAt(index).description}",
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
                                              print(
                                                  "here is your delete index------------>" +
                                                      index.toString());
                                              //! --Delete Alert Box--------------------------------
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
                                                              const Text(
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
                                                                    shape: const RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(10))),
                                                                    child:
                                                                        const Text(
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
                                                                        //! MainBloc Delete data---------
                                                                        _mainBloc.add(POIDeletedata(
                                                                            token:
                                                                                token,
                                                                            vendorid:
                                                                                1,
                                                                            branchid:
                                                                                1,
                                                                            srno:
                                                                                int.parse(pointInterstDataitem![index].srNo.toString())));
                                                                        CustomDialog().popUp(
                                                                            context,
                                                                            "Well done! Record Delete Successfully....!!");
                                                                      },
                                                                      shape: const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10))),
                                                                      child:
                                                                          const Text(
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
                                              // _deleteRecordConfirmation();
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
                          ),
                  ],
                ),
              ),
            )));
  }

  _deleteRecordConfirmation() {}
}
