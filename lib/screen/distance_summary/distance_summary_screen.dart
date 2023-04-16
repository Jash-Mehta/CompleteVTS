import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/main_bloc.dart';
import '../../bloc/main_event.dart';
import '../../bloc/main_state.dart';
import '../../model/distanceSummary/distance_summary_filter.dart';
import '../../model/distanceSummary/distance_summary_search.dart';
import '../../model/distanceSummary/distancesummary_entity.dart';

class DistanceSummaryScreen extends StatefulWidget {
  @override
  _DistanceSummaryScreenState createState() => _DistanceSummaryScreenState();
}

class _DistanceSummaryScreenState extends State<DistanceSummaryScreen> {
  ScrollController notificationController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> items = ["aaa", "bb", "cc", "dd", "ee"];

  bool isSelected = false;

  String radiolist = "radio";
  late int value = 0;
  String dropdownValue = 'today';

  final controller = ScrollController();
  late String token = "";
  late MainBloc _mainBloc;
  late SharedPreferences sharedPreferences;
  bool isvalue = false;

  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController;
  int vendorid = 1;
  int branchid = 1;
  int pagenumber = 1;
  int pagesize = 10;
  String fromdate = "01-sep-2022";
  String arainonari = "arai";
  String todate = "30-sep-2022";
  String fromtime = "06:30";
  String vehiclelist = '86,76';
  String summaryrange = "months";
  String totime = "18:00";
  String IMEINO = "867322033819244";
  List<DistanceSummary>? dist = [];
  List<DistanceFilter>? distancefilter = [];
  List<DistanceSearch>? distancesearch = [];
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
    _mainBloc.add(DistanceSummaryEvent(
        token: token,
        arainonarai: arainonari,
        branchid: branchid,
        fromdata: isvalue ? fromDateController.toString() : fromdate,
        fromtime: isvalue ? fromTimeController.toString() : fromtime,
        pagenumber: pagenumber,
        pagesize: pagesize,
        todate: isvalue ? toDateController.toString() : todate,
        totime: isvalue ? toTimeController.toString() : totime,
        vendorid: vendorid,
        IMEINO: IMEINO));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: CustomAppBar()
          .getCustomAppBar("DISTANCE SUMMARY", _scaffoldKey, 8, context),
      body: _vehicleStatus(),
    );
  }

  _vehicleStatus() {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        //! SearchEvent DistanceSummary fetching Start from here----------------
        if (state is DistanceSummarySearchLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is DistanceSummarySearchLoadedState) {
          if (state.distanceSummarySearch.dist != null) {
            print("Search data is printed!!");
            distancesearch!.addAll(state.distanceSummarySearch.dist!);
          } else {
            print("Something is going wrong in Search data");
          }
        } else if (state is TravelSummaryErrorState) {
          print("Something went Wrong search data");
        }
        //! Distance summary Filter Fetching-----------------------

        if (state is DistanceSummaryFilterLoadingState) {
          const Center(child: CircularProgressIndicator());
        } else if (state is DistanceSummaryFilterLoadedState) {
          setState(() {
            if (state.DistanceSummaryFilterResponse.dist != null) {
              print("Distance Summary filter data is printed!!");
              distancefilter!.addAll(state.DistanceSummaryFilterResponse.dist!);
            } else {
              print("Something is going wrong in Distance Filter");
            }
          });
        } else if (state is DistanceSummaryErrorState) {
          print("Something went Wrong in Distance Filter");
        }
        //! Distance summary All data is Fetching-------------------
        if (state is DistanceSummaryLoadingState) {
          const Center(child: CircularProgressIndicator());
        } else if (state is DistanceSummaryLoadedState) {
          setState(() {
            if (state.DistanceSummaryResponse.dist != null) {
              print("loaded");
              dist!.addAll(state.DistanceSummaryResponse.dist!);
            } else {
              print("Something is going wrong");
            }
          });
        } else if (state is DistanceSummaryErrorState) {
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
                        blurRadius: 2, color: MyColors.shadowGreyColorCode)
                  ]),
              // width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Set Summary Range",
                    style: TextStyle(fontSize: 18),
                  ),
                  Container(
                    color: MyColors.greyColorCode,
                    width: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        isDense: true,
                        value: dropdownValue,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: MyColors.text4ColorCode,
                        ),
                        elevation: 16,
                        style: const TextStyle(color: MyColors.text4ColorCode),
                        underline: Container(
                          height: 0,
                          color: MyColors.text4ColorCode,
                          // color: MyColors.blueColorCode,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            isvalue = true;
                            print(dropdownValue);
                          });
                          _mainBloc.add(DistanceSummaryFilterEvent(
                              token: token,
                              vendorid: vendorid,
                              branchid: branchid,
                              arainonarai: arainonari,
                              summaryrange: dropdownValue,
                              vehiclelist: vehiclelist,
                              pagesize: pagesize,
                              pagenumber: pagenumber));
                        },
                        items: <String>['today', 'week', 'months']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 15, right: 15, bottom: 10),
              child: Column(
                children: [
                  TextField(
                    onChanged: onSearchTextChanged,
                    enabled: true, // to trigger disabledBorder
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
                      ? distancesearch!.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: 350.0,
                              child: ListView.builder(
                                  controller: notificationController,
                                  shrinkWrap: true,
                                  itemCount: distancesearch!.length,
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
                                                  padding: EdgeInsets.all(10),
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
                                                          distancesearch![index]
                                                              .vehicleregNo
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 20),
                                                        ),
                                                        Text(
                                                          distancesearch![index]
                                                              .driverName
                                                              .toString(),
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              color: MyColors
                                                                  .analyticGreenColorCode),
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
                                                                distancesearch![
                                                                        index]
                                                                    .vehicleStatus
                                                                    .toString(),
                                                                style: const TextStyle(
                                                                    color: MyColors
                                                                        .analyticGreenColorCode,
                                                                    fontSize:
                                                                        16),
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
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            8,
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: MyColors
                                                                      .textBoxColorCode,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8)),
                                                                ),
                                                                child: Text(
                                                                    distancesearch![
                                                                            index]
                                                                        .tDate
                                                                        .toString())),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }))
                      : dist!.length == 0
                          ? const Center(child: CircularProgressIndicator())
                          : distancefilter!.length == 0
                              ? const Center(child: CircularProgressIndicator())
                              : BlocBuilder<MainBloc, MainState>(
                                  builder: (context, state) {
                                    return ListView.builder(
                                        controller: notificationController,
                                        shrinkWrap: true,
                                        itemCount: isvalue
                                            ? distancefilter!.length
                                            : dist!.length,
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
                                                            EdgeInsets.all(10),
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
                                                        child: Image.asset(
                                                          "assets/driving_pin.png",
                                                          width: 40,
                                                          height: 40,
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
                                                                isvalue
                                                                    ? distancefilter![
                                                                            index]
                                                                        .vehicleregNo
                                                                        .toString()
                                                                    : dist![index]
                                                                        .vehicleregNo
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                              Text(
                                                                isvalue
                                                                    ? distancefilter![
                                                                            index]
                                                                        .driverName
                                                                        .toString()
                                                                    : dist![index]
                                                                        .driverName
                                                                        .toString(),
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: MyColors
                                                                        .analyticGreenColorCode),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .circle,
                                                                    color: MyColors
                                                                        .analyticGreenColorCode,
                                                                    size: 7,
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            4.0,
                                                                        top: 6,
                                                                        bottom:
                                                                            6),
                                                                    child: Text(
                                                                      isvalue
                                                                          ? distancefilter![index]
                                                                              .vehicleStatus
                                                                              .toString()
                                                                          : dist![index]
                                                                              .vehicleStatus
                                                                              .toString(),
                                                                      style: const TextStyle(
                                                                          color: MyColors
                                                                              .analyticGreenColorCode,
                                                                          fontSize:
                                                                              16),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          left:
                                                                              8.0,
                                                                          right:
                                                                              8,
                                                                          top:
                                                                              8,
                                                                          bottom:
                                                                              8),
                                                                      decoration:
                                                                          const BoxDecoration(
                                                                        color: MyColors
                                                                            .textBoxColorCode,
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(8)),
                                                                      ),
                                                                      child: Text(isvalue
                                                                          ? distancefilter![index]
                                                                              .tDate
                                                                              .toString()
                                                                          : dist![index]
                                                                              .tDate
                                                                              .toString())),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                )
                ],
              ),
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
      _mainBloc.add(DistanceSummarySearchEvent(
          token: token,
          vendorid: vendorid,
          branchid: branchid,
          arainonarai: arainonari,
          searchtext: "MH12",
          fromdata: fromdate,
          fromtime: fromtime,
          todate: todate,
          totime: totime,
          pagesize: pagesize,
          pagenumber: pagenumber));
    }

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
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
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
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 10),
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
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
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
