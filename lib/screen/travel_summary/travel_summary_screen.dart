import 'package:flutter/material.dart' hide Key;
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/travel_summary/travel_summary.dart';
import 'package:flutter_vts/model/travel_summary/travel_summary_search.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/main_bloc.dart';
import '../../model/travel_summary/travel_summary_filter.dart';
import 'package:loading_overlay/loading_overlay.dart';

class TravelSummaryScreen extends StatefulWidget {
  @override
  _TravelSummaryScreenState createState() => _TravelSummaryScreenState();
}

class _TravelSummaryScreenState extends State<TravelSummaryScreen> {
  ScrollController notificationController = new ScrollController();
  ScrollController vendorRecordController = new ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isSelected = false;
  bool isvalue = false;
  bool isData = false;
  late bool _isLoading = false;
  final controller = ScrollController();
  late String token = "";
  late MainBloc _mainBloc;
  late SharedPreferences sharedPreferences;
  TextEditingController searhcontroller = new TextEditingController();
  late int value = 0;
  late int searchvalue = 0;
  var fromDateController,
      toDateController,
      fromTimeController,
      toTimeController,
      vehiclenumber;
  int vendorid = 1;
  int branchid = 1;
  int pagenumber = 1;
  int pagesize = 10;
  TextEditingController fromdateInput = TextEditingController();
  TextEditingController todateInput = TextEditingController();
  TextEditingController fromTimeInput = TextEditingController();
  TextEditingController toTimrInput = TextEditingController();
  String fromdate = "01-sep-2022";
  String arainonari = "arai";
  String todate = "30-sep-2022";
  String searchtext = "MH12";
  String fromtime = "06:30";
  String totime = "18:00";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  String searchfromtime = "10:30";
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
          isSelected ? getsearch() : null ;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: CustomAppBar()
          .getCustomAppBar("TRAVEL SUMMARY", _scaffoldKey, 5, context),
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
              setState(() {
                _isLoading = false;
                pagenumber++;
                searchvalue = state.travelSummaryResponse.totalRecords!;
              });
              searchdata!.addAll(state.travelSummaryResponse.datewise!);
            } else {
              print("Something is going wrong in Search data");
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
            setState(() {
              if (state.TravelSummaryResponse.datewise != null) {
                print("All travel Summary data is printed!!");
                setState(() {
                  _isLoading = false;
                  pagenumber++;
                  value = state.TravelSummaryResponse.totalRecords!;
                });
                traveldata!.addAll(state.TravelSummaryResponse.datewise!);
              } else {
                print("Something is going wrong");
              }
            });
          } else if (state is TravelSummaryErrorState) {
            print("Something went Wrong");
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          controller: notificationController,
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 15, right: 15, bottom: 10),
                child: Column(
                  children: [
                    TextField(
                      enabled: true,
                      controller: searhcontroller,
                      onChanged: onSearchTextChanged,
                      // to trigger disabledBorder
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
                                    height: MediaQuery.of(context).size.height *
                                        0.7,
                                    width: 350.0,
                                    child: BlocBuilder<MainBloc, MainState>(
                                        builder: (context, state) {
                                      return ListView.builder(
                                        controller: vendorRecordController,
                                        itemCount: searchdata!.length,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          var article = searchdata![index];
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
                                                                article
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
                                                                article.imei
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
                                                                      article
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
                                                                        top: 8,
                                                                        bottom:
                                                                            8),
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      color: MyColors
                                                                          .textBoxColorCode,
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(8)),
                                                                    ),
                                                                    child: Text(
                                                                        article
                                                                            .tDate
                                                                            .toString()),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 2.0,
                                                                  ),
                                                                  Container(
                                                                    padding: const EdgeInsets
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
                                                                              Radius.circular(8)),
                                                                    ),
                                                                    child: Text(article
                                                                        .vehicleStatusTime
                                                                        .toString()),
                                                                  ),
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
                                        },
                                      );
                                    }),
                                  )
                        : traveldata!.length == 0 || _isLoading
                            ? Container()
                            : BlocBuilder<MainBloc, MainState>(
                                builder: (context, state) {
                                  return ListView.builder(
                                    controller: vendorRecordController,
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
                                                    padding: EdgeInsets.all(10),
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
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 20),
                                                          ),
                                                          Text(
                                                            isvalue
                                                                ? filterdata![
                                                                        index]
                                                                    .imei
                                                                    .toString()
                                                                : traveldata![
                                                                        index]
                                                                    .imei
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
                                                                        left:
                                                                            4.0,
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
                                                                child: Text(isvalue
                                                                    ? filterdata![
                                                                            index]
                                                                        .tDate
                                                                        .toString()
                                                                    : traveldata![
                                                                            index]
                                                                        .tDate
                                                                        .toString()),
                                                              ),
                                                              const SizedBox(
                                                                width: 2.0,
                                                              ),
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
                                                                child: Text(isvalue
                                                                    ? filterdata![
                                                                            index]
                                                                        .vehicleStatusTime
                                                                        .toString()
                                                                    : traveldata![
                                                                            index]
                                                                        .vehicleStatusTime
                                                                        .toString()),
                                                              ),
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
                                    },
                                  );
                                },
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

  onSearchTextChanged(value) async {
    if (searhcontroller.text.isEmpty) {
      setState(() {
        isSelected = false;
      });
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
          fromdata: fromDateController ?? fromdate,
          fromtime: fromTimeController ?? fromtime,
          todate: toDateController ?? todate,
          totime: toTimeController ?? searchtotime,
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
