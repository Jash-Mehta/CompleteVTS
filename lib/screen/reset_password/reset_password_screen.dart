import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/login/forget_password_request.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';

class ResetPassword extends StatefulWidget {
  // const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  int userid = 0;
  int userid1 = 0;
  late bool _isLoading = false;
  String usernamedropdown = '';
  String selectedusername = '';

  late MainBloc _mainBloc;
  late String token="";
  late SharedPreferences sharedPreferences;
  late String userName="";
  late String vendorName="",branchName="",userType="";
  late int branchid=0,vendorid=0;
  List data =[];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late bool _dropdownclick = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainBloc = BlocProvider.of(context);

    getdata();
    // getusers();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("RESET PASSWORD",_scaffoldKey,0,context),
      body: _resetPassword(),
    );
  }

  _resetPassword(){
    return
      LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Color(0xFFCE4A6F),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child: BlocListener<MainBloc, MainState>(
          listener: (context,state){
            if (state is ResetPasswordLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else  if (state is ResetPasswordLoadedState) {
              setState(() {
                _isLoading = false;
              });
              if(state.editDeviceResponse.message!=null){
                Fluttertoast.showToast(
                  msg: state.editDeviceResponse.message!/*"Reset Password Successfully...!!"*/,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }else{
                Fluttertoast.showToast(
                  msg:"Something Went Wrong,please try again...!!",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }

            }else  if (state is ResetPasswordErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                msg: "Something Went Wrong,please try again...!!",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }
          },
          child: SingleChildScrollView(
            child:Padding(
              padding: const EdgeInsets.only(top:15.0,right: 15,left: 15),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0, bottom: 8),
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
                      // "Select product",
                       selectedusername=="" ? "Select" :"Select",
                      this.usernamedropdown,
                      this.data,
                          (onChangeVal){
                        setState(() {
                          this.usernamedropdown=onChangeVal;

                          for(int i=0;i<data.length;i++){
                            if(onChangeVal=="${data[i]["userId"]}"){
                              selectedusername=data[i]["userName"];
                              print(data[i]["userName"]);
                            }
                          }
                          userid1=int.parse(onChangeVal);
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
                      optionValue: "userId",
                      optionLabel: "userName",
                      // paddingLeft:20

                    ),
                  ),


                  // token=="" ? Container() :
                 /* GestureDetector(
                    onTap: (){
                      print("click");
                      setState(() {
                        _dropdownclick=true;
                      });
                      getusers();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                      ),
                      child: DropdownButton(
                        underline: SizedBox(),
                        hint:Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width-80,
                                  child: Text("All" )
                              ),
                              // Icon(Icons.keyboard_arrow_down)
                              // Text("All" ),

                            ],
                          ),
                        ),
                        // iconSize:_dropdownclick ? 12:0,
                        onTap: (){
                          print("click");
                        },
                        items: data.map((item) {
                          setState(() {
                            userid=item['userId'];
                          });
                          return DropdownMenuItem(
                            child:  Container(
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
                        icon: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),*/
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 148,
                            height: 48,
                            padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: MyColors.dateIconColorCode)
                            ),
                            child: Text("Close",style: TextStyle(color: MyColors.text4ColorCode,fontSize: 20)),
                          ),
                        ),

                        GestureDetector(
                          onTap:(){
                            // print(userid1);
                            _validation();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: 148,
                            height: 48,
                            margin: const EdgeInsets.only(left: 15),
                            padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                            decoration: BoxDecoration(
                                color: MyColors.blueColorCode,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: MyColors.textBoxBorderColorCode)
                            ),
                            child: Text("Reset",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
                          ),
                        )

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
    if (selectedusername == '') {
      Fluttertoast.showToast(
        msg: "Please Select Username...!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else {

      // print(userid);
      // print(selectedusername);

      _mainBloc.add(ResetPasswordEvents(
          token:token,
          resetPasswordRequest: ResetPasswordRequest(
              userId: userid1, //int.parse(widget.userid),
              vendorSrNo: vendorid,
              branchSrNo: vendorid,
              resetBy: selectedusername
          ))
      );
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
    userid=sharedPreferences.getInt("UserID")!;

    print("token: $token");

    if(token!=""){
      getusers();
    }
  }


  Future<String> getusers() async {
    setState(() {
      _isLoading=true;
    });

    print(Constant.userNameUrl+"" +vendorid.toString()+"/"+branchid.toString());
    var response = await http.get(Uri.parse(Constant.userNameUrl+"" +vendorid.toString()+"/"+branchid.toString()
    ),  headers: <String, String>{
      'Authorization': "Bearer $token",
    },);
    if (response.statusCode == 200) {

      var resBody = json.decode(response.body);

      setState(() {
        _isLoading=false;

        // if(widget.flag==1){
        usernamedropdown=resBody['data'][0]["userName"];
        // userid=resBody[1]["userId"];
        // userid1=resBody[1]["userId"];
        data = resBody['data'];
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