import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';

import '../../model/report/over_speed_report_response.dart';

class OverSpeedReportScreen extends StatefulWidget {
  const OverSpeedReportScreen({Key? key}) : super(key: key);

  @override
  _OverSpeedReportScreenState createState() => _OverSpeedReportScreenState();
}

class _OverSpeedReportScreenState extends State<OverSpeedReportScreen> {
  final controller = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late bool isSearch = false;
  bool isvalue = false;

  bool isSelected = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber = 1;
  int pageSize = 10;
  late String srNo = "";
  late String vehicleRegNo = "";
  late String imeino = "", branchName = "", userType = "";
  int pagenumber = 1;
  int pagesize = 10;
  String fromdata = "01-sep-2022";
  String arainonarai = "arai";
  String todate = "30-sep-2022";
  String fromtime = "06:30";
  String totime = "18:00";
  String searchtotime = "15:30";
  String vehiclelist = "86,76";
  String searchfromtime = "10:30";
  late SharedPreferences sharedPreferences;
  late String token = "";
  late int branchid = 0, vendorid = 0;
  List<OverSpeeddDetail>? overspeedlist = [];
  List<OverSpeeddSearchDetail>? overspeedsearchlist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: CustomAppBar()
          .getCustomAppBar("OVER SPEED REPORT", _scaffoldKey, 2, context),
      body: _vehicleMaster(),
    );
  }

  @override
  void initState() {
    getdata();
    super.initState();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        print("Scroll ${pagenumber}");
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
    } else {
      print("null");
    }
  }

  getallbranch() {
    _mainBloc.add(getOverSpeedEvents(
        token: token,
        vendorid: vendorid,
        branchid: branchid,
        arainonarai: arainonarai,
        fromdata: fromdata,
        fromtime: fromtime,
        todate: todate,
        pagesize: pagesize,
        pagenumber: pagenumber));
  }

  _vehicleMaster() {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        //! Overspeed all Data is fetching--------------------
        if (state is GetOverSpeedCreateDetailLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is GetOverSpeedCreateDetailLoadedState) {
          if (state.getOverspeedREportResponse.overspeeddetail != null) {
            print("overspeed data is printed!!");

            overspeedlist!
                .addAll(state.getOverspeedREportResponse.overspeeddetail!);
            overspeedlist!.forEach((element) {
              print("Overspeed element is Printed");
            });
          } else {
            print("Something went worong in  data");
          }
        } else if (state is GetOverSpeedCreateDetailErrorState) {
          print("Something went Wrong  data");
        }
        //! Overspeed search Data is fetching------------------
        if (state is SearchOverSpeedCreateLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is SearchOverSpeedCreateLoadedState) {
          if (state.searchOverSpeedCreateResponse.oversearchspeeddetail !=
              null) {
            print("Overspeed search data is printed");
            overspeedsearchlist!.addAll(
                state.searchOverSpeedCreateResponse.oversearchspeeddetail!);
          } else {
            print("Something went wrong in search data");
          }
        } else if (state is SearchOverSpeedCreateErrorState) {
          print("Error is their in Overspeed Search data");
        }
      },
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: [
            Container(
                decoration:
                    const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(blurRadius: 2, color: MyColors.shadowGreyColorCode)
                ]),
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 6.0, left: 15, right: 15, bottom: 6),
                      decoration: const BoxDecoration(
                          color: MyColors.greyDividerColorCode,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(
                        children: const [
                          Icon(Icons.file_copy_outlined),
                          Text("Export"),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        String? transtime;
                        String? distancetravel;
                        String? overspeed;
                        String? speed;
                        String? imeino;
                        overspeedlist!.forEach((element) {
                          transtime = element.transTime;
                          distancetravel = element.distancetravel;
                          overspeed = element.overSpeed;
                          speed = element.speed;
                          imeino = element.imeino;
                        });
                        var status = await Permission.storage.status;
                        if (await Permission.storage.request().isGranted) {
                          final pdfFile = await PdfInvoiceApi.generate(
                              transtime.toString(),
                              speed.toString(),
                              overspeed.toString(),
                              distancetravel.toString(),
                              imeino.toString());
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
                                  color: MyColors.analyticActiveColorCode),
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
                  TextField(
                      controller: searchController,
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
                        hintText: "Search By...",
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24,
                          color: MyColors.text3greyColorCode,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 18, color: MyColors.searchTextColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      onChanged: onSearchTextChanged),
                  BlocBuilder<MainBloc, MainState>(
                    builder: (context, state) {
                      return Text(
                        "${overspeedlist!.length} RECORDS",
                        //!isSearch ? allVehicleDetaildatalist!.length!=0 ?  "${allVehicleDetaildatalist!.length} RECORDS" : "0 RECORDS" : searchData!.length!=0 ?  "${searchData!.length} RECORDS" :"0 RECORDS",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        color: MyColors.bluereportColorCode,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Speed Limit",
                                        style: TextStyle(fontSize: 18)),
                                    Text("50", style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              // TextSpan(text: 'Group By(MH12FG4567) Total : 3.5 '),
                              TextSpan(
                                text: 'Group By(MH12FG4567) Total :',
                                style: TextStyle(fontSize: 18),
                              ),
                              // TextSpan(text: 'km'),
                              TextSpan(
                                text: ' 3.5 km',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              // TextSpan(text: 'Group By(MH12FG4567) Total : 3.5 '),
                              TextSpan(
                                text: 'Group By(09/03/2022) Total :',
                                style: TextStyle(fontSize: 18),
                              ),
                              // TextSpan(text: 'km'),
                              TextSpan(
                                text: ' 3.5 km',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      ]),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              // TextSpan(text: 'Group By(MH12FG4567) Total : 3.5 '),
                              TextSpan(
                                text: 'Total Over Speed Distance Travel :',
                                style: TextStyle(fontSize: 18),
                              ),
                              // TextSpan(text: 'km'),
                              TextSpan(
                                text: ' 3.5 km',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      ]
                      // children: [
                      //   Text("Group By(MH12FG4567) Total : 3.5 km",style: TextStyle(fontSize: 18),),
                      //   Padding(
                      //     padding: const EdgeInsets.only(top:8.0,bottom: 8),
                      //     child: Text("Group By(09/03/2022) Total : 3.5 km",style: TextStyle(fontSize: 18)),
                      //   ),
                      //   Text("Total Over Speed Distance Travel : 3.5 km",style: TextStyle(fontSize: 18))
                      //   /*Row(
                      //    children: [
                      //      Text("Group By(MH12FG4567) Total : 3.5 km")
                      //    ],
                      //  )*/
                      // ],
                      ),
                  isSelected
                      ? overspeedsearchlist!.isEmpty
                          ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: 350.0,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  controller: vehicleRecordController,
                                  itemCount: overspeedlist!.length,
                                  itemBuilder: (context, index) {
                                    var article = overspeedlist![index];

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
                                        padding: const EdgeInsets.only(
                                            top: 15,
                                            left: 14,
                                            right: 14,
                                            bottom: 15),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: const BoxDecoration(
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
                                                          children: const [
                                                            Text(
                                                              "Sr.No",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              "1",
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
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "IMEI NO",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .textprofiledetailColorCode,
                                                                fontSize: 18),
                                                          ),
                                                          Text(
                                                            article.imeino
                                                                .toString(),
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
                                                              "Trans Time",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.transTime
                                                                  .toString(),
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
                                                            article.speed
                                                                .toString(),
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
                                                              "Overspeed kmph",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.overSpeed
                                                                  .toString(),
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
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Distance Travel",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .textprofiledetailColorCode,
                                                                fontSize: 18),
                                                          ),
                                                          Text(
                                                            article
                                                                .distancetravel
                                                                .toString(),
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
                                                            const Text(
                                                              "Lattitude",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.latitude
                                                                  .toString(),
                                                              style: const TextStyle(
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
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          const Text(
                                                            "Longitude",
                                                            style: TextStyle(
                                                                color: MyColors
                                                                    .textprofiledetailColorCode,
                                                                fontSize: 18),
                                                          ),
                                                          Text(
                                                            article.longitude
                                                                .toString(),
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
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
                                                            const Text(
                                                              "Address",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.address
                                                                  .toString(),
                                                              style: const TextStyle(
                                                                  color: MyColors
                                                                      .text5ColorCode,
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
                                  }),
                            )
                      : BlocBuilder<MainBloc, MainState>(
                          builder: (context, state) {
                            return Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    controller: vehicleRecordController,
                                    itemCount: overspeedlist!.length,
                                    itemBuilder: (context, index) {
                                      var article = overspeedlist![index];

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
                                          padding: const EdgeInsets.only(
                                              top: 15,
                                              left: 14,
                                              right: 14,
                                              bottom: 15),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: const BoxDecoration(
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
                                                            children: const [
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
                                                              "IMEI NO",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.imeino
                                                                  .toString(),
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
                                                                "Trans Time",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article
                                                                    .transTime
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
                                                              "Speed",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.speed
                                                                  .toString(),
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
                                                                "Overspeed kmph",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article
                                                                    .overSpeed
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
                                                              "Distance Travel",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article
                                                                  .distancetravel
                                                                  .toString(),
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
                                                                "Lattitude",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article.latitude
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
                                                              "Longitude",
                                                              style: TextStyle(
                                                                  color: MyColors
                                                                      .textprofiledetailColorCode,
                                                                  fontSize: 18),
                                                            ),
                                                            Text(
                                                              article.longitude
                                                                  .toString(),
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
                                                              const Text(
                                                                "Address",
                                                                style: TextStyle(
                                                                    color: MyColors
                                                                        .textprofiledetailColorCode,
                                                                    fontSize:
                                                                        18),
                                                              ),
                                                              Text(
                                                                article.address
                                                                    .toString(),
                                                                style: const TextStyle(
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
                                    }));
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
      _mainBloc.add(SearchOverSpeedCreateEvents(
          token: token,
          vendorid: vendorid,
          branchid: branchid,
          arainonarai: arainonarai,
          fromdata: fromdata,
          fromtime: fromtime,
          todate: todate,
          pagesize: pageSize,
          pagenumber: pageNumber,
          searchText: "MH12"));
    }
  }
}

class PdfInvoiceApi {
  static Future<File> generate(String transtime, String speed, String overspeed,
      String distancetravel, String imeino) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a5,
      build: (context) {
        return pw.Column(children: [
          pw.Center(
              child: pw.Text("OVER SPEED REPORT",
                  style: pw.TextStyle(
                      fontSize: 20.0, fontWeight: pw.FontWeight.bold))),
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 10.0),
            child: pw.Table(
              children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding:
                        pw.EdgeInsets.only(top: 8.0, bottom: 8.0, left: 2.0),
                    child: pw.Text(
                      "Transtime",
                      style: pw.TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: pw.Text(
                      "Speed",
                      style: pw.TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: pw.Text(
                      "Overspeed",
                      style: pw.TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: pw.Text(
                      "DistanceTime",
                      style: pw.TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding:
                        pw.EdgeInsets.only(left: 5.0, top: 8.0, bottom: 8.0),
                    child: pw.Text(
                      "IMEINO",
                      style: pw.TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ])
              ],
            ),
          ),
          pw.Expanded(
              child: pw.ListView.builder(
                  itemBuilder: (pw.Context context, int index) {
                    return pw.Table(
                        border: pw.TableBorder.all(
                            color: PdfColors.black, width: 0.8),
                        children: [
                          pw.TableRow(children: [
                            pw.SizedBox(
                              width: 3.0,
                            ),
                            pw.Text(transtime),
                            pw.SizedBox(
                              width: 3.0,
                            ),
                            pw.Text(speed),
                            pw.SizedBox(
                              width: 3.0,
                            ),
                            pw.Text(overspeed),
                            pw.SizedBox(
                              width: 3.0,
                            ),
                            pw.Text(distancetravel),
                            pw.SizedBox(
                              width: 3.0,
                            ),
                            pw.Text(imeino),
                            pw.SizedBox(
                              width: 3.0,
                            ),
                          ])
                        ]);
                  },
                  itemCount: overspeed.length))
        ]);
      },
    ));

    return PdfApi.saveDocument(name: 'OverSpeedReport.pdf', pdf: pdf);
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
