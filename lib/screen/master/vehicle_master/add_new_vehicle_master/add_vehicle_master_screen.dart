import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/vehicle/search_vehicle_response.dart';
import 'package:flutter_vts/model/vehicle/edit_vehicle_request.dart';
import 'package:flutter_vts/model/vehicle/add_vehicle_request.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../../model/vehicle/all_vehicle_detail_response.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snippet_coder_utils/FormHelper.dart';


class AddVehicleMasterScreen extends StatefulWidget {
  int flag;
  Datum datum;
  Data searchData;
  bool searchText;

  AddVehicleMasterScreen({Key? key,required this.flag,required this.searchText,required this.datum,required this.searchData}) : super(key: key);

  @override
  _AddVehicleMasterScreenState createState() => _AddVehicleMasterScreenState();
}

class _AddVehicleMasterScreenState extends State<AddVehicleMasterScreen> {
  String dropdownvalue = 'Item 1';
  TextEditingController _vehicleidcontroller=new TextEditingController();
  TextEditingController _vendorNamecontroller=new TextEditingController();
  TextEditingController _vehicleBranchNamecontroller=new TextEditingController();
  TextEditingController _vehicleNumbercontroller=new TextEditingController();
  TextEditingController _vehicleNamecontroller=new TextEditingController();
  TextEditingController _vehicleTypecontroller=new TextEditingController();
  TextEditingController _fuelTypecontroller=new TextEditingController();
  TextEditingController _speedLimitcontroller=new TextEditingController();
  TextEditingController _branchNamecontroller=new TextEditingController();
  TextEditingController _deviceNamecontroller=new TextEditingController();
  TextEditingController _statuscontroller=new TextEditingController();
  TextEditingController _currentOdometercontroller=new TextEditingController();
  // static String vehicle = r'^[A-Z]{2}\s[0-9]{1,2}\s[A-Z]{1,2}\s[0-9]{1,4}$';
  static String vehicle = r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{1,4}$';
  late String token="";
  bool activeStatus = false;
  bool isClickVehicleType = false;

  static String character = r'^[A-Z]$';
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  RegExp regexvehicle = new RegExp(vehicle);
  RegExp regexcharacter = new RegExp(character);

  // List of items in our dropdown menu
  String vehicletypedropdownvalue = 'Select';

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  var vehicletypeitems = [
    'Select',
    '2Wheeler',
    '3Wheeler',
    'BUS',
    'TRUCK'
  ];
  late bool _isLoading = false;
  List data =[];
  List driverData =[];
  List deviceData =[];

  late int vehicleid=0,driverid=0,deviceid=0;
  late MainBloc _mainBloc;

  String vehicletypedropdown = '';
  String driverNamedropdown = '';
  String deviceNamedropdown = '';

  String selectedVehicleType = '';
  String selectedDriverName = '';
  String selectedDeviceName = '';


  late SharedPreferences sharedPreferences;
  late String userName="";
  late String vendorName="",branchName="",userType="";
  late int branchid=0,vendorid=0;
  var rcDocumentEncoded,insuranceDocumentEncoded,pucDocumentEncoded,otherDocumentEncoded;
  late String _rcDocumentfileName="",_insuranceDocumentfileName="",_pucDocumentfileName="",_otherDocumentfileName="";
  String rcselecteddocument="";
  Random random = new Random();
  int randomNumber=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);


    print(widget.datum.vehicleType);
    getdata();
    if(widget.flag==2){

      if(widget.searchText){
        print(widget.datum.vsrNo.toString());
        _vehicleidcontroller.text=widget.searchData.vsrNo!.toString();
        _vehicleNamecontroller.text=widget.searchData.vehicleName!;
        // _vendorNamecontroller.text=widget.datum;
        // _vehicleBranchNamecontroller.text=widget.datum.vsrNo;
        _vehicleNumbercontroller.text=widget.searchData.vehicleRegNo!;
        _fuelTypecontroller.text=widget.searchData.fuelType!;
        _speedLimitcontroller.text=widget.searchData.speedLimit!.toString();
        _currentOdometercontroller.text=widget.searchData.currentOdometer!.toString();
        // _vehicleTypecontroller.text=widget.searchData.vehicleType.toString();
        /*_getdocuments(widget.searchData.vehicleRc==null ? "" :widget.searchData.vehicleRc!,widget.searchData.vehicleInsurance==null ? "" :widget.searchData.vehicleInsurance!,widget.searchData.vehiclePuc==null ? "" :widget.datum.vehiclePuc!,widget.searchData.vehicleOther==null ? "" :widget.searchData.vehicleOther!);

        setState(() {
          rcDocumentEncoded=widget.searchData.vehicleRc;
          insuranceDocumentEncoded=widget.searchData.vehicleInsurance;
          pucDocumentEncoded=widget.searchData.vehiclePuc;
          otherDocumentEncoded=widget.searchData.vehicleOther;
        });*/

        selectedDriverName=widget.searchData.driverName!;
        selectedDeviceName=widget.searchData.deviceName!;
        if(widget.searchData.vehicleType!=null){
          selectedVehicleType=widget.searchData.vehicleTypeName!;
        }



        setState(() {
          deviceid=widget.searchData.deviceSrNo!;
          driverid=widget.searchData.driverSrNo!;
          if(widget.searchData.vehicleType!=null){
            vehicleid=int.parse(widget.searchData.vehicleType!);
          }

          if(widget.searchData.acStatus=='Active'){
            activeStatus=true;
          }else{
            activeStatus=false;
          }
        });
      }else{
        print(widget.datum.vsrNo.toString());
        _vehicleidcontroller.text=widget.datum.vsrNo!.toString();
        _vehicleNamecontroller.text=widget.datum.vehicleName!;
        // _vendorNamecontroller.text=widget.datum;
        // _vehicleBranchNamecontroller.text=widget.datum.vsrNo;
        _vehicleNumbercontroller.text=widget.datum.vehicleRegNo!;
        _fuelTypecontroller.text=widget.datum.fuelType!;
        _speedLimitcontroller.text=widget.datum.speedLimit!.toString();
        _currentOdometercontroller.text=widget.datum.currentOdometer!.toString();
        // _vehicleTypecontroller.text=widget.datum.vehicleType.toString();
      /*  _getdocuments(widget.datum.vehicleRc==null ? "" :widget.datum.vehicleRc!,widget.datum.vehicleInsurance==null ? "" :widget.datum.vehicleInsurance!,widget.datum.vehiclePuc==null ? "" :widget.datum.vehiclePuc!,widget.datum.vehicleOther==null ? "" :widget.datum.vehicleOther!);

        setState(() {
          rcDocumentEncoded=widget.datum.vehicleRc;
          insuranceDocumentEncoded=widget.datum.vehicleInsurance;
          pucDocumentEncoded=widget.datum.vehiclePuc;
          otherDocumentEncoded=widget.datum.vehicleOther;
        });*/

        selectedDriverName=widget.datum.driverName!;
        selectedDeviceName=widget.datum.deviceName!;
        if(widget.datum.vehicleType!=null){
          selectedVehicleType=widget.datum.vehicleTypeName!;
        }

        setState(() {
          deviceid=widget.datum.deviceSrNo!;
          driverid=widget.datum.driverSrNo!;
          if(widget.datum.vehicleType!=null){
            vehicleid=int.parse(widget.datum.vehicleType!);
          }


          if(widget.datum.acStatus=='Active'){
            activeStatus=true;
          }else{
            activeStatus=false;
          }
        });
      }

    }else{

    }


   /* _rcDocumentfileName=widget.datum.vehicleRc!;
    var decoded = base64.decode(widget.datum.vehicleRc!);
    print('Decoded: $decoded');
    print(utf8.decode(decoded));
    // Converting the decoded result to string

    String credentials = "Techno@5421&";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encoded = stringToBase64.encode(credentials);      // dXNlcm5hbWU6cGFzc3dvcmQ=
    print('Password: $encoded');

    String decodedd = stringToBase64.decode(encoded);
    print('Decoded2: $decodedd');*/
  }

  _getdocuments(String rcdocument,String insurrancedocument,String pucdocument,String otherdocument){
    var decodeByte=base64.decode(rcdocument);
    var decodeString=utf8.decode(decodeByte);
    print("document url : ${decodeString}");
    setState(() {

      _rcDocumentfileName=decodeString.split('/').last;
      // rcselecteddocument=decodeString.split('/').last;
      if(_rcDocumentfileName.length!=0){
        print("*******************************Length ${_rcDocumentfileName.length}");
      }else{
        print("*******************************Length 0");
      }
      print(_rcDocumentfileName);
      if(_rcDocumentfileName==""){
          _rcDocumentfileName="No file Chosen";
      }
      if(decodeString.split('/').last==""){
        print(_rcDocumentfileName);
      }
    });

    print(decodeString.split('/').last);

    var insurancedecodeByte=base64.decode(insurrancedocument);
    var insurancedecodeString=utf8.decode(insurancedecodeByte);
    print("document url : ${insurancedecodeString}");
    _insuranceDocumentfileName=insurancedecodeString.split('/').last;
    print(insurancedecodeString.split('/').last);

    var pucdecodeByte=base64.decode(pucdocument);
    var pucdecodeString=utf8.decode(pucdecodeByte);
    print("document url : ${pucdecodeString}");
   _pucDocumentfileName=pucdecodeString.split('/').last;
    print(pucdecodeString.split('/').last);

    var otherdecodeByte=base64.decode(otherdocument);
    var otherdecodeString=utf8.decode(otherdecodeByte);
    print("document url : ${otherdecodeString}");
    _otherDocumentfileName=otherdecodeString.split('/').last;
    print(otherdecodeString.split('/').last);
  }


  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    vendorName=sharedPreferences.getString("VendorName")!;
    branchName=sharedPreferences.getString("BranchName")!;
    userType=sharedPreferences.getString("UserType")!;
    vendorid=sharedPreferences.getInt("VendorId")!;
    branchid=sharedPreferences.getInt("BranchId")!;

    if(userType!=""){
      _vendorNamecontroller.text=vendorName;
      _branchNamecontroller.text=branchName;
    }
    if(token!=""){
      if(widget.flag==1){
        _mainBloc.add(SerialNumberEvents(token: token,apiName:"Vehicles/GetMaxId" ));
      }else{
        getvehicleType();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.appBarColorCode,
        title: Text(widget.flag==1 ? "ADD NEW VEHICLE MASTER": "VEHICLE MASTER"),
      ),
      body: _addvehiclemaster(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  // _vehicleidcontroller.clear();
                  _vehicleNumbercontroller.clear();
                  _fuelTypecontroller.clear();
                  _speedLimitcontroller.clear();
                  _currentOdometercontroller.clear();
                  _vehicleNamecontroller.clear();
                  setState(() {
                    _rcDocumentfileName='';
                    _insuranceDocumentfileName='';
                    _pucDocumentfileName='';
                    _otherDocumentfileName='';
                    activeStatus=false;

                    driverNamedropdown='';
                    selectedDriverName = '';
                    driverid=0;

                    vehicletypedropdown='';
                    selectedVehicleType = '';
                    vehicleid=0;

                    deviceNamedropdown='';
                    selectedDeviceName = '';
                    deviceid=0;


                  });

                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phonelink_erase_rounded,color: MyColors.text4ColorCode,),
                    Text("Clear",style: TextStyle(color: MyColors.text4ColorCode,decoration: TextDecoration.underline,fontSize: 20)),
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
                    Icon(Icons.close,size: 25,color: MyColors.text4ColorCode),
                    Text("Cancel",style: TextStyle(color: MyColors.text4ColorCode,decoration: TextDecoration.underline,fontSize: 20),),
                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  print("Values : $vehicleid , $driverid , $deviceid  ");
                  _validation();

                  // CustomDialog().popUp(context,"Record successfully updated.");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 148,
                  height: 56,
                  margin:  EdgeInsets.only(left: 15),
                  padding:  EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                  decoration: BoxDecoration(
                      color: MyColors.blueColorCode,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: MyColors.textBoxBorderColorCode)
                  ),
                  child: Text(widget.flag==1 ? "Save" : "Update",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
                ),
              )

            ],
          ),
        ),

      ),
    );

  }

  _addvehiclemaster(){
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener : (context,state){
          if (state is AddVehicleLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is AddVehicleLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if(state.addVehicleResponse.succeeded!=null){
              if(state.addVehicleResponse.succeeded!){
                CustomDialog().popUp(context,"New record has been successfully saved.");
              }else{
                Fluttertoast.showToast(
                  msg:state.addVehicleResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }

          }else  if (state is AddVehicleErrorState) {
            setState(() {
              _isLoading = false;
            });
          } if (state is EditVehicleLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is EditVehicleLoadedState) {
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

          }else  if (state is EditVehicleErrorState) {
            setState(() {
              _isLoading = false;
            });

          }else  if (state is SerialNumberLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is SerialNumberLoadedState) {
            setState(() {
              _isLoading = false;
              print(state.serialNumberResponse.value!);
              _vehicleidcontroller.text=state.serialNumberResponse.value!;
              getvehicleType();

            });
          }else  if (state is SerialNumberErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:4.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("Vehicle ID",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vehicleidcontroller,
                  enabled:/*widget.flag==1 ?  true :*/false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Vendor Name",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorNamecontroller,
                  enabled: false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
               /* Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon:  Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          *//* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(items,style: TextStyle(fontSize: 18))
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),*/
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Branch Name",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
               /* Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon:  Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          *//* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(items,style: TextStyle(fontSize: 18))
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),*/
                TextField(
                  controller: _branchNamecontroller,
                  enabled: false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Vehicle Number",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vehicleNumbercontroller,
                  textCapitalization: TextCapitalization.characters,
                  enabled: true, // to trigger disabledBorder
                  maxLength: 10,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text("Vehicle Name",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vehicleNamecontroller,
                  enabled: true, // to trigger disabledBorder
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z][a-zA-Z ]*')),
                  // ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color:MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Vehicle Type",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
               /* !isClickVehicleType ?  TextField(
                  controller: _vehicleTypecontroller,
                  enabled: true, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    hintText: "Select",
                    suffixIcon: Icon(Icons.keyboard_arrow_down_rounded),
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.text3greyColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                  onTap: (){
                    setState(() {
                      isClickVehicleType=true;
                    });
                  },
                ):*/
              /*   Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    value: vehicletypedropdownvalue,
                    underline: SizedBox(),
                    icon:  Icon(Icons.keyboard_arrow_down),
                    items: vehicletypeitems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          //  decoration: BoxDecoration(
                          //   border: Border.all(color:MyColors.text3greyColorCode )
                          // ),
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(items,style: TextStyle(fontSize: 18))
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        vehicletypedropdownvalue = newValue!;
                      });
                    },
                  ),
                ),*/
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color:MyColors.whiteColorCode,

                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormHelper.dropDownWidget(
                      context,
                      // "Select product",
                     selectedVehicleType=='' ?  "Select" :selectedVehicleType,
                      this.vehicletypedropdown,
                      this.data,
                          (onChangeVal){
                       setState(() {
                         this.vehicletypedropdown=onChangeVal;
                         vehicleid=int.parse(onChangeVal);
                         print("Selected Product : $onChangeVal");
                       });

                      },
                          (onValidateval){
                        if(onValidateval==null){
                          return "Please select country";
                        }
                        return null;
                      },
                      borderColor:MyColors.whiteColorCode,
                      borderFocusColor: MyColors.whiteColorCode,
                      borderRadius: 10,
                      optionValue: "srNo",
                      optionLabel: "vehicleType",
                      // paddingLeft:20

                  ),
                ),
                /*token=="" ? Container() :
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    items: data.map((item) {
                      setState(() {
                        vehicleid=item['srNo'];
                      });
                      return DropdownMenuItem(
                        child:  Container(
                          *//* decoration: BoxDecoration(
                              border: Border.all(color:MyColors.text3greyColorCode )
                            ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(item['vehicleType'],style: TextStyle(fontSize: 18))
                        ),
                        value: item['vehicleType'],
                      );
                    }).toList(),

                    onChanged: (newVal) {
                      setState(() {
                        vehicletypedropdown = newVal.toString();
                        print(newVal.toString());
                        for(int i=0;i<data.length;i++){
                          if(data[i]['vehicleType']==newVal){
                            // userid=data[i]['userId'];
                            vehicleid=data[i]['srNo'];

                            print(data[i]['srNo']);
                          }
                        }
                        // print();
                      });
                    },
                    value: vehicletypedropdown,
                  ),
                ),*/
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:15,bottom: 8),
                      child: Row(
                        children: [
                          Text("Fuel Type ",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _fuelTypecontroller,
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ], //
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Speed Limit",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _speedLimitcontroller,
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "HintText",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Driver Name",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color:MyColors.whiteColorCode,

                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormHelper.dropDownWidget(
                    context,
                    // "Select product",
                    /* "Select Vehicle Type"*//*widget.datum!=null ? widget.datum.vehicleType.toString() :*/ selectedDriverName=='' ?  "Select" :selectedDriverName,
                    this.driverNamedropdown,
                    this.driverData,
                        (onChangeVal){
                      setState(() {
                        this.driverNamedropdown=onChangeVal;
                        driverid=int.parse(onChangeVal);
                        print("Selected Product : $onChangeVal");
                      });

                    },
                        (onValidateval){
                      if(onValidateval==null){
                        return "Please select Driver";
                      }
                      return null;
                    },
                    borderColor:MyColors.whiteColorCode,
                    borderFocusColor: MyColors.whiteColorCode,
                    borderRadius: 10,
                    optionValue: "driverId",
                    optionLabel: "driverName",
                    // paddingLeft:20
                  ),
                ),
               /* token=="" ? Container() :
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    items: deviceData.map((item) {
                      setState(() {
                        // userid=item['deviceId'];
                      });
                      return DropdownMenuItem(
                        child:  Container(
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(item['deviceName'],style: TextStyle(fontSize: 18))
                        ),
                        value: item['deviceName'],
                      );
                    }).toList(),

                    onChanged: (newVal) {
                      setState(() {
                        deviceNamedropdown = newVal.toString();
                        print(newVal.toString());
                        for(int i=0;i<deviceData.length;i++){
                          if(deviceData[i]['deviceName']==newVal){
                            // userid=data[i]['userId'];
                            deviceid=deviceData[i]['deviceId'];

                            print(deviceData[i]['deviceId']);
                          }
                        }
                      });

                    },
                    value: deviceNamedropdown,
                  ),
                ),*/
                /*Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon:  Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          *//* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(items,style: TextStyle(fontSize: 18))
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),*/

                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:17,bottom: 8),
                      child: Row(
                        children: [
                          Text("Device Name",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color:MyColors.whiteColorCode,

                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormHelper.dropDownWidget(
                    context,
                    // "Select product",
                    /* "Select Vehicle Type"*//*widget.datum!=null ? widget.datum.vehicleType.toString() :*/ selectedDeviceName=='' ?  "Select" :selectedDeviceName,
                    this.deviceNamedropdown,
                    this.deviceData,
                        (onChangeVal){
                      setState(() {
                        this.deviceNamedropdown=onChangeVal;
                        deviceid=int.parse(onChangeVal);
                        print("Selected Product : $onChangeVal");
                      });

                    },
                        (onValidateval){
                      if(onValidateval==null){
                        return "Please Select Device";
                      }
                      return null;
                    },
                    borderColor:MyColors.whiteColorCode,
                    borderFocusColor: MyColors.whiteColorCode,
                    borderRadius: 10,
                    optionValue: "deviceId",
                    optionLabel: "deviceName",
                    // paddingLeft:20
                  ),
                ),
               /* token=="" ? Container() :
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    items: driverData.map((item) {
                      setState(() {
                        // userid=item['driverId'];
                      });
                      return DropdownMenuItem(
                        child:  Container(

                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(item['driverName'],style: TextStyle(fontSize: 18))
                        ),
                        value: item['driverName'],
                      );
                    }).toList(),

                    onChanged: (newVal) {
                      setState(() {
                        driverNamedropdown = newVal.toString();
                        print(newVal.toString());
                        for(int i=0;i<driverData.length;i++){
                          if(driverData[i]['driverName']==newVal){
                            driverid=driverData[i]['driverId'];

                            print(driverData[i]['driverId']);
                          }
                        }
                      });
                    },
                    value: driverNamedropdown,
                  ),
                ),*/
               /* Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon:  Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          *//* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(items,style: TextStyle(fontSize: 18))
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),*/


                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:17,bottom: 8),
                      child: Row(
                        children: [
                          Text("Status",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                Padding(
                  padding:  EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: activeStatus,
                          onChanged: (checkvalue) {
                            setState(() {
                              activeStatus = checkvalue!;
                              print(checkvalue);
                            });
                          }
                      ),
                      Text("Active", style: TextStyle(
                          fontSize: 18, color: MyColors.blackColorCode),)
                    ],
                  ),
                ),
               /* Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon:  Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(
                          *//* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(items,style: TextStyle(fontSize: 18))
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),*/

                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:17,bottom: 8),
                      child: Row(
                        children: [
                          Text("Current Odometer",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _currentOdometercontroller,
                  enabled: true,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor:MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: Colors.orange),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                    ),
                    // hintText: "10",
                    hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxBorderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("RC Document",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),

                Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color:  MyColors.textFieldBackgroundColorCode,
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(

                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc'],
                          );
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            print(file.path);
                            setState(() {
                              _rcDocumentfileName=result.names[0]!;
                              print(file.uri.toString());
                              rcDocumentEncoded = base64.encode(utf8.encode(file.uri.toString()));
                              print(rcDocumentEncoded);

                              /*var decodeByte=base64.decode(rcDocumentEncoded);
                              var decodeString=utf8.decode(decodeByte);
                              print("document url : ${decodeString}");
                              File file1 = File(decodeString);
                              print(decodeString.split('/').last);*/

                            });

                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10,left: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [
                                MyColors.linearGradientGreyColorCode,
                                MyColors.linearGradientGrey2ColorCode,
                                // MyColors.linearGradientGreyColorCode,
                                // Colors.grey[300]!,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text("Choose File",style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      Expanded(
                          // child: Text(rcselecteddocument=="" ? "No file" :rcselecteddocument,style: TextStyle(fontSize: 18),)

                        child: Text(_rcDocumentfileName!=""
                            ?  _rcDocumentfileName
                            :"No file Chosen" ,style: TextStyle(fontSize: 18),)
                        // child: Text(_rcDocumentfileName!="" && _rcDocumentfileName!=null ? _rcDocumentfileName :  "No file Chosen" ,style: TextStyle(fontSize: 18),)
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:17,bottom: 8),
                      child: Row(
                        children: [
                          Text("Insurance Document",style: TextStyle(fontSize: 18),),

                        ],
                      ),
                    )
                ),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: MyColors.textFieldBackgroundColorCode,
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc'],
                          );
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            print(file.path);
                            setState(() {
                              _insuranceDocumentfileName=result.names[0]!;
                              print(file.uri.toString());
                              insuranceDocumentEncoded = base64.encode(utf8.encode(file.uri.toString()));
                              print(insuranceDocumentEncoded);
                            });

                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10,left: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [
                                MyColors.linearGradientGreyColorCode,
                                MyColors.linearGradientGrey2ColorCode,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text("Choose File",style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      Expanded(child: Text(_insuranceDocumentfileName!='' ? _insuranceDocumentfileName :"No file Chosen",style: TextStyle(fontSize: 18),))

                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:17,bottom: 8),
                      child: Row(
                        children: [
                          Text("PUC Document",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: MyColors.textFieldBackgroundColorCode,
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc'],
                          );
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            print(file.path);
                            setState(() {
                              _pucDocumentfileName=result.names[0]!;
                              print(file.uri.toString());
                              pucDocumentEncoded = base64.encode(utf8.encode(file.uri.toString()));
                              print(pucDocumentEncoded);
                            });

                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10,left: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [
                                MyColors.linearGradientGreyColorCode,
                                MyColors.linearGradientGrey2ColorCode,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text("Choose File",style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      Expanded(child: Text(_pucDocumentfileName!='' ? _pucDocumentfileName :"No file Chosen",style: TextStyle(fontSize: 18),))
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:  EdgeInsets.only(top:17,bottom: 8),
                      child: Row(
                        children: [
                          Text("Other Document",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                      color: MyColors.textFieldBackgroundColorCode,
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: ()async{
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf', 'doc'],
                          );
                          if (result != null) {
                            File file = File(result.files.single.path!);
                            print(file.path);
                            setState(() {
                              _otherDocumentfileName=result.names[0]!;
                              print(file.uri.toString());
                              otherDocumentEncoded = base64.encode(utf8.encode(file.uri.toString()));
                              print(otherDocumentEncoded);
                            });

                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10,left: 10),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            gradient: LinearGradient(
                              colors: [
                                MyColors.linearGradientGreyColorCode,
                                MyColors.linearGradientGrey2ColorCode,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Text("Choose File",style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      Expanded(child: Text(_otherDocumentfileName!='' ? _otherDocumentfileName :"No file Chosen",style: TextStyle(fontSize: 18),))

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _validation(){
    if(_vehicleidcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vehicle Id",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if(_vehicleNumbercontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vehicle Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_vehicleNumbercontroller.text.length!=10){
      Fluttertoast.showToast(
        msg: "Vehicle Number field 10 character allow...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
    else if(!regexvehicle.hasMatch(_vehicleNumbercontroller.text)){
      Fluttertoast.showToast(
        msg: "Vehicle number should contain digits & alphabets only...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
    else if(_vehicleNamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vehicle Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }  else if (!validCharacters.hasMatch(_vehicleNamecontroller.text)) {
      Fluttertoast.showToast(
        msg: "Only Alphanumeric value allow in Vehicle Name Field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

    }else if(vehicleid==0){
        Fluttertoast.showToast(
          msg: "Please Select Vehicle Type",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
    }
    /*else if(!regexcharacter.hasMatch(_fuelTypecontroller.text)){
      Fluttertoast.showToast(
        msg: "Fuel Field allow only Alphabets and space...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/
  /*  else if(_vehicleTypecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vehicle Type",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/else if(_fuelTypecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Fuel Type",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }/*else
     if(vehicletypedropdownvalue=='Select'){
        Fluttertoast.showToast(
        msg: "Please Select the vehicle type from DropDown List...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        );
    }*/else if(_speedLimitcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please enter Speed Limit field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(driverid==0){
      Fluttertoast.showToast(
        msg: "Please Select Driver Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(deviceid==0){
      Fluttertoast.showToast(
        msg: "Please Select Device Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
    else if(_currentOdometercontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Current Odometer Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }/*else if(int.tryParse(_currentOdometercontroller.text)!=null){
      Fluttertoast.showToast(
        msg: "Current Odometer Field in Only Decimal value allow...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }*/
    else {
      if(widget.flag==1){
        // print("add" + rcDocumentEncoded+","+insuranceDocumentEncoded+","+pucDocumentEncoded+","+otherDocumentEncoded,);

        _mainBloc.add(AddVehicleEvents(
            addVehicleRequest: AddVehicleRequest(
              // vsrNo:int.parse(_vehicleidcontroller.text),
              vendorSrNo:vendorid,
              branchSrNo:branchid,
              vehicleRegNo:_vehicleNumbercontroller.text,
              vehicleName:_vehicleNamecontroller.text,
              fuelType:_fuelTypecontroller.text,
              speedLimit:int.parse(_speedLimitcontroller.text),
              vehicleType:vehicleid.toString(),
              driverSrNo:driverid,
              deviceSrNo:deviceid,
              currentOdometer:double.parse(_currentOdometercontroller.text),
              vehicleRc:rcDocumentEncoded,
              vehicleInsurance:insuranceDocumentEncoded,
              vehiclePuc:pucDocumentEncoded,
              vehicleOther:otherDocumentEncoded,
              acUser:userName,
              acStatus:activeStatus ? 'Y' : 'N',
            ),
            token: token)
        );
      }else{
        if(widget.searchText){
          print("edit " +widget.searchData.vsrNo.toString());

        }else{
          print("edit " +widget.datum.vsrNo.toString());

        }
        print(_rcDocumentfileName+","+_insuranceDocumentfileName+","+_pucDocumentfileName+","+_otherDocumentfileName);
        _mainBloc.add(EditVehicleEvents(
            editVehicleRequest: EditVehicleRequest(
              vsrNo:widget.searchText ? widget.searchData.vsrNo : widget.datum.vsrNo,
              vendorSrNo:vendorid,
              branchSrNo:branchid,
              vehicleRegNo:_vehicleNumbercontroller.text,
              vehicleName:_vehicleNamecontroller.text,
              fuelType:_fuelTypecontroller.text,
              speedLimit:int.parse(_speedLimitcontroller.text),
              vehicleType:vehicleid.toString(),
              driverSrNo:driverid,
              deviceSrNo:deviceid,
              currentOdometer:double.parse(_currentOdometercontroller.text),
              vehicleRc:rcDocumentEncoded,
              vehicleInsurance:insuranceDocumentEncoded,
              vehiclePuc:pucDocumentEncoded,
              vehicleOther:otherDocumentEncoded,
              acUser:userName,
              acStatus:activeStatus ? 'Y' : 'N',
            ),
            token: token, vehicleid: widget.searchText ? widget.searchData.vsrNo! :widget.datum.vsrNo!)
        );
      }

    }
  }


  Future<String> getvehicleType() async {
    setState(() {
      _isLoading=true;
    });
    print(Constant.vehicleTypeUrl);
    var response = await http.get(Uri.parse(Constant.vehicleTypeUrl),  headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        _isLoading=false;
        vehicletypedropdown=resBody['data'][0]["vehicleType"];
        // vehicleid=resBody[0]["srNo"];
        if(userName!=''){
          data = resBody['data'];
        }
      });
      print(resBody);
      getDriverlist();
      return "Success";
    }else{
      setState(() {
        _isLoading=false;
      });
      throw Exception('Failed to load data.');
    }
  }

  Future<String> getDriverlist() async {
    setState(() {
      _isLoading=true;
    });
    print(Constant.deviceNamesUrl+""+vendorid.toString()+"/"+branchid.toString());

    var response = await http.get(Uri.parse(Constant.driverNamesUrl+"/"+vendorid.toString()+"/"+branchid.toString()),  headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        _isLoading=false;
        driverNamedropdown=resBody['data'][0]["driverName"];
        // driverid=resBody[1]["driverId"];
        // if(userName!=''){
          driverData = resBody['data'];
        // }
      });
      print(resBody);
      getDevicelist();
      return "Success";
    }else{
      setState(() {
        _isLoading=false;
      });
      throw Exception('Failed to load data.');
    }
  }

  Future<String> getDevicelist() async {
    setState(() {
      _isLoading=true;
    });
    print(Constant.deviceNamesUrl+""+vendorid.toString()+"/"+branchid.toString());

    var response = await http.get(Uri.parse(Constant.deviceNamesUrl+"/"+vendorid.toString()+"/"+branchid.toString()),  headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        _isLoading=false;
        deviceNamedropdown=resBody['data'][0]["deviceName"];
        // deviceid=resBody[1]["deviceId"];
        // if(userName!=''){
        deviceData = resBody['data'];
        // }
      });
      print(resBody);
      return "Success";
    }else{
      setState(() {
        _isLoading=false;
      });
      throw Exception('Failed to load data.');
    }
  }
}
