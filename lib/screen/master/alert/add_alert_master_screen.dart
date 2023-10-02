import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';
import 'package:flutter_vts/model/alert/add_alert_master_response.dart';
import 'package:flutter_vts/model/alert/fill_alert_response.dart';
import 'package:flutter_vts/model/alert/vehicle_fill_srno_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/screen/comman_screen/multi_select_vehicle_screen.dart';
import 'package:flutter_vts/screen/master/alert/multi_select_alert_type.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../model/alert/all_alert_master_response.dart';
import '../../../model/alert/search_alert_master_screen.dart';

class AddAlertMasterScreen extends StatefulWidget {
  int flag;
  bool searchFlag;
  Datum  datalist;
  Data searchData;

  AddAlertMasterScreen({Key? key,required this.flag,required this.searchFlag,required this.datalist,required this.searchData}) : super(key: key);

  @override
  _AddAlertMasterScreenState createState() => _AddAlertMasterScreenState();
}

class _AddAlertMasterScreenState extends State<AddAlertMasterScreen> {
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token = "";
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 0, vendorid = 0;
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _branchNamecontroller = new TextEditingController();
  TextEditingController alertGroupController = new TextEditingController();
  List<String> list=[];
  List<String> alertlist=[];
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  List<VehicleFillResponse> vehiclelist=[];
  List<AlertTypesDatum> alerttypelist=[];
  // List<FillAlertResponse> selectedalerttypelist=[];

  List<AlertsDetail> alertDetailslist=[];
  List<AlertsDetail> selectedalerttypelist=[];
  List<VehiclesDetail> vehicleSrNoDetailslist=[];
  List<VehiclesDetail> selectedvehicleSrNoDetailslist=[];

  List<VehicleDatums> vehicleSrNolist=[];


  late var vehicleresult;
  late var alertresult;

  List<VehiclesDetail> ?vehicleDetails=[];

  List<String> _selectedItems = [];
  List<VehicleFillResponse> selectedvehiclelist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    getdata();



    if(widget.flag==2){
      if(!widget.searchFlag){
        alertGroupController.text=widget.datalist.alertGroupName!;
        for(int i=0;i<widget.datalist.vehicleDetails!.length;i++){
          selectedvehicleSrNoDetailslist.add(VehiclesDetail(vsrNo:widget.datalist.vehicleDetails![i].vsrNo,vehicleRegNo: widget.datalist.vehicleDetails![i].vehicleRegNo ));
        }
        for(int j=0;j<widget.datalist.alertDetails!.length;j++){
          selectedalerttypelist.add(AlertsDetail(alertCode:widget.datalist.alertDetails![j].alertCode,alertIndication: widget.datalist.alertDetails![j].alertIndication ));
        }
      }else{
        alertGroupController.text=widget.searchData.alertGroupName!;
        for(int i=0;i<widget.searchData.vehicleDetails!.length;i++){
          selectedvehicleSrNoDetailslist.add(VehiclesDetail(vsrNo:widget.searchData.vehicleDetails![i].vsrNo,vehicleRegNo: widget.searchData.vehicleDetails![i].vehicleRegNo ));
        }
        for(int j=0;j<widget.searchData.alertDetails!.length;j++){
          selectedalerttypelist.add(AlertsDetail(alertCode:widget.searchData.alertDetails![j].alertCode,alertIndication: widget.searchData.alertDetails![j].alertIndication ));
        }
      }

      print(selectedvehicleSrNoDetailslist.length);
      print(selectedalerttypelist.length);

    }
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
    if (sharedPreferences.getString("Username") != null) {
      userName = sharedPreferences.getString("Username")!;
    }
    if (sharedPreferences.getString("VendorName") != null) {
      vendorName = sharedPreferences.getString("VendorName")!;
    }
    if (sharedPreferences.getString("BranchName") != null) {
      branchName = sharedPreferences.getString("BranchName")!;
    }
    if (sharedPreferences.getString("UserType") != null) {
      userType = sharedPreferences.getString("UserType")!;
    }

    print("branchid ${branchid}   Vendor id   ${vendorid}");

    print("" +
        vendorid.toString() +
        " " +
        branchid.toString() +
        " " +
        userName +
        " " +
        vendorName +
        " " +
        branchName +
        " " +
        userType);

    if (token != "" ||
        vendorid != 0 ||
        branchid != 0 ||
        vendorName != "" ||
        branchName != "") {
      _vendorNamecontroller.text = vendorName;
      _branchNamecontroller.text = branchName;
      getvehiclelist();
      // getalerttypelist();
    }
  }

  void _showMultiSelect() async {
    vehicleresult = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: list,vehiclelist: vehicleSrNoDetailslist,selectedvehicleSrNoDetailslist: selectedvehicleSrNoDetailslist,);
      },
    );

    if (vehicleresult != null && vehicleresult.containsKey('VehicleList')) {
      setState(() {
        print("vehicle list : ${vehicleresult["VehicleList"]}");
      });
    }
    if (vehicleresult != null && vehicleresult.containsKey('VehicleListDemo')) {
      setState(() {

        selectedvehicleSrNoDetailslist=vehicleresult["VehicleListDemo"];
        print("Name ${selectedvehicleSrNoDetailslist[0].vehicleRegNo}");
        // selectedvehiclelist=vehicleresult["VehicleListDemo"];
        // print("Name ${selectedvehiclelist[1].vehicleRegNo}");
      });
    }

    /*final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: list,vehiclelist: vehiclelist,);
      },
    );*/

    // Update UI
    /* if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }*/
  }


  void _showMultiAlertTypeSelect() async {

    alertresult=await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectAlertType(items: alertlist, alerttypelist: alertDetailslist,selectedalerttypelist: selectedalerttypelist,);
      },
    );

    if (alertresult != null && alertresult.containsKey('AlertTypeList')) {
      setState(() {
        print("Alert Type list : ${alertresult["AlertTypeList"]}");
      });
    }
    if (alertresult != null && alertresult.containsKey('AlertTypeCodeList')) {
      setState(() {
        selectedalerttypelist=alertresult["AlertTypeCodeList"];
        print("Alert Type ${selectedalerttypelist[0].alertIndication}");
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flag==1 ? "ADD ALERT MASTER" :"ALERT MASTER"),
      ),
      body: _addalertmaster(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  if(widget.flag==1){
                    alertGroupController.clear();
                  }
                  setState(() {
                    selectedvehicleSrNoDetailslist.clear();
                    selectedalerttypelist.clear();
                  });


                },
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
              GestureDetector(
                onTap: (){

                  Navigator.pop(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.close, size: 25, color: MyColors.text4ColorCode),
                    Text(
                      "Cancel",
                      style: TextStyle(
                          color: MyColors.text4ColorCode,
                          decoration: TextDecoration.underline,
                          fontSize: 20),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  _validation();

                },
                child: Container(
                  alignment: Alignment.center,
                  width: 148,
                  height: 56,
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(
                      top: 6.0, bottom: 6, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: MyColors.buttonColorCode,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border:
                          Border.all(color: MyColors.textBoxBorderColorCode)),
                  child: Text(
                    widget.flag == 1 ? "Save" : "Update",
                    style:
                        TextStyle(color: MyColors.whiteColorCode, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _addalertmaster() {
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
          if (state is AddAlertLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is AddAlertLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if (state.addAlertMasterResponse.succeeded != null) {
              if (state.addAlertMasterResponse.succeeded!) {
                CustomDialog()
                    .popUp(context, "New record has been successfully saved.");
              } else {
                Fluttertoast.showToast(
                  msg: state.addAlertMasterResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }
          } else if (state is AddAlertErrorState) {
            setState(() {
              _isLoading = false;
            });
          }else if (state is EditAlertLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is EditAlertLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if(state.editDeviceResponse.succeeded!=null){
              if(state.editDeviceResponse.succeeded!){
                CustomDialog().popUp(context,"Record successfully updated.");
              }else{
                Fluttertoast.showToast(
                  msg:state.editDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }

          }else if (state is EditAlertErrorState) {
            setState(() {
              _isLoading = false;
            });
          }


        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 15, right: 15, bottom: 20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Vendor Name",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  controller: _vendorNamecontroller,
                  enabled: false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
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
                    // hintText: "HintText",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Branch Name",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  controller: _branchNamecontroller,
                  enabled: false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
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
                    // hintText: "HintText",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Alert Group Name",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  controller: alertGroupController,
                  enabled: widget.flag==1 ? true :false,
                  /*inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z][a-zA-Z ]*')),
                    ],*/
                  onTap: (){
                  },// to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.flag==1 ? MyColors.whiteColorCode : MyColors.textFieldBackgroundColorCode,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
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
                    hintText: "",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.datePlacehoderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Select Vehicle",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  // controller: alertGroupController,
                  enabled: true,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _showMultiSelect();
                  }, // to trigger disabledBorder
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
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
                    hintText: "Select",
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                      color: MyColors.dateIconColorCode,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.datePlacehoderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),

                /*_selectedItems.length==0 ?*/
              /*  widget.flag==1 ? Container() :*/ selectedvehicleSrNoDetailslist.length==0 ? Container()
                /*GridView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: widget.datalist.vehicleDetails!.length,
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: MyColors.dateIconColorCode,
                            borderRadius: BorderRadius.all(Radius.circular(22))
                          ),
                          child: Text(widget.datalist.vehicleDetails![index].vehicleRegNo!,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)
                      );
                    }
                )*/:GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: selectedvehicleSrNoDetailslist.length,
                    itemBuilder: (context,index){
                      return Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: MyColors.dateIconColorCode,
                              borderRadius: BorderRadius.all(Radius.circular(22))
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(selectedvehicleSrNoDetailslist[index].vehicleRegNo!,overflow:TextOverflow.ellipsis,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)),
                              GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedvehicleSrNoDetailslist.removeAt(index);
                                  });
                                  },
                                  child: Icon(Icons.close,color: MyColors.whiteColorCode,)
                              )
                            ],
                          )
                      );
                    }
                ),
               /* Wrap(
                  children: _selectedItems
                      .map((e) => Chip(
                    label: Text(e.toString()),
                  ))
                      .toList(),
                ),*/

                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8,top: 8),
                      child: Row(
                        children: [
                          Text(
                            "Select Alert Type",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  // controller: alertGroupController,
                  enabled: true,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());

                    _showMultiAlertTypeSelect();
                    // _showMultiSelect();
                  },// to trigger disabledBorder
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
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
                    hintText: "Select",
                    suffixIcon: Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                      color: MyColors.dateIconColorCode,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.datePlacehoderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
               /* widget.flag==1 ? Container() :*/selectedalerttypelist.length==0 ? Container()
                /*GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: widget.datalist.alertDetails!.length,
                    itemBuilder: (context,index){
                      return Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: MyColors.dateIconColorCode,
                              borderRadius: BorderRadius.all(Radius.circular(22))
                          ),
                          child: Text(widget.datalist.alertDetails![index].alertCode!,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)
                      );
                    }
                )*/:GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 10 /3,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: selectedalerttypelist.length,
                    itemBuilder: (context,index){
                      return Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: MyColors.dateIconColorCode,
                              borderRadius: BorderRadius.all(Radius.circular(22))
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text(selectedalerttypelist[index].alertIndication!,overflow:TextOverflow.ellipsis,maxLines:2,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)),
                              GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      selectedalerttypelist.removeAt(index);
                                    });
                                  },
                                  child: Icon(Icons.close,color: MyColors.whiteColorCode,)
                              )
                            ],
                          )
                      );
                    }
                )
// token=="" ? Container() :
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: BoxDecoration(
//                       border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
//                   ),
//                   child: DropdownButton(
//                     underline: SizedBox(),
//                     items: data.map((item) {
//                       setState(() {
//                         userid=item['userId'];
//                       });
//                       return DropdownMenuItem(
//                         child:  Container(
//
//                               decoration: BoxDecoration(
//                               border: Border.all(color:MyColors.text3greyColorCode )
//                             ),
//                             padding: EdgeInsets.only(left: 10),
//                             width: MediaQuery.of(context).size.width-58,
//                             child: Text(item['userName'],style: TextStyle(fontSize: 18))
//                         ),
//                         value: item['userName'],
//                       );
//                     }).toList(),
//
//                     onChanged: (newVal) {
//                       setState(() {
//                         usernamedropdown = newVal.toString();
//                         print(newVal.toString());
//                         for(int i=0;i<data.length;i++){
//                           if(data[i]['userName']==newVal){
//                             // userid=data[i]['userId'];
//                             userid1=data[i]['userId'];
//
//                             print(data[i]['userId']);
//                           }
//                         }
//                         // print();
//                       });
//                     },
//                     value: usernamedropdown,
//                   ),
//                 ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validation() {
    if (alertGroupController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter The Alert Group Name...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (!validCharacters.hasMatch(alertGroupController.text)) {
      Fluttertoast.showToast(
        msg: "Only Alphanumeric value allow in Alert Group Name Field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

    }else if( selectedvehicleSrNoDetailslist.length==0){
      Fluttertoast.showToast(
        msg: "Please Select The Vehicle From List...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(selectedalerttypelist.length==0){
      Fluttertoast.showToast(
        msg:"Please Select The Alert Type From List...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else{
      if(widget.flag==1){
        _mainBloc.add(AddAlertEvents(
            addAlertMasterRequest: AddAlertMasterRequest(
                vendorSrNo: vendorid,
                branchSrNo: branchid,
                alertGroupName: alertGroupController.text,
                acUser: userName,
                vehicleDetails: selectedvehicleSrNoDetailslist,
                alertDetails: selectedalerttypelist
            ),
            token: token
        ));
      }else{
        _mainBloc.add(EditAlertEvents(
            addAlertMasterRequest: AddAlertMasterRequest(
                vendorSrNo: vendorid,
                branchSrNo: branchid,
                alertGroupName: alertGroupController.text,
                acUser: userName,
                vehicleDetails: selectedvehicleSrNoDetailslist ,
                alertDetails:selectedalerttypelist
            ),
            token: token,
            alerttext: alertGroupController.text
        ));
      }

    }
  }

  Future<String> getvehiclelist() async {
    setState(() {
      _isLoading=true;
    });
    String url=Constant.vehicleFillSrnoUrl+""+vendorid.toString()+"/"+branchid.toString();

    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    var resBody = json.decode(response.body);
    // vehiclelist=vehicleFillSrNoResponseFromJson(response.body);
    vehicleSrNolist=vehicleFillSrNoResponseFromJson(response.body).data!;
    setState(() {
      _isLoading=false;
    });
    for(int i=0;i<vehicleSrNolist.length;i++){
      list.add(vehicleSrNolist[i].vehicleRegNo!);
      vehicleSrNoDetailslist.add(VehiclesDetail(vsrNo: vehicleSrNolist[i].vsrNo,vehicleRegNo: vehicleSrNolist[i].vehicleRegNo!));
    }
    getalerttypelist();
    print("list legth ${resBody['data'][0]['vehicleRegNo']}");
    print("list legth 1 ${list.length}");

    return "Success";
  }


  Future<String> getalerttypelist() async {
    String url=Constant.alertFillUrl;
    setState(() {
      _isLoading=true;
    });
    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    var resBody = json.decode(response.body);
    alerttypelist=fillAlertResponseFromJson(response.body).data!;
    setState(() {
      _isLoading=false;
    });
    for(int i=0;i<alerttypelist.length;i++){
      alertlist.add(alerttypelist[i].alertIndication!);
      alertDetailslist.add(AlertsDetail(alertCode: alerttypelist[i].alertCode,alertIndication: alerttypelist[i].alertIndication!));
    }
    print("list legth ${resBody['data'][0]['alertIndication']}");
    print("list legth 1 ${alertlist.length}");
    // alertCode
    return "Success";
  }

}
