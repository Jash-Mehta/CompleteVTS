import 'dart:convert';
import 'dart:math';

import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/driver/add_driver_master_request.dart';
import 'package:flutter_vts/model/subscription/add_subscription_request.dart';
import 'package:flutter_vts/model/subscription/edit_subscription_resquest.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../model/subscription/subscription_master_response.dart';
import 'package:snippet_coder_utils/FormHelper.dart';



class AddSubscriptionMasterScreen extends StatefulWidget {
  int flag;
  bool searchText;
  Datum ? datalist;
  Data searchData;

  AddSubscriptionMasterScreen({Key? key,required this.flag,required this.searchText,required this.datalist,required this.searchData}) : super(key: key);

  @override
  _AddSubscriptionMasterScreenState createState() => _AddSubscriptionMasterScreenState();
}

class _AddSubscriptionMasterScreenState extends State<AddSubscriptionMasterScreen> {

  String dropdownvalue = 'Item 1';
  String usernamedropdown = '';
  String selectedusername = '';

  int userid = 0;
  int userid1 = 0;

  List data =[];

  TextEditingController _subscriptionsrnocontroller = new TextEditingController();
  TextEditingController _driverCodecontroller = new TextEditingController();
  TextEditingController _usernamecontroller = new TextEditingController();
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _fromdatecontroller = new TextEditingController();
  TextEditingController _todatecontroller = new TextEditingController();

  TextEditingController _branchNamecontroller = new TextEditingController();

  bool activeStatus = false;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token="";
  late SharedPreferences sharedPreferences;
  late String userName="";
  late String vendorName="",branchName="",userType="";
  late int branchid=0,vendorid=0;


  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  DateTime selectedDate = DateTime.now();
  DateTime toselectedDate = DateTime.now();

  late String date='',tilldate='';

  Random random = new Random();
  int randomNumber=0;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        // firstDate: DateTime(2015, 8),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2102)
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _fromdatecontroller.text=selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
        date=selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();

      });
    }
  }

  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toselectedDate,
        firstDate: DateTime.now(),
        // firstDate: DateTime(2015, 8),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2102)
    );
    if (picked != null && picked != toselectedDate) {
      setState(() {
        toselectedDate = picked;
        _todatecontroller.text=toselectedDate.day.toString()+"/"+toselectedDate.month.toString()+"/"+toselectedDate.year.toString();
        tilldate=toselectedDate.year.toString()+"-"+toselectedDate.month.toString()+"-"+toselectedDate.day.toString();

      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainBloc = BlocProvider.of(context);
    getdata();

    print(widget.datalist!.userName!);


     if(widget.flag==2){
       if(widget.searchText){
         _subscriptionsrnocontroller.text=widget.searchData.srNo.toString();
         _fromdatecontroller.text=widget.searchData.validFrom!.day.toString()+"/"+widget.searchData.validFrom!.month.toString()+"/"+widget.searchData.validFrom!.year.toString();
         _todatecontroller.text=widget.searchData.validTill!.day.toString()+"/"+widget.searchData.validTill!.month.toString()+"/"+widget.searchData.validTill!.year.toString();
         date=widget.searchData.validFrom!.year.toString()+"-"+widget.searchData.validFrom!.month.toString()+"-"+widget.searchData.validFrom!.day.toString();
         tilldate=widget.searchData.validTill!.year.toString()+"-"+widget.searchData.validTill!.month.toString()+"-"+widget.searchData.validTill!.day.toString();

         setState(() {
           userid=widget.searchData.userId!;
           userid1=widget.searchData.userId!;
           selectedusername=widget.searchData.userName!;
           if(widget.searchData.acStatus=='Active'){
             activeStatus=true;
           }else{
             activeStatus=false;
           }
         });
       }else{
         _subscriptionsrnocontroller.text=widget.datalist!.srNo.toString();
         _fromdatecontroller.text=widget.datalist!.validFrom!.day.toString()+"/"+widget.datalist!.validFrom!.month.toString()+"/"+widget.datalist!.validFrom!.year.toString();
         _todatecontroller.text=widget.datalist!.validTill!.day.toString()+"/"+widget.datalist!.validTill!.month.toString()+"/"+widget.datalist!.validTill!.year.toString();
         date=widget.datalist!.validFrom!.year.toString()+"-"+widget.datalist!.validFrom!.month.toString()+"-"+widget.datalist!.validFrom!.day.toString();
         tilldate=widget.datalist!.validTill!.year.toString()+"-"+widget.datalist!.validTill!.month.toString()+"-"+widget.datalist!.validTill!.day.toString();

         setState(() {
           userid=widget.datalist!.userId!;
           userid1=widget.datalist!.userId!;

           selectedusername=widget.datalist!.userName!;

           if(widget.datalist!.acStatus=='Active'){
             activeStatus=true;
           }else{
             activeStatus=false;
           }
         });
       }

    }else{
     /*  randomNumber = random.nextInt(100); // from 0 upto 99 included
       print('Random number ${randomNumber}');
       if(randomNumber!=0){
         _subscriptionsrnocontroller.text=randomNumber.toString();
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
    if(token!=""){
      if(widget.flag==1){
        _mainBloc.add(SerialNumberEvents(token: token,apiName:"Subscription/GetMaxId" ));
      }else{
        getusers();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SUBSCRIPTION SETTING"),
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
                  _fromdatecontroller.clear();
                  _todatecontroller.clear();
                  setState(() {
                    selectedusername='';
                    usernamedropdown='';
                    userid1=0;
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
                  // print(userid1);

                  _validation();

                  // DateTime now = new DateTime.now();
                  // String date1=now.year.toString()+"-"+now.month.toString()+"-"+now.day.toString();
                  // print("from date $date , till date $tilldate  : date  $date1" );
                  // print(userid.toString());

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
          if (state is AddSubscriptionLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AddSubscriptionLoadedState) {
            setState(() {
              _isLoading = false;
            });

            if(state.editDeviceResponse.succeeded!=null){
              if(state.editDeviceResponse.succeeded!){
                CustomDialog().popUp(context,"New record has been successfully saved.");
              }else{
                Fluttertoast.showToast(
                  msg:state.editDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }

          }else if (state is AddSubscriptionErrorState) {
            setState(() {
              _isLoading = false;
            });
          }if (state is UpdateSubscriptionLoadingState) {
            setState(() {
              _isLoading = true;
            });

          }else if (state is UpdateSubscriptionLoadedState) {
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

          }else if (state is UpdateSubscriptionErrorState) {
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
              _subscriptionsrnocontroller.text=state.serialNumberResponse.value!;
              getusers();

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
                  controller: _subscriptionsrnocontroller,
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color:MyColors.whiteColorCode,

                  ),
                  width: MediaQuery.of(context).size.width,
                  child: FormHelper.dropDownWidget(
                    context,
                    selectedusername!='' ? selectedusername : "Select",
                    this.usernamedropdown,
                    this.data,
                        (onChangeVal){
                      setState(() {
                        this.usernamedropdown=onChangeVal;
                        userid1=int.parse(onChangeVal);
                        print("Selected Product : $userid1");
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
                    optionValue: "userId",
                    optionLabel: "userName",
                    // paddingLeft:20

                  ),
                ),
              /*  token=="" ? Container() :
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    items: data.map((item) {
                      setState(() {
                        userid=item['userId'];
                      });
                      return DropdownMenuItem(
                        child:  Container(
                          *//* decoration: BoxDecoration(
                              border: Border.all(color:MyColors.text3greyColorCode )
                            ),*//*
                            padding: EdgeInsets.only(left: 10),
                            width: MediaQuery.of(context).size.width-58,
                            child: Text(item['userName'],style: TextStyle(fontSize: 18))
                        ),
                        value: item['userName'],
                      );
                    }).toList(),

                    onChanged: (newVal) {
                      setState(() {
                        usernamedropdown = newVal.toString();
                        print(newVal.toString());
                        for(int i=0;i<data.length;i++){
                          if(data[i]['userName']==newVal){
                            // userid=data[i]['userId'];
                            userid1=data[i]['userId'];

                            print(data[i]['userId']);
                          }
                        }
                        // print();
                      });
                    },
                    value: usernamedropdown,
                  ),
                ),
*/
               /* TextField(
                  controller: _usernamecontroller,
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
                ),*/
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:15,bottom: 8),
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
                          Text("Valid Form", style: TextStyle(fontSize: 18),),
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
                    hintText: "DD/MM/YYYY",

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
                          Text("Valid Till", style: TextStyle(fontSize: 18),),
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
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _toDate(context);
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
                    hintText: "DD/MM/YYYY",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.datePlacehoderColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  _validation() {
    if (_subscriptionsrnocontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Driver Sr No.",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (userid1==0) {
      Fluttertoast.showToast(
        msg: "Please Select Username",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_fromdatecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter The Valid From Date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if (_todatecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter The Valid Till Date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(selectedDate.compareTo(toselectedDate)==1){
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else {

      if(widget.flag==1){
        print("edit");
        _mainBloc.add(AddSubscriptionEvents(addSubscriptionRequest: AddSubscriptionRequest(
          vendorSrNo: vendorid,
          branchSrNo: branchid,
          userId: userid1,
          validFrom:date,
          validTill:tilldate,
          acUser:userName,
          acStatus:activeStatus ? 'Y': 'N',
        ),
          token: token,
        ));
      }else{
          _mainBloc.add(UpdateSubscriptionEvents(editSubscriptionRequest: EditSubscriptionRequest(
           srNo: widget.datalist!.srNo! ,
            vendorSrNo: vendorid,
            branchSrNo: branchid,
            userId: userid1,
            validFrom: date,
            validTill: tilldate,
            acUser:userName,
            acStatus:activeStatus ? 'Y': 'N',
          ),
              token: token,
              subid: widget.datalist!.srNo!,
          ));
      }

    }
  }


  Future<String> getusers() async {
    setState(() {
      _isLoading=true;
    });
    var response = await http.get(Uri.parse(Constant.userNameUrl+""+vendorid.toString()+"/"+branchid.toString()),  headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {
      var res = await http.get(
        Uri.parse(Constant.userNameUrl+""+vendorid.toString()+"/"+branchid.toString()),
        headers: <String, String>{
          'Authorization': "Bearer $token",
        },
      );
      var resBody = json.decode(res.body);

      setState(() {
        _isLoading=false;

        // if(widget.flag==1){
          usernamedropdown=resBody['data'][0]["userName"];

        // userid1=resBody[1]["userId"];

        if(userName!=''){
          data = resBody['data'];
        }
        /*}else{

          for(int i=0;i<resBody.length;i++){
            print("suces");
            if(resBody[i]['userId']==widget.datalist!.userId){
              print("suce");

              usernamedropdown=resBody[i]["userName"];
              userid=resBody[i]['userId'];
            }else{
              print("suce 1");

            }
          }
        }*/

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



