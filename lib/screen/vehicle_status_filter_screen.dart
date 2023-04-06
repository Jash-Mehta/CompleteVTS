import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert_notification/fill_alert_notification_vehicle_response.dart';
import 'package:flutter_vts/model/filter/Vendor_response.dart';
import 'package:flutter_vts/model/filter/branch_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_Status_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VehicleStatusFilterScreen extends StatefulWidget {
  String fromdate;
  String fromTime;
  String todate;
  String toTime;

  VehicleStatusFilterScreen({Key? key,required this.fromdate,required this.fromTime,required this.todate,required this.toTime}) : super(key: key);

  @override
  State<VehicleStatusFilterScreen> createState() =>
      _VehicleStatusFilterScreenState();
}

class _VehicleStatusFilterScreenState extends State<VehicleStatusFilterScreen> {

  late String userName="";
  late bool isSearch = false;
  bool activeStatus = false;

  TextEditingController searchController=new TextEditingController();
  ScrollController vehicleStatusController=new ScrollController();
  ScrollController vehicleController=new ScrollController();

  late String vendorName="",branchName="",userType="";
  late SharedPreferences sharedPreferences;
  late String token="";
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late int branchid=0,vendorid=0;
  late int selectedVendorid=0,selectedbranchid=0;
  List<VendorDatum> vendorList=[];
  List<BranchDatum> branchList=[];
  ScrollController vendorController=new ScrollController();
  ScrollController branchController=new ScrollController();
  List<int> selectedvehicleSrNolist=[];
  List<String> selectedVehicleStatusList=[];
  List<VehicleStatusResponse> vehicleStatuslisst=[];
  List<bool> _isChecked=[];


  List<String> vehicleStatusList=[];
  List<VehicleHistoryFilterDatum>? data=[];
  List<VehicleDatum>  vehicleSrNolist=[];
  List<bool> _isvehicleChecked=[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    getdata();
  }


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
      getVehicleStatus();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.textColorCode,
        centerTitle: true,
        title: Text("Filter".toUpperCase()),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context,{"FilterAlert":false});

                // Navigator.pop(context);
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
      body: WillPopScope(
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
              listener: (context,state){
                if (state is VehicleHistoryFilterLoadingState) {
                  setState(() {
                    _isLoading = true;
                  });
                }else if (state is VehicleHistoryFilterLoadedState) {
                  setState(() {
                    _isLoading = false;
                  });
                  if(state.vehicleHistoryFilterResponse.succeeded!){
                    if(state.vehicleHistoryFilterResponse.data!=null){
                      data!.addAll(state.vehicleHistoryFilterResponse.data!);
                      Navigator.pop(context,{"VehicleHistoryFilterList":data,"SearchText":searchController.text,"SelectedVehicleStatusList":selectedVehicleStatusList,"SelectedVehicleList" : selectedvehicleSrNolist,"SearchFilter":false,"FilterPageNumber":2,"SelectedVendorId":selectedVendorid,"SelectedBranchId":selectedbranchid,"TotalFilterRecord":state.vehicleHistoryFilterResponse.totalRecords.toString()});
                    }

                  }else{
                    if(state.vehicleHistoryFilterResponse.message!=null){
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        msg: state.vehicleHistoryFilterResponse.message!,
                      );
                    }
                  }
                  }else if (state is VehicleHistoryFilterErrorState) {
                  setState(() {
                    _isLoading = false;
                  });
                }else if (state is VehicleHistorySearchFilterLoadingState) {
                  setState(() {
                    _isLoading = true;
                  });
                }else if (state is VehicleHistorySearchFilterLoadedState) {
                  setState(() {
                    _isLoading = false;
                  });
                  if(state.vehicleHistoryFilterResponse.succeeded!){
                    data!.addAll(state.vehicleHistoryFilterResponse.data!);
                    Navigator.pop(context,{"VehicleHistoryFilterList":data,"SearchText":searchController.text,"SearchFilter":true,"FilterPageNumber":2,"SelectedVehicleStatusList":selectedVehicleStatusList,"SelectedVehicleList" : selectedvehicleSrNolist,"SelectedVendorId":selectedVendorid,"SelectedBranchId":selectedbranchid,"TotalFilterRecord":state.vehicleHistoryFilterResponse.totalRecords.toString()});
                  }else{
                    if(state.vehicleHistoryFilterResponse.message!=null){
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        msg: state.vehicleHistoryFilterResponse.message!,
                      );
                    }
                  }
                }else if (state is VehicleHistorySearchFilterErrorState) {
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
                                    child: const Text("Filter",style: TextStyle(color: MyColors.blackColorCode,fontSize: 18),),
                                    onPressed: () {},
                                  ),
                                  TextButton(
                                    child: const Text("Clear",style: TextStyle(fontSize: 18)),
                                    onPressed: () {
                                      setState(() {
                                        searchController.text="";
                                        selectedVendorid=0;
                                        selectedbranchid=0;
                                        activeStatus=false;
                                        branchList.clear();
                                        vehicleSrNolist.clear();
                                        selectedVehicleStatusList.clear();
                                        _isChecked = List<bool>.filled(vehicleStatuslisst.length, false);
                                        selectedvehicleSrNolist.clear();
                                        _isvehicleChecked = List<bool>.filled(vehicleSrNolist.length, false);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                height: 36,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50.0),
                                    color: Colors.blue),
                                child: TextButton(
                                    child: const Text("Apply",
                                        style: TextStyle(color: Colors.white,fontSize: 18)),
                                    onPressed: () {
                                      // print(selectedVehicleStatusList.length);
                                      applyFilter();

                                    })),
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
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              // crossAxisAlignment: CrossAxisAlignment.end,
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
                                  "Active",
                                  style: TextStyle(
                                      fontSize: 20, color: MyColors.blackColorCode),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Status",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                              ),
                            ),
                            ListView.builder(
                                controller: vehicleStatusController,
                                shrinkWrap: true,
                                itemCount: vehicleStatuslisst.length,
                                itemBuilder: (context,position){
                                  return CheckboxListTile(
                                      title: Text(vehicleStatuslisst[position].status!),
                                      value: _isChecked[position],
                                      onChanged: (val){
                                        setState(() {
                                          _isChecked[position]=val!;
                                          if(_isChecked[position]){
                                            selectedVehicleStatusList.add(vehicleStatuslisst[position].status!.toString());
                                          }else{
                                            selectedVehicleStatusList.removeWhere((item) => item == vehicleStatuslisst[position].status!);
                                          }

                                        });
                                      });
                                }
                            ),
                            /*CheckboxListTile(
                              title: const Text("Running"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            CheckboxListTile(
                              title: const Text("Idle"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            CheckboxListTile(
                              title: const Text("Stop"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            CheckboxListTile(
                              title: const Text("Parking"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            CheckboxListTile(
                              title: const Text("Over Speed"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            CheckboxListTile(
                              title: const Text("In-Active"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.all(0),
                            ),
                            CheckboxListTile(
                              title: const Text("No Data"), //    <-- label
                              value: false,
                              onChanged: (newValue) {},
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: const EdgeInsets.all(0),
                            ),
                            const SizedBox(
                              height: 16,
                            ),*/
                            vendorList.length==0 ? Container() : const Padding(
                              padding: EdgeInsets.only(left: 8.0,bottom: 10),
                              child: Text(
                                "Company",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
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
                                }
                            ),
                            branchList.length==0 ? Container() : const Padding(
                              padding: EdgeInsets.only(top:10,left: 8.0,bottom: 10),
                              child: Text(
                                "Branch",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold,fontSize: 18),
                              ),
                            ),
                            ListView.builder(
                                controller: branchController,
                                shrinkWrap: true,
                                itemCount: branchList.length,
                                itemBuilder: (context,index){
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        _isLoading=true;
                                      });
                                      print(branchList[index].branchId!);
                                      print(selectedVendorid);
                                      setState(() {
                                        vehicleSrNolist.clear();
                                        selectedvehicleSrNolist.clear();
                                        selectedbranchid=branchList[index].branchId!;
                                        if(selectedbranchid!=0){
                                          // _isLoading=false;
                                          _loaderTime();
                                        }
                                        getvehiclelist(branchList[index].branchId!);

                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10.0,top: 4,bottom: 4),
                                      child: Text(branchList[index].branchName!,style: TextStyle(fontSize: 16),),
                                    ),
                                  );
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
                                          }else{
                                            selectedvehicleSrNolist.removeWhere((item) => item == vehicleSrNolist[position].vsrNo!);
                                          }

                                        });
                                      });
                                }
                            ),
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
      ),

      // TabBarView(
      //     physics: const NeverScrollableScrollPhysics(),
      //     children: listScreens),
    );
  }

  _loaderTime() async{
    await Future.delayed(const Duration(seconds: 1), (){
      setState(() {
        _isLoading=false;
      });
    });
  }

  applyFilter(){
    if(selectedVehicleStatusList.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please Select Vehicle Status...!",
      );
    }
    else if(selectedVendorid==0){
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
        msg: "Please Select Vehicle Numbers...!",
      );
    }else{
      // Fluttertoast.showToast(
      //   toastLength: Toast.LENGTH_SHORT,
      //   timeInSecForIosWeb: 1,
      //   msg: "success",
      // );
      if(isSearch){
        print(" search");
        _mainBloc.add(VehicleHistorySearchFilterEvents(token:token,vendorId:selectedVendorid, branchId: selectedbranchid, araiNoarai: activeStatus ? 'arai' : "nonarai",fromDate:widget.fromdate,formTime:widget.fromTime,toDate:widget.todate,toTime:widget.toTime ,vehicleStatusList:selectedVehicleStatusList,vehicleList:selectedvehicleSrNolist,searchText:searchController.text,pageNumber:1 ,pageSize:10, ));
      }else{
        print("not search");
        _mainBloc.add(VehicleHistoryFilterEvents(token:token,vendorId:selectedVendorid, branchId: selectedbranchid, araiNoarai: activeStatus ? "arai" :'nonarai',fromDate:widget.fromdate,formTime:widget.fromTime,toDate:widget.todate,toTime:widget.toTime ,vehicleStatusList:selectedVehicleStatusList,vehicleList: selectedvehicleSrNolist,pageNumber:1 ,pageSize:10, ));
      }
    }

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


  Future<String> getVehicleStatus() async {
    setState(() {
      _isLoading=true;
    });
    String url=Constant.getVehicleStatusUrl;

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
      vehicleStatuslisst=vehicleStatusResponseFromJson(response.body);
      _isChecked= List<bool>.filled(vehicleStatuslisst.length, false);

    });
    return "Success";
  }

  Future<String> getvehiclelist(int selectedbranchid) async {

    try{
      setState(() {
        vehicleSrNolist.clear();
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
      }
    }catch(error){
      setState(() {
        _isLoading=false;
      });
    }
    return "Success";
  }


}
