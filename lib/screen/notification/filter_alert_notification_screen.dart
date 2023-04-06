import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert/fill_alert_response.dart';
import 'package:flutter_vts/model/alert/vehicle_fill_srno_response.dart';
import 'package:flutter_vts/model/alert_notification/alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/fill_alert_notification_vehicle_response.dart';
import 'package:flutter_vts/model/alert_notification/filter_notification_alert_type_response.dart';
import 'package:flutter_vts/model/filter/Vendor_response.dart';
import 'package:flutter_vts/model/filter/branch_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model/alert_notification/filter_alert_notification_response.dart';

class FilterAlertNotificationScreen extends StatefulWidget {
  // List<AlertNotificationDatum>? data=[];

  FilterAlertNotificationScreen({Key? key,/*required this.data*/}) : super(key: key);

  @override
  State<FilterAlertNotificationScreen> createState() => _FilterAlertNotificationScreenState();
}

class _FilterAlertNotificationScreenState extends State<FilterAlertNotificationScreen> {
  ScrollController vendorController=new ScrollController();
  ScrollController branchController=new ScrollController();
  ScrollController alertTypeController=new ScrollController();
  ScrollController vehicleController=new ScrollController();

  TextEditingController searchController=new TextEditingController();
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String userName="";
  late bool isSearch = false;
  late bool isapplybtnvisible = false;
  bool activeStatus = false;

  late String vendorName="",branchName="",userType="";
  late SharedPreferences sharedPreferences;
  late String token="";
  late int branchid=0,vendorid=0;
  late int selectedVendorid=0,selectedbranchid=0;
  List<VehicleDatum>  vehicleSrNolist=[];
  // List<VehicleFillSrNoResponse>  selectedvehicleSrNolist=[];
  List<bool> _isvehicleChecked=[];

  List<VendorDatum> vendorList=[];
  List<BranchDatum> branchList=[];
  List<Datum>? filterAlertdataList=[];


  List<AlertTypeDatum> alerttypeList=[];
  // List<FillAlertResponse> selectedalerttypeList=[];

  List<String> alerttypesList=[];
  List<String>  vehicleSrNoslist=[];

  List<int> selectedvehicleSrNolist=[];
  List<String> selectedalerttypeList=[];

  int pageNumber=1;
  int pagesize=10;
  List<bool> _isChecked=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    getdata();
  }

  /*getalertNotification(){
    _mainBloc.add(AlertNotificationEvents(token: token,vendorId: vendorid,branchId:branchid,arai:"nonarai",username:userName,displayStatus:"Y",pagenumber: pageNumber,pagesize: 10));
  }*/


  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
      print("token ${token}");

    }
    if(sharedPreferences.getInt("VendorId")!=null){
      vendorid=sharedPreferences.getInt("VendorId")!;
    }
    if(sharedPreferences.getInt("BranchId")!=null){
      branchid=sharedPreferences.getInt("BranchId")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    if(sharedPreferences.getString("VendorName")!=null){
      vendorName=sharedPreferences.getString("VendorName")!;

    }
    if(sharedPreferences.getString("BranchName")!=null){
      branchName=sharedPreferences.getString("BranchName")!;
    }
    if(sharedPreferences.getString("UserType")!=null){
      userType=sharedPreferences.getString("UserType")!;
    }



    print("branchid ${branchid}   Vendor id   ${vendorid}");

    print(""+vendorid.toString()+" "+branchid.toString()+" "+userName+" "+vendorName+" "+branchName+" "+userType);


    if(token!="" || vendorid!=0 || branchid!=0 ||vendorName!="" || branchName!=""){
      getCompanylist();
      getalertTypeList();
      // getvehiclelist(1);
    }

  }

  applyFilter(){
    if(selectedVendorid==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please Select Company Name...!",
      );
    }else if(selectedbranchid==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please Select Branch Name...!",
      );
    }else if(selectedvehicleSrNolist.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please Select Vehicles...!",
      );
    }else if(selectedalerttypeList.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please Select Alert Type...!",
      );
      if(selectedVendorid==0 && selectedalerttypeList.length==0 && selectedvehicleSrNolist.length==0 ){
        setState(() {
          isapplybtnvisible=true;
        });
      }
    }else{

      print(selectedvehicleSrNolist[0]);
      if(isSearch){
        print(" search");
        _mainBloc.add(SearchFilteralertNotificationEvents(token:token,vendorId:selectedVendorid, branchId: selectedbranchid, araiNoarai: 'nonarai', username: userName,  displayStatus: activeStatus ? 'Y' :'N' ,vehiclesrNo: selectedvehicleSrNolist,alertCode: selectedalerttypeList, searchText: searchController.text,pageNumber:pageNumber ,pageSize:pagesize ));
      }else{
        print("not search");
        _mainBloc.add(FilteralertNotificationEvents(token:token,vendorId:selectedVendorid, branchId: selectedbranchid, araiNoarai: 'nonarai', username: userName,  displayStatus: activeStatus ? 'Y' : 'N',vehiclesrNo: selectedvehicleSrNolist,alertCode: selectedalerttypeList,pageNumber:pageNumber ,pageSize:pagesize ));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.textColorCode,
        title: Text("Filter".toUpperCase(),),
        actions: [
          IconButton(
              onPressed: () {
                /*for(int i=0;i<selectedalerttypeList.length;i++){
                  print(selectedalerttypeList[i].alertIndication);

                }
                for(int i=0;i<selectedvehicleSrNolist.length;i++){
                  print(selectedvehicleSrNolist[i].vehicleRegNo);

                }*/
                Navigator.pop(context);
              },
              icon: const Icon(
                // controller.page == 2
                //?
                Icons.close,
                //  : Icons.help_outline,
                size: 24,
                color: MyColors.whiteColorCode,
              )),
          const SizedBox(
            width: 8.0,
          )
        ],
      ),

      backgroundColor: Colors.white,
      body: _alertNotification()

      // TabBarView(
      //     physics: const NeverScrollableScrollPhysics(),
      //     children: listScreens),
    );
  }


  _alertNotification(){
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, {"FilterAlert":false});
        return false;
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: MyColors.appDefaultColorCode,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child: BlocListener<MainBloc, MainState>(
          listener:(context,state){
            if (state is FilteralertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else  if (state is FilteralertNotificationLoadedState) {
              setState(() {
                _isLoading = false;
              });


              if(state.filterAlertNotificationResponse.succeeded!){
                filterAlertdataList!.addAll(state.filterAlertNotificationResponse.data!);
                Navigator.pop(context,{"FilterAlertDataList":filterAlertdataList,"SearchFilter":false,"FilterPageNumber":2,"SelectedVehicleList":selectedvehicleSrNolist,"SelectedAlertCodeList":selectedalerttypeList,"SelectedVendorId":selectedVendorid,"SelectedBranchId":selectedbranchid});
              }else{
                if(state.filterAlertNotificationResponse.message!=null){
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    msg: state.filterAlertNotificationResponse.message!,
                  );
                }
              }

            }else  if (state is FilteralertNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: "Something Went Wrong,Please try again",
              );
            }else  if (state is SearchFilteralertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else  if (state is SearchFilteralertNotificationLoadedState) {
              setState(() {
                _isLoading = false;
              });
              if(state.filterAlertNotificationResponse.succeeded!){
                filterAlertdataList!.addAll(state.filterAlertNotificationResponse.data!);
                Navigator.pop(context,{"FilterAlertDataList":filterAlertdataList,"SearchText":searchController.text,"SearchFilter":true,"FilterPageNumber":2,"SelectedVehicleList":selectedvehicleSrNolist,"SelectedAlertCodeList":selectedalerttypeList,"SelectedVendorId":selectedVendorid,"SelectedBranchId":selectedbranchid});
              }else{
                if(state.filterAlertNotificationResponse.message!=null){
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    msg: state.filterAlertNotificationResponse.message!,
                  );
                }
              }
            }else  if (state is SearchFilteralertNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0), //left: 8, top: 16.0, right: 8.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  child: const Text("Filter",style: TextStyle(fontSize: 18,color: MyColors.blackColorCode),),
                                  onPressed: () {},
                                ),
                                TextButton(
                                  child: const Text("Clear",style: TextStyle(decoration: TextDecoration.underline,fontSize: 18),),
                                  onPressed: () {

                                    setState(() {
                                      isapplybtnvisible=false;
                                      searchController.text="";
                                      selectedVendorid=0;
                                      selectedbranchid=0;
                                      selectedvehicleSrNolist.clear();
                                      selectedalerttypeList.clear();
                                      _isChecked = List<bool>.filled(alerttypeList.length, false);
                                      _isvehicleChecked = List<bool>.filled(vehicleSrNolist.length, false);


                                    });
                                    // Navigator.pop(context,{"FilterAlert":false});

                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: (){
                              // applyFilter();
                            },
                            child: Container(
                                height: 36,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color:/*isapplybtnvisible ?*/ Colors.blue, /*: MyColors.blueColorCode.withOpacity(0.5)*/),
                                child: TextButton(
                                    child: const Text("Apply",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      // print(selectedalerttypeList.length);
                                      // print(selectedvehicleSrNolist.length);
                                      applyFilter();

                                    })
                            ),
                          ),
                        ],
                      ),
                    ),
                    LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        final boxWidth = constraints.constrainWidth();
                        const dashWidth = 2.0;
                        final dashCount = (boxWidth / (2 * dashWidth)).floor();
                        return Flex(
                          children: List.generate(dashCount, (_) {
                            return const SizedBox(
                              width: dashWidth,
                              height: 1,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Colors.black),
                              ),
                            );
                          }),
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          direction: Axis.horizontal,
                        );
                      },
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller:searchController,
                            validator: (value) {
                              if (value == "") {
                                return "Please Enter Username";
                              }
                            },
                            enabled: true, // to trigger disabledBorder
                            decoration: const InputDecoration(
                              isDense: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey,
                              ),

                              hintText: "Search",

                              fillColor: Color(0xFFF2F2F2),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 1, color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                BorderSide(width: 0.3, color: Colors.grey),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 0.5,
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
                                  borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                              // hintText: "HintText",
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            // onChanged: _authenticationFormBloc.onPasswordChanged,
                            obscureText: false,
                            onChanged: (value){
                              if(searchController.text.isEmpty){
                                setState(() {
                                  isSearch=false;
                                });
                              }else{
                                setState(() {
                                  isSearch=true;
                                });
                              }
                            },
                          ),
                        /*  Align(
                            alignment: Alignment.topRight,
                            child: */Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        value: activeStatus,
                                        onChanged: (checkvalue) {
                                          setState(() {
                                            activeStatus = checkvalue!;
                                            print(checkvalue);
                                          });
                                        }),
                                    Text(
                                      "Read",
                                      // activeStatus ? "Read" : "Unread",
                                      style: TextStyle(
                                          fontSize: 20, color: MyColors.blackColorCode),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Company",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold,fontSize: 22),
                            ),
                          ),
                          ListView.builder(
                            controller: vendorController,
                              shrinkWrap: true,
                              itemCount: vendorList.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      selectedVendorid=vendorList[index].vendorId!;
                                      selectedbranchid=0;
                                      branchList.clear();
                                      getBranchList(vendorList[index].vendorId!);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,top: 4,bottom: 4),
                                    child: Text(vendorList[index].vendorName!,style: TextStyle(fontSize: 18),),
                                  ),
                                );
                          }),
                          // CheckboxListTile(
                          //   title: Text("All"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("M-Tech LTD"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),

                          const SizedBox(
                            height: 16,
                          ),
                          if(branchList.length!=0) const Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Branch",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold,fontSize: 22),
                            ),
                          ),
                          ListView.builder(
                              controller: branchController,
                              shrinkWrap: true,
                              itemCount: branchList.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    print(branchList[index].branchId!);
                                    print(selectedVendorid);
                                    setState(() {
                                      vehicleSrNolist.clear();
                                      selectedbranchid=branchList[index].branchId!;
                                    });
                                    getvehiclelist(branchList[index].branchId!);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,top: 4,bottom: 4),
                                    child: Text(branchList[index].branchName!,style: TextStyle(fontSize: 16),),
                                  ),
                                );
                              }),
                          // CheckboxListTile(
                          //   title: Text("All"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("M-Tech LTD"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          const SizedBox(
                            height: 16,
                          ),
                          if(alerttypeList.length!=0) const Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Alert Type Selection",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold,fontSize: 22),
                            ),
                          ),
                          // CheckboxListTile(
                          //   title: Text("Harsh Breaking"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("Vehicle Inactive"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("Location Updates"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                        /*  ListView.builder(
                              controller: alertTypeController,
                              shrinkWrap: true,
                              itemCount: alerttypeList.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      // selectedVendorid=vendorList[index].vendorId!;
                                      // getBranchList(vendorList[index].vendorId!);
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,top: 4,bottom: 4),
                                    child: Text(alerttypeList[index].alertIndication!,style: TextStyle(fontSize: 16),),
                                  ),
                                );
                              }),*/


                          // ListView.builder(
                          //    itemCount: alerttypeList.length,
                          //    itemBuilder: (context, index) {
                          //      return CheckboxListTile(
                          //        title: Text(alerttypeList[index].alertIndication!),
                          //        value: _isChecked[index],
                          //         onChanged: (val) {
                          //           setState(() {
                          //             _isChecked[index] = val!;
                          //          },
                          //        );
                          //      },
                          //     ),
                          ListView.builder(
                              controller: alertTypeController,
                              shrinkWrap: true,
                              itemCount: alerttypeList.length,
                              itemBuilder: (context,position){
                                return CheckboxListTile(
                                    title: Text(alerttypeList[position].alertIndication!),
                                    value: _isChecked[position],
                                    onChanged: (val){
                                      setState(() {
                                        _isChecked[position]=val!;
                                        if(_isChecked[position]){
                                          selectedalerttypeList.add(alerttypeList[position].alertCode!);
                                          // selectedalerttypeList.add(alerttypeList[position]);

                                        }else{
                                          selectedalerttypeList.removeWhere((item) => item == alerttypeList[position].alertCode!);

                                          // selectedalerttypeList.removeWhere((item) => item.alertIndication == alerttypeList[position].alertIndication);

                                        }

                                      });
                                    });
                              }
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          if(vehicleSrNolist.length!=0) const Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Vehicle",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold,fontSize: 22),
                            ),
                          ),
                          /*ListView.builder(
                              controller: vehicleController,
                              shrinkWrap: true,
                              itemCount: vehicleSrNolist.length,
                              itemBuilder: (context,index){
                                return GestureDetector(
                                  onTap: (){
                                    setState(() {
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10.0,top: 4,bottom: 4),
                                    child: Text(vehicleSrNolist[index].vehicleRegNo!,style: TextStyle(fontSize: 16),),
                                  ),
                                );
                              }),*/
                          ListView.builder(
                              controller: vehicleController,
                              shrinkWrap: true,
                              itemCount: vehicleSrNolist.length/*vehicleSrNoslist.length*/,
                              itemBuilder: (context,position){
                                return CheckboxListTile(
                                    title: Text(vehicleSrNolist[position].vehicleRegNo!),
                                    value: _isvehicleChecked[position],
                                    onChanged: (val){
                                      setState(() {
                                        _isvehicleChecked[position]=val!;
                                        if(_isvehicleChecked[position]){
                                          print(vehicleSrNolist[position].vsrNo!);

                                          selectedvehicleSrNolist.add(vehicleSrNolist[position].vsrNo!);
                                          // selectedvehicleSrNolist.add(vehicleSrNolist[position]);

                                        }else{
                                          // selectedvehicleSrNolist.removeAt(position);
                                          selectedvehicleSrNolist.removeWhere((item) => item == vehicleSrNolist[position].vsrNo!);

                                          // selectedvehicleSrNolist.removeWhere((item) => item.vehicleRegNo == vehicleSrNolist[position].vehicleRegNo);
                                        }

                                      });
                                    });
                              }
                          ),
                          // CheckboxListTile(
                          //   title: Text("Type"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("Type"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("Type"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                          // CheckboxListTile(
                          //   title: Text("Type"), //    <-- label
                          //   value: false,
                          //   onChanged: (newValue) {},
                          //   dense: true,
                          //   controlAffinity: ListTileControlAffinity.leading,
                          //   contentPadding: EdgeInsets.all(0),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> getCompanylist() async {
    setState(() {
      _isLoading=true;
    });
    String url=Constant.alertFilterCompanyUrl;

    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    // vendorList=vendorResponseFromJson(response.body);
    vendorList=vendorResponseFromJson(response.body).data!;

    setState(() {
      _isLoading=false;
    });

    return "Success";
  }

  Future<String> getBranchList(int selectedvendoid) async {
    setState(() {
      _isLoading=true;
    });
    String url=Constant.alertFilterBranchUrl+""+selectedvendoid.toString();

    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );

    var resBody = json.decode(response.body);

    print(response.body);
    if(response.statusCode==404){
      setState(() {
        _isLoading=false;
      });
      print("Succeed value : ${resBody["succeeded"].toString()}") ;
      if(resBody["succeeded"]==false){
         Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          msg: resBody['message'],
        );
      }

    }else{
      setState(() {
        _isLoading=false;
      });
      branchList=branchResponseFromJson(response.body).data!;
    }



    return "Success";
  }


  Future<String> getalertTypeList() async {
    setState(() {
      _isLoading=true;
    });
    String url=Constant.alertFilterTypeUrl;

    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    setState(() {
      _isLoading=false;
      alerttypeList=filterNotificationAlertTypeResponseFromJson(response.body).data!;
      _isChecked= List<bool>.filled(alerttypeList.length, false);

    });

    /* for(int i=0;i<alerttypeList.length;i++){
      alerttypesList.add(alerttypeList[i].alertIndication!);
    }
    if(alerttypeList.length!=0){
      _isChecked = List<bool>.filled(alerttypesList.length, false);
    }*/


    return "Success";
  }

  Future<String> getvehiclelist(int selectedbranchid) async {

    try{
      setState(() {
        _isLoading=true;
      });
      String url=Constant.alertFilterVehiclesrnoUrl+""+selectedVendorid.toString()+"/"+selectedbranchid.toString();

      print(url);
      final response = await http.get(
        Uri.parse(url),
        headers: <String, String>{
          'Authorization': "Bearer ${token}",
        },
      );
      print(response.body);
      var resBody = json.decode(response.body);

      if(response.statusCode==404){
        setState(() {
          _isLoading=false;
        });
        Fluttertoast.showToast(
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          msg: resBody['message'],
        );
      }else{
        setState(() {
          _isLoading=false;
          vehicleSrNolist=fillAlertNotificationVehicleResponseFromJson(response.body).data!;
          _isvehicleChecked = List<bool>.filled(vehicleSrNolist.length, false);
        });


        // vehicleSrNoslist=resBody['data'];

       /* for(int i=0;i<resBody['data'].length;i++){
          vehicleSrNoslist.add(resBody['data']['vehicleRegNo']!);
        }
        print(vehicleSrNoslist.length);*/

        // vehicleSrNolist=vehicleFillSrNoResponseFromJson(response.body);

        /*for(int i=0;i<vehicleSrNoslist.length;i++){
          vehicleSrNoslist.add(vehicleSrNoslist[i]!);
        }
        if(vehicleSrNoslist.length!=0){
          _isvehicleChecked = List<bool>.filled(vehicleSrNoslist.length, false);
        }*/


      }

    }catch(error){
      setState(() {
        _isLoading=false;
      });
    }
    return "Success";
  }

}
