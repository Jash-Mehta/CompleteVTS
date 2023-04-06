import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:email_validator/email_validator.dart';

class ForgetPasswordScreen extends StatefulWidget {
  // const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late SharedPreferences sharedPreferences;
  late String token;
  late bool _isLoading = false;
  late MainBloc _mainBloc;
  TextEditingController emailidcontroller=new TextEditingController();
  late int branchid = 0, vendorid = 0;
  int pageNumber=1;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";

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

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("FORGET PASSWORD"),
      ),
      body: _changePassword(),
    );
  }



  _changePassword(){
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
          if (state is CheckForgetPasswordUserLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else   if (state is CheckForgetPasswordUserLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if (state.checkForgetPasswordUserResponse.succeeded != null) {
              if (state.checkForgetPasswordUserResponse.succeeded!) {
                Fluttertoast.showToast(
                  msg: "Email-ID verify successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
                /* Navigator.push(context,
                    MaterialPageRoute(builder: (_) => BlocProvider(
                        create: (context) {
                          return MainBloc(webService: WebService());
                        },
                        child: ChangePasswordScreen(userid: state.checkForgetPasswordUserResponse.value!,)
                    )));*/
                // CustomDialog()
                //     .popUp(context, state.checkForgetPasswordUserResponse.message!);
              } else {
                Fluttertoast.showToast(
                  msg: "This Email-ID does not exist,please try another one.",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }
          }else   if (state is CheckForgetPasswordUserErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          child:Padding(
            padding: const EdgeInsets.only(top:100.0,left: 15,right: 15,bottom: 20),
            child: Column(
              children: [
                Text("FORGOT PASSWORD",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:30.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("Register Email Id",style: TextStyle(fontSize: 18,color: MyColors.blackColorCode),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: emailidcontroller,
                  enabled: true, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
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
                    labelText: "example@gmail.com",
                    labelStyle: TextStyle(fontSize: 16,color: MyColors.textfieldlableColorCode),
                    // hintStyle: TextStyle(fontSize: 16,color:  MyColors.textBoxColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                /*Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:6.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("New Password",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  enabled: true, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
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
                        borderSide: BorderSide(width: 1,color: Colors.black)
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
                      padding: const EdgeInsets.only(top:6.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("Confirm Password",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  enabled: true, // to trigger disabledBorder
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF2F2F2),
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
                        borderSide: BorderSide(width: 1,color: Colors.black)
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
                ),*/
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /* Container(
                        alignment: Alignment.center,
                        width: 148,
                        height: 48,
                        padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: MyColors.textBoxBorderColorCode)
                        ),
                        child: Text("Close",style: TextStyle(color: MyColors.textColorCode,fontSize: 20)),
                      ),*/

                      GestureDetector(
                        onTap:(){
                          // CustomDialog().popUp(context,"Link successfully sent on your register email.");

                          if(!EmailValidator.validate(emailidcontroller.text)){
                            Fluttertoast.showToast(
                              msg: "Please Enter Valid Email-Id",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,);
                          }else{
                            print("success");
                            _mainBloc.add(CheckForgetPasswordUserEvents(token: token, searchEmaitId: emailidcontroller.text));
                          }

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
                          child: Text("Save",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
                        ),
                      )

                    ],
                  ),
                ),
                /* GestureDetector(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => BlocProvider(
                            create: (context) {
                              return MainBloc(webService: WebService());
                            },
                            child: LoginScreen()
                        )));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top:10,bottom: 10.0),
                    child: Text("Forget Password" *//*"Back to login"*//*,style: TextStyle(decoration:TextDecoration.underline,color: MyColors.blueColorCode,fontSize: 18),),
                  ),
                ),*/
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}
