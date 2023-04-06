// import 'package:flutter/material.dart' hide Key;
// import 'package:flutter_vts/bloc/main_event.dart';
// import 'package:flutter_vts/bloc/main_state.dart';
// import 'package:flutter_vts/model/travel_summary/travel_summary.dart';
// import 'package:flutter_vts/model/travel_summary/travel_summary_search.dart';
// import 'package:flutter_vts/util/MyColor.dart';
// import 'package:flutter_vts/util/custom_app_bar.dart';
// import 'package:flutter_vts/util/menu_drawer.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../bloc/main_bloc.dart';
// import '../../model/travel_summary/travel_summary_filter.dart';
// import 'package:jiffy/jiffy.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class TravelSummaryScreen extends StatefulWidget {
//   @override
//   _TravelSummaryScreenState createState() => _TravelSummaryScreenState();
// }

// class _TravelSummaryScreenState extends State<TravelSummaryScreen> {
//   // TextEditingController _fromdatecontroller = new TextEditingController();
//   // TextEditingController _fromTimecontroller = new TextEditingController();
//   // TextEditingController _todatecontroller = new TextEditingController();
//   // TextEditingController _toTimecontroller = new TextEditingController();

//   DateTime selectedDate = DateTime.now();
//   DateTime selectedToDate = DateTime.now();
//   TimeOfDay selectedTime = TimeOfDay.now();
//   TimeOfDay selectedToTime = TimeOfDay.now();
//   DateTime currentdate = DateTime.now();
//   // late String todate = '01/09/2022',
//   //     fromTime = '',
//   //     fromDate = '30/09/2022',
//   //     toTime = '';
//   ScrollController notificationController = new ScrollController();
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   bool isSelected = false;
//   bool isvalue = false;
//   final controller = ScrollController();
//   late String token = "";
//   late MainBloc _mainBloc;
//   late SharedPreferences sharedPreferences;
//   TextEditingController searhcontroller = new TextEditingController();
//   late int value = 0;
//   var fromDateController,
//       toDateController,
//       fromTimeController,
//       toTimeController,
//       vehiclenumber;
//   int vendorid = 1;
//   int branchid = 1;
//   int pagenumber = 1;
//   int pagesize = 10;
//   String fromdate = "01-oct-2022";
//   String arainonari = "arai";
//   String todate = "30-oct-2022";
//   String searchtext = "MH12";
//   String fromtime = "06:30";
//   String totime = "18:00";
//   String searchtotime = "15:30";
//   String vehiclelist = "86,76";
//   String searchfromtime = "10:30";
//   List<DatewiseStatusWiseTravelSummaryData>? traveldata = [];
//   List<DatewiseStatusWiseTravelSearch>? searchdata = [];
//   List<DatewiseStatusWiseTravelFilter>? filterdata = [];

//   @override
//   void initState() {
//     super.initState();
//     getdata();
//     setState(() {
//       isvalue = false;
//     });
//     controller.addListener(() {
//       if (controller.position.maxScrollExtent == controller.offset) {
//         setState(() {
//           print("Scroll ${pagenumber}");
//           getdata();
//           getallbranch();
//           getTravelSummaryFilter();
//         });
//       }
//     });
//     _mainBloc = BlocProvider.of(context);
//   }

//   getdata() async {
//     sharedPreferences = await SharedPreferences.getInstance();
//     if (sharedPreferences.getString("auth_token") != null) {
//       token = sharedPreferences.getString("auth_token")!;
//     }
//     if (token != "" || vendorid != 0 || branchid != 0) {
//       print(token);
//       getallbranch();
//       // getTravelSummaryFilter();
//       setState(() {});
//     } else {
//       print("null");
//     }
//   }

//   getallbranch() {
//     _mainBloc.add(TravelSummaryReportEvent(
//         token: token,
//         arainonarai: arainonari,
//         branchid: branchid,
//         fromdata: fromdate,
//         fromtime: fromtime,
//         pagenumber: pagenumber,
//         pagesize: pagesize,
//         todate: todate,
//         totime: totime,
//         vendorid: vendorid));
//   }

//   getTravelSummaryFilter() {
//     _mainBloc.add(TravelSummaryFilterEvent(
//         token: token,
//         vendorid: vendorid,
//         branchid: branchid,
//         arainonarai: arainonari,
//         fromdata: fromdate,
//         fromtime: fromtime,
//         todate: todate,
//         totime: totime,
//         vehiclelist: vehiclelist,
//         pagesize: pagesize,
//         pagenumber: pagenumber));
//   }

 



//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: MenuDrawer(),
//       appBar: CustomAppBar()
//           .getCustomAppBar("TRAVEL SUMMARY", _scaffoldKey, 5, context),
//       body: _vehicleStatus(),
//     );
//   }

//   _vehicleStatus() {
//     return BlocListener<MainBloc, MainState>(
//       listener: (context, state) {
//         //! FilterEvent TravelSummarydata fetching Start from here----------------
//         if (state is TravelSummaryFilterLoadingState) {
//           const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is TravelSummaryFilterLoadedState) {
//           if (state.travelSummaryFilterResponse.datewise != null) {
//             print("Filter data is printed!!");
//             filterdata!.addAll(state.travelSummaryFilterResponse.datewise!);
//           } else {
//             print("Something went worong in Filter data");
//           }
//         } else if (state is TravelSummaryFilterErrorState) {
//           print("Something went Wrong Filter data");
//         }
//         //! SearchEvent TravelSummarydata fetching Start from here----------------
//         if (state is TravelSummarySearchLoadingState) {
//           const Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (state is TravelSummarySearchLoadedState) {
//           if (state.travelSummaryResponse.datewise != null) {
//             print("Search data is printed!!");
//             searchdata!.addAll(state.travelSummaryResponse.datewise!);
//           } else {
//             print("Something is going wrong in Search data");
//           }
//         } else if (state is TravelSummaryErrorState) {
//           print("Something went Wrong search data");
//         }

//         //! All TravelSummarydata fetching Start from here----------------
//         if (state is TravelSummaryReportLoadingState) {
//           const Center(child: CircularProgressIndicator());
//         } else if (state is TravelSummaryReportLoadedState) {
//           setState(() {
//             if (state.TravelSummaryResponse.datewise != null) {
//               print("All travel Summary data is printed!!");
//               traveldata!.addAll(state.TravelSummaryResponse.datewise!);
//             } else {
//               print("Something is going wrong");
//             }
//           });
//         } else if (state is TravelSummaryErrorState) {
//           print("Something went Wrong");
//         }
//       },
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.only(
//                   left: 10, right: 10, top: 10, bottom: 10),
//               decoration: const BoxDecoration(
//                   color: MyColors.lightgreyColorCode,
//                   boxShadow: [
//                     BoxShadow(
//                         blurRadius: 2, color: MyColors.shadowGreyColorCode)
//                   ]),
//               // width: MediaQuery.of(context).size.width,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     children: [
//                       // Text(_fromdatecontroller.text.isEmpty
//                       //     ? fromdate.toLowerCase()
//                       //     : _fromdatecontroller.text.toLowerCase()),
//                       Text(isvalue ? fromDateController.toString() :fromdate),

//                       Text(isvalue ? fromTimeController.toString() :fromtime),
//                     ],
//                   ),
//                   const Text("-"),
//                   Column(
//                     children: [
//                       // Text(_todatecontroller.text.isEmpty
//                       //     ? todate
//                       //     : _todatecontroller.text),
//                       Text(isvalue ? toDateController.toString() :todate),
//                       Text(isvalue ? toTimeController.toString() :totime),
//                     ],
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       changeDatepopUp(context);
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.only(
//                           left: 20, right: 20, top: 10, bottom: 10),
//                       decoration: const BoxDecoration(
//                           color: MyColors.greyColorCode,
//                           borderRadius: BorderRadius.all(Radius.circular(20))),
//                       child: const Text(
//                         "Change",
//                         style: TextStyle(
//                             color: MyColors.text4ColorCode, fontSize: 18),
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(
//                   top: 10.0, left: 15, right: 15, bottom: 10),
//               child: Column(
//                 children: [
//                   TextField(
//                     enabled: true,
//                     controller: searhcontroller,
//                     onChanged: onSearchTextChanged,
//                     // to trigger disabledBorder
//                     decoration: const InputDecoration(
//                       filled: true,
//                       fillColor: MyColors.whiteColorCode,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(4)),
//                         borderSide: BorderSide(
//                             width: 1, color: MyColors.buttonColorCode),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(4)),
//                         borderSide: BorderSide(width: 1, color: Colors.orange),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(4)),
//                         borderSide:
//                             BorderSide(width: 1, color: MyColors.textColorCode),
//                       ),
//                       border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(4)),
//                           borderSide: BorderSide(
//                             width: 1,
//                           )),
//                       errorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(4)),
//                           borderSide: BorderSide(
//                               width: 1,
//                               color: MyColors.textBoxBorderColorCode)),
//                       focusedErrorBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(4)),
//                           borderSide: BorderSide(
//                               width: 2, color: MyColors.buttonColorCode)),
//                       hintText: "Enter Vehicle Number",
//                       prefixIcon: Icon(
//                         Icons.search,
//                         size: 24,
//                         color: Colors.black,
//                       ),
//                       hintStyle: TextStyle(
//                           fontSize: 18, color: MyColors.searchTextColorCode),
//                       errorText: "",
//                     ),

//                     obscureText: false,
//                   ),
//                   isSelected
//                       ? searchdata!.isEmpty
//                           ? Center(
//                               child: Text("Data is Loading..."),
//                             )
//                           : SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.7,
//                               width: 350.0,
//                               child: ListView.builder(
//                                 controller: notificationController,
//                                 itemCount: searchdata!.length,
//                                 shrinkWrap: true,
//                                 physics: const ScrollPhysics(),
//                                 itemBuilder: (BuildContext context, int index) {
//                                   var article = searchdata![index];
//                                   return Card(
//                                     shape: RoundedRectangleBorder(
//                                       side: const BorderSide(
//                                           width: 1,
//                                           color:
//                                               MyColors.textBoxBorderColorCode),
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     child: Container(
//                                       padding: const EdgeInsets.only(
//                                           top: 10,
//                                           left: 14,
//                                           right: 14,
//                                           bottom: 10),
//                                       width: MediaQuery.of(context).size.width,
//                                       decoration: const BoxDecoration(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10)),
//                                       ),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               Container(
//                                                 padding: EdgeInsets.all(10),
//                                                 decoration: BoxDecoration(
//                                                   color:
//                                                       MyColors.whiteColorCode,
//                                                   border: Border.all(
//                                                       color: MyColors
//                                                           .boxBackgroundColorCode),
//                                                   borderRadius:
//                                                       const BorderRadius.all(
//                                                           Radius.circular(10)),
//                                                 ),
//                                                 child: Image.asset(
//                                                   "assets/driving_pin.png",
//                                                   width: 40,
//                                                   height: 40,
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsets.only(
//                                                           left: 10.0),
//                                                   child: Column(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment.start,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       Text(
//                                                         article.vehicleregNo
//                                                             .toString(),
//                                                         style: const TextStyle(
//                                                             fontWeight:
//                                                                 FontWeight.bold,
//                                                             fontSize: 20),
//                                                       ),
//                                                       Text(
//                                                         article.imei.toString(),
//                                                         style: const TextStyle(
//                                                             fontSize: 16,
//                                                             color: MyColors
//                                                                 .analyticGreenColorCode),
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           const Icon(
//                                                             Icons.circle,
//                                                             color: MyColors
//                                                                 .analyticGreenColorCode,
//                                                             size: 7,
//                                                           ),
//                                                           Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 4.0,
//                                                                     top: 6,
//                                                                     bottom: 6),
//                                                             child: Text(
//                                                               article
//                                                                   .vehicleStatus
//                                                                   .toString(),
//                                                               style: const TextStyle(
//                                                                   color: MyColors
//                                                                       .analyticGreenColorCode,
//                                                                   fontSize: 16),
//                                                             ),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Row(
//                                                         children: [
//                                                           Container(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 8.0,
//                                                                     right: 8,
//                                                                     top: 8,
//                                                                     bottom: 8),
//                                                             decoration:
//                                                                 const BoxDecoration(
//                                                               color: MyColors
//                                                                   .textBoxColorCode,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .all(Radius
//                                                                           .circular(
//                                                                               8)),
//                                                             ),
//                                                             child: Text(article
//                                                                 .tDate
//                                                                 .toString()),
//                                                           ),
//                                                           const SizedBox(
//                                                             width: 2.0,
//                                                           ),
//                                                           Container(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     left: 8.0,
//                                                                     right: 8,
//                                                                     top: 8,
//                                                                     bottom: 8),
//                                                             decoration:
//                                                                 const BoxDecoration(
//                                                               color: MyColors
//                                                                   .textBoxColorCode,
//                                                               borderRadius:
//                                                                   BorderRadius
//                                                                       .all(Radius
//                                                                           .circular(
//                                                                               8)),
//                                                             ),
//                                                             child: Text(article
//                                                                 .vehicleStatusTime
//                                                                 .toString()),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             )
//                       : traveldata!.length == 0
//                           ? Center(
//                               child: Text("Data is Loading..."),
//                             )
//                           : BlocBuilder<MainBloc, MainState>(
//                               builder: (context, state) {
//                                 return ListView.builder(
//                                   controller: notificationController,
//                                   shrinkWrap: true,
//                                   itemCount: isvalue
//                                       ? filterdata!.length
//                                       : traveldata!.length,
//                                   itemBuilder: (context, index) {
//                                     // var article = traveldata![index];
//                                     // var filterarticle = filterdata![index];
//                                     return Card(
//                                       shape: RoundedRectangleBorder(
//                                         side: const BorderSide(
//                                             width: 1,
//                                             color: MyColors
//                                                 .textBoxBorderColorCode),
//                                         borderRadius:
//                                             BorderRadius.circular(10.0),
//                                       ),
//                                       child: Container(
//                                         padding: const EdgeInsets.only(
//                                             top: 10,
//                                             left: 14,
//                                             right: 14,
//                                             bottom: 10),
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         decoration: const BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(10)),
//                                         ),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: [
//                                                 Container(
//                                                   padding: EdgeInsets.all(10),
//                                                   decoration: BoxDecoration(
//                                                     color:
//                                                         MyColors.whiteColorCode,
//                                                     border: Border.all(
//                                                         color: MyColors
//                                                             .boxBackgroundColorCode),
//                                                     borderRadius:
//                                                         const BorderRadius.all(
//                                                             Radius.circular(
//                                                                 10)),
//                                                   ),
//                                                   child: Image.asset(
//                                                     "assets/driving_pin.png",
//                                                     width: 40,
//                                                     height: 40,
//                                                   ),
//                                                 ),
//                                                 Expanded(
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             left: 10.0),
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           isvalue
//                                                               ? filterdata![
//                                                                       index]
//                                                                   .vehicleregNo
//                                                                   .toString()
//                                                               : traveldata![
//                                                                       index]
//                                                                   .vehicleregNo
//                                                                   .toString(),
//                                                           style:
//                                                               const TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   fontSize: 20),
//                                                         ),
//                                                         Text(
//                                                           isvalue
//                                                               ? filterdata![
//                                                                       index]
//                                                                   .imei
//                                                                   .toString()
//                                                               : traveldata![
//                                                                       index]
//                                                                   .imei
//                                                                   .toString(),
//                                                           style: const TextStyle(
//                                                               fontSize: 16,
//                                                               color: MyColors
//                                                                   .analyticGreenColorCode),
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             const Icon(
//                                                               Icons.circle,
//                                                               color: MyColors
//                                                                   .analyticGreenColorCode,
//                                                               size: 7,
//                                                             ),
//                                                             Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       left: 4.0,
//                                                                       top: 6,
//                                                                       bottom:
//                                                                           6),
//                                                               child: Text(
//                                                                 isvalue
//                                                                     ? filterdata![
//                                                                             index]
//                                                                         .vehicleStatus
//                                                                         .toString()
//                                                                     : traveldata![
//                                                                             index]
//                                                                         .vehicleStatus
//                                                                         .toString(),
//                                                                 style: const TextStyle(
//                                                                     color: MyColors
//                                                                         .analyticGreenColorCode,
//                                                                     fontSize:
//                                                                         16),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Container(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       left: 8.0,
//                                                                       right: 8,
//                                                                       top: 8,
//                                                                       bottom:
//                                                                           8),
//                                                               decoration:
//                                                                   const BoxDecoration(
//                                                                 color: MyColors
//                                                                     .textBoxColorCode,
//                                                                 borderRadius: BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             8)),
//                                                               ),
//                                                               child: Text(isvalue
//                                                                   ? filterdata![
//                                                                           index]
//                                                                       .tDate
//                                                                       .toString()
//                                                                   : traveldata![
//                                                                           index]
//                                                                       .tDate
//                                                                       .toString()),
//                                                             ),
//                                                             const SizedBox(
//                                                               width: 2.0,
//                                                             ),
//                                                             Container(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       left: 8.0,
//                                                                       right: 8,
//                                                                       top: 8,
//                                                                       bottom:
//                                                                           8),
//                                                               decoration:
//                                                                   const BoxDecoration(
//                                                                 color: MyColors
//                                                                     .textBoxColorCode,
//                                                                 borderRadius: BorderRadius
//                                                                     .all(Radius
//                                                                         .circular(
//                                                                             8)),
//                                                               ),
//                                                               child: Text(isvalue
//                                                                   ? filterdata![
//                                                                           index]
//                                                                       .vehicleStatusTime
//                                                                       .toString()
//                                                                   : traveldata![
//                                                                           index]
//                                                                       .vehicleStatusTime
//                                                                       .toString()),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 );
//                               },
//                             )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   onSearchTextChanged(String text) async {
//     if (text.isEmpty) {
//       setState(() {
//         isSelected = false;
//       });
//       return;
//     } else {
//       setState(() {
//         isSelected = true;
//       });
//       _mainBloc.add(TravelSummarySearchEvent(
//           token: token,
//           vendorid: vendorid,
//           branchid: branchid,
//           arainonarai: arainonari,
//           searchtext: searhcontroller.text,
//           fromdata: fromdate,
//           fromtime: searchfromtime,
//           todate: todate,
//           totime: searchtotime,
//           pagesize: pagesize,
//           pagenumber: pagenumber));
//     }
//     // traveldata!.forEach((userDetail) {
//     //   if (userDetail.vehicleregNo!.contains(text)) searchdata!.add(userDetail);
//     // });
//   }

//   changeDatepopUp(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0)), //this right here
//             child: Container(
//               height: 310,
//               width: MediaQuery.of(context).size.width - 20,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Padding(
//                       padding: const EdgeInsets.only(top: 2.0, bottom: 10),
//                       child: Text(
//                         "From Date/Time",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                     ),
//                     Row(
//                       // ignore: prefer_const_literals_to_create_immutables
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: TextField(
//                             // controller: _fromdatecontroller,
//                             onChanged: (value) {
//                               fromDateController = value;
//                             },
//                             enabled: true,
//                             decoration: const InputDecoration(
//                               filled: true,
//                               fillColor: MyColors.whiteColorCode,
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4)),
//                                 borderSide: BorderSide(
//                                     width: 1, color: MyColors.buttonColorCode),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4)),
//                                 borderSide:
//                                     BorderSide(width: 1, color: Colors.orange),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4)),
//                                 borderSide: BorderSide(
//                                     width: 1, color: MyColors.textColorCode),
//                               ),
//                               border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                     width: 1,
//                                   )),
//                               errorBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1,
//                                       color: MyColors.textBoxBorderColorCode)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 2,
//                                       color: MyColors.buttonColorCode)),
//                               hintText: "DD/MM/YY",
//                               suffixIcon: Icon(
//                                 Icons.calendar_today_outlined,
//                                 size: 24,
//                                 color: MyColors.dateIconColorCode,
//                               ),
//                               hintStyle: TextStyle(
//                                   fontSize: 18,
//                                   color: MyColors.searchTextColorCode),
//                               errorText: "",
//                             ),
//                             // onTap: () {
//                             //   FocusScope.of(context)
//                             //       .requestFocus(new FocusNode());
//                             //   _fromDate(context);
//                             // },
//                             // controller: _passwordController,
//                             // onChanged: _authenticationFormBloc.onPasswordChanged,
//                             obscureText: false,
//                           ),
//                         ),
//                         // ignore: prefer_const_constructors
//                         Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 4.0),
//                             child: TextField(
//                               // controller: fromTimecontroller,
//                               onChanged: (value) {
//                                 fromTimeController = value;
//                               },
//                               enabled: true, // to trigger disabledBorder
//                               decoration: const InputDecoration(
//                                 filled: true,
//                                 fillColor: MyColors.whiteColorCode,
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1,
//                                       color: MyColors.buttonColorCode),
//                                 ),
//                                 disabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1, color: Colors.orange),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1, color: MyColors.textColorCode),
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(4)),
//                                     borderSide: BorderSide(
//                                       width: 1,
//                                     )),
//                                 errorBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(4)),
//                                     borderSide: BorderSide(
//                                         width: 1,
//                                         color:
//                                             MyColors.textBoxBorderColorCode)),
//                                 focusedErrorBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(4)),
//                                     borderSide: BorderSide(
//                                         width: 2,
//                                         color: MyColors.buttonColorCode)),
//                                 hintText: "hh:mm:AM",
//                                 suffixIcon: Icon(
//                                   Icons.watch_later_outlined,
//                                   size: 24,
//                                   color: MyColors.dateIconColorCode,
//                                 ),
//                                 hintStyle: TextStyle(
//                                     fontSize: 18,
//                                     color: MyColors.searchTextColorCode),
//                                 errorText: "",
//                               ),
//                               // onTap: () {
//                               //   FocusScope.of(context)
//                               //       .requestFocus(new FocusNode());
//                               //   _selectTime(context);
//                               // },
//                               // controller: _passwordController,
//                               // onChanged: _authenticationFormBloc.onPasswordChanged,
//                               obscureText: false,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.only(top: 2.0, bottom: 10),
//                       child: Text(
//                         "To Date/Time",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 18),
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 3,
//                           child: TextField(
//                             // controller: _todatecontroller,
//                             onChanged: (value) {
//                               toDateController = value;
//                             },
//                             enabled: true, // to trigger disabledBorder
//                             decoration: const InputDecoration(
//                               filled: true,
//                               fillColor: MyColors.whiteColorCode,
//                               focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4)),
//                                 borderSide: BorderSide(
//                                     width: 1, color: MyColors.buttonColorCode),
//                               ),
//                               disabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4)),
//                                 borderSide:
//                                     BorderSide(width: 1, color: Colors.orange),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(4)),
//                                 borderSide: BorderSide(
//                                     width: 1, color: MyColors.textColorCode),
//                               ),
//                               border: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                     width: 1,
//                                   )),
//                               errorBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1,
//                                       color: MyColors.textBoxBorderColorCode)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 2,
//                                       color: MyColors.buttonColorCode)),
//                               hintText: "DD/MM/YY",
//                               suffixIcon: Icon(
//                                 Icons.calendar_today_outlined,
//                                 size: 24,
//                                 color: MyColors.dateIconColorCode,
//                               ),
//                               hintStyle: TextStyle(
//                                   fontSize: 18,
//                                   color: MyColors.searchTextColorCode),
//                               errorText: "",
//                             ),
//                             // onTap: () {
//                             //   FocusScope.of(context)
//                             //       .requestFocus(new FocusNode());
//                             //   _toDate(context);
//                             // },
//                             // controller: _passwordController,
//                             // onChanged: _authenticationFormBloc.onPasswordChanged,
//                             obscureText: false,
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 4.0),
//                             child: TextField(
//                               // controller: _toTimecontroller,
//                               onChanged: (value) {
//                                 toTimeController = value;
//                               },
//                               enabled: true, // to trigger disabledBorder
//                               decoration: const InputDecoration(
//                                 filled: true,
//                                 fillColor: MyColors.whiteColorCode,
//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1,
//                                       color: MyColors.buttonColorCode),
//                                 ),
//                                 disabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1, color: Colors.orange),
//                                 ),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(4)),
//                                   borderSide: BorderSide(
//                                       width: 1, color: MyColors.textColorCode),
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(4)),
//                                     borderSide: BorderSide(
//                                       width: 1,
//                                     )),
//                                 errorBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(4)),
//                                     borderSide: BorderSide(
//                                         width: 1,
//                                         color:
//                                             MyColors.textBoxBorderColorCode)),
//                                 focusedErrorBorder: OutlineInputBorder(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(4)),
//                                     borderSide: BorderSide(
//                                         width: 2,
//                                         color: MyColors.buttonColorCode)),
//                                 hintText: "hh:mm:AM",
//                                 suffixIcon: Icon(
//                                   Icons.watch_later_outlined,
//                                   size: 24,
//                                   color: MyColors.dateIconColorCode,
//                                 ),
//                                 hintStyle: TextStyle(
//                                     fontSize: 18,
//                                     color: MyColors.searchTextColorCode),
//                                 errorText: "",
//                               ),
//                               // onTap: () {
//                               //   FocusScope.of(context)
//                               //       .requestFocus(new FocusNode());
//                               //   _selectToTime(context);
//                               // },
//                               // controller: _passwordController,
//                               // onChanged: _authenticationFormBloc.onPasswordChanged,
//                               obscureText: false,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 1,
//                           child: GestureDetector(
//                             onTap: () {
//                               // _fromdatecontroller.text = "";
//                               // _toTimecontroller.text = "";
//                               // _fromTimecontroller.text = "";
//                               // _todatecontroller.text = "";
//                               setState(() {
//                                 // searchDateWiseData!.clear();
//                                 // isDateWiseSearch=false;
//                               });
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: const [
//                                 Icon(
//                                   Icons.phonelink_erase_rounded,
//                                   color: MyColors.text4ColorCode,
//                                 ),
//                                 Text("Clear",
//                                     style: TextStyle(
//                                         color: MyColors.text4ColorCode,
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 20)),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 1,
//                           child: GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: const [
//                                 Icon(
//                                   Icons.close,
//                                   color: MyColors.text4ColorCode,
//                                 ),
//                                 Text("Close",
//                                     style: TextStyle(
//                                         color: MyColors.text4ColorCode,
//                                         decoration: TextDecoration.underline,
//                                         fontSize: 20)),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           flex: 2,
//                           child: MaterialButton(
//                             onPressed: () {
                            
//                               _mainBloc.add(TravelSummaryFilterEvent(
//                                   token: token,
//                                   vendorid: vendorid,
//                                   branchid: branchid,
//                                   arainonarai: arainonari,
//                                   fromdata: fromdate,
//                                   fromtime: fromtime,
//                                   todate: todate,
//                                   totime: totime,
//                                   vehiclelist: vehiclelist,
//                                   pagesize: pagesize,
//                                   pagenumber: pagenumber));
//                               setState(() {
//                                 isvalue = true;
//                               });
//                               Navigator.of(context).pop();
//                               // _validation();
//                             },
//                             shape: const RoundedRectangleBorder(
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(10))),
//                             child: const Padding(
//                               padding: EdgeInsets.only(
//                                   left: 8.0, right: 8, top: 8, bottom: 8),
//                               child: Text(
//                                 "Apply",
//                                 style: TextStyle(
//                                     fontSize: 18,
//                                     color: MyColors.whiteColorCode),
//                               ),
//                             ),
//                             color: MyColors.buttonColorCode,
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   // _validation() {
//   //   if (_fromdatecontroller.text.isEmpty) {
//   //     Fluttertoast.showToast(
//   //       msg: "Please Select From Date",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       timeInSecForIosWeb: 1,
//   //     );
//   //   } else if (_fromTimecontroller.text.isEmpty) {
//   //     Fluttertoast.showToast(
//   //       msg: "Please Select From Time",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       timeInSecForIosWeb: 1,
//   //     );
//   //   } else if (_todatecontroller.text.isEmpty) {
//   //     Fluttertoast.showToast(
//   //       msg: "Please Select To Date",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       timeInSecForIosWeb: 1,
//   //     );
//   //   } else if (_toTimecontroller.text.isEmpty) {
//   //     Fluttertoast.showToast(
//   //       msg: "Please Select To Time",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       timeInSecForIosWeb: 1,
//   //     );
//   //   } else if (selectedDate.compareTo(selectedToDate) == 1) {
//   //     Fluttertoast.showToast(
//   //       msg:
//   //           "Please check Start & End date! Start date should be less than to End date...!",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       timeInSecForIosWeb: 1,
//   //     );
//   //   } else if (selectedDate.month != selectedToDate.month) {
//   //     Fluttertoast.showToast(
//   //       msg:
//   //           "Please check Start & End date! Start date and end date Month Will be Same...!",
//   //       toastLength: Toast.LENGTH_SHORT,
//   //       timeInSecForIosWeb: 1,
//   //     );
//   //   } else {
//   //     Navigator.pop(context);
//   //   }
//   // }
// }
