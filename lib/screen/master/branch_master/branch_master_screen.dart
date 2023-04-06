import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/branch/all_branch_master_response.dart';
import 'package:flutter_vts/screen/master/branch_master/add_branch_master/add_branch_master_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/branch/search_branch_response.dart';

class BranchMasterScreen extends StatefulWidget {
  const BranchMasterScreen({Key? key}) : super(key: key);

  @override
  _BranchMasterScreenState createState() => _BranchMasterScreenState();
}

class _BranchMasterScreenState extends State<BranchMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController branchRecordController = new ScrollController();
  ScrollController branchScrollController = new ScrollController();
  TextEditingController searchController = new TextEditingController();
  late MainBloc _mainBloc;
  late SharedPreferences sharedPreferences;
  late int vendorid = 0;
  int pageNumber = 1;
  int total = 10;
  late bool _isLoading = false;
  late String token = "";
  List<Datum>? data = [];
  List<Data>? searchData = [];
  late bool isSearch = false;
  int totalBranchRecords = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    getdata();
    branchScrollController.addListener(() {
      if (branchScrollController.position.maxScrollExtent ==
          branchScrollController.offset) {
        if (isSearch) {
        } else {
          setState(() {
            print("Scroll ${pageNumber}");
            getallbranch();
          });
        }
      }
    });
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (sharedPreferences.getInt("VendorId") != null) {
      vendorid = sharedPreferences.getInt("VendorId")!;
    }

    if (token != "" || vendorid != 0) {
      print("not null");
      getallbranch();
    } else {
      print("null");
    }
  }

  getallbranch() {
    _mainBloc.add(AllBranchMasterEvents(
        token: token,
        vendorId: vendorid,
        pagenumber: pageNumber,
        pagesize: total));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer() /*.getMenuDrawer(context)*/,
      appBar: CustomAppBar()
          .getCustomAppBar("BRANCH MASTER", _scaffoldKey, 0, context),
      body: _branchMaster(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.buttonColorCode,
        onPressed: () async {
          // if(data.length!=0){
          setState(() {
            pageNumber = 1;
          });
          await Navigator.of(context)
              .push(
            new MaterialPageRoute(
                builder: (_) => BlocProvider(
                    create: (context) {
                      return MainBloc(webService: WebService());
                    },
                    child: AddBranchMasterScreen(
                      flag: 1,
                      searchText: false,
                      datum: data!.length == 0 ? Datum() : data![0],
                      searchData: Data(),
                    ))),
          )
              .then((val) {
            if (val != null) {
              if (val) {
                data!.clear();
                getallbranch();
              }
            }

            return false;
          });
        },
        child: Icon(
          Icons.add,
          color: MyColors.whiteColorCode,
        ),
      ),
    );
  }

  _branchMaster() {
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
          if (state is AllBranchMasterLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is AllBranchMasterLoadedState) {
            setState(() {
              _isLoading = false;
              totalBranchRecords = state.allBranchMasterResponse.totalRecords!;
              pageNumber++;
              if (state.allBranchMasterResponse.data != null) {
                data!.addAll(state.allBranchMasterResponse.data!);
              }
            });
          } else if (state is AllBranchMasterErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something Went Wrong,Please try again",
            );
          } else if (state is SearchBranchLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is SearchBranchLoadedState) {
            searchData!.clear();
            setState(() {
              _isLoading = false;
            });
            if (state.searchBranchResponse.data != null) {
              searchData!.addAll(state.searchBranchResponse.data!);
            }
          } else if (state is SearchBranchErrorState) {
            setState(() {
              _isLoading = false;
            });
            /* Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something Went Wrong,Please try again",
            );*/
          }
        },
        child: SingleChildScrollView(
          controller: branchScrollController,
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
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)),
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
                  // controller: _passwordController,
                  onChanged: (value) {
                    if (searchController.text.isEmpty) {
                      setState(() {
                        isSearch = false;
                      });
                    } else {
                      setState(() {
                        isSearch = true;
                      });
                      _mainBloc.add(SearchBranchEvents(
                          vendorId: vendorid,
                          searchText: searchController.text,
                          token: token));
                    }
                  },
                  obscureText: false,
                ),
                Text(
                  !isSearch
                      ? data!.length != 0
                          ? "Showing 1 to ${data!.length} Out of ${totalBranchRecords}"
                          : "0 RECORDS"
                      : searchData!.length != 0
                          ? "Showing 1 to ${searchData!.length} Out of ${totalBranchRecords}"
                          : "0 RECORDS",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                !isSearch
                    ? data!.length == 0
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: ListView.builder(
                                controller: branchRecordController,
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
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                child: Icon(
                                                  Icons.circle,
                                                  size: 10,
                                                  color: data![index]
                                                              .acStatus ==
                                                          'Active'
                                                      ? MyColors.greenColorCode
                                                      : MyColors.redColorCode,
                                                ),
                                              ),
                                              Expanded(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  data![index].acStatus ==
                                                          'Active'
                                                      ? "Active"
                                                      : "Inactive",
                                                  style: TextStyle(
                                                      color: data![index]
                                                                  .acStatus ==
                                                              'Active'
                                                          ? MyColors
                                                              .greenColorCode
                                                          : MyColors
                                                              .redColorCode,
                                                      fontSize: 20),
                                                ),
                                              )),
                                              GestureDetector(
                                                onTap: () async {
                                                  /*  Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(webService: WebService());
                                                    },
                                                    child: AddBranchMasterScreen(flag: 2,searchText:false,datum: data![index],searchData: Data(),)
                                                )

                                            ));*/

                                                  setState(() {
                                                    pageNumber = 1;
                                                  });
                                                  await Navigator.of(context)
                                                      .push(
                                                    new MaterialPageRoute(
                                                        builder: (_) =>
                                                            BlocProvider(
                                                                create:
                                                                    (context) {
                                                                  return MainBloc(
                                                                      webService:
                                                                          WebService());
                                                                },
                                                                child:
                                                                    AddBranchMasterScreen(
                                                                  flag: 2,
                                                                  searchText:
                                                                      false,
                                                                  datum: data![
                                                                      index],
                                                                  searchData:
                                                                      Data(),
                                                                ))),
                                                  )
                                                      .then((val) {
                                                    if (val != null) {
                                                      if (val) {
                                                        data!.clear();
                                                        getallbranch();
                                                      }
                                                    }

                                                    return false;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 6,
                                                      bottom: 6),
                                                  decoration: BoxDecoration(
                                                      color: MyColors
                                                          .notificationblueColorCode,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Text(
                                                    "EDIT",
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        color: MyColors
                                                            .appDefaultColorCode,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                              ),
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
                                                        "Sr.No",
                                                        style: TextStyle(
                                                            color: MyColors
                                                                .textprofiledetailColorCode,
                                                            fontSize: 18),
                                                      ),
                                                      Text(
                                                        data![index].srNo != 0
                                                            ? data![index]
                                                                .srNo
                                                                .toString()
                                                            : "0",
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
                                                      "Branch Code",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      data![index].branchCode !=
                                                              null
                                                          ? data![index]
                                                              .branchCode!
                                                          : "",
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
                                                      "Branch Name",
                                                      style: TextStyle(
                                                          color: MyColors
                                                              .textprofiledetailColorCode,
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      data![index].branchName !=
                                                              null
                                                          ? data![index]
                                                              .branchName!
                                                          : "",
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
                                                    "Vendor Name",
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .textprofiledetailColorCode,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    data![index].vendorName !=
                                                            null
                                                        ? data![index]
                                                            .vendorName!
                                                        : "",
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
                                                top: 15.0, bottom: 15),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Mobile Number",
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .textprofiledetailColorCode,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  data![index].mobileNo != null
                                                      ? data![index].mobileNo!
                                                      : "",
                                                  style: TextStyle(
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
                                  );
                                }),
                          )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView.builder(
                            controller: branchRecordController,
                            shrinkWrap: true,
                            itemCount: searchData!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 15),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: MyColors.textBoxBorderColorCode),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 15, left: 14, right: 14, bottom: 15),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.circle,
                                              size: 10,
                                              color:
                                                  searchData![index].acStatus ==
                                                          'Active'
                                                      ? MyColors.greenColorCode
                                                      : MyColors.redColorCode,
                                            ),
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              searchData![index].acStatus ==
                                                      'Active'
                                                  ? "Active"
                                                  : "Inactive",
                                              style: TextStyle(
                                                  color: searchData![index]
                                                              .acStatus ==
                                                          'Active'
                                                      ? MyColors.greenColorCode
                                                      : MyColors.redColorCode,
                                                  fontSize: 20),
                                            ),
                                          )),
                                          GestureDetector(
                                            onTap: () async {
                                              /*Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(webService: WebService());
                                                    },
                                                    child: AddBranchMasterScreen(flag: 2,searchText:true,datum: data![index],searchData: searchData![index],)
                                                )

                                            ));*/

                                              setState(() {
                                                pageNumber = 1;
                                              });
                                              await Navigator.of(context)
                                                  .push(
                                                new MaterialPageRoute(
                                                    builder: (_) => BlocProvider(
                                                        create: (context) {
                                                          return MainBloc(
                                                              webService:
                                                                  WebService());
                                                        },
                                                        child: AddBranchMasterScreen(
                                                          flag: 2,
                                                          searchText: true,
                                                          datum: data![index],
                                                          searchData:
                                                              searchData![
                                                                  index],
                                                        ))),
                                              )
                                                  .then((val) {
                                                if (val) {
                                                  data!.clear();
                                                  getallbranch();
                                                }
                                                return false;
                                              });
                                            },
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 6,
                                                  bottom: 6),
                                              decoration: BoxDecoration(
                                                  color: MyColors
                                                      .notificationblueColorCode,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                              child: Text(
                                                "EDIT",
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: MyColors
                                                        .appDefaultColorCode,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Sr.No",
                                                    style: TextStyle(
                                                        color: MyColors
                                                            .textprofiledetailColorCode,
                                                        fontSize: 18),
                                                  ),
                                                  Text(
                                                    searchData![index]
                                                                .srNo
                                                                .toString() !=
                                                            null
                                                        ? searchData![index]
                                                            .srNo
                                                            .toString()
                                                        : "",
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
                                                  "Branch Code",
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .textprofiledetailColorCode,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  searchData![index]
                                                              .branchCode !=
                                                          null
                                                      ? searchData![index]
                                                          .branchCode!
                                                      : "",
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
                                                  "Branch Name",
                                                  style: TextStyle(
                                                      color: MyColors
                                                          .textprofiledetailColorCode,
                                                      fontSize: 18),
                                                ),
                                                Text(
                                                  searchData![index]
                                                              .branchName !=
                                                          null
                                                      ? searchData![index]
                                                          .branchName!
                                                      : "",
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
                                                "Vendor Name",
                                                style: TextStyle(
                                                    color: MyColors
                                                        .textprofiledetailColorCode,
                                                    fontSize: 18),
                                              ),
                                              Text(
                                                searchData![index].vendorName !=
                                                        null
                                                    ? searchData![index]
                                                        .vendorName!
                                                    : "",
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                    color:
                                                        MyColors.text5ColorCode,
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0, bottom: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Mobile Number",
                                              style: TextStyle(
                                                  color: MyColors
                                                      .textprofiledetailColorCode,
                                                  fontSize: 18),
                                            ),
                                            Text(
                                              searchData![index].mobileNo !=
                                                      null
                                                  ? searchData![index].mobileNo!
                                                  : "",
                                              style: TextStyle(
                                                  color:
                                                      MyColors.text5ColorCode,
                                                  fontSize: 18),
                                            ),
                                          ],
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
}
