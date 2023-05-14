import 'package:flutter/material.dart' hide Key;
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../bloc/main_event.dart';
import '../../model/travel_summary/travel_summary.dart';
import '../../model/travel_summary/travel_summary_filter.dart';
import '../../model/travel_summary/travel_summary_search.dart';
import 'package:loading_overlay/loading_overlay.dart';

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
  String fromdate = "01-sep-2022";
  String arainonari = "arai";
  String todate = "30-sep-2022";
  String searchtext = "MH12";
  String fromtime = "06:30";
  String totime = "18:00";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  String searchfromtime = "10:30";
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
  TextEditingController fromTimeInput = TextEditingController();
  TextEditingController toTimrInput = TextEditingController();
  late SharedPreferences sharedPreferences;
  final controller = ScrollController();
  late bool _isLoading = false;
  bool isData = false;
  late String token = "";
  late MainBloc _mainBloc;
  bool isSelected = false;
  String radiolist = "radio";
  bool isvalue = false;
  bool applyclicked = false;
  int vendorid = 1;
  int branchid = 1;
  int pagenumber = 1;
  int pagesize = 10;
  late int value = 0;
  late int searchvalue = 0;
  List<DatewiseStatusWiseTravelSummaryData>? traveldata = [];
  List<DatewiseStatusWiseTravelSearch>? searchdata = [];
  List<DatewiseStatusWiseTravelFilter>? filterdata = [];
  @override
  void initState() {
    super.initState();

    getdata();
    setState(() {
      isvalue = false;
    });
    notificationController.addListener(() {
      if (notificationController.position.maxScrollExtent ==
          notificationController.offset) {
        setState(() {
          print("Scroll ${pagenumber}");
          getallbranch();
          // isSelected ? getsearch() : null ;
        });
      }
    });
    _mainBloc = BlocProvider.of(context);
  }

  getsearch() {
    _mainBloc.add(TravelSummarySearchEvent(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        arainonarai: arainonari,
        searchtext: searhcontroller.text,
        fromdata: fromDateController ?? fromdate,
        fromtime: fromTimeController ?? fromtime,
        todate: toDateController ?? todate,
        totime: toTimeController ?? searchtotime,
        pagesize: pagesize,
        pagenumber: pagenumber));
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
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          //! FilterEvent TravelSummarydata fetching Start from here----------------
          if (state is TravelSummaryFilterLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is TravelSummaryFilterLoadedState) {
            if (state.travelSummaryFilterResponse.datewise != null) {
              print("Filter data is printed!!");
              setState(() {
                _isLoading = false;
                // pagenumber++;
                filterdata!.clear();
                filterdata!.addAll(state.travelSummaryFilterResponse.datewise!);
              });
            } else {
              print("Something went worong in Filter data");
              setState(() {
                _isLoading = false;
              });
            }
          } else if (state is TravelSummaryFilterErrorState) {
            print("Something went Wrong Filter data");
            setState(() {
              _isLoading = false;
            });
          }
          //! SearchEvent TravelSummarydata fetching Start from here----------------
          if (state is TravelSummarySearchLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is TravelSummarySearchLoadedState) {
            if (state.travelSummaryResponse.datewise != null) {
              print("Search data is printed!!");
              pagenumber++;
              setState(() {
                _isLoading = false;
                searchdata!.clear();
                searchvalue = state.travelSummaryResponse.totalRecords!;
              });
              searchdata!.addAll(state.travelSummaryResponse.datewise!);
            } else {
              print("Something is going wrong in Search data");
              setState(() {
                _isLoading = false;
              });
            }
          } else if (state is TravelSummaryErrorState) {
            print("Something went Wrong search data");
            setState(() {
              _isLoading = false;
            });
          }
          //! All TravelSummarydata fetching Start from here----------------
          if (state is TravelSummaryReportLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is TravelSummaryReportLoadedState) {
            // setState(() {
            if (state.TravelSummaryResponse.datewise != null) {
              print("All travel Summary data is printed!!");
              pagenumber++;
              setState(() {
                _isLoading = false;
                value = state.TravelSummaryResponse.totalRecords!;
              });
              traveldata!.addAll(state.TravelSummaryResponse.datewise!);
            }
            // });
          } else if (state is TravelSummaryErrorState) {
            print("Something went Wrong");
            setState(() {
              _isLoading = false;
            });
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
                        Text(
                            isvalue ? fromDateController.toString() : fromdate),
                        Text(
                            isvalue ? fromTimeController.toString() : fromtime),
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
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
                        borderSide: BorderSide(
                            width: 1, color: MyColors.buttonColorCode),
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
                              width: 1,
                              color: MyColors.textBoxBorderColorCode)),
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
                          ? Center(
                              child: Text("No data Found"),
                            )
                          : _isLoading
                              ? Center(
                                  child: Text("Please wait for data"),
                                )
                              : SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                                          const EdgeInsets.all(
                                                              10),
                                                      decoration: BoxDecoration(
                                                        color: MyColors
                                                            .whiteColorCode,
                                                        border: Border.all(
                                                            color: MyColors
                                                                .boxBackgroundColorCode),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10)),
                                                      ),
                                                       child: searchdata![index]
                                                            .vehicleStatus ==
                                                        "Idle"
                                                    ? Image.asset(
                                                        "assets/idle_truck.png",
                                                        height: 45.0,
                                                        width: 45.0,
                                                      )
                                                    : searchdata![index]
                                                                .vehicleStatus ==
                                                            "Inactive"
                                                        ? Image.asset(
                                                            "assets/inactive_truck.png",
                                                            height: 45.0,
                                                            width: 45.0,
                                                          )
                                                        : searchdata![index]
                                                                    .vehicleStatus ==
                                                                "Stop"
                                                            ? Image.asset(
                                                                "assets/stopped_truck.png",
                                                                height: 45.0,
                                                                width: 45.0,
                                                              )
                                                            : searchdata![index]
                                                                        .vehicleStatus ==
                                                                    "Overspeed"
                                                                ? Image.asset(
                                                                    "assets/overspeed_truck.png",
                                                                    height:
                                                                        45.0,
                                                                    width: 45.0,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/running_truck.png",
                                                                    height:
                                                                        45.0,
                                                                    width: 45.0,
                                                                  ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                              searchdata![index]
                                                                  .vehicleregNo
                                                                  .toString(),
                                                              style: const TextStyle(
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      top: 6,
                                                                      bottom:
                                                                          6),
                                                                  child: Text(
                                                                    searchdata![
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
                                                                  padding: const EdgeInsets
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
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(10)),
                                                                  ),
                                                                  child: Text(
                                                                    searchdata![
                                                                            index]
                                                                        .tDate
                                                                        .toString(),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 6),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 4.0,
                                                                      right: 4,
                                                                      top: 4,
                                                                      bottom:
                                                                          4),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: MyColors
                                                                    .lightblueColorCode,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            4)),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const Text(
                                                                            "Arrival Time"),
                                                                        Text(
                                                                            searchdata![index]
                                                                                .vehicleStatusTime
                                                                                .toString(),
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold)),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  const Icon(Icons
                                                                      .compare_arrows),
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        const Text(
                                                                            "Depature Time"),
                                                                        Text(
                                                                            searchdata![index]
                                                                                .vehicleStatusTime
                                                                                .toString(),
                                                                            style:
                                                                                const TextStyle(fontWeight: FontWeight.bold)),
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
                                                    color:
                                                        MyColors.greyColorCode,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0, right: 10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child:
                                                            Column(children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 6),
                                                            child: Text(
                                                                "Distance"),
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
                                                        child:
                                                            Column(children: [
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
                                                              searchdata![index]
                                                                  .avgSpeed
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: MyColors
                                                                      .analyticActiveColorCode))
                                                        ]),
                                                      ),
                                                      Expanded(
                                                        child:
                                                            Column(children: [
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
                      : applyclicked ?BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                        controller: notificationController,
                                        shrinkWrap: true,
                                        itemCount:  filterdata!.length,
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: MyColors
                                                              .whiteColorCode,
                                                          border: Border.all(
                                                              color: MyColors
                                                                  .boxBackgroundColorCode),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: filterdata![index]
                                                            .vehicleStatus ==
                                                        "Idle"
                                                    ? Image.asset(
                                                        "assets/idle_truck.png",
                                                        height: 45.0,
                                                        width: 45.0,
                                                      )
                                                    : filterdata![index]
                                                                .vehicleStatus ==
                                                            "Inactive"
                                                        ? Image.asset(
                                                            "assets/inactive_truck.png",
                                                            height: 45.0,
                                                            width: 45.0,
                                                          )
                                                        : filterdata![index]
                                                                    .vehicleStatus ==
                                                                "Stop"
                                                            ? Image.asset(
                                                                "assets/stopped_truck.png",
                                                                height: 45.0,
                                                                width: 45.0,
                                                              )
                                                            : filterdata![index]
                                                                        .vehicleStatus ==
                                                                    "Overspeed"
                                                                ? Image.asset(
                                                                    "assets/overspeed_truck.png",
                                                                    height:
                                                                        45.0,
                                                                    width: 45.0,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/running_truck.png",
                                                                    height:
                                                                        45.0,
                                                                    width: 45.0,
                                                                  ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                 filterdata![
                                                                            index]
                                                                        .vehicleregNo
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  // const Icon(
                                                                  //   Icons
                                                                  //       .circle,
                                                                  //   color: Colors.black,
                                                                  //   size: 7,
                                                                  // ),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              4.0,
                                                                          top:
                                                                              6,
                                                                          bottom:
                                                                              6),
                                                                      child:  Text(
                                                                              filterdata![index].vehicleStatus.toString(),
                                                                              style: TextStyle(
                                                                                  color: filterdata![index].vehicleStatus.toString() == "Running"
                                                                                      ? Color.fromARGB(255, 74, 172, 79)
                                                                                      : filterdata![index].vehicleStatus.toString() == "Idle"
                                                                                          ? Color.fromARGB(255, 233, 215, 60)
                                                                                          : filterdata![index].vehicleStatus.toString() == "Inactive"
                                                                                              ? Colors.blue
                                                                                              : filterdata![index].vehicleStatus.toString() == "Stop"
                                                                                                  ? Colors.red
                                                                                                  : filterdata![index].vehicleStatus.toString() == "Overspeed"
                                                                                                      ? Colors.orange
                                                                                                      : Colors.grey,
                                                                                  fontSize: 16),
                                                                            )
                                                                          ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6.0,
                                                                        right:
                                                                            6,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: MyColors
                                                                          .textBoxColorCode,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10)),
                                                                    ),
                                                                    child: Text(
                                                                     filterdata![index]
                                                                              .tDate
                                                                              .toString(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 6),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            4.0,
                                                                        right:
                                                                            4,
                                                                        top: 4,
                                                                        bottom:
                                                                            4),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: MyColors
                                                                      .lightblueColorCode,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Text(
                                                                              "Arrival Time"),
                                                                          Text(
                                                                               filterdata![index].vehicleStatusTime.toString(),
                                                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Icon(Icons
                                                                        .compare_arrows),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Text(
                                                                              "Depature Time"),
                                                                          Text(
                                                                               filterdata![index].vehicleStatusTime.toString() ,
                                                                              style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Divider(
                                                      height: 5,
                                                      color: MyColors
                                                          .greyColorCode,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            right: 10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          6),
                                                                  child: Text(
                                                                      "Distance"),
                                                                ),
                                                                Text(
                                                                     filterdata![index]
                                                                            .distanceTravel
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        color: MyColors
                                                                            .analyticGreenColorCode))
                                                              ]),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          6),
                                                                  child: const Text(
                                                                      "Avg Speed",
                                                                      style: TextStyle(
                                                                          color:
                                                                              MyColors.analyticActiveColorCode)),
                                                                ),
                                                                Text(
                                                                    filterdata![index]
                                                                            .avgSpeed
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        color: MyColors
                                                                            .analyticActiveColorCode))
                                                              ]),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          6),
                                                                  child: const Text(
                                                                      "Max Speed",
                                                                      style: TextStyle(
                                                                          color:
                                                                              MyColors.maxspeedcolorCode)),
                                                                ),
                                                                Text(
                                                                    filterdata![index]
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
                                )   :traveldata!.length == 0
                          ? Center(
                              child: Text("No data Found"),
                            )
                          : _isLoading
                              ? Center(
                                  child: Text("Please wait for data"),
                                )
                              : BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                        controller: notificationController,
                                        shrinkWrap: true,
                                        itemCount:  traveldata!.length,
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: MyColors
                                                              .whiteColorCode,
                                                          border: Border.all(
                                                              color: MyColors
                                                                  .boxBackgroundColorCode),
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: traveldata![index]
                                                            .vehicleStatus ==
                                                        "Idle"
                                                    ? Image.asset(
                                                        "assets/idle_truck.png",
                                                        height: 45.0,
                                                        width: 45.0,
                                                      )
                                                    : traveldata![index]
                                                                .vehicleStatus ==
                                                            "Inactive"
                                                        ? Image.asset(
                                                            "assets/inactive_truck.png",
                                                            height: 45.0,
                                                            width: 45.0,
                                                          )
                                                        : traveldata![index]
                                                                    .vehicleStatus ==
                                                                "Stop"
                                                            ? Image.asset(
                                                                "assets/stopped_truck.png",
                                                                height: 45.0,
                                                                width: 45.0,
                                                              )
                                                            : traveldata![index]
                                                                        .vehicleStatus ==
                                                                    "Overspeed"
                                                                ? Image.asset(
                                                                    "assets/overspeed_truck.png",
                                                                    height:
                                                                        45.0,
                                                                    width: 45.0,
                                                                  )
                                                                : Image.asset(
                                                                    "assets/running_truck.png",
                                                                    height:
                                                                        45.0,
                                                                    width: 45.0,
                                                                  ),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
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
                                                                 traveldata![
                                                                            index]
                                                                        .vehicleregNo
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  // const Icon(
                                                                  //   Icons
                                                                  //       .circle,
                                                                  //   color: Colors.black,
                                                                  //   size: 7,
                                                                  // ),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              4.0,
                                                                          top:
                                                                              6,
                                                                          bottom:
                                                                              6),
                                                                      child:  Text(
                                                                              traveldata![index].vehicleStatus.toString(),
                                                                              style: TextStyle(
                                                                                  color: traveldata![index].vehicleStatus.toString() == "Running"
                                                                                      ? Color.fromARGB(255, 74, 172, 79)
                                                                                      : traveldata![index].vehicleStatus.toString() == "Idle"
                                                                                          ? Color.fromARGB(255, 233, 215, 60)
                                                                                          : traveldata![index].vehicleStatus.toString() == "Inactive"
                                                                                              ? Colors.blue
                                                                                              : traveldata![index].vehicleStatus.toString() == "Stop"
                                                                                                  ? Colors.red
                                                                                                  : traveldata![index].vehicleStatus.toString() == "Overspeed"
                                                                                                      ? Colors.orange
                                                                                                      : Colors.grey,
                                                                                  fontSize: 16),
                                                                            )
                                                                          ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            6.0,
                                                                        right:
                                                                            6,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: MyColors
                                                                          .textBoxColorCode,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10)),
                                                                    ),
                                                                    child: Text(
                                                                     traveldata![index]
                                                                              .tDate
                                                                              .toString(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top: 6),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            4.0,
                                                                        right:
                                                                            4,
                                                                        top: 4,
                                                                        bottom:
                                                                            4),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: MyColors
                                                                      .lightblueColorCode,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              4)),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Text(
                                                                              "Arrival Time"),
                                                                          Text(
                                                                               traveldata![index].vehicleStatusTime.toString(),
                                                                              style: const TextStyle(fontWeight: FontWeight.bold)),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    const Icon(Icons
                                                                        .compare_arrows),
                                                                    Expanded(
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          const Text(
                                                                              "Depature Time"),
                                                                          Text(
                                                                               traveldata![index].vehicleStatusTime.toString() ,
                                                                              style: const TextStyle(fontWeight: FontWeight.bold)),
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
                                                    padding: EdgeInsets.only(
                                                        top: 8.0),
                                                    child: Divider(
                                                      height: 5,
                                                      color: MyColors
                                                          .greyColorCode,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            right: 10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          6),
                                                                  child: Text(
                                                                      "Distance"),
                                                                ),
                                                                Text(
                                                                     traveldata![index]
                                                                            .distanceTravel
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        color: MyColors
                                                                            .analyticGreenColorCode))
                                                              ]),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          6),
                                                                  child: const Text(
                                                                      "Avg Speed",
                                                                      style: TextStyle(
                                                                          color:
                                                                              MyColors.analyticActiveColorCode)),
                                                                ),
                                                                Text(
                                                                    traveldata![index]
                                                                            .avgSpeed
                                                                            .toString(),
                                                                    style: const TextStyle(
                                                                        color: MyColors
                                                                            .analyticActiveColorCode))
                                                              ]),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          6),
                                                                  child: const Text(
                                                                      "Max Speed",
                                                                      style: TextStyle(
                                                                          color:
                                                                              MyColors.maxspeedcolorCode)),
                                                                ),
                                                                Text(
                                                                    traveldata![index]
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
                            // onChanged: (value) {
                            //   fromDateController = value;
                            // },
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
                                setState(() {
                                  fromdateInput.text = fromDateController;
                                });
                              } else {}
                            },
                            controller: fromdateInput,
                            enabled: true,
                            readOnly: true,
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
                              // onChanged: (value) {
                              //   fromTimeController = value;
                              // },
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
                                  setState(() {
                                    fromTimeInput.text = fromTimeController;
                                  });
                                }
                              },
                              readOnly: true,
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
                              controller: fromTimeInput,
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
                            // onChanged: (value) {
                            //   toDateController = value;
                            // },
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
                                setState(() {
                                  todateInput.text = toDateController;
                                });
                              } else {}
                            },
                            enabled: true,
                            readOnly: true,
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
                                  setState(() {
                                    toTimrInput.text = toTimeController;
                                  });
                                }
                              },
                              readOnly: true,
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
                              controller: toTimrInput,
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
                          child: GestureDetector(
                            onTap: () {
                              toTimrInput.text = "";
                              todateInput.text = "";
                              fromTimeInput.text = "";
                              fromdateInput.text = "";
                              setState(() {});
                            },
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
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  color: MyColors.text4ColorCode,
                                ),
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
                              print(
                                  "Here is your fromdatecontroller-------------" +
                                      fromDateController);
                              _mainBloc.add(TravelSummaryFilterEvent(
                                  token: token,
                                  vendorid: vendorid,
                                  branchid: branchid,
                                  arainonarai: arainonari,
                                  fromdata: fromDateController,
                                  fromtime: fromTimeController,
                                  todate: toDateController,
                                  totime: toTimeController,
                                  vehiclelist: vehiclelist,
                                  pagesize: pagesize,
                                  pagenumber: pagenumber));
                              setState(() {
                                isvalue = true;
                                isData = true;
                                applyclicked = true;
                              });
                              Navigator.of(context).pop();
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
              ),
            ),
          );
        });
  }
}
