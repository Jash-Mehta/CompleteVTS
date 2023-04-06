

import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/driver/add_driver_master_request.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../model/driver/all_driver_master_response.dart';
import 'package:flutter_vts/model/driver/search_driver_master_response.dart';

class AddDriverMasterScreen extends StatefulWidget {
  int flag;
  bool searchText;
  Data searchData;
  Datum ? alldriverDetaildatalist;

  AddDriverMasterScreen({Key? key,required this.flag,required this.searchText,required this.alldriverDetaildatalist,required this.searchData}) : super(key: key);

  @override
  _AddDriverMasterScreenState createState() => _AddDriverMasterScreenState();
}

class _AddDriverMasterScreenState extends State<AddDriverMasterScreen> {

  String dropdownvalue = 'Item 1';
  TextEditingController _driversrnocontroller = new TextEditingController();
  TextEditingController _driverCodecontroller = new TextEditingController();
  TextEditingController _driverNmaecontroller = new TextEditingController();
  TextEditingController _livenceNumbercontroller = new TextEditingController();
  TextEditingController _mobileNocontroller = new TextEditingController();
  TextEditingController _citycontroller = new TextEditingController();
  TextEditingController _addresscontroller = new TextEditingController();
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _dojcontroller = new TextEditingController();
  TextEditingController _branchNamecontroller = new TextEditingController();

  bool activeStatus = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token="";
  late SharedPreferences sharedPreferences;
  late String userName="";
  late String vendorName="",branchName="",userType="";
  late int branchid=0,vendorid=0;
  static String licencevehicle = "^(([A-Z]{2}[0-9]{2})( )|([A-Z]{2}-[0-9]{2}))((19|20)[0-9][0-9])[0-9]{7}" +
      "|([a-zA-Z]{2}[0-9]{2}[\\/][a-zA-Z]{3}[\\/][0-9]{2}[\\/][0-9]{5})" +
      "|([a-zA-Z]{2}[0-9]{2}(N)[\\-]{1}((19|20)[0-9][0-9])[\\-][0-9]{7})" +
      "|([a-zA-Z]{2}[0-9]{14})" +
      "|([a-zA-Z]{2}[\\-][0-9]{13})";
  RegExp regexvehicle = new RegExp(licencevehicle);
  static String mobileNumber = r'(^[789]\d{9}$)';
  RegExp regexMobile = new RegExp(mobileNumber);
  static String City = '^[a-zA-Z][a-zA-Z ]*';
  RegExp regexCity = new RegExp(City);
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  DateTime now = new DateTime.now();
  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  DateTime selectedDate = DateTime.now();
  late String date='';
  Random random = new Random();
  int randomNumber=0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // firstDate: DateTime(2022),
        firstDate: DateTime(now.year, now.month-1, now.day),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now()
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dojcontroller.text=selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
        date=selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainBloc = BlocProvider.of(context);
    getdata();
    if(widget.flag==2){
      if(widget.searchText){
        _driversrnocontroller.text=widget.searchData.srNo.toString();
        _driverCodecontroller.text=widget.searchData.driverCode!;
        _driverNmaecontroller.text=widget.searchData.driverName!;
        _livenceNumbercontroller.text=widget.searchData.licenceNo!;
        _mobileNocontroller.text=widget.searchData.mobileNo!;
        _citycontroller.text=widget.searchData.city!;
        _addresscontroller.text=widget.searchData.driverAddress!;
        // _dojcontroller.text=widget.alldriverDetaildatalist!.doj!.toString();
        date=widget.searchData.doj!.year.toString()+"-"+widget.searchData.doj!.month.toString()+"-"+widget.searchData.doj!.day.toString();

        _dojcontroller.text=widget.searchData.doj!.day.toString()+"/"+widget.searchData.doj!.month.toString()+"/"+widget.searchData.doj!.year.toString();
        setState(() {
          if(widget.searchData.acStatus=='Active'){
            activeStatus=true;
          }else{
            activeStatus=false;
          }
        });
      }else{
        _driversrnocontroller.text=widget.alldriverDetaildatalist!.srNo.toString();
        _driverCodecontroller.text=widget.alldriverDetaildatalist!.driverCode!;
        _driverNmaecontroller.text=widget.alldriverDetaildatalist!.driverName!;
        _livenceNumbercontroller.text=widget.alldriverDetaildatalist!.licenceNo!;
        _mobileNocontroller.text=widget.alldriverDetaildatalist!.mobileNo!;
        _citycontroller.text=widget.alldriverDetaildatalist!.city!;
        _addresscontroller.text=widget.alldriverDetaildatalist!.driverAddress!;
        // _dojcontroller.text=widget.alldriverDetaildatalist!.doj!.toString();
        date=widget.alldriverDetaildatalist!.doj!.year.toString()+"-"+widget.alldriverDetaildatalist!.doj!.month.toString()+"-"+widget.alldriverDetaildatalist!.doj!.day.toString();

        _dojcontroller.text=widget.alldriverDetaildatalist!.doj!.day.toString()+"/"+widget.alldriverDetaildatalist!.doj!.month.toString()+"/"+widget.alldriverDetaildatalist!.doj!.year.toString();
        setState(() {
          if(widget.alldriverDetaildatalist!.acStatus=='Active'){
            activeStatus=true;
          }else{
            activeStatus=false;
          }
        });
      }
    }else{
     /* randomNumber = random.nextInt(100); // from 0 upto 99 included
      print('Random number ${randomNumber}');
      if(randomNumber!=0){
        _driversrnocontroller.text=randomNumber.toString();
      }*/
    }
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
    if(token!="") {
      if (widget.flag == 1) {
        _mainBloc.add(
            SerialNumberEvents(token: token, apiName: "Drivers/GetMaxId"));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flag==1 ? "ADD NEW DRIVER MASTER" : "DRIVER MASTER"),
      ),
      body: _addbranchmaster(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  _driverCodecontroller.clear();
                  _driverNmaecontroller.clear();
                  _livenceNumbercontroller.clear();
                  _dojcontroller.clear();
                  _mobileNocontroller.clear();
                  _citycontroller.clear();
                  _addresscontroller.clear();
                  setState(() {
                    activeStatus=false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phonelink_erase_rounded,
                      color: MyColors.text4ColorCode,),
                    Text("Clear", style: TextStyle(color: MyColors.text4ColorCode,
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
                    Text("Cancel", style: TextStyle(
                        color: MyColors.text4ColorCode,
                        decoration: TextDecoration.underline,
                        fontSize: 20),),
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
                      border: Border.all(color: MyColors.textBoxBorderColorCode)
                  ),
                  child: Text(widget.flag==1 ? "Save" : "Update", style: TextStyle(
                      color: MyColors.whiteColorCode, fontSize: 20),),
                ),
              )
            ],
          ),
        ),

      ),
    );
  }


  _addbranchmaster() {
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context,state){
           if (state is AddDeviceLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AddDriverLoadedState) {
            setState(() {
              _isLoading = false;
             /* if(state.addDriverResponse.errors==null){
                Fluttertoast.showToast(
                  msg:"not error",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }else{*/
                if(state.addDriverResponse.succeeded!){
                  CustomDialog().popUp(context,"New record has been successfully saved.");
                }else{
                  Fluttertoast.showToast(
                    msg:state.addDriverResponse.message!,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                  );
                }
              // }

            });

          }else if (state is AddDriverErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong",
            );
          }else if (state is EditDriverLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is EditDriverLoadedState) {
            setState(() {
              _isLoading = false;
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
              }else{
                Fluttertoast.showToast(
                  msg:"Something went wrong,Please try again",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }

            });

          }else if (state is EditDriverErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong",
            );
          }else  if (state is SerialNumberLoadingState) {
             setState(() {
               _isLoading = true;
             });
           }else  if (state is SerialNumberLoadedState) {
             setState(() {
               _isLoading = false;
               print(state.serialNumberResponse.value!);
               _driversrnocontroller.text=state.serialNumberResponse.value!;

             });
           }else  if (state is SerialNumberErrorState) {
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
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                      child: Row(
                        children: [
                          Text("Sr. No", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _driversrnocontroller,
                  enabled: /*widget.flag==2 ? false :*/false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Vendor Name", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.buttonColorCode),
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
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Branch Name", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _branchNamecontroller,
                  enabled: false, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.textFieldBackgroundColorCode,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Driver Code", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _driverCodecontroller,
                  enabled: true, // to trigger disabledBorder
                  maxLength: 7,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Driver Name", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _driverNmaecontroller,
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z][a-zA-Z ]*')),
                  ],
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("License Number", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _livenceNumbercontroller,
                  enabled: true, // to trigger disabledBorder
                  maxLength: 16,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9][a-zA-Z 0-9]*')),
                  ],
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1,   color: MyColors.buttonColorCode),
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
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Mobile Number", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _mobileNocontroller,
                  enabled: true, // to trigger disabledBorder
                  maxLength: 10,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.whiteColorCode,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                          width: 1,   color: MyColors.buttonColorCode),
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
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("City", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _citycontroller,
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z][a-zA-Z ]*')),
                  ],
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Driver Address", style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _addresscontroller,
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("DOJ", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _dojcontroller,
                  enabled: true,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  },// to trigger disabledBorder
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
                      borderSide: BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(width: 1,)
                    ),
                    errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode)
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)
                    ),
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
                          Text("Status", style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
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


              ],
            ),
          ),
        ),
      ),
    );
  }

  _validation() {
     if (_driversrnocontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Driver Sr No.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_driverCodecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Driver Code",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }  else if (!validCharacters.hasMatch(_driverCodecontroller.text)) {
       Fluttertoast.showToast(
         msg: "Only Alphanumeric value allow in Driver Code Field...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     }else if (_driverNmaecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Driver Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_livenceNumbercontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Licence Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }  else if (_livenceNumbercontroller.text.length!=16) {
      Fluttertoast.showToast(
        msg: "Licence Number field 16 character allow...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else  if(!regexvehicle.hasMatch(_livenceNumbercontroller.text)){
      Fluttertoast.showToast(
        msg: "Driving Licence Number should be on (MH12 20160034761) format ...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 2,
      );
    } else if (_mobileNocontroller.text.length!=10) {
      Fluttertoast.showToast(
        msg: "Please Enter Valid Mobile Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }  else if (!regexMobile.hasMatch(_mobileNocontroller.text)) {
       Fluttertoast.showToast(
         msg: "Please Enter Valid Mobile Number...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     } else if (_citycontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter City",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }/*   else if (!regexCity.hasMatch(_citycontroller.text)) {
       Fluttertoast.showToast(
         msg: "Please Enter Valid Mobile Number...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     }*/ else if (_dojcontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Select Date of Join",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if(_addresscontroller.text.isNotEmpty){
       if (!validCharacters.hasMatch(_addresscontroller.text)) {
         Fluttertoast.showToast(
           msg: "Only Alphanumeric value allow in Address Field...!",
           toastLength: Toast.LENGTH_SHORT,
           timeInSecForIosWeb: 1,
         );
       }else{
         _driverMaster();
       }
     } else {
       _driverMaster();
    }
  }

  _driverMaster(){
    if(widget.flag==1){
      _mainBloc.add(AddDriverEvents(addDriverRequest: AddDriverRequest(
        srNo:int.parse(_driversrnocontroller.text),
        vendorSrNo:vendorid,
        branchSrNo:branchid,
        driverCode:_driverCodecontroller.text,
        driverName:_driverNmaecontroller.text,
        licenceNo:_livenceNumbercontroller.text,
        city:_citycontroller.text,
        mobileNo:_mobileNocontroller.text,
        doj:date/*_dojcontroller.text*/,
        driverAddress:_addresscontroller.text,
        acUser:userName,
        acStatus:activeStatus ? 'Y': 'N',
      ),
          token: token));
    }else{
      print("edit");
      _mainBloc.add(EditDriverEvents(addDriverRequest: AddDriverRequest(
        srNo:widget.searchText ? widget.searchData.srNo! : widget.alldriverDetaildatalist!.srNo!,
        vendorSrNo:vendorid,
        branchSrNo:branchid,
        driverCode:_driverCodecontroller.text,
        driverName:_driverNmaecontroller.text,
        licenceNo:_livenceNumbercontroller.text,
        city:_citycontroller.text,
        mobileNo:_mobileNocontroller.text,
        doj:date,
        driverAddress:_addresscontroller.text,
        acUser:userName,
        acStatus:activeStatus ? 'Y': 'N',
      ),
        srno: widget.searchText ? widget.searchData.srNo! : widget.alldriverDetaildatalist!.srNo!,
        token: token,
      ));
    }
  }
}



// AddSubscriptionMasterScreen(flag: 1,alldriverDetaildatalist: null,)