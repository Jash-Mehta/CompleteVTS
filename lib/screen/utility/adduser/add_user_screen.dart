import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert/vehicle_fill_srno_response.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';
import 'package:flutter_vts/model/user/create_user/assign_menu_list_response.dart';
import 'package:flutter_vts/screen/utility/adduser/multi_select_assign_menu_list.dart';
import 'package:flutter_vts/screen/utility/adduser/multi_select_user_vehicle.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_vts/model/user/create_user/get_all_create_user_response.dart';
import 'package:flutter_vts/model/user/create_user/search_created_user_response.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:file_picker/file_picker.dart';

class AddUserScreen extends StatefulWidget {
  int flag;
  Datum datum;
  Data searchData;
  bool searchText;
  AddUserScreen({Key? key,required this.flag,required this.searchText,required this.datum,required this.searchData}) : super(key: key);

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  String dropdownvalue = 'Item 1';
  ScrollController selectedVehicleItemsController=new ScrollController();
  ScrollController selectedassignItemsController=new ScrollController();

  TextEditingController _useridcontroller = new TextEditingController();
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _branchNamecontroller = new TextEditingController();
  TextEditingController _vehicleNumbercontroller = new TextEditingController();
  TextEditingController _userNamecontroller = new TextEditingController();
  TextEditingController _emailidcontroller = new TextEditingController();
  TextEditingController _fromdatecontroller = new TextEditingController();
  TextEditingController _todatecontroller = new TextEditingController();
  TextEditingController _passwordcontroller = new TextEditingController();
  TextEditingController _confirmpasswordcontroller = new TextEditingController();
  TextEditingController _currentOdometercontroller = new TextEditingController();

  // static String vehicle = r'^[A-Z]{2}\s[0-9]{1,2}\s[A-Z]{1,2}\s[0-9]{1,4}$';
  static String vehicle = r'^[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{1,4}$';
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  late String token = "";
  bool activeStatus = false;

  late String profileImageIUrl = "";
  late String filename = "";
  late String pickfile = "";
    File? uploadFile;
  PlatformFile? file;
  late bool _isUpload = false;

  FilePickerResult? result;
  static String character = r'^[A-Z]$';

  RegExp regexvehicle = new RegExp(vehicle);
  RegExp regexcharacter = new RegExp(character);

  // List of items in our dropdown menu
  String vehicletypedropdownvalue = 'Select';
  String tilldate='',fromDate='';
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  late String path="";

  var vehicletypeitems = [
    'Select',
    '2Wheeler',
    '3Wheeler',
    'BUS',
    'TRUCK'
  ];
  late bool _isLoading = false;

  List data = [];
  List driverData = [];
  List deviceData = [];
  List<VehicleList> vehicleList=[];
  List<MenuList> menuList=[];
  List<MenuList> selectedmenuList=[];

  // List<VehicleFillSrNoResponse> vehicleSrNolist=[];
  List<VehicleDatums> vehicleSrNolist=[];

  List<VehicleList> selectedvehicleIDlist=[];
  // List<VehicleFillResponse> vehiclelist = [];
  List<String> list = [];

  List<AssignMenuDatum> assignmenulist=[];
  List<String> assignallmenulist = [];


  late var vehicleresult;
  late var assignMenuresult;

  // List<VehicleFillResponse> selectedvehiclelist = [];
  DateTime now = new DateTime.now();

  late int vehicleid = 0,
      userTypeid = 0,
      deviceid = 0;
  late MainBloc _mainBloc;

  String vehicletypedropdown = '';
  String userTypedropdown = '';
  String deviceNamedropdown = '';
  String selectedUserType="";

  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "",
      branchName = "",
      userType = "";
  late int branchid = 0,
      vendorid = 0;
  var profileDocumentEncoded;
  late String _rcDocumentfileName = "",
      _insuranceDocumentfileName = "",
      _pucDocumentfileName = "",
      _otherDocumentfileName = "";
  DateTime toselectedDate = DateTime.now();
  DateTime fromselectedDate = DateTime.now();
  Random random = new Random();
  int randomNumber=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    getdata();


     /*String credentials = "Techno@5421&";
      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String encoded = stringToBase64.encode(credentials);      // dXNlcm5hbWU6cGFzc3dvcmQ=
      print('Password: $encoded');

      String decodedd = stringToBase64.decode(encoded);
      print('Decoded2: $decodedd');*/

    if(widget.flag==2){
      if(widget.searchText){
        _useridcontroller.text=widget.searchData.userId.toString();
        _userNamecontroller.text=widget.searchData.userName.toString();
        _emailidcontroller.text=widget.searchData.emailId.toString();
        _fromdatecontroller.text=widget.searchData.validFrom!.day.toString()+"-"+widget.searchData.validFrom!.month.toString()+"-"+widget.searchData.validFrom!.year.toString();
        _todatecontroller.text=widget.searchData.validTill!.day.toString()+"-"+widget.searchData.validTill!.month.toString()+"-"+widget.searchData.validTill!.year.toString();
        fromDate=widget.searchData.validFrom!.year.toString()+"-"+widget.searchData.validFrom!.month.toString()+"-"+widget.searchData.validFrom!.day.toString();
        tilldate=widget.searchData.validTill!.year.toString()+"-"+widget.searchData.validTill!.month.toString()+"-"+widget.searchData.validTill!.day.toString();

        setState(() {
          selectedUserType=widget.searchData.userType!;
          // userTypeid=widget.searchData.userId!;
          fromselectedDate=widget.searchData.validFrom!;
          toselectedDate=widget.searchData.validTill!;
          userTypeid=widget.searchData.userTypeId!;

        });

        for(int i=0;i<widget.searchData.vehicleList!.length;i++){
          selectedvehicleIDlist.add(VehicleList(vehicleId: widget.searchData.vehicleList![i].vehicleId!,vehicleRegNo: widget.searchData.vehicleList![i].vehicleRegNo!));
        }
        for(int i=0;i<widget.searchData.menuList!.length;i++){
          selectedmenuList.add(MenuList(menuId: widget.searchData.menuList![i].menuId!,menuCaption: widget.searchData.menuList![i].menuCaption!));
        }
        if(widget.searchData.acFlag=='Active'){
          setState(() {
            activeStatus=true;
          });
        }else{
          setState(() {
            activeStatus=false;
          });
        }
      }else{
        print(widget.datum.userPwd);
        _useridcontroller.text=widget.datum.userId.toString();
        _userNamecontroller.text=widget.datum.userName.toString();
        _emailidcontroller.text=widget.datum.emailId.toString();
        _fromdatecontroller.text=widget.datum.validFrom!.day.toString()+"-"+widget.datum.validFrom!.month.toString()+"-"+widget.datum.validFrom!.year.toString();
        _todatecontroller.text=widget.datum.validTill!.day.toString()+"-"+widget.datum.validTill!.month.toString()+"-"+widget.datum.validTill!.year.toString();
        fromDate=widget.datum.validFrom!.year.toString()+"-"+widget.datum.validFrom!.month.toString()+"-"+widget.datum.validFrom!.day.toString();
        tilldate=widget.datum.validTill!.year.toString()+"-"+widget.datum.validTill!.month.toString()+"-"+widget.datum.validTill!.day.toString();
        selectedUserType=widget.datum.userType!;
        // userTypeid=widget.datum.userId!;
        setState(() {
          fromselectedDate=widget.datum.validFrom!;
          toselectedDate=widget.datum.validTill!;
          userTypeid=widget.datum.userTypeId!;
        });

        for(int i=0;i<widget.datum.vehicleList!.length;i++){
          selectedvehicleIDlist.add(VehicleList(vehicleId: widget.datum.vehicleList![i].vehicleId!,vehicleRegNo: widget.datum.vehicleList![i].vehicleRegNo!));
        }
        for(int i=0;i<widget.datum.menuList!.length;i++){
          selectedmenuList.add(MenuList(menuId: widget.datum.menuList![i].menuId!,menuCaption: widget.datum.menuList![i].menuCaption!));
        }

        if(widget.datum.acFlag=='Active'){
          setState(() {
            activeStatus=true;
          });
        }else{
          setState(() {
            activeStatus=false;
          });
        }
        // _passwordcontroller.text=widget.datum.userPwd.toString();
      }
    }else{
     /* randomNumber = random.nextInt(100); // from 0 upto 99 included
      print('Random number ${randomNumber}');
      if(randomNumber!=0){
        _useridcontroller.text=randomNumber.toString();
      }*/
    }
  }


  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (sharedPreferences.getString("Username") != null) {
      userName = sharedPreferences.getString("Username")!;
    }
    vendorName = sharedPreferences.getString("VendorName")!;
    branchName = sharedPreferences.getString("BranchName")!;
    userType = sharedPreferences.getString("UserType")!;
    vendorid = sharedPreferences.getInt("VendorId")!;
    branchid = sharedPreferences.getInt("BranchId")!;

    if (userType != "") {
      _vendorNamecontroller.text = vendorName;
      _branchNamecontroller.text = branchName;
    }

    // getUserlist();

    if (token != "") {
      if(widget.flag==1){
        _mainBloc.add(SerialNumberEvents(token: token,apiName:"Users/GetMaxId" ));
      }else{
        getUserlist();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD USER"),
      ),
      body: _adduser(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                   _vehicleNumbercontroller.clear();
                    _userNamecontroller.clear();
                   _emailidcontroller.clear();
                    _currentOdometercontroller.clear();
                    _fromdatecontroller.clear();
                    _todatecontroller.clear();
                    _passwordcontroller.clear();
                    _confirmpasswordcontroller.clear();

                    setState(() {
                    profileImageIUrl='';
                    selectedvehicleIDlist.clear();
                    selectedmenuList.clear();
                    selectedUserType="";
                    userTypedropdown="";
                      userTypeid=0;

                    activeStatus=false;
                  });

                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phonelink_erase_rounded,
                      color: MyColors.text4ColorCode,),
                    Text("Clear", style: TextStyle(
                        color: MyColors.text4ColorCode,
                        decoration: TextDecoration.underline,
                        fontSize: 20)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
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
                  // print(fromDate);
                  // print(tilldate);
                  //   print(fromselectedDate);
                  // print(profileDocumentEncoded);


                  _validation();
                  /*for(int i=0;i<selectedvehicleIDlist.length;i++) {
                    print(selectedvehicleIDlist[i].vehicleId);
                  }*/
                    // print(selectedmenuList);

                  // CustomDialog().popUp(context,"Record successfully updated.");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 148,
                  height: 56,
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(
                      top: 6.0, bottom: 6, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: MyColors.blueColorCode,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: MyColors.textBoxBorderColorCode)
                  ),
                  child: Text(widget.flag == 1 ? "Save" : "Update",
                    style: TextStyle(
                        color: MyColors.whiteColorCode, fontSize: 20),),
                ),
              )

            ],
          ),
        ),

      ),
    );
  }

  _adduser() {
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
          if (state is AddUserLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AddUserLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if(state.addCreatedUserResponse.succeeded!=null){
              if(state.addCreatedUserResponse.succeeded!){
                CustomDialog().popUp(context,"New record has been successfully saved.");
              }else{
                Fluttertoast.showToast(
                  msg:state.addCreatedUserResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }


          }else if (state is AddUserErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: state.msg,
            );
          }if (state is EditUserLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is EditUserLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if(state.editDeviceResponse.succeeded!=null){
              if(state.editDeviceResponse.succeeded!){
                CustomDialog().popUp(context,"User Record successfully updated.");
              }else{
                Fluttertoast.showToast(
                  msg:state.editDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }


          }else if (state is EditUserErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: state.msg,
            );
          }  else  if (state is SerialNumberLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is SerialNumberLoadedState) {
            setState(() {
              _isLoading = false;
              print(state.serialNumberResponse.value!);
              _useridcontroller.text=state.serialNumberResponse.value!;
              getUserlist();
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
                          Text("User ID", style: TextStyle(fontSize: 18),),
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
                  controller: _useridcontroller,
                  enabled: /*widget.flag==1 ?  true :*/false,
                  // to trigger disabledBorder
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
                          Text("User Name", style: TextStyle(fontSize: 18),),
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
                  controller: _userNamecontroller,
                  // textCapitalization: TextCapitalization.characters,
                  enabled: true,
                 /* inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  ],*/
                  // to trigger disabledBorder
                  // maxLength: 10,
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
                          Text("User Type", style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                token == "" ? Container() :
               /* Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: MyColors.textBoxBorderColorCode, width: 2)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    items: data.map((item) {
                      setState(() {
                        vehicleid = item['srNo'];
                      });
                      return DropdownMenuItem(
                        child: Container(
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 58,
                            child: Text(item['userType'],
                                style: TextStyle(fontSize: 18))
                        ),
                        value: item['userType'],
                      );
                    }).toList(),

                    onChanged: (newVal) {
                      setState(() {
                        userTypedropdown = newVal.toString();
                        print(newVal.toString());
                        for (int i = 0; i < data.length; i++) {
                          if (data[i]['userType'] == newVal) {
                            // userid=data[i]['userId'];
                            userTypeid = data[i]['srNo'];

                            print(data[i]['srNo']);
                          }
                        }
                        // print();
                      });
                    },
                    value: userTypedropdown,
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
                    selectedUserType=='' ?  "Select" :selectedUserType,
                    this.userTypedropdown,
                    this.data,
                        (onChangeVal){
                      setState(() {
                        this.userTypedropdown=onChangeVal;
                        userTypeid=int.parse(onChangeVal);
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
                    optionLabel: "userType",
                    // paddingLeft:20

                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                      child: Row(
                        children: [
                          Text("Email ID", style: TextStyle(fontSize: 18),),
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
                  controller: _emailidcontroller,
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
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Subscription Valid Form", style: TextStyle(
                              fontSize: 18),),
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
                  controller: _fromdatecontroller,
                  enabled: true,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _fromDate(context);
                  },
                  // to trigger disabledBorder
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
                    hintText: "DD/MM/YYYY",
                    suffixIcon: Icon(Icons.calendar_today_outlined),
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
                          Text("Subscription Valid Till", style: TextStyle(
                              fontSize: 18),),
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
                  controller: _todatecontroller,
                  enabled: true,
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _toDate(context);
                  },
                  // to trigger disabledBorder
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
                    hintText: "DD/MM/YYYY",
                    suffixIcon: Icon(Icons.calendar_today_outlined),
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
                          Text("Select Vehicle", style: TextStyle(
                              fontSize: 18),),
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
                  // controller: alertGroupController,
                  enabled: true,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _showMultiSelect();
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
                    hintText: "Select",
                    suffixIcon: Icon(Icons.keyboard_arrow_down,size: 30,color: MyColors.dateIconColorCode,),
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.datePlacehoderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                selectedvehicleIDlist.length==0 ? Container() : GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    controller: selectedVehicleItemsController,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: selectedvehicleIDlist.length,
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
                              Expanded(child: Text(selectedvehicleIDlist[index].vehicleRegNo!,overflow:TextOverflow.ellipsis,maxLines:1,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)),
                              GestureDetector(
                                onTap:(){
                                  setState(() {
                                    selectedvehicleIDlist.removeAt(index);
                                  });
                                  },
                                  child: Icon(Icons.close,color: MyColors.whiteColorCode,)
                              )
                            ],
                          )
                      );
                    }
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8),
                      child: Row(
                        children: [
                          Text("Menu To Assign", style: TextStyle(
                              fontSize: 18),),
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
                  // controller: alertGroupController,
                  enabled: true,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _showMultiAssignMenuSelect();
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
                    hintText: "Select",
                    suffixIcon: Icon(Icons.keyboard_arrow_down,size: 30,color: MyColors.dateIconColorCode,),
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.datePlacehoderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                selectedmenuList.length==0 ? Container() : GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    controller: selectedassignItemsController,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /5,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: selectedmenuList.length,
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
                              Expanded(child: Text(selectedmenuList[index].menuCaption!,textAlign:TextAlign.center,maxLines:2,overflow:TextOverflow.ellipsis,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)),
                              GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      selectedmenuList.removeAt(index);
                                    });
                                  },
                                  child: Icon(Icons.close,color: MyColors.whiteColorCode,)
                              )
                            ],
                          )
                      );
                    }
                ),
                /*Container(
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                      border: Border.all(
                          color: MyColors.textBoxBorderColorCode, width: 2)
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    underline: SizedBox(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Container(

                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 58,
                            child: Text(items, style: TextStyle(fontSize: 18))
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
                      padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                      child: Row(
                        children: [
                          Text("Password", style: TextStyle(fontSize: 18),),
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
                  controller: _passwordcontroller,
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
                  obscureText: true,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Text("Confirm Password", style: TextStyle(
                              fontSize: 18),),
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
                  controller: _confirmpasswordcontroller,
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
                  obscureText: true,
                ),

                //
                // /* token=="" ? Container() :
                //  Container(
                //    width: MediaQuery.of(context).size.width,
                //    decoration: BoxDecoration(
                //        border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                //    ),
                //    child: DropdownButton(
                //      underline: SizedBox(),
                //      items: deviceData.map((item) {
                //        setState(() {
                //          // userid=item['deviceId'];
                //        });
                //        return DropdownMenuItem(
                //          child:  Container(
                //              decoration: BoxDecoration(
                //                  border: Border.all(color:MyColors.text3greyColorCode )
                //              ),
                //              padding: EdgeInsets.only(left: 10),
                //              width: MediaQuery.of(context).size.width-58,
                //              child: Text(item['deviceName'],style: TextStyle(fontSize: 18))
                //          ),
                //          value: item['deviceName'],
                //        );
                //      }).toList(),
                //
                //      onChanged: (newVal) {
                //        setState(() {
                //          deviceNamedropdown = newVal.toString();
                //          print(newVal.toString());
                //          for(int i=0;i<deviceData.length;i++){
                //            if(deviceData[i]['deviceName']==newVal){
                //              // userid=data[i]['userId'];
                //              deviceid=deviceData[i]['deviceId'];
                //
                //              print(deviceData[i]['deviceId']);
                //            }
                //          }
                //        });
                //
                //      },
                //      value: deviceNamedropdown,
                //    ),
                //  ),*/
                //
                //  /*Container(
                //    decoration: BoxDecoration(
                //        color: Color(0xFFF2F2F2),
                //        border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                //    ),
                //    child: DropdownButton(
                //      value: dropdownvalue,
                //      underline: SizedBox(),
                //      icon: const Icon(Icons.keyboard_arrow_down),
                //      items: items.map((String items) {
                //        return DropdownMenuItem(
                //          value: items,
                //          child: Container(
                //            *//* decoration: BoxDecoration(
                //              border: Border.all(color:MyColors.text3greyColorCode )
                //            ),*//*
                //              padding: EdgeInsets.only(left: 10),
                //              width: MediaQuery.of(context).size.width-58,
                //              child: Text(items,style: TextStyle(fontSize: 18))
                //          ),
                //        );
                //      }).toList(),
                //      onChanged: (String? newValue) {
                //        setState(() {
                //          dropdownvalue = newValue!;
                //        });
                //      },
                //    ),
                //  ),*/
                //
                // /* Align(
                //      alignment: Alignment.centerLeft,
                //      child: Padding(
                //        padding: const EdgeInsets.only(top:17,bottom: 8),
                //        child: Row(
                //          children: [
                //            Text("Device Name",style: TextStyle(fontSize: 18),),
                //          ],
                //        ),
                //      )
                //  ),
                //  token=="" ? Container() :
                //  Container(
                //    width: MediaQuery.of(context).size.width,
                //    decoration: BoxDecoration(
                //        border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                //    ),
                //    child: DropdownButton(
                //      underline: SizedBox(),
                //      items: driverData.map((item) {
                //        setState(() {
                //          // userid=item['driverId'];
                //        });
                //        return DropdownMenuItem(
                //          child:  Container(
                //              decoration: BoxDecoration(
                //                  border: Border.all(color:MyColors.text3greyColorCode )
                //              ),
                //              padding: EdgeInsets.only(left: 10),
                //              width: MediaQuery.of(context).size.width-58,
                //              child: Text(item['driverName'],style: TextStyle(fontSize: 18))
                //          ),
                //          value: item['driverName'],
                //        );
                //      }).toList(),
                //
                //      onChanged: (newVal) {
                //        setState(() {
                //          driverNamedropdown = newVal.toString();
                //          print(newVal.toString());
                //          for(int i=0;i<driverData.length;i++){
                //            if(driverData[i]['driverName']==newVal){
                //              driverid=driverData[i]['driverId'];
                //
                //              print(driverData[i]['driverId']);
                //            }
                //          }
                //        });
                //      },
                //      value: driverNamedropdown,
                //    ),
                //  ),*/
                //
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Profile Image", style: TextStyle(
                              fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),

                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  height: 65,
                  decoration: BoxDecoration(
                    color: MyColors.textFieldBackgroundColorCode,
                    border: Border.all(
                        color: MyColors.textBoxBorderColorCode, width: 2),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(

                        onTap: () async {
                             try{
                               result = await FilePicker.platform.pickFiles(
                                 type: FileType.any,
                                 allowMultiple: false
                               );

                               if (result != null) {
                                 setState(() {
                                   filename=result!.files.first.name;
                                   file = result!.files.first;
                                   File file1 = File(result!.files.single.path!);

                                   profileImageIUrl= file!.name;
                                   uploadFile=File(file!.path.toString());
                                   // profileDocumentEncoded = base64.encode(utf8.encode(file1.uri.toString()));
                                   // print(profileDocumentEncoded);

                                   // var base64string = Base64String.encode( "somestring" );
                                   // print("Base 64");
                                  convertImageBase64();
                                 });
                               }
                             }catch(e){
                               print(e.toString());
                             }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 10, left: 10),
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
                          child: Text("Choose File",
                            style: TextStyle(fontSize: 18),),
                        ),
                      ),
                      Expanded(child: Text(profileImageIUrl != ''
                          ? profileImageIUrl
                          : "No file Chosen", style: TextStyle(fontSize: 18),)),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            _isUpload=true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right:6.0),
                          child: Text("Upload",style: TextStyle(fontSize: 18,decoration: TextDecoration.underline,color: MyColors.blueColorCode),),
                        ),
                      ),

                    ],
                  ),
                ),
                _isUpload ? uploadFile==null ? Container() : Image.file(
                  uploadFile!,height: 200,):Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  convertImageBase64() async{
    File imagefile = File(result!.files.single.path!); //convert Path to File
    Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imagebytes); //convert bytes to base64 string
    print("Base 64");
    setState(() {
      profileDocumentEncoded= base64.encode(imagebytes);
    });
    print(profileDocumentEncoded);


    // List<int> test = imagefile.readAsBytesSync();
    // String test2 = base64Encode(test);
    // setState(() {
    //     profileDocumentEncoded=test2;
    //   });
    // print(test2);
  }

  Future<String> getUserlist() async {
    setState(() {
      _isLoading = true;
    });
    print(Constant.userTypeUrl);

    var response = await http.get(
      Uri.parse(Constant.userTypeUrl), headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        _isLoading = false;
        // userTypedropdown = resBody[0]["userType"];
        // userTypeid = resBody[0]["srNo"];
        data = resBody['data'];
      });
      print(resBody);
      getvehiclelist();
      return "Success";
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data.');
    }
  }

  Future<String> getvehiclelist() async {
    // String url = Constant.vehicleFillUrl + "" + vendorid.toString() + "/" +
    //     branchid.toString();
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
    vehicleSrNolist=vehicleFillSrNoResponseFromJson(response.body).data!;
    setState(() {
      _isLoading=false;
    });
    for(int i=0;i<vehicleSrNolist.length;i++){
      list.add(vehicleSrNolist[i].vehicleRegNo!);
      vehicleList.add(VehicleList(vehicleId: vehicleSrNolist[i].vsrNo,vehicleRegNo: vehicleSrNolist[i].vehicleRegNo!));
    }

    getAssignMenuList();
    /*print(response.body);
    var resBody = json.decode(response.body);
    vehiclelist = vehicleFillResponseFromJson(response.body);
    for (int i = 0; i < vehiclelist.length; i++) {
      list.add(vehiclelist[i].vehicleRegNo!);
    }*/
    print("list legth ${resBody['data'][0]['vehicleRegNo']}");
    print("list legth 1 ${list.length}");

    return "Success";
  }

  Future<String> getAssignMenuList() async {
    String url=Constant.assignMenuListUrl;

    print(url);

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    var resBody = json.decode(response.body);
    assignmenulist=assignMenuListResponseFromJson(response.body).data!;
    setState(() {
      _isLoading=false;
    });
    for(int i=0;i<assignmenulist.length;i++){
      assignallmenulist.add(assignmenulist[i].menuCaption!);
      menuList.add(MenuList(menuId: assignmenulist[i].menuId,menuCaption: assignmenulist[i].menuCaption!));
    }

    print("list menu length ${resBody['data'][0]['menuCaption']}");
    print("list length 1 ${list.length}");

    return "Success";
  }


  void _showMultiSelect() async {

    vehicleresult=await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectUserVehicle(items: list,vehicleList: vehicleList,selectedvehicleIDlist: selectedvehicleIDlist,);
      },
    );

    if (vehicleresult != null && vehicleresult.containsKey('SelectedUserItemsList')) {
      setState(() {
        print("vehicle list : ${vehicleresult["SelectedUserItemsList"]}");
      });
    }
    if (vehicleresult != null && vehicleresult.containsKey('SelectedUserVehicleList')) {
      setState(() {
        selectedvehicleIDlist=vehicleresult["SelectedUserVehicleList"];
        if(selectedvehicleIDlist.length!=0){
          print("Name ${selectedvehicleIDlist[0].vehicleRegNo}");
        }
      });
    }


  }


  void _showMultiAssignMenuSelect() async {

    assignMenuresult=await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectAssignMenuList(assignallmenulist : assignallmenulist,menuList: menuList,selectedmenuList:selectedmenuList);
      },
    );

    if (assignMenuresult != null && assignMenuresult.containsKey('SelectedAssignMenuItemsList')) {
      setState(() {
        print("Assign Menu list : ${assignMenuresult["SelectedAssignMenuItemsList"]}");
      });
    }
    if (assignMenuresult != null && assignMenuresult.containsKey('SelectedAssignMenuList')) {
      setState(() {
        selectedmenuList=assignMenuresult["SelectedAssignMenuList"];
        if(selectedmenuList.length!=0){
          print("Assign Menu ${selectedmenuList[0].menuCaption}");
        }
      });
    }


  }

  Future<void> _fromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: toselectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year, now.month+1, now.day),
      // lastDate: DateTime(2102)
    );
    if (picked != null && picked != toselectedDate) {
      setState(() {
        fromselectedDate = picked;
        _fromdatecontroller.text=fromselectedDate.day.toString()+"-"+fromselectedDate.month.toString()+"-"+fromselectedDate.year.toString();
        fromDate=fromselectedDate.year.toString()+"-"+fromselectedDate.month.toString()+"-"+fromselectedDate.day.toString();

      });
    }
  }

  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toselectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2102)
    );
    if (picked != null && picked != toselectedDate) {
      setState(() {
        toselectedDate = picked;
        _todatecontroller.text=toselectedDate.day.toString()+"-"+toselectedDate.month.toString()+"-"+toselectedDate.year.toString();
        tilldate=toselectedDate.year.toString()+"-"+toselectedDate.month.toString()+"-"+toselectedDate.day.toString();

      });
    }
  }

  _validation(){
    if(_useridcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The User ID...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_userNamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The User Name...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (!validCharacters.hasMatch(_userNamecontroller.text)) {
      Fluttertoast.showToast(
        msg: "Only Alphanumeric value allow in Username Field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

    }else  if(userTypeid==0){
      Fluttertoast.showToast(
        msg:"Please Select the User Type from Dropdown List...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_emailidcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The Email ID...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(!EmailValidator.validate(_emailidcontroller.text)){
      Fluttertoast.showToast(
        msg: "Please Enter Valid Email-Id",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_fromdatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The Subscription Valid From Date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_todatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter The Subscription Valid Till Date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(fromselectedDate.compareTo(toselectedDate)==1)/*if(_fromdatecontroller.text.compareTo(_todatecontroller.text)==1)*/{
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if(fromDate==tilldate)/*if(_fromdatecontroller.text.compareTo(_todatecontroller.text)==1)*/{
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_passwordcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter Password...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_passwordcontroller.text.length<=7){
      Fluttertoast.showToast(
        msg:"User Password field minimum 8 character allow...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if(_confirmpasswordcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg:"Please Enter Confirm Password...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_confirmpasswordcontroller.text.length<=7){
      Fluttertoast.showToast(
        msg:"User Confirm Password field minimum 8 character allow...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_passwordcontroller.text!=_confirmpasswordcontroller.text){
      Fluttertoast.showToast(
        msg:"New Password and Confirm Password should same...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(selectedvehicleIDlist.length==0){
      Fluttertoast.showToast(
        msg:"Please Select The Vehicle From List...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(selectedmenuList.length==0){
      Fluttertoast.showToast(
        msg:"Please Select The Menu From List...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if(profileImageIUrl==""){
    Fluttertoast.showToast(
    msg:"Please Choose Profile Image...!",
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: 1,
    );
    }
    else{
     /* Fluttertoast.showToast(
        msg:"Success",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );*/
      print(selectedvehicleIDlist);
      if(widget.flag==1){
        _mainBloc.add(AddUserEvents(
            addUserRequest: AddUserRequest(
              userId:int.parse(_useridcontroller.text),
              userName:_userNamecontroller.text,
              vendorSrNo:vendorid,
              branchSrNo:branchid,
              userPwd:_passwordcontroller.text,
              userType:userTypeid.toString(),
              emailId:_emailidcontroller.text,
              acUser:userName,
              acFlag:activeStatus ? 'Y' :'N',
              validFrom:fromDate,
              validTill:tilldate,
              profilePhoto: profileDocumentEncoded,
              vehicleList:selectedvehicleIDlist,
              menuList:selectedmenuList,
            ),
            token: token));
      }else{
        print(tilldate);
        _mainBloc.add(EditUserEvents(
            addUserRequest: AddUserRequest(
              userId:widget.searchText ? widget.searchData.userId : widget.datum.userId,
              userName:_userNamecontroller.text,
              vendorSrNo:vendorid,
              branchSrNo:branchid,
              userPwd:_passwordcontroller.text,
              userType:userTypeid.toString(),
              emailId:_emailidcontroller.text,
              acUser:userName,
              acFlag:activeStatus ? 'Y' :'N',
              validFrom:fromDate,
              validTill:tilldate,
              profilePhoto: profileDocumentEncoded,
              vehicleList:selectedvehicleIDlist,
              menuList:selectedmenuList,
            ),
            token: token,
            userId:_useridcontroller.text));
      }


    }
  }



}