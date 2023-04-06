import 'package:flutter/material.dart' hide Key;
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_event.dart';
import '../../model/travel_summary/travel_summary.dart';
import '../../model/travel_summary/travel_summary_filter.dart';
import '../../model/travel_summary/travel_summary_search.dart';

class StorageSummaryScreen extends StatefulWidget {
  // const VehicleStatusScreen({Key? key}) : super(key: key);

  @override
  _StorageSummaryScreenState createState() => _StorageSummaryScreenState();
}

class _StorageSummaryScreenState extends State<StorageSummaryScreen> {
  ScrollController notificationController = new ScrollController();
   TextEditingController searhcontroller = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController,
      vehiclenumber;
  late SharedPreferences sharedPreferences;
  final controller = ScrollController();
   
  late String token = "";
  late MainBloc _mainBloc;
  bool isSelected = false;
  String radiolist = "radio";
  bool isvalue = false;
  int vendorid = 1;
  int branchid = 1;
  int pagenumber = 1;
  int pagesize = 10;
  String fromdate = "01-sep-2022";
  String arainonari = "arai";
  String todate = "30-sep-2022";
  String searchtext = "MH12";
  String fromtime = "06:30";
  String totime = "18:00";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  String searchfromtime = "10:30";
  late int value = 0;
  List<DatewiseStatusWiseTravelSummaryData>? traveldata = [];
  List<DatewiseStatusWiseTravelSearch>? searchdata = [];
  List<DatewiseStatusWiseTravelFilter>? filterdata = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    setState(() {
      isvalue = false;
    });
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        setState(() {
          print("Scroll ${pagenumber}");
          getallbranch();
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
  }

  getdata() async {
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
    _mainBloc.add(TravelSummaryReportEvent(
        token: token,
        arainonarai: arainonari,
        branchid: branchid,
        fromdata: fromdate,
        fromtime: fromtime,
        pagenumber: pagenumber,
        pagesize: pagesize,
        todate: todate,
        totime: totime,
        vendorid: vendorid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: CustomAppBar()
          .getCustomAppBar("STORAGE SUMMARY", _scaffoldKey, 10, context),
      body: _vehicleStatus(),
    );
  }

  _vehicleStatus() {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        
        //! FilterEvent TravelSummarydata fetching Start from here----------------
        if (state is TravelSummaryFilterLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TravelSummaryFilterLoadedState) {
          if (state.travelSummaryFilterResponse.datewise != null) {
            print("Filter data is printed!!");
            filterdata!.addAll(state.travelSummaryFilterResponse.datewise!);
          } else {
            print("Something went worong in Filter data");
          }
        } else if (state is TravelSummaryFilterErrorState) {
          print("Something went Wrong Filter data");
        }
        //! SearchEvent TravelSummarydata fetching Start from here----------------
        if (state is TravelSummarySearchLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is TravelSummarySearchLoadedState) {
          if (state.travelSummaryResponse.datewise != null) {
            print("Search data is printed!!");
            searchdata!.addAll(state.travelSummaryResponse.datewise!);
          } else {
            print("Something is going wrong in Search data");
          }
        } else if (state is TravelSummaryErrorState) {
          print("Something went Wrong search data");
        }

        //! All TravelSummarydata fetching Start from here----------------
        if (state is TravelSummaryReportLoadingState) {
          const Center(child: CircularProgressIndicator());
        } else if (state is TravelSummaryReportLoadedState) {
          setState(() {
            if (state.TravelSummaryResponse.datewise != null) {
              print("All travel Summary data is printed!!");
              traveldata!.addAll(state.TravelSummaryResponse.datewise!);
            } else {
              print("Something is going wrong");
            }
          });
        } else if (state is TravelSummaryErrorState) {
          print("Something went Wrong");
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              decoration: const BoxDecoration(
                  color: MyColors.lightgreyColorCode,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 4, color: MyColors.shadowGreyColorCode)
                  ]),
              // width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(isvalue ? fromDateController.toString() : fromdate),
                      Text(isvalue ? fromTimeController.toString() : fromtime),
                    ],
                  ),
                  const Text("-"),
                  Column(
                    children: [
                      Text(isvalue ? toDateController.toString() : todate),
                      Text(isvalue ? toTimeController.toString() : totime),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      changeDatepopUp(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      decoration: const BoxDecoration(
                          color: MyColors.greyColorCode,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Text(
                        "Change",
                        style: TextStyle(
                            color: MyColors.text4ColorCode, fontSize: 18),
                      ),
                    ),
                  )

                  // Text("10 NOTIFICATIONS",style: TextStyle(fontSize: 18),),
                  // Text("CLEAR ALL",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 15, right: 15, bottom: 10),
              child: Column(children: [
                 TextField(
                         controller: searhcontroller,
                    onChanged: onSearchTextChanged,
                  enabled: true, // to trigger disabledBorder
                  decoration: const InputDecoration(
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
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)),
                    hintText: "Enter Vehicle Number",
                    prefixIcon: Icon(
                      Icons.search,
                      size: 24,
                      color: Colors.black,
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
                    ? searchdata!.isEmpty
                        ? Container()
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            width: 350.0,
                            child: ListView.builder(
                                controller: notificationController,
                                shrinkWrap: true,
                                itemCount: searchdata!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 1,
                                          color:
                                              MyColors.textBoxBorderColorCode),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          left: 14,
                                          right: 14,
                                          bottom: 10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: const BoxDecoration(
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
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color:
                                                      MyColors.whiteColorCode,
                                                  border: Border.all(
                                                      color: MyColors
                                                          .boxBackgroundColorCode),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                ),
                                                child: Image.asset(
                                                  "assets/driving_pin.png",
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        searchdata![index]
                                                            .vehicleregNo
                                                            .toString(),
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 20),
                                                      ),
                                                      Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.circle,
                                                            color: MyColors
                                                                .analyticGreenColorCode,
                                                            size: 7,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 4.0,
                                                                    top: 6,
                                                                    bottom: 6),
                                                            child: Text(
                                                              searchdata![index]
                                                                  .vehicleStatus
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: MyColors
                                                                      .analyticGreenColorCode),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 6.0,
                                                                    right: 6,
                                                                    top: 6,
                                                                    bottom: 6),
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: MyColors
                                                                  .textBoxColorCode,
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10)),
                                                            ),
                                                            child: Text(
                                                              searchdata![index]
                                                                  .tDate
                                                                  .toString(),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(top: 6),
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 4.0,
                                                                right: 4,
                                                                top: 4,
                                                                bottom: 4),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: MyColors
                                                              .lightblueColorCode,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          4)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Arrival Time"),
                                                                  Text(
                                                                      searchdata![
                                                                              index]
                                                                          .vehicleStatusTime
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                              
                                                                ],
                                                              ),
                                                            ),
                                                            const Icon(Icons
                                                                .compare_arrows),
                                                            Expanded(
                                                              child: Column(
                                                                children: [
                                                                  const Text(
                                                                      "Depature Time"),
                                                                  Text(
                                                                      searchdata![
                                                                              index]
                                                                          .vehicleStatusTime
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold)),
                                                                              
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
                                            ],
                                          ),
                                          
                                          const Padding(
                                            padding: EdgeInsets.only(top: 8.0),
                                            child: Divider(
                                              height: 5,
                                              color: MyColors.greyColorCode,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, right: 10),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 6),
                                                      child: Text("Distance"),
                                                    ),
                                                    Text(
                                                        searchdata![index]
                                                            .distanceTravel
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: MyColors
                                                                .analyticGreenColorCode))
                                                  ]),
                                                ),
                                                Expanded(
                                                  child: Column(children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 6),
                                                      child: const Text(
                                                          "Avg Speed",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .analyticActiveColorCode)),
                                                    ),
                                                    Text(
                                                        searchdata![index]
                                                            .avgSpeed
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: MyColors
                                                                .analyticActiveColorCode))
                                                  ]),
                                                ),
                                                Expanded(
                                                  child: Column(children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 6),
                                                      child: const Text(
                                                          "Max Speed",
                                                          style: TextStyle(
                                                              color: MyColors
                                                                  .maxspeedcolorCode)),
                                                    ),
                                                    Text(
                                                        searchdata![index]
                                                            .maxSpeed
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: MyColors
                                                                .analyticGreenColorCode))
                                                  ]),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }))
                    : traveldata!.length == 0
                        ? Container()
                        : BlocBuilder<MainBloc, MainState>(
                            builder: (context, state) {
                              return ListView.builder(
                                  controller: notificationController,
                                  shrinkWrap: true,
                                  itemCount: isvalue
                                      ? filterdata!.length
                                      : traveldata!.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 1,
                                            color: MyColors
                                                .textBoxBorderColorCode),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 10,
                                            left: 14,
                                            right: 14,
                                            bottom: 10),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
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
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        MyColors.whiteColorCode,
                                                    border: Border.all(
                                                        color: MyColors
                                                            .boxBackgroundColorCode),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10)),
                                                  ),
                                                  child: Image.asset(
                                                    "assets/driving_pin.png",
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          isvalue
                                                              ? filterdata![
                                                                      index]
                                                                  .vehicleregNo
                                                                  .toString()
                                                              : traveldata![
                                                                      index]
                                                                  .vehicleregNo
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                              Icons.circle,
                                                              color: MyColors
                                                                  .analyticGreenColorCode,
                                                              size: 7,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      top: 6,
                                                                      bottom:
                                                                          6),
                                                              child: Text(
                                                                isvalue
                                                                    ? filterdata![
                                                                            index]
                                                                        .vehicleStatus
                                                                        .toString()
                                                                    : traveldata![
                                                                            index]
                                                                        .vehicleStatus
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    color: MyColors
                                                                        .analyticGreenColorCode),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 6.0,
                                                                      right: 6,
                                                                      top: 6,
                                                                      bottom:
                                                                          6),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: MyColors
                                                                    .textBoxColorCode,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                              ),
                                                              child: Text(
                                                                isvalue
                                                                    ? filterdata![
                                                                            index]
                                                                        .tDate
                                                                        .toString()
                                                                    : traveldata![
                                                                            index]
                                                                        .tDate
                                                                        .toString(),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(top: 6),
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 4.0,
                                                                  right: 4,
                                                                  top: 4,
                                                                  bottom: 4),
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: MyColors
                                                                .lightblueColorCode,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4)),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    const Text(
                                                                        "Arrival Time"),
                                                                    Text(
                                                                        isvalue
                                                                            ? filterdata![index]
                                                                                .vehicleStatusTime
                                                                                .toString()
                                                                            : traveldata![index]
                                                                                .vehicleStatusTime
                                                                                .toString(),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                              const Icon(Icons
                                                                  .compare_arrows),
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    const Text(
                                                                        "Depature Time"),
                                                                    Text(
                                                                        isvalue
                                                                            ? filterdata![index]
                                                                                .vehicleStatusTime
                                                                                .toString()
                                                                            : traveldata![index]
                                                                                .vehicleStatusTime
                                                                                .toString(),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
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
                                              ],
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 8.0),
                                              child: Divider(
                                                height: 5,
                                                color: MyColors.greyColorCode,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0, right: 10),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 6),
                                                        child: Text("Distance"),
                                                      ),
                                                      Text(
                                                          isvalue
                                                              ? filterdata![
                                                                      index]
                                                                  .distanceTravel
                                                                  .toString()
                                                              : traveldata![
                                                                      index]
                                                                  .distanceTravel
                                                                  .toString(),
                                                          style: const TextStyle(
                                                              color: MyColors
                                                                  .analyticGreenColorCode))
                                                    ]),
                                                  ),
                                                  Expanded(
                                                    child: Column(children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 6),
                                                        child: const Text(
                                                            "Avg Speed",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .analyticActiveColorCode)),
                                                      ),
                                                      Text(
                                                          isvalue
                                                              ? filterdata![
                                                                      index]
                                                                  .avgSpeed
                                                                  .toString()
                                                              : traveldata![
                                                                      index]
                                                                  .avgSpeed
                                                                  .toString(),
                                                          style: const TextStyle(
                                                              color: MyColors
                                                                  .analyticActiveColorCode))
                                                    ]),
                                                  ),
                                                  Expanded(
                                                    child: Column(children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                bottom: 6),
                                                        child: const Text(
                                                            "Max Speed",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .maxspeedcolorCode)),
                                                      ),
                                                      Text(
                                                          isvalue
                                                              ? filterdata![
                                                                      index]
                                                                  .maxSpeed
                                                                  .toString()
                                                              : traveldata![
                                                                      index]
                                                                  .maxSpeed
                                                                  .toString(),
                                                          style: const TextStyle(
                                                              color: MyColors
                                                                  .analyticGreenColorCode))
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            },
                          )
              ]),
            ),
          ],
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
      });
      _mainBloc.add(TravelSummarySearchEvent(
          token: token,
          vendorid: vendorid,
          branchid: branchid,
          arainonarai: arainonari,
          searchtext: searhcontroller.text,
          fromdata: fromdate,
          fromtime: searchfromtime,
          todate: todate,
          totime: searchtotime,
          pagesize: pagesize,
          pagenumber: pagenumber));
    }
    // traveldata!.forEach((userDetail) {
    //   if (userDetail.vehicleregNo!.contains(text)) searchdata!.add(userDetail);
    // });
  }

  changeDatepopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 310,
              width: MediaQuery.of(context).size.width - 20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 10),
                      child: Text(
                        "From Date/Time",
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
                            enabled: true,
                            onChanged: (value) {
                              fromDateController = value;
                            }, // to trigger disabledBorder
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
                              onChanged: (value) {
                                fromTimeController = value;
                              },
                              enabled: true, // to trigger disabledBorder
                              decoration: InputDecoration(
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
                            onChanged: (value) {
                              toDateController = value;
                            },
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
                            padding: EdgeInsets.only(left: 4.0),
                            child: TextField(
                              onChanged: ((value) => toTimeController = value),
                              enabled: true, // to trigger disabledBorder
                              decoration: InputDecoration(
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
                            children: [
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
                            children: [
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
                              _mainBloc.add(TravelSummaryFilterEvent(
                                  token: token,
                                  vendorid: vendorid,
                                  branchid: branchid,
                                  arainonarai: arainonari,
                                  fromdata: fromdate,
                                  fromtime: fromtime,
                                  todate: todate,
                                  totime: totime,
                                  vehiclelist: vehiclelist,
                                  pagesize: pagesize,
                                  pagenumber: pagenumber));
                              setState(() {
                                isvalue = true;
                              });
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(
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
              ),
            ),
          );
        });
  }
}
