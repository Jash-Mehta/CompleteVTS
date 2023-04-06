import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/branch/branch_name_response.dart';
import 'package:flutter_vts/model/device/add_device_request.dart';
import 'package:flutter_vts/model/device/device_master_response.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_name_response.dart';
import 'package:flutter_vts/screen/transaction/vts_live/vts_live_screen.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:flutter_vts/util/session_manager.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../model/device/search_device_response.dart';

class AddDeviceMasterScreen extends StatefulWidget {
  int flag;
  Datum datum;
  Data searchData;
  bool searchText;

  AddDeviceMasterScreen(
      {Key? key,
      required this.flag,
      required this.searchText,
      required this.datum,
      required this.searchData})
      : super(key: key);

  @override
  _AddDeviceMasterScreenState createState() => _AddDeviceMasterScreenState();
}

class _AddDeviceMasterScreenState extends State<AddDeviceMasterScreen> {
  String dropdownvalue = 'Y';
  String vendordropdownname = '';
  bool activeStatus = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  List<VendorNameResponse> vendronamelist = [];
  List<BranchNameResponse> branchnamelist = [];

  List<String> vendorNameList = [];
  List data = [];
  late String _mySelection = '';
  String vendordropdownid = "";
  TextEditingController _devicesrnocontroller = new TextEditingController();
  TextEditingController _deviceNumbercontroller = new TextEditingController();
  TextEditingController _deviceNmaecontroller = new TextEditingController();
  TextEditingController _modelNumbercontroller = new TextEditingController();
  TextEditingController _simCard1controller = new TextEditingController();
  TextEditingController _simCard2controller = new TextEditingController();
  TextEditingController _Imeicontroller = new TextEditingController();
  TextEditingController _PortNocontroller = new TextEditingController();
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _branchNamecontroller = new TextEditingController();

  late String token = "";
  late int branchid = 0, vendorid = 0;
  SessionManager sessionManager = SessionManager();
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late SharedPreferences sharedPreferences;
  late Future<String> myFuture;
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');


  // List of items in our dropdown menu
  List<String> items = [];
  Random random = new Random();
  int randomNumber=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = ['Y', 'N'];
    _mainBloc = BlocProvider.of(context);
    // _gettoken();
    getdata();
    if (widget.flag == 2) {
      if (widget.searchText) {
        _devicesrnocontroller.text = widget.searchData.srNo!.toString();
        _deviceNumbercontroller.text = widget.searchData.deviceNo!;
        _deviceNmaecontroller.text = widget.searchData.deviceName!;
        _modelNumbercontroller.text = widget.searchData.modelNo!;
        _simCard1controller.text = widget.searchData.simNo1!;
        _simCard2controller.text = widget.searchData.simNo2!;
        _Imeicontroller.text = widget.searchData.imeino!;
        _PortNocontroller.text = widget.searchData.portNo!;
        _vendorNamecontroller.text = widget.searchData.vendorName!;
        _branchNamecontroller.text = widget.searchData.branchName!;
        if(widget.searchData.acStatus=="Active"){
          setState(() {
            activeStatus=true;
          });
        }else{
          setState(() {
            activeStatus=false;
          });
        }
      } else {
        _devicesrnocontroller.text = widget.datum.srNo!.toString();
        _deviceNumbercontroller.text = widget.datum.deviceNo!;
        _deviceNmaecontroller.text = widget.datum.deviceName!;
        _modelNumbercontroller.text = widget.datum.modelNo!;
        _simCard1controller.text = widget.datum.simNo1!;
        _simCard2controller.text = widget.datum.simNo2!;
        _Imeicontroller.text = widget.datum.imeino!;
        _PortNocontroller.text = widget.datum.portNo!;
        _vendorNamecontroller.text = widget.datum.vendorName!;
        _branchNamecontroller.text = widget.datum.branchName!;
        if(widget.datum.acStatus=="Active"){
          setState(() {
            activeStatus=true;
          });
        }else{
          setState(() {
            activeStatus=false;
          });
        }
      }
    }else{
      /*randomNumber = random.nextInt(100); // from 0 upto 99 included
      print('Random number ${randomNumber}');
      if(randomNumber!=0){
        _devicesrnocontroller.text=randomNumber.toString();
      }*/
    }
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("auth_token")!;
    vendorid = sharedPreferences.getInt("VendorId")!;
    branchid = sharedPreferences.getInt("BranchId")!;
    userName = sharedPreferences.getString("Username")!;
    vendorName = sharedPreferences.getString("VendorName")!;
    branchName = sharedPreferences.getString("BranchName")!;
    userType = sharedPreferences.getString("UserType")!;
    print(token);
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

    if (userType != "") {
      _vendorNamecontroller.text = vendorName;
      _branchNamecontroller.text = branchName;
    }
    if (token != "") {
      // myFuture = getvendorname().whenComplete(() {});
      if(widget.flag==1){
        _mainBloc.add(SerialNumberEvents(token: token,apiName:"Device/GetMaxId" ));
      }else{
        getvendorname();
      }
    }
  }

  _gettoken() async {
    /*  Future<String> authToken = sessionManager.getUserToken();
    await authToken.then((data) {
      token=data.toString();
      print("authToken " + data.toString());
      if(token!=""){

      }
    },onError: (e) {
      print(e);
    });

    Future<int> vendorId = sessionManager.getVendorId();
    await vendorId.then((data) {
      branchid=data.toString();
      print("BranchId " + data.toString());
      if(branchid!=""){

      }
    },onError: (e) {
      print(e);
    });

    Future<int> branchId = sessionManager.getBranchId();
    await branchId.then((data) {
      vendorid=data.toString();
      print("VendorId " + data.toString());
      if(vendorid!=""){

      }
    },onError: (e) {
      print(e);
    });



    Future<String> username = sessionManager.getUserName();
    await username.then((data) {
      userName=data.toString();
      print("Username " + data.toString());
    },onError: (e) {
      print(e);
    });


    await sessionManager.getVendorName().then((data) {
      vendorName=data.toString();
      print("VendorName " + data.toString());
    },onError: (e){
      print(e);
    });

    await sessionManager.getBranchName().then((data) {
      branchName=data.toString();
      print("BranchName " + data.toString());
    },onError: (e){
      print(e);
    });

    sessionManager.getUserType().then((data) {
      userType=data.toString();
      if(data.toString()=="1"){
      }else{
        _vendorNamecontroller.text=vendorName;
        _branchNamecontroller.text=branchName;
      }
      print("userType " + data.toString());
    },onError: (e){
      print(e);
    });

    _mainBloc.add(AllVendorNamesEvents(token: token));
*/ // _mainBloc.add(AllBranchNamesEvents(token: token,branchid: "1"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.flag == 1 ? "ADD NEW DEVICE MASTER" : "EDIT"),
      ),
      body: _adddevicemaster(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _deviceNumbercontroller.clear();
                  _deviceNmaecontroller.clear();
                  _modelNumbercontroller.clear();
                  _simCard1controller.clear();
                  _simCard2controller.clear();
                  _Imeicontroller.clear();
                  _PortNocontroller.clear();
                  setState(() {
                    activeStatus = false;
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
                onTap: () {
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

  _adddevicemaster() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
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
          listener: (context, state) {
            if (state is AddDeviceLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is AddDeviceLoadedState) {
              setState(() {
                _isLoading = false;
              });
              if (state.addDeviceResponse.succeeded!) {
                CustomDialog()
                    .popUp(context, "New record has been successfully saved.");
                Navigator.pop(context);
              } else {
                Fluttertoast.showToast(
                  msg: state.addDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            } else if (state is AddDeviceErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.msg,
              );
            }
            if (state is AddDeviceLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is AddDeviceLoadedState) {
              setState(() {
                _isLoading = false;
              });
              if (state.addDeviceResponse.succeeded!) {
                print("add device");
                CustomDialog()
                    .popUp(context, "New record has been successfully saved.");
              } else {
                Fluttertoast.showToast(
                  msg: state.addDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            } else if (state is AddDeviceErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.msg,
              );
            } else if (state is AllVendorNamesLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is AllVendorNamesLoadedState) {
              setState(() {
                _isLoading = false;
                vendronamelist = state.vendorNameResponse;
                for (int i = 0; i < state.vendorNameResponse.length; i++) {
                  vendorNameList.add(state.vendorNameResponse[i].vendorName!);
                }
              });
              /* Fluttertoast.showToast(
                  msg:"success",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );*/
            } else if (state is AllVendorNamesErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.msg,
              );
            } else if (state is AllBranchNamesLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is AllBranchNamesLoadedState) {
              setState(() {
                _isLoading = false;
                branchnamelist = state.branchnameresponse;
              });
              /* Fluttertoast.showToast(
                  msg:"success",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );*/
            } else if (state is AllBranchNamesErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.msg,
              );
            } else if (state is EditDeviceLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is EditDeviceLoadedState) {
              setState(() {
                _isLoading = false;
              });

              CustomDialog().popUp(context, "Record successfully updated.");
            } else if (state is EditDeviceErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.msg,
              );
            }else  if (state is SerialNumberLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else  if (state is SerialNumberLoadedState) {
              setState(() {
                _isLoading = false;
                print(state.serialNumberResponse.value!);
                _devicesrnocontroller.text=state.serialNumberResponse.value!;
                getvendorname();

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
                            Text(
                              "Device ID",
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
                    controller: _devicesrnocontroller,
                    enabled: /*widget.flag == 1
                        ? true
                        :*/ false, // to trigger disabledBorder
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
                      // hintText: "HintText",
                      hintStyle: TextStyle(
                          fontSize: 16, color: MyColors.textBoxColorCode),
                      errorText: "",
                    ),
                    // controller: _passwordController,
                    // onChanged: _authenticationFormBloc.onPasswordChanged,
                    obscureText: false,
                  ),
                  /*token=="" ? Container() :*/ /*: DropDownScreen(token:token)*/ /*
                  DropdownButton(
                    items: data.map((item) {
                      return DropdownMenuItem(
                        child: Text(item['vendorName']),
                        value: item['vendorName'],
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {

                        */ /*for(int i=0;i<data!.length;i++){
                          if(data[i]["vendorName"]==newVal);
                        }*/ /*
                        vendordropdownname = newVal.toString();
                        print(newVal.toString());
                      });
                    },
                    value: vendordropdownname,
                  ),*/
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              "Device Number",
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
                    controller: _deviceNumbercontroller,
                    enabled: true, //
                    maxLength: 7, // to trigger disabledBorder
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
                              "Device Name",
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
                    controller: _deviceNmaecontroller,
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
                      // hintText: "HintText",
                      hintStyle: TextStyle(
                          fontSize: 16, color: MyColors.textBoxColorCode),
                      errorText: "",
                    ),
                    // controller: _passwordController,
                    // onChanged: _authenticationFormBloc.onPasswordChanged,
                    obscureText: false,
                  ),
                  /* DropdownButton(
                    items: data.map((item) {
                      return new DropdownMenuItem(
                        child: new Text(item['vendorName']),
                        value: item['vendorId'].toString(),
                      );
                    }).toList(),
                    onChanged: (newVal) {
                      setState(() {
                        _mySelection = newVal.toString();
                      });
                    },
                    value: _mySelection,
                  ),*/
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
                          ],
                        ),
                      )),
                  /* userType=="1" ?*/
                  // vendorNameList.length==0 ? Text(""):
                  /*  Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.textBoxBorderColorCode),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: vendordropdownname,
                          iconEnabledColor: Color(0xFF595959),
                          items: data.map((returnValue) {
                            return DropdownMenuItem<String>(
                              value: returnValue['vendorName'],
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  returnValue['vendorName'],
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: ( returnValue) {

                          */ /*  List names = [];
                            for(int i=0;i<data.length;i++){
                              if (data.contains(data[i]["vendorName"])) print("duplicate ${data[i]["vendorName"]}");
                              else print("not duplicate");
                            }
*/ /*

                            setState(() {
                              vendordropdownname = returnValue!;
                            });
                          },
                        ),
                      )),*/
                  /*Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFF2F2F2),
                        border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                    ),
                    child: DropdownButton(
                      value: dropdownvalue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Container(
                            */ /* decoration: BoxDecoration(
                              border: Border.all(color:MyColors.text3greyColorCode )
                            ),*/ /*
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
                        padding: const EdgeInsets.only(top: 10, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              "Branch Name",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )),
                  userType == "1"
                      ? Container(
                          decoration: BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              border: Border.all(
                                  color: MyColors.textBoxBorderColorCode,
                                  width: 2)),
                          child: DropdownButton(
                            value: dropdownvalue,
                            underline: SizedBox(),
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Container(
                                    /* decoration: BoxDecoration(
                              border: Border.all(color:MyColors.text3greyColorCode )
                            ),*/
                                    padding: EdgeInsets.only(left: 10),
                                    width:
                                        MediaQuery.of(context).size.width - 58,
                                    child: Text(items,
                                        style: TextStyle(fontSize: 18))),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                          ),
                        )
                      : TextField(
                          controller: _branchNamecontroller,
                          enabled: false, // to trigger disabledBorder
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: MyColors.textFieldBackgroundColorCode,
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
                                  width: 1,
                                  color: MyColors.textBoxBorderColorCode),
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
                        padding: const EdgeInsets.only(top: 12, bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              "Model Number ",
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
                    controller: _modelNumbercontroller,
                    enabled: true, // to trigger disabledBorder
                    maxLength: 20,
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
                              "Sim Card Number 1",
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
                    controller: _simCard1controller,
                    enabled: true, // to trigger disabledBorder
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
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
                              "Sim Card Number 2",
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
                    controller: _simCard2controller,
                    enabled: true, // to trigger disabledBorder
                    maxLength: 12,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
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
                              "IMEI Number",
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
                    controller: _Imeicontroller,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    enabled: true, // to trigger disabledBorder
                    maxLength: 20,
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
                              "Port Number",
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
                    controller: _PortNocontroller,
                    maxLength: 4,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
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
                              "Status",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )),
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
                            }),
                        Text(
                          "Active",
                          style: TextStyle(
                              fontSize: 18, color: MyColors.blackColorCode),
                        )
                      ],
                    ),
                  ),
                  /* Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                    ),
                    child: DropdownButton(
                      value: dropdownvalue,
                      underline: SizedBox(),
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Container(
                            */ /* decoration: BoxDecoration(
                              border: Border.all(color:MyColors.text3greyColorCode )
                            ),*/ /*
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  addnewdevice() {
    if (token != "" || branchid != "" || vendorid != "") {
      if (widget.flag == 1) {
        _mainBloc.add(AddDeviceEvents(
            adddeviceRequest: AddDeviceRequest(
                srNo: int.parse(_devicesrnocontroller.text),
                vendorSrNo: vendorid,
                branchSrNo: branchid,
                deviceNo: _deviceNumbercontroller.text,
                modelNo: _modelNumbercontroller.text,
                simNo1: _simCard1controller.text,
                simNo2: _simCard2controller.text,
                deviceName: _deviceNmaecontroller.text,
                imeino: _Imeicontroller.text,
                portNo: _PortNocontroller.text,
                acStatus: activeStatus ? 'Y' : 'N',
                acUser: userName),
            token: token));
      } else {
        _mainBloc.add(EditDeviceEvents(
            adddeviceRequest: AddDeviceRequest(
                srNo: int.parse(_devicesrnocontroller.text),
                vendorSrNo: vendorid,
                branchSrNo: branchid,
                deviceNo: _deviceNumbercontroller.text,
                modelNo: _modelNumbercontroller.text,
                simNo1: _simCard1controller.text,
                simNo2: _simCard2controller.text,
                deviceName: _deviceNmaecontroller.text,
                imeino: _Imeicontroller.text,
                portNo: _PortNocontroller.text,
                acStatus: activeStatus ? 'Y' : 'N',
                acUser: userName),
            token: token,
            deviceId: widget.searchText
                ? widget.searchData.srNo!
                : widget.datum.srNo!));
      }
    } else {}
  }

  _validation() {
    if (_devicesrnocontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Device Sr No.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_deviceNumbercontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Device Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }  else if (!validCharacters.hasMatch(_deviceNumbercontroller.text)) {
      Fluttertoast.showToast(
        msg: "Only Alphanumeric value allow in Device Number Field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

    }else if (_deviceNumbercontroller.text.length != 7) {
      Fluttertoast.showToast(
        msg: "Device Number must be 7 character..!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_deviceNmaecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Device Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }  else if (!validCharacters.hasMatch(_deviceNmaecontroller.text)) {
      Fluttertoast.showToast(
        msg: "Only Alphanumeric value allow in Device Name Field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

    }else if (_modelNumbercontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Model Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (!validCharacters.hasMatch(_modelNumbercontroller.text)) {
      Fluttertoast.showToast(
        msg: "Model Number field should contain digits & alphabets only...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );

    } else if (_simCard1controller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Sim Card Number 1",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_simCard1controller.text.length < 10 /*|| _simCard1controller.text.length > 12*/) {
      Fluttertoast.showToast(
        msg: "Please enter Sim Card Number 1 minimum 10 & maximum 12 numeric value...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_simCard2controller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please submit the Sim Card Number 2 details...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_simCard2controller.text.length < 10) {
      Fluttertoast.showToast(
        msg: "Please enter Sim Card Number 2 minimum 10 & maximum 12 numeric value...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_Imeicontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter IMEI ",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_Imeicontroller.text.length < 14) {
      Fluttertoast.showToast(
        msg: "IMEI number field minimum 14 character allowed...! ",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }/* else if (_Imeicontroller.text.length != 14) {
      Fluttertoast.showToast(
        msg: "IMEI number field minimum 14 character allowed...! ",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } */else if (_PortNocontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Port Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_PortNocontroller.text.length != 4) {
      Fluttertoast.showToast(
        msg: "Port Number field minimum 4 character allowed...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else {
      addnewdevice();
    }
  }

  Future<String> getvendorname() async {
    var response = await http.get(
      Uri.parse(Constant.vendorNameUrl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      var res = await http.get(
        Uri.parse(Constant.vendorNameUrl),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        },
      );
      var resBody = json.decode(res.body);

      setState(() {
        vendordropdownname = resBody['data'][0]["vendorName"];
        if (vendordropdownname != '') {
          data = resBody['data'];
        }
      });

      print(resBody);

      return "Success";
    } else {
      throw Exception('Failed to load data.');
    }
  }

  /*Future<String> getvendorname() async {
    var response = await http.get(Uri.parse(Constant.branchNameUrl+"1"),  headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {
      var res = await http.get(
        Uri.parse(Constant.branchNameUrl+"1"),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        },
      );
      var resBody = json.decode(res.body);

      setState(() {

        vendordropdownname=resBody[1]["branchName"];
        if(vendordropdownname!=''){
          data = resBody;
        }
      });

      print(resBody);

      return "Sucess";
    }else{
      throw Exception('Failed to load data.');
    }

  }
*/

}
