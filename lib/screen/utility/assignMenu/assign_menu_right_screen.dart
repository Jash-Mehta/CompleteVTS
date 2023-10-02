import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/assign_menu_rights_request.dart';
import 'package:flutter_vts/model/user/create_user/assign_menu_list_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';

class AssignMenuRightScreen extends StatefulWidget {
  // const AssignMenuRightScreen({Key? key}) : super(key: key);

  @override
  _AssignMenuRightScreenState createState() => _AssignMenuRightScreenState();
}

class _AssignMenuRightScreenState extends State<AssignMenuRightScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String usernamedropdown = '';
  String dropdownvalue = 'Item 1';
  late String dropdownValue='select';
  late String selectedVehicleType;

  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];



  late SharedPreferences sharedPreferences;
  late String userName="";
  late String vendorName="",branchName="",userType="";
  late int branchid=0,vendorid=0;
  late String token="";
  int userid = 0;
  int userid1 = 0;

  late bool _isLoading = false;
  List data =[];
  List assignMenudata =[];

  String selectedusername = '';

  List<AssignMenuDatum> assignmenulist=[];
  List<String> assignallmenulist = [];

  List<String> usernamelist=[];
  List<String> assignMenulist=[];
  List<String> selectedUserNamelist=[];
  List<String> selectedAssignMenulist=[];

  late MainBloc mainBloc;
  List<UserList>? selecteduserList=[];
  List<MenuList>? selectedmenuList=[];


  late var userNameResult,assignMenuResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mainBloc = BlocProvider.of(context);

    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("ASSIGN MENU RIGHTS",_scaffoldKey,0,context),
      body: _assignMenu(),
    );
  }

  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    userType=sharedPreferences.getString("UserType")!;
    vendorid=sharedPreferences.getInt("VendorId")!;
    branchid=sharedPreferences.getInt("BranchId")!;


    if(token!=""){
      getusers();
      getAssignMenuList();
    }
  }

  _assignMenu(){
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child:  BlocListener<MainBloc, MainState>(
        listener: (context,state){
          if (state is CreateAssignMenuRightsLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else   if (state is CreateAssignMenuRightsLoadedState) {
            setState(() {
              _isLoading = false;
            });
            if(state.editDeviceResponse.succeeded!){
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: state.editDeviceResponse.message!,
              );
            }else{
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: "Menu Right Already Assign for Selected User",
              );
            }
          }else   if (state is CreateAssignMenuRightsErrorState) {
            setState(() {
              _isLoading = false;
            });
          }if (state is RemoveAssignMenuRightsLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else   if (state is RemoveAssignMenuRightsLoadedState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: state.editDeviceResponse.message!,
            );
          }else   if (state is RemoveAssignMenuRightsErrorState) {
            setState(() {
              _isLoading = false;
            });
          }


        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top:15.0,left: 10,right: 10),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Select User Name", style: TextStyle(fontSize: 20,),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*", style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                token=="" ? Container() :
                TextField(
                  // controller: alertGroupController,
                  enabled: true,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode());
                    _showMultiUsernameSelect();
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
                selectedUserNamelist.length==0 ? Container() :GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: selectedUserNamelist.length,
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
                              Expanded(child: Text(selectedUserNamelist[index],overflow:TextOverflow.ellipsis,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)),
                              GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      selectedUserNamelist.removeAt(index);
                                      selecteduserList!.removeAt(index);
                                    });
                                  },
                                  child: Icon(Icons.close,color: MyColors.whiteColorCode,)
                              )
                            ],
                          )
                      );
                    }
                ),
               /* Container(
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
                ),*/
               /* Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                  ),
                  child: DropdownButton(
                    underline: SizedBox(),
                    items: data.map((item) {
                      setState(() {
                        // userid=item['userId'];
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
                            userid=data[i]['userId'];

                            print(data[i]['userId']);
                          }
                        }
                        // print();
                      });
                    },
                    value: usernamedropdown,
                  ),
                ),*/
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:15,bottom: 8),
                      child: Row(
                        children: [
                          Text("Menu To Assign", style: TextStyle(fontSize: 20),),
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
                selectedAssignMenulist.length==0 ? Container() : GridView.builder(
                  // physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 10 /4,
                      mainAxisSpacing: 6.0,
                      crossAxisSpacing: 6.0,
                    ),
                    itemCount: selectedAssignMenulist.length,
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
                              Expanded(child: Text(selectedAssignMenulist[index],overflow:TextOverflow.ellipsis,style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),)),
                              GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      selectedAssignMenulist.removeAt(index);
                                      selectedmenuList!.removeAt(index);

                                    });
                                  },
                                  child: Icon(Icons.close,color: MyColors.whiteColorCode,)
                              )
                            ],
                          )
                      );
                    }
                ),
                  // Container(
                  //   height: 40,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //       border: Border.all(color: MyColors.greyColorCode),
                  //       borderRadius: BorderRadius.all(Radius.circular(6))),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton<String>(
                  //       value: dropdownValue=='' ? 'select' :dropdownValue,
                  //       iconEnabledColor: Color(0xFF595959),
                  //       items: assignmenulist.map((returnValue) {
                  //         return DropdownMenuItem<String>(
                  //           onTap: () {
                  //             setState(() {
                  //               selectedVehicleType =
                  //                   returnValue.menuId.toString();
                  //             });
                  //           },
                  //           value: returnValue.menuCaption ?? "Select",
                  //           child: Padding(
                  //             padding: const EdgeInsets.only(left: 10),
                  //             child: Text(
                  //               returnValue.menuCaption!=null ? returnValue.menuCaption! :"Select",
                  //               style: TextStyle(
                  //                 fontSize: 15,
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       }).toList(),
                  //       hint: Padding(
                  //         padding: const EdgeInsets.only(left: 10),
                  //         child: Text(
                  //           "Select Vehicle Type",
                  //           style: TextStyle(fontSize: 15),
                  //         ),
                  //       ),
                  //       onChanged: (String? returnValue) {
                  //         setState(() {
                  //           dropdownValue = returnValue!;
                  //         });
                  //       },
                  //     ),
                  //   )),

                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Color(0xFFF2F2F2),
                    //       border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                    //   ),
                    //   child: DropdownButton(
                    //     value: dropdownvalue,
                    //     underline: SizedBox(),
                    //     icon: const Icon(Icons.keyboard_arrow_down),
                    //     items: items.map((String items) {
                    //       return DropdownMenuItem(
                    //         value: items,
                    //         child: Container(
                    //             padding: EdgeInsets.only(left: 10),
                    //             width: MediaQuery.of(context).size.width-58,
                    //             child: Text(items,style: TextStyle(fontSize: 18))
                    //         ),
                    //       );
                    //     }).toList(),
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         dropdownvalue = newValue!;
                    //       });
                    //     },
                    //   ),
                    // ),

                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            validation(2);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 10),
                            height: 48,
                            padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 10,right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: MyColors.dateIconColorCode)
                            ),
                            child: Text("Remove",style: TextStyle(color: MyColors.textColorCode,fontSize: 16)),
                          ),
                        ),
                      ),
                       Expanded(
                         child: GestureDetector(
                           onTap: (){
                             Navigator.of(context).pop();
                           },
                           child: Container(
                             alignment: Alignment.center,
                             // width: 148,
                             height: 48,
                             padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 10,right: 10),
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.all(Radius.circular(10)),
                                 border: Border.all(color: MyColors.textBoxBorderColorCode)
                             ),
                             child: Text("Cancel",style: TextStyle(color: MyColors.textColorCode,fontSize: 16)),
                           ),
                         ),
                       ),
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              selectedUserNamelist.clear();
                              selectedAssignMenulist.clear();
                              selecteduserList!.clear();
                              selectedmenuList!.clear();
                            });

                          },
                          child: Container(
                            alignment: Alignment.center,
                            // width: 148,
                            height: 48,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 10,right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: MyColors.textBoxBorderColorCode)
                            ),
                            child: Text("Clear",style: TextStyle(color: MyColors.textColorCode,fontSize: 16)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap:(){
                            // CustomDialog().popUp(context,"Link successfully sent on your register email.");
                            validation(1);
                            print("click");
                          },
                          child: Container(
                            alignment: Alignment.center,
                            // width: 148,
                            height: 48,
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 10,right: 10),
                            decoration: BoxDecoration(
                                color: MyColors.blueColorCode,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(color: MyColors.textBoxBorderColorCode)
                            ),
                            child: Text("Assign",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 16),),
                          ),
                        ),
                      ),


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

  validation(int flag){
    if(selectedUserNamelist.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please select usernames...!",
      );
    }else  if(selectedAssignMenulist.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please select Menu to assign...!",
      );
    }else
    if(selecteduserList!.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please select usernames...!",
      );
    }else  if(selectedmenuList!.length==0){
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        msg: "Please select Menu to assign...!",
      );
    }else{
      print(selectedUserNamelist.length.toString()+" : "+selectedAssignMenulist.length.toString());
      print(selecteduserList!.length.toString()+" : "+selectedmenuList!.length.toString());

      if(flag==1){
        mainBloc.add(CreateAssignMenuRightsEvents(assignMenuRightsRequest: AssignMenuRightsRequest(
            vendorSrNo: vendorid,
            branchSrNo: branchid,
            updatedBy: userName,
            userList: selecteduserList,
            menuList: selectedmenuList),
            token:token));
      }else{
        mainBloc.add(RemoveAssignMenuRightsEvents(assignMenuRightsRequest: AssignMenuRightsRequest(
            vendorSrNo: vendorid,
            branchSrNo: branchid,
            updatedBy: userName,
            userList: selecteduserList,
            menuList: selectedmenuList),
            token:token));
      }

    }
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
    assignMenudata = resBody['data'];

    for(int i=0;i<resBody['data'].length;i++){
      // usernamelist.add(resBody['data'][i]['userName']);
      assignMenulist.add(resBody['data'][i]['menuCaption']);
      // usernameDetailslist.add(UserList(userId: alerttypelist[i].alertCode,alertIndication: resBody['data'][i]['userName']));
    }
    setState(() {
      dropdownValue=resBody['data'][0]['menuCaption'];
      assignmenulist=assignMenuListResponseFromJson(response.body).data!;

    });

    return "Success";
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
      for(int i=0;i<resBody['data'].length;i++){
        // usernamelist.add(resBody['data'][i]['userName']);
        usernamelist.add(resBody['data'][i]['userName']);
        // usernameDetailslist.add(UserList(userId: alerttypelist[i].alertCode,alertIndication: resBody['data'][i]['userName']));
      }
      setState(() {
        _isLoading=false;
        usernamedropdown=resBody['data'][0]["userName"];
        if(userName!=''){
          data = resBody['data'];
        }
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

  void _showMultiUsernameSelect() async {

    userNameResult=await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectUsernames(items: usernamelist ,selectedusernamelist: selectedUserNamelist);
      },
    );

    if (userNameResult != null && userNameResult.containsKey('SelectedUserNameItemsList')) {
      setState(() {
        selectedUserNamelist=userNameResult["SelectedUserNameItemsList"];
        selecteduserList!.clear();
        for(int i=0;i<data.length;i++){
          for(int j=0;j<selectedUserNamelist.length;j++){
            if(data[i]['userName']==selectedUserNamelist[j]){
              selecteduserList!.add(UserList(userId:data[i]['userId']));
              print(data[i]['userId']);
            }
          }
        }
        // print("Username list : ${userNameResult["SelectedUserNameItemsList"]}");
      });
    }
    // if (userNameResult != null && userNameResult.containsKey('AlertTypeCodeList')) {
    //   setState(() {
    //     selectedalerttypelist=userNameResult["AlertTypeCodeList"];
    //     print("Alert Type ${selectedalerttypelist[0].alertIndication}");
    //   });
    // }

  }


  void _showMultiAssignMenuSelect() async {

    assignMenuResult=await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectAssignMenu(items: assignMenulist ,selectedAssignMenulist: selectedAssignMenulist,);
      },
    );

    if (assignMenuResult != null && assignMenuResult.containsKey('SelectedAssignMenuItemsList')) {
      setState(() {
        selectedAssignMenulist=assignMenuResult["SelectedAssignMenuItemsList"];
        selectedmenuList!.clear();

        for(int i=0;i<assignMenudata.length;i++){
          for(int j=0;j<selectedAssignMenulist.length;j++){
            if(assignMenudata[i]['menuCaption']==selectedAssignMenulist[j]){
              print(assignMenudata[i]['menuId']);
              selectedmenuList!.add(MenuList(menuId:assignMenudata[i]['menuId']));
            }
          }
        }
        // print("Assign Menu list : ${assignMenuResult["SelectedAssignMenuItemsList"]}");
      });
    }
    // if (userNameResult != null && userNameResult.containsKey('AlertTypeCodeList')) {
    //   setState(() {
    //     selectedalerttypelist=userNameResult["AlertTypeCodeList"];
    //     print("Alert Type ${selectedalerttypelist[0].alertIndication}");
    //   });
    // }

  }
}




class MultiSelectUsernames extends StatefulWidget {
  List<String> items;
  // List<VehicleList> vehicleList=[];
  List<String> selectedusernamelist=[];


  MultiSelectUsernames({Key? key, required this.items,required this.selectedusernamelist/*,required this.selectedvehicleIDlist*/}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectUsernamesState();
}

class _MultiSelectUsernamesState extends State<MultiSelectUsernames> {
  final List<String> _selectedItems = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i=0;i<widget.selectedusernamelist.length;i++){
      _selectedItems.add(widget.selectedusernamelist[i]);
    }
  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
        // _selectedItemslist.removeWhere((item) => item.vehicleRegNo == itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);

    Navigator.pop(context, {
      "SelectedUserNameItemsList":_selectedItems,

    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Vehicle'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item.toString()),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}


class MultiSelectAssignMenu extends StatefulWidget {
  List<String> items;
  // List<VehicleList> vehicleList=[];
  List<String> selectedAssignMenulist=[];


  MultiSelectAssignMenu({Key? key, required this.items,required this.selectedAssignMenulist/*,required this.selectedvehicleIDlist*/}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectAssignMenuState();
}

class _MultiSelectAssignMenuState extends State<MultiSelectAssignMenu> {
  final List<String> _selectedItems = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(int i=0;i<widget.selectedAssignMenulist.length;i++){
      _selectedItems.add(widget.selectedAssignMenulist[i]);
    }
  }

  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {

        _selectedItems.add(itemValue);

      } else {
        _selectedItems.remove(itemValue);
        // _selectedItemslist.removeWhere((item) => item.vehicleRegNo == itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);

    Navigator.pop(context, {
      "SelectedAssignMenuItemsList":_selectedItems,
    });

  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Vehicle'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item.toString()),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}


