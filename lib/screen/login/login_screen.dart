

import 'package:flutter/material.dart' hide Key;
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/forget/forget_password_screen.dart';
import 'package:flutter_vts/screen/main/main_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/session_manager.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_des/flutter_des.dart';

class LoginScreen extends StatefulWidget {
  // const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool value = false;
  late MainBloc _mainBloc;
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  late bool _isLoading = false;
  late bool isVisiblePassword = false;

  // late SessionManager sessionManager;
  SessionManager sessionManager = SessionManager();
  static late SharedPreferences sharedPreferences;
  static const String string = "techno@8521\$";

  @override
  void initState() {
    //sessionManager.init();
    setdata();
    _mainBloc = BlocProvider.of(context);
  }

  _updateLogin(String token, int vendorid, int branchid, int userid) {
    _mainBloc.add(UpdateLoginEvents(
        menuCaption: "application",
        vendorSrNo: vendorid,
        branchSrNo: branchid,
        sessionId: "123456789123456",
        userId: userid,
        token: token));
  }

  setdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("RememberMe") != null) {
      setState(() {
        value = sharedPreferences.getBool("RememberMe")!;
      });

      if (value) {
        if (sharedPreferences.getString("Password") != null) {
          if (sharedPreferences.getString("Password") == "") {
          } else {
            passwordController.text = sharedPreferences.getString("Password")!;
          }
        }
        if (sharedPreferences.getString("UsernameSave") != null) {
          if (sharedPreferences.getString("UsernameSave") == "") {
          } else {
            usernameController.text =
                sharedPreferences.getString("UsernameSave")!;
          }
        }
      }
    }
  }

  decryptionwithAES(String key, String encryptedData) {
    final cipherKey = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));
    return encryptService.decrypt64(encryptedData, iv: initVector);
  }

  Encrypted encryptWithAES(String key, String plaintext) {
    final ciphertext = Key.fromUtf8(key);
    final encryptService = Encrypter(AES(ciphertext, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(key.substring(0, 16));
    Encrypted encrypteddata = encryptService.encrypt(plaintext, iv: initVector);
    return encrypteddata;
  }

  loginbloc() async {
    if (usernameController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Username",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (usernameController.text.length < 4) {
      Fluttertoast.showToast(
        msg: "Please Enter Valid Username",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Password",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else {
      if (passwordController.text != string) {
        Fluttertoast.showToast(
          msg: "Please Enter Valid Password",
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
        );
      } else {
        // Encrypted encrypted =
        //     encryptWithAES(passwordController.text, usernameController.text);
        print("success");

        _mainBloc.add(LoginEvents(
            username: usernameController.text,
            password: passwordController.text)); //passwordController.text));
      }
    }
  }

  //

/*  _des() async{
    const string = "Techno@8521\$"; // base64
    const key = "r0b1nr0y"; // base64
    const iv = "xxx="*/ /*{ 0x12, 0x34, 0x56, 0x78, 0x90, 0xab, 0xcd, 0xef }*/ /*;


    var decrypted = await HlDes.desDecrypt(data: string, iv: iv, key: key);
    print("decrypted = $decrypted");

    final encrypted = await HlDes.desEncrypt(data: decrypted, iv: iv, key: key);
    print("encrypted = $encrypted");
  }*/

  _encrypt1() async {
    /* const key = "r0b1nr0y";
    final iv = "123456788";*/
    const string =
        "Java, android, ios, get the same result by DES encryption and decryption.";
    const key = "u1BvOHzUOcklgNpn1MaWvdn9DT4LyzSX";
    const iv = "12345678";

    var encrypt = await FlutterDes.encrypt(string, key, iv: iv);
    print(encrypt);
    if (encrypt != null) {
      var decrypt = await FlutterDes.decrypt(encrypt, key, iv: iv);
      var encryptHex = await FlutterDes.encryptToHex(string, key, iv: iv);
      var decryptHex = await FlutterDes.decryptFromHex(encryptHex, key, iv: iv);
      var encryptBase64 = await FlutterDes.encryptToBase64(string, key, iv: iv);
      var decryptBase64 = await FlutterDes.decryptFromBase64(
          encryptBase64.toString(), key,
          iv: iv);
    }
  }

  _encrypt() {
    final plainText = /*'admin123'*/ /*'Techno@123'*/ passwordController.text;

    final key = Key.fromLength(16);
    final iv = IV.fromLength(8);
    final encrypter = Encrypter(AES(key));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    print(encrypted.base64);

    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print(decrypted);

    if (encrypted != null) {
      _mainBloc.add(LoginEvents(
          username: usernameController.text, password: encrypted.base64));
    }

    /*final encrypted1 = encrypter.encrypt("KJO4M39YLFf7WFiGo2z8cA==", iv: iv);

    final decrypted1 = encrypter.decrypt(encrypted1, iv: iv);
    print(decrypted1);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _loginscreen());
  }

  _loginscreen() {
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
            if (state is LoginLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is LoginLoadedState) {
              setState(() {
                _isLoading = false;
              });
              if (state.loginResponse.message != null) {
                /* Fluttertoast.showToast(
                  msg: "Login successful"*/ /*state.loginResponse.message == ""
                      ? "Login successful"
                      : "Enter Valid Username and Password"*/ /*,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );*/
              }
              if (value) {
                sharedPreferences.setString(
                    "Password", passwordController.text);
                sharedPreferences.setString(
                    "UsernameSave", usernameController.text);
              } else {
                sharedPreferences.setString("Password", "");
                sharedPreferences.setString("UsernameSave", "");
              }
              if (state.loginResponse.data != null) {
                if (state.loginResponse.data!.token != null) {
                  sharedPreferences.setString(
                      "auth_token", state.loginResponse.data!.token!);
                  // _updateLogin(state.loginResponse.data!.token!);
                }
                if (state.loginResponse.data!.userName != null) {
                  sharedPreferences.setString(
                      "Username", state.loginResponse.data!.userName!);
                }
                if (state.loginResponse.data!.vendorSrNo != null) {
                  sharedPreferences.setInt(
                      "VendorId", state.loginResponse.data!.vendorSrNo!);
                }
                sharedPreferences.setInt(
                    "BranchId", state.loginResponse.data!.branchSrNo!);
                sharedPreferences.setInt(
                    "UserID", state.loginResponse.data!.userId!);
                sharedPreferences.setString(
                    "VendorName", state.loginResponse.data!.vendorName!);
                sharedPreferences.setString(
                    "BranchName", state.loginResponse.data!.branchName!);
                sharedPreferences.setString(
                    "UserType", state.loginResponse.data!.userType!);
                sharedPreferences.setString("LastLoginDateTime",
                    state.loginResponse.data!.lastLoginTime!);

                if (state.loginResponse.data!.token != null &&
                    state.loginResponse.data!.vendorSrNo != null &&
                    state.loginResponse.data!.branchSrNo != null &&
                    state.loginResponse.data!.userId != null) {
                  sharedPreferences.setString(
                      "auth_token", state.loginResponse.data!.token!);
                  _updateLogin(
                      state.loginResponse.data!.token!,
                      state.loginResponse.data!.vendorSrNo!,
                      state.loginResponse.data!.branchSrNo!,
                      state.loginResponse.data!.userId!);
                }
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (_) => MainScreen()));
              } else {
                /* Fluttertoast.showToast(
                msg: "User does not exist",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );*/
              }

              /*  sessionManager.setUserToken(state.loginResponse.data!.token);
            sessionManager.setUserName(usernameController.text);
            sessionManager.setBranchId(state.loginResponse.data!.branchSrNo!);
            sessionManager.setVendorId(state.loginResponse.data!.vendorSrNo!);
            sessionManager.setUserType(state.loginResponse.data!.userType!);
            sessionManager.setVendorName(state.loginResponse.data!.vendorName!);
            sessionManager.setBranchName(state.loginResponse.data!.branchName!);*/

              // if(state.loginResponse.errors!=null){

              /* }else{
              Fluttertoast.showToast(
                msg: "User does not exist",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }*/
            } else if (state is LoginErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                msg: "User does not exist",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            } else if (state is UpdateLoginLoadingState) {
              setState(() {
                _isLoading = true;
              });
            } else if (state is UpdateLoginLoadedState) {
              setState(() {
                _isLoading = false;
              });
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => MainScreen()));
            } else if (state is UpdateLoginErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          child: SingleChildScrollView(
            child: Stack(alignment: Alignment.bottomCenter, children: [
              // Image.asset("assets/login.png",width: MediaQuery.of(context).size.width,fit: BoxFit.cover,)
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/login.png"),
                          fit: BoxFit.cover
                          // fit: BoxFit.fill
                          )),
                  child: _loginmainfield()),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        "@ Copy 2022 M-Tech Innovations Ltd Pune",
                        style: TextStyle(
                            color: MyColors.whiteColorCode, fontSize: 18),
                      ),
                    ),
                    Text(
                      "Vehicle Tracking System",
                      style: TextStyle(
                          color: MyColors.whiteColorCode, fontSize: 18),
                    ),
                  ],
                ),
              )
            ]),
          )
          /*Container(
            height: MediaQuery.of(context).size.height,
            width:double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/login.png"),
                fit: BoxFit.cover
                // fit: BoxFit.fill
              )
            ),
            child: _loginmainfield()
        ),*/
          ),
    );
  }

  _loginmainfield() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          "assets/vtsgps_icon.png",
          width: 144,
          height: 53,
        ),
        Card(
          margin: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            // side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 8.0),
                      child: Text("User Name",
                          style: TextStyle(
                              fontSize: 18, color: MyColors.blackColorCode)),
                    )),
                SizedBox(
                  height: 70,
                  child: TextField(
                    controller: usernameController,
                    enabled: true, // to trigger disabledBorder
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
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
                    // onChanged: _authenticationFormBloc.onPasswordChanged,
                    obscureText: false,
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        "Password",
                        style: TextStyle(
                            fontSize: 18, color: MyColors.blackColorCode),
                      ),
                    )),
                SizedBox(
                  height: 70,
                  child: TextField(
                    controller: passwordController,
                    enabled: true, // to trigger disabledBorder
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFFF2F2F2),
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
                      suffixIcon: IconButton(
                        icon: isVisiblePassword
                            ? Icon(Icons.visibility)
                            : Icon(Icons.visibility_off_outlined),
                        onPressed: () {
                          setState(() {
                            isVisiblePassword = !isVisiblePassword;
                          });
                        },
                      ),
                    ),
                    // onChanged: _authenticationFormBloc.onPasswordChanged,
                    obscureText: isVisiblePassword ? false : true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    children: [
                      Checkbox(
                          value: value,
                          onChanged: (checkvalue) {
                            setState(() {
                              value = checkvalue!;
                              sharedPreferences.setBool("RememberMe", value);
                            });
                          }),
                      Text(
                        "Remember me",
                        style: TextStyle(
                            fontSize: 18, color: MyColors.blackColorCode),
                      )
                    ],
                  ),
                ),
                ConstrainedBox(
                    constraints: new BoxConstraints(
                      maxHeight: 70.0,
                    ),
                    // ignore: deprecated_member_use
                    child: MaterialButton(
                        onPressed: () async {
                          print(string);
                          loginbloc();
                          // _encrypt();
                          // _encrypt1();
                        },
                        color: MyColors.blueColorCode,
                        height: 50,
                        minWidth: MediaQuery.of(context).size.width,
                        materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap, // add this
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide.none),
                        child: Container(
                            child: Text(
                          "Login",
                          style: TextStyle(
                              color: MyColors.whiteColorCode, fontSize: 20),
                        )))),
                GestureDetector(
                  onTap: () async {
                    /* Future<String> lan=SessionManager.getLanguageCode();
                    await lan.then((value) {
                      print(value);

                    },onError: (e) {
                      print(e);
                    });*/
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BlocProvider(
                                create: (context) {
                                  return MainBloc(webService: WebService());
                                },
                                child: ForgetPasswordScreen()
                            )));*/

                    // _encrypt();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10.0),
                    child: Text(
                      "Forgot Password",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: MyColors.blueColorCode,
                          fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        /* Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Text("@ Copy 2022 M-Tech Innovations Ltd Pune",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 18),),
        ),
        Text("Vehicle Tracking System",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 18),),
*/
      ],
    );
  }

  _loginfield() {
    return Column(
      children: [
        Lottie.network(
            'https://assets4.lottiefiles.com/packages/lf20_b8ddk0iq.json',
            width: 56,
            height: 57),
        Padding(
          padding: const EdgeInsets.only(top: 17.0, bottom: 26),
          child: Image.asset(
            "assets/vtsgps.png",
            width: 147,
            height: 44,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 37, right: 37, bottom: 45),
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22, color: MyColors.textColorCode),
          ),
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("User Name", style: TextStyle(fontSize: 18)),
            )),
        TextField(
          controller: usernameController,
          enabled: true, // to trigger disabledBorder
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2F2F2),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: MyColors.buttonColorCode),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.orange),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide:
                  BorderSide(width: 1, color: MyColors.textBoxBorderColorCode),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                  width: 1,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(width: 2, color: MyColors.buttonColorCode)),
// hintText: "HintText",
            hintStyle:
                TextStyle(fontSize: 16, color: MyColors.textBoxColorCode),
            errorText: "",
          ),
          // onChanged: _authenticationFormBloc.onPasswordChanged,
          obscureText: false,
        ),
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 8),
              child: Text(
                "Password",
                style: TextStyle(fontSize: 18),
              ),
            )),
        TextField(
          controller: passwordController,
          enabled: true, // to trigger disabledBorder
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF2F2F2),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: MyColors.buttonColorCode),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(width: 1, color: Colors.orange),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide:
                  BorderSide(width: 1, color: MyColors.textBoxBorderColorCode),
            ),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(
                  width: 1,
                )),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide: BorderSide(width: 1, color: Colors.black)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                borderSide:
                    BorderSide(width: 2, color: MyColors.buttonColorCode)),
            // hintText: "HintText",
            hintStyle:
                TextStyle(fontSize: 16, color: MyColors.textBoxColorCode),
            errorText: "",
          ),
          // onChanged: _authenticationFormBloc.onPasswordChanged,
          obscureText: true,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Checkbox(
                  value: value,
                  onChanged: (checkvalue) {
                    setState(() {
                      value = checkvalue!;
                    });
                  }),
              Text(
                "Remember me",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
        ConstrainedBox(
            constraints: new BoxConstraints(
              maxHeight: 70.0,
            ),
            // ignore: deprecated_member_use
            child: MaterialButton(
                onPressed: () {
                  loginbloc();
                },
                color: MyColors.buttonColorCode,
                height: 50,
                minWidth: MediaQuery.of(context).size.width,
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap, // add this
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide.none),
                child: Container(
                    child: Text(
                  "Login",
                  style:
                      TextStyle(color: MyColors.whiteColorCode, fontSize: 20),
                )))),
      ],
    );
  }
}
