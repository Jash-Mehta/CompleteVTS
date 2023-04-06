import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:email_validator/email_validator.dart';


class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {

  ScrollController vehicleassignController = new ScrollController();
  ScrollController menuassignController = new ScrollController();

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token = "";
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 0, vendorid = 0,profileid = 0,userId=0;
  late GetProfileResponse getProfileResponse;
  List<Datum>? data=[];
  int profilePosition=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);
    getdata();
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
    if (sharedPreferences.getInt("UserID") != null) {
      userId = sharedPreferences.getInt("UserID")!;
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

      getprofiledetails();
    }
  }

  getprofiledetails(){
    _mainBloc.add(ProfileDetailsEvents(token:token,vendorId:vendorid, branchId: branchid,profileid:userId  ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VIEW PROFILE DETAILS"),
        actions: [
          GestureDetector(
            onTap: (){
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) =>
              //             BlocProvider(
              //                 create: (context) {
              //                   return MainBloc(
              //                       webService: WebService());
              //                 },
              //                 child: ProfileEditScreen(data: data![0],))
              //     )
              // );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Image.asset(
                'assets/profile_edit.png',
                height: 40,
                width: 40,
              ),
            ),
          ),
        ],
      ),

      body: _profiledetail(),
    );
  }



  _profiledetail(){
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: MyColors.appDefaultColorCode,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener:(context,state){
          if (state is GetProfileDetailsLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is GetProfileDetailsLoadedState) {
            setState(() {
              _isLoading = false;
              data=state.getProfileResponse.data;
            });
          }else  if (state is GetProfileDetailsErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: data!.length==0 ? Container() : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  margin: EdgeInsets.only(top:15),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    // padding: EdgeInsets.only(top:15,left:14,right:14,bottom: 15),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                color: MyColors.notificationblueColorCode,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: const EdgeInsets.only(left: 10.0),
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              child: Text("Profile",style: TextStyle(fontSize: 18,color: MyColors.textColorCode),)
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:10,left: 10.0,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Joined",style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode)),
                                Text("25/01/2022",style: TextStyle(fontSize: 16,color: MyColors.textColorCode)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0,bottom: 10,left: 10,right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Last Seen",style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode)),
                                Text(data![0].lastSeen!/*"Thursday,10/01/2022 | 02:03 01 PM"*/,style: TextStyle(fontSize: 16,color: MyColors.textColorCode)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0,right: 10,bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Account Status",style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode)),
                                Text(data![0].accountStatus!=null ? data![0].accountStatus!.toString() : "",style: TextStyle(fontSize: 16,color: MyColors.textColorCode)),
                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ),
                _otherInformation(),
                _vehicleAssigned(),
                _menuAssigned()
              ],
            ),
          ),
        ),
      ),
    );
  }


  _otherInformation(){
    return Card(
      margin: EdgeInsets.only(top:15),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),

          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: MyColors.notificationblueColorCode,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: const EdgeInsets.only(left: 10.0),
                  margin: const EdgeInsets.only(bottom: 10.0),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Text("Other Information",style: TextStyle(fontSize: 18,color: MyColors.textColorCode),)
              ),
              _otherDetail("User Id",data![0].userId!.toString()),
              _otherDetail("Name",data![0].userName!),
              _otherDetail("Email",data![0].emailId!),
              _otherDetail("User Type",data![0].userType!),
              _otherDetail("Vendor Name",data![0].vendorName!),
              _otherDetail("Branch Name",data![0].branchName!),
              _otherDetail("Subscription Valid From",data![0].subscriptionValidFrom!),
              _otherDetail("Subscription Valid Till",data![0].subscriptionValidTill!),
              /* Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Divider(
                  height: 1,
                  color: MyColors.greenColorCode,
                ),
              ),*/
              /*   Padding(
                padding: const EdgeInsets.only(top: 10.0,left: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _socialMedia("assets/facebook.png"),
                    _socialMedia("assets/twitter.png"),
                    _socialMedia("assets/linkdin.png"),
                    _socialMedia("assets/game.png"),
                    _socialMedia("assets/google.png"),
                  ],
                ),
              )*/

            ],
          )
      ),
    );
  }

  _otherDetail(String title,String detail){
    return  Padding(
      padding: const EdgeInsets.only(top:12,left: 10.0,right: 10),
      child: Row(
        children: [
          Expanded(
              child: Text(title,style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode))
          ),
          Expanded(
              child: Text(":  ${detail}",style: TextStyle(fontSize: 16,color: MyColors.textColorCode))
          ),
        ],
      ),
    );
  }

  _socialMedia(String image){
    return Container(
      margin: EdgeInsets.only(right: 10),
      /*padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: MyColors.notificationblueColorCode,
        shape: BoxShape.circle,
      ),*/
      child:  Image.asset(image,width: 46,height: 46,)/*Icon(Icons.facebook,color: MyColors.appDefaultColorCode,)*/,
    );
  }

  _vehicleAssigned(){
    return
      Card(
        margin: EdgeInsets.only(top:15),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          // padding: EdgeInsets.only(top:15,left:14,right:14,bottom: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: MyColors.notificationblueColorCode,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Text("Vehicle Assigned",style: TextStyle(fontSize: 18,color: MyColors.textColorCode),)
                ),
                ListView.builder(
                    controller: vehicleassignController,
                    shrinkWrap: true,
                    itemCount: data![0].vehicleAssignedList!.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.only(top:10,left: 10.0,right: 10),
                        child: Text(data![0].vehicleAssignedList![index].vehicleRegNo!,style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode)),
                      );
                    }
                ),
              ],
            )
        ),
      );
  }

  _menuAssigned(){
    return
      Card(
        margin: EdgeInsets.only(top:15),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          // padding: EdgeInsets.only(top:15,left:14,right:14,bottom: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: MyColors.notificationblueColorCode,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: const EdgeInsets.only(left: 10.0),
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Text("Menu Assigned",style: TextStyle(fontSize: 18,color: MyColors.textColorCode),)
                ),
                ListView.builder(
                    controller: menuassignController,
                    shrinkWrap: true,
                    itemCount: data![0].menuAssignedList!.length,
                    itemBuilder: (context,index){
                      return Padding(
                        padding: const EdgeInsets.only(top:10,left: 10.0,right: 10),
                        child: Text(data![0].menuAssignedList![index].menuCaption!,style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode)),
                      );
                    }
                ),
                /*  _simpletext("Vender Master"),
                _simpletext("Branch Master"),
                _simpletext("Device configuration Master"),
                _simpletext("Driver Entry Master"),
                Padding(
                  padding: const EdgeInsets.only(bottom:10),
                  child:  _simpletext("Vehicle Entry Master")
                )*/

              ],
            )
        ),
      );
  }

  _simpletext(String title){
    return  Padding(
      padding: const EdgeInsets.only(top:10,left: 10.0,right: 10),
      child: Text(title,style: TextStyle(fontSize: 16,color: MyColors.textprofiledetailColorCode)),
    );
  }
}

//----------------------------------------------------------

// To parse this JSON data, do
//
//     final getProfileResponse = getProfileResponseFromJson(jsonString);


GetProfileResponse getProfileResponseFromJson(String str) => GetProfileResponse.fromJson(json.decode(str));

String getProfileResponseToJson(GetProfileResponse data) => json.encode(data.toJson());

class GetProfileResponse {
  GetProfileResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datum>? data;
  bool ?succeeded;
  dynamic errors;
  String ?message;

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) => GetProfileResponse(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datum {
  Datum({
    this.userId,
    this.userName,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.emailId,
    this.userType,
    this.lastUpdatedDate,
    this.lastSeen,
    this.accountStatus,
    this.subscriptionValidFrom,
    this.subscriptionValidTill,
    this.profilePhoto,
    this.vehicleAssignedList,
    this.menuAssignedList,
  });

  int? userId;
  String? userName;
  int ?vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String? branchName;
  String? emailId;
  String ?userType;
  String ?lastUpdatedDate;
  String ?lastSeen;
  String ?accountStatus;
  String ?subscriptionValidFrom;
  String ?subscriptionValidTill;
  dynamic ?profilePhoto;
  List<VehicleAssignedList>? vehicleAssignedList;
  List<MenuAssignedList> ?menuAssignedList;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["userId"],
    userName: json["userName"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    emailId: json["emailId"],
    userType: json["userType"],
    lastUpdatedDate: json["lastUpdatedDate"],
    lastSeen: json["lastSeen"],
    accountStatus: json["accountStatus"],
    subscriptionValidFrom: json["subscriptionValidFrom"],
    subscriptionValidTill: json["subscriptionValidTill"],
    profilePhoto: json["profilePhoto"],
    vehicleAssignedList: List<VehicleAssignedList>.from(json["vehicleAssignedList"].map((x) => VehicleAssignedList.fromJson(x))),
    menuAssignedList: List<MenuAssignedList>.from(json["menuAssignedList"].map((x) => MenuAssignedList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "emailId": emailId,
    "userType": userType,
    "lastUpdatedDate": lastUpdatedDate,
    "lastSeen": lastSeen,
    "accountStatus": accountStatus,
    "subscriptionValidFrom": subscriptionValidFrom,
    "subscriptionValidTill": subscriptionValidTill,
    "profilePhoto": profilePhoto,
    "vehicleAssignedList": List<dynamic>.from(vehicleAssignedList!.map((x) => x.toJson())),
    "menuAssignedList": List<dynamic>.from(menuAssignedList!.map((x) => x.toJson())),
  };
}

class MenuAssignedList {
  MenuAssignedList({
    this.menuId,
    this.menuCaption,
  });

  int ?menuId;
  String ?menuCaption;

  factory MenuAssignedList.fromJson(Map<String, dynamic> json) => MenuAssignedList(
    menuId: json["menuId"],
    menuCaption: json["menuCaption"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuCaption": menuCaption,
  };
}

class VehicleAssignedList {
  VehicleAssignedList({
    this.vehicleId,
    this.vehicleRegNo,
  });

  int? vehicleId;
  String ?vehicleRegNo;

  factory VehicleAssignedList.fromJson(Map<String, dynamic> json) => VehicleAssignedList(
    vehicleId: json["vehicleId"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "vehicleRegNo": vehicleRegNo,
  };
}

// -------------------------------------------------------------------------------
class ProfileEditScreen extends StatefulWidget {
  Datum data;

  ProfileEditScreen({Key? key,required this.data}) : super(key: key);

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  TextEditingController _useridcontroller=new TextEditingController();
  TextEditingController _vendorNamecontroller=new TextEditingController();
  TextEditingController _branchNamecontroller=new TextEditingController();
  TextEditingController _userNamecontroller = new TextEditingController();
  TextEditingController _emailcontroller = new TextEditingController();
  TextEditingController _subtodatecontroller = new TextEditingController();
  TextEditingController _subfromdatecontroller = new TextEditingController();
  late bool _isLoading = false;
  List data = [];
  String userTypedropdown = '';
  String selectedUserType="";
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  late MainBloc _mainBloc;
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "",
      branchName = "",
      userType = "";
  late int branchid = 0,
      vendorid = 0;
  late String token = "";
  int userid=0;
  String userTypeid="";
  DateTime selectedDate = DateTime.now();
  DateTime toselectedDate = DateTime.now();

  late String date='',tilldate='';
  DateTime formDate = DateTime.now();
  DateTime tillDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    setState(() {
      _userNamecontroller.text=widget.data.userName!;
      _emailcontroller.text=widget.data.emailId!;
      _subfromdatecontroller.text= widget.data.subscriptionValidFrom!;
      _subtodatecontroller.text= widget.data.subscriptionValidTill!;
      selectedUserType=widget.data.userType!;
    });

    getdata();
  }


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
        _subfromdatecontroller.text=selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
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
        _subtodatecontroller.text=toselectedDate.day.toString()+"/"+toselectedDate.month.toString()+"/"+toselectedDate.year.toString();
        tilldate=toselectedDate.year.toString()+"-"+toselectedDate.month.toString()+"-"+toselectedDate.day.toString();

      });
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

    userid = sharedPreferences.getInt("UserID")!;
    _useridcontroller.text=userid.toString();


    if (userType != "") {
      _vendorNamecontroller.text = vendorName;
      _branchNamecontroller.text = branchName;
    }

    if (token != "") {
      getUserlist();
    }
  }

  _updateprofile(){
    _mainBloc.add(UpdateProfileEvents(userId:userid,
        profileUpdateRequest : ProfileUpdateRequest(
            userId: userid,
            userName: _userNamecontroller.text,
            vendorSrNo: vendorid,
            branchSrNo: branchid,
            userPwd: "19diJC9yqSaXf/QgO4P8gQ==",
            userTypeId: userTypeid,
            emailId: _emailcontroller.text,
            acUser: "",
            acFlag: "y",
            validFrom: formDate,
            validTill: tillDate,
            profilePhoto: "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",
            vehicleList: [],
            menuList: []
        ),token:token));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.appBarColorCode,
        title: Text("EDIT"),
        actions: [

        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  // _driverCodecontroller.clear();
                  // _driverNmaecontroller.clear();
                  // _livenceNumbercontroller.clear();
                  // _dojcontroller.clear();
                  // _mobileNocontroller.clear();
                  // _citycontroller.clear();
                  // _addresscontroller.clear();
                  // setState(() {
                  //   activeStatus=false;
                  // });
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
                  // validation();
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
                  child: Text("Update", style: TextStyle(
                      color: MyColors.whiteColorCode, fontSize: 20),),
                ),
              )
            ],
          ),
        ),

      ),
      body: _editProfile(),
    );
  }

  _editProfile(){
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: MyColors.appDefaultColorCode,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context,state){
          if (state is UpdateProfileLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is UpdateProfileLoadedState) {
            setState(() {
              _isLoading = false;
            });
          }else if (state is UpdateProfileErrorState) {
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
                      padding:  EdgeInsets.only(top:4.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("User ID",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _useridcontroller,
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
                          Text("Subscription Valid From",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _subfromdatecontroller,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _selectDate(context);
                  },
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
                          Text("Subscription Valid Till",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _subtodatecontroller,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _toDate(context);
                  },
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
                          Text("Name",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _userNamecontroller,
                  textCapitalization: TextCapitalization.characters,
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
                          Text("Email",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _emailcontroller,
                  textCapitalization: TextCapitalization.characters,
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
                          Text("User Type",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding:  EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
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
                    // "Select product",
                    selectedUserType=='' ?  "Select" :selectedUserType,
                    this.userTypedropdown,
                    this.data,
                        (onChangeVal){
                      setState(() {
                        this.userTypedropdown=onChangeVal;
                        userTypeid=int.parse(onChangeVal).toString();
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  validation(){
    /*  if(_vendorNamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Something Went Wrong, please try again",
      );
    }else if(_branchNamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Something Went Wrong, please try again",
      );
    } if(_subfromdatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Something Went Wrong, please try again",
      );
    }else  if(_subtodatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Something Went Wrong, please try again",
      );
    }else*/if(selectedDate.compareTo(toselectedDate)==1){
      Fluttertoast.showToast(
        msg: "Please check Subscription Valid From & To date! Subscription Valid From data should be less than to To date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_userNamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please enter Username...!",
      );
    } else if (!validCharacters.hasMatch(_userNamecontroller.text)) {
      Fluttertoast.showToast(
        msg: "Only Alphanumeric value allow in Username Field...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else  if(_emailcontroller.text.isEmpty){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please enter Email-ID...!",
      );
    }else if(!EmailValidator.validate(_emailcontroller.text)){
      Fluttertoast.showToast(
        msg: "Please Enter Valid Email-Id",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else  if(userTypeid==""){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please select User Type...!",
      );
    }else{
      _updateprofile();

    }
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
        data = resBody['data'];
      });
      print(resBody);
      return "Success";
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data.');
    }
  }
}


//---------------------------------------------------------------



ProfileUpdateRequest profileUpdateRequestFromJson(String str) => ProfileUpdateRequest.fromJson(json.decode(str));

String profileUpdateRequestToJson(ProfileUpdateRequest data) => json.encode(data.toJson());

class ProfileUpdateRequest {
  ProfileUpdateRequest({
    this.userId,
    this.userName,
    this.vendorSrNo,
    this.branchSrNo,
    this.userPwd,
    this.userTypeId,
    this.emailId,
    this.acUser,
    this.acFlag,
    this.validFrom,
    this.validTill,
    this.profilePhoto,
    this.vehicleList,
    this.menuList,
  });

  int? userId;
  String ?userName;
  int ?vendorSrNo;
  int ?branchSrNo;
  String ?userPwd;
  String ?userTypeId;
  String ?emailId;
  String ?acUser;
  String ?acFlag;
  DateTime? validFrom;
  DateTime ?validTill;
  String ?profilePhoto;
  List<VehicleList>? vehicleList;
  List<MenuList> ?menuList;

  factory ProfileUpdateRequest.fromJson(Map<String, dynamic> json) => ProfileUpdateRequest(
    userId:json["userId"]==null ? null : json["userId"],
    userName:json["userName"]==null ? null : json["userName"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    branchSrNo:json["branchSrNo"]==null ? null : json["branchSrNo"],
    userPwd:json["userPwd"]==null ? null : json["userPwd"],
    userTypeId:json["userTypeId"]==null ? null : json["userTypeId"],
    emailId: json["emailId"]==null ? null :json["emailId"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acFlag: json["acFlag"]==null ? null :json["acFlag"],
    validFrom: json["validFrom"]==null ? null :DateTime.parse(json["validFrom"]),
    validTill: json["validTill"]==null ? null :DateTime.parse(json["validTill"]),
    profilePhoto:json["profilePhoto"]==null ? null : json["profilePhoto"],
    vehicleList: json["vehicleList"]==null ? null :List<VehicleList>.from(json["vehicleList"].map((x) => VehicleList.fromJson(x))),
    menuList:json["menuList"]==null ? null : List<MenuList>.from(json["menuList"].map((x) => MenuList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "userPwd": userPwd,
    "userTypeId": userTypeId,
    "emailId": emailId,
    "acUser": acUser,
    "acFlag": acFlag,
    "validFrom": "${validFrom!.year.toString().padLeft(4, '0')}-${validFrom!.month.toString().padLeft(2, '0')}-${validFrom!.day.toString().padLeft(2, '0')}",
    "validTill": "${validTill!.year.toString().padLeft(4, '0')}-${validTill!.month.toString().padLeft(2, '0')}-${validTill!.day.toString().padLeft(2, '0')}",
    "profilePhoto": profilePhoto,
    "vehicleList": List<dynamic>.from(vehicleList!.map((x) => x.toJson())),
    "menuList": List<dynamic>.from(menuList!.map((x) => x.toJson())),
  };
}

class MenuList {
  MenuList({
    this.menuId,
  });

  int ?menuId;

  factory MenuList.fromJson(Map<String, dynamic> json) => MenuList(
    menuId:json["menuId"]==null ? null : json["menuId"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
  };
}

class VehicleList {
  VehicleList({
    this.vehicleId,
  });

  int ?vehicleId;

  factory VehicleList.fromJson(Map<String, dynamic> json) => VehicleList(
    vehicleId:json["vehicleId"]==null ? null : json["vehicleId"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
  };
}
