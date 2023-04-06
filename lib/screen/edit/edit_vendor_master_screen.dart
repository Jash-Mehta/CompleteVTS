import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/vendor/all_vendor_detail_response.dart';
import 'package:flutter_vts/model/vendor/request/edit_vendor_request.dart';
import 'package:flutter_vts/model/vendor/search_vendor_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/util/session_manager.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

class EditVendorMasterScreen extends StatefulWidget {
  int srno;
  late Datum data;
  SearchData searchData;
  bool searchText;

  EditVendorMasterScreen({Key? key,required this.srno,required this.searchText,required this.data,required this.searchData}) : super(key: key);

  @override
  _EditVendorMasterScreenState createState() => _EditVendorMasterScreenState();
}

class _EditVendorMasterScreenState extends State<EditVendorMasterScreen> {


  String dropdownvalue = 'Y';

  TextEditingController _vendorsrnocontroller=new TextEditingController();
  TextEditingController _vendorcodecontroller=new TextEditingController();
  TextEditingController _vendorNamecontroller=new TextEditingController();
  TextEditingController _vendorcompanynamecontroller=new TextEditingController();
  TextEditingController _vendorEmailIdcontroller=new TextEditingController();
  TextEditingController _vendorMobileNumbercontroller=new TextEditingController();
  TextEditingController _vendorCityIdcontroller=new TextEditingController();
  TextEditingController _vendorAddresscontroller=new TextEditingController();

  bool activeStatus = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  late String token="";
  late String userName="";
  static String mobileNumber = r'(^[789]\d{9}$)';
  RegExp regexMobile = new RegExp(mobileNumber);
  static final  validCharacters = RegExp(r'^[a-zA-Z0-9]+$');

  SessionManager sessionManager =  SessionManager();

  // List of items in our dropdown menu
  var items = [
    'Y',
    'N'
  ];
  
  

  
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    if(widget.data!=null){
      if(widget.searchText){
        _vendorsrnocontroller.text=widget.searchData.srNo.toString();
        _vendorcodecontroller.text=widget.searchData.vendorCode!;
        _vendorNamecontroller.text=widget.searchData.vendorName!;
        _vendorcompanynamecontroller.text=widget.searchData.company!;
        _vendorEmailIdcontroller.text=widget.searchData.emailId!;
        _vendorMobileNumbercontroller.text=widget.searchData.mobileNo!;
        _vendorCityIdcontroller.text=widget.searchData.city!;
        _vendorAddresscontroller.text=widget.searchData.address!;
        if(widget.searchData.acStatus=='Active'){
          setState(() {
            activeStatus=true;
          });
        }else{
          setState(() {
            activeStatus=false;
          });
        }
      }else{
        _vendorsrnocontroller.text=widget.srno.toString();
        _vendorcodecontroller.text=widget.data.vendorCode!;
        _vendorNamecontroller.text=widget.data.vendorName!;
        _vendorcompanynamecontroller.text=widget.data.company!;
        _vendorEmailIdcontroller.text=widget.data.emailId!;
        _vendorMobileNumbercontroller.text=widget.data.mobileNo!;
        _vendorCityIdcontroller.text=widget.data.city!;
        _vendorAddresscontroller.text=widget.data.address!;
        if(widget.data.acStatus=='Active'){
          setState(() {
            activeStatus=true;
          });
        }else{
          setState(() {
            activeStatus=false;
          });
        }
      }

    }


    _gettoken();
  }

  _gettoken(){
    Future<String> authToken = sessionManager.getUserToken();
    authToken.then((data) {
      token=data.toString();
      print("authToken " + data.toString());
    },onError: (e) {
      print(e);
    });

    Future<String> username = sessionManager.getUserName();
    username.then((data) {
      userName=data.toString();
      print("Username " + data.toString());
    },onError: (e) {
      print(e);
    });
  }

  editvendor(){
    if(token!=""){
      _mainBloc.add(EditVendorEvents(editVendorRequest: EditVendorRequest(
          srNo: widget.srno,
          vendorCode:_vendorcodecontroller.text,
          vendorName:_vendorNamecontroller.text,
          city:_vendorCityIdcontroller.text,
          mobileNo:_vendorMobileNumbercontroller.text,
          emailId:_vendorEmailIdcontroller.text,
          phoneNo:"",
          address:_vendorAddresscontroller.text,
          company:_vendorcompanynamecontroller.text,
          acUser:userName,
          acDate:"",
          modifiedBy:"",
          acStatus:activeStatus ? 'Y' : 'N'
        ),
          token: token,
          vendorid: widget.srno ));

    }else{
      print("Token null");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.appBarColorCode,
        title: Text("EDIT"),
      ),
      body: _editvendormaster(),
      bottomNavigationBar: BottomAppBar(
       child: SizedBox(
         height: 70,
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             GestureDetector(
               onTap: (){
                 _vendorcodecontroller.clear();
                 _vendorcompanynamecontroller.clear();
                 _vendorNamecontroller.clear();
                 _vendorEmailIdcontroller.clear();
                 _vendorMobileNumbercontroller.clear();
                 _vendorCityIdcontroller.clear();
                 _vendorAddresscontroller.clear();
                 setState(() {
                   activeStatus=false;
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
                 _validation();
               },
               child: Container(
                 alignment: Alignment.center,
                 width: 148,
                 height: 56,
                 margin: const EdgeInsets.only(left: 15),
                 padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                 decoration: BoxDecoration(
                     color: MyColors.buttonColorCode,
                     borderRadius: BorderRadius.all(Radius.circular(10)),
                     border: Border.all(color: MyColors.textBoxBorderColorCode)
                 ),
                 child: Text("Update",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
               ),
             )

           ],
         ),
       ),

      ),
    );
  }

  _editvendormaster(){
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
            if (state is EditVendorLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is EditVendorLoadedState) {
              setState(() {
                _isLoading = false;
              });
              CustomDialog().popUp(context,"Record successfully updated.");

            }else if (state is EditVendorErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:4.0,bottom: 8),
                      child: Row(
                        children: [
                          Text("Sr. No",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorsrnocontroller,
                  enabled: false, // to trigger disabledBorder
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Vendor Code",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorcodecontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Vendor Name",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorNamecontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Company Name",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorcompanynamecontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Email ID",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorEmailIdcontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Mobile Number",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorMobileNumbercontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("City",style: TextStyle(fontSize: 18),),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorCityIdcontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Vendor Address",style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    )
                ),
                TextField(
                  controller: _vendorAddresscontroller,
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
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text("Status",style: TextStyle(fontSize: 18),),
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
                          onChanged: (checkvalue){
                            setState(() {
                              activeStatus=checkvalue!;
                              print(checkvalue);
                            });
                          }
                      ),
                      Text("Active",style: TextStyle(fontSize: 18,color: MyColors.blackColorCode),)
                    ],
                  ),
                ),
               /* Container(
                  padding: EdgeInsets.only(left: 10),
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
                         *//* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*//*
                          width: MediaQuery.of(context).size.width-68,
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
    );
  }

  _validation(){
     if(_vendorcodecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vendor COde",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if (!validCharacters.hasMatch(_vendorcodecontroller.text)) {
       Fluttertoast.showToast(
         msg: "Only Alphanumeric value allow in Vendor Code...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     }else if(_vendorNamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vendor Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if (!validCharacters.hasMatch(_vendorNamecontroller.text)) {
       Fluttertoast.showToast(
         msg: "Only Alphanumeric value allow in Vendor Name...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     }else if(_vendorcompanynamecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Vendor Company Name",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if (!validCharacters.hasMatch(_vendorcompanynamecontroller.text)) {
       Fluttertoast.showToast(
         msg: "Only Alphanumeric value allow in Vendor Company Name...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     }else if(_vendorEmailIdcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Email-Id",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(!EmailValidator.validate(_vendorEmailIdcontroller.text)){
      Fluttertoast.showToast(
        msg: "Please Enter Valid Email-Id",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if(_vendorMobileNumbercontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter Mobile Number",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if (_vendorMobileNumbercontroller.text.length !=10) {
       Fluttertoast.showToast(
         msg: "Please Enter Valid Mobile Number...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );
     } else if (!regexMobile.hasMatch(_vendorMobileNumbercontroller.text)) {
       Fluttertoast.showToast(
         msg: "Please Enter Valid Mobile Number...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     } else if(_vendorCityIdcontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Enter City",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (!validCharacters.hasMatch(_vendorCityIdcontroller.text)) {
       Fluttertoast.showToast(
         msg: "Only Alphanumeric value allow in Vendor City Field...!",
         toastLength: Toast.LENGTH_SHORT,
         timeInSecForIosWeb: 1,
       );

     }else if(_vendorAddresscontroller.text.isNotEmpty){
       if (!validCharacters.hasMatch(_vendorAddresscontroller.text)) {
         Fluttertoast.showToast(
           msg: "Only Alphanumeric value allow in Vendor Address Field...!",
           toastLength: Toast.LENGTH_SHORT,
           timeInSecForIosWeb: 1,
         );

       }else{
         editvendor();

       }
     }else {
      editvendor();
    }

  }
}
