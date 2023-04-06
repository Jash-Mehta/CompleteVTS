import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/device/device_master_response.dart';
import 'package:flutter_vts/model/device/search_device_response.dart';
import 'package:flutter_vts/screen/master/device_master/add_device_master/add_device_master_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_vts/util/session_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';

class DeviceMasterScreen extends StatefulWidget {
  const DeviceMasterScreen({Key? key}) : super(key: key);

  @override
  _DeviceMasterScreenState createState() => _DeviceMasterScreenState();
}

class _DeviceMasterScreenState extends State<DeviceMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController deviceRecordController=new ScrollController();
  ScrollController deviceScrollController=new ScrollController();
  TextEditingController searchController=new TextEditingController();

  late MainBloc _mainBloc;
  SessionManager sessionManager =  SessionManager();
  late String token="";
  late int branchid=0,vendorid=0;


  int pageNumber=1;
  int total=10;
  int totalDeviceRecords=0;

  late bool _isLoading = false;
  late bool isSearch = false;

  List<Datum>? data=[];
  List<Data>? searchData=[];
  late SharedPreferences sharedPreferences;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainBloc = BlocProvider.of(context);
    getdata();
    // _gettoken();
    deviceScrollController.addListener(() {
      if(deviceScrollController.position.maxScrollExtent==deviceScrollController.offset){
        setState(() {
          print("Scroll ${pageNumber}");
          _getalldevice();
        });
      }
    });
  }


  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;

    }
    if(sharedPreferences.getInt("VendorId")!=null){
      vendorid=sharedPreferences.getInt("VendorId")!;

    }
    if(sharedPreferences.getInt("BranchId")!=null){
      branchid=sharedPreferences.getInt("BranchId")!;
    }

    if(token!="" || branchid!=0 || vendorid!=0){
      print("not null");
      _getalldevice();
    }else{
      print("null");

    }
  }


  _getalldevice(){
    _mainBloc.add(AllDeviceEvents(vendorId: vendorid,branchId : branchid,pageNumber: pageNumber,pageSize: 10,token: token));
  }

 /* _gettoken()async{
    Future<String> authToken = sessionManager.getUserToken();
    await authToken.then((data) {
      token=data.toString();
      print("authToken " + data.toString());
      if(token!=""){
        // _getalldevice();
      }
    },onError: (e) {
      print(e);
    });


    Future<int> vendorId = sessionManager.getVendorId();
    await vendorId.then((data) {
      branchid=data.toString();
      print("BranchId " + data.toString());
      if(branchid!=""){
        // _getalldevice();
      }
    },onError: (e) {
      print(e);
    });

    Future<int> branchId = sessionManager.getBranchId();
    await branchId.then((data) {
      vendorid=data.toString();
      print("VendorId " + data.toString());
      if(vendorid!=""){
        // _getalldevice();
      }
    },onError: (e) {
      print(e);
    });

    if(token!="" || branchid!="" || vendorid!=""){
      print("not null");
      _getalldevice();
    }else{
      print("null");

    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("DEVICE CONFIG MASTER",_scaffoldKey,0,context),
      body: _deviceMaster(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.buttonColorCode,
        onPressed: ()async {
        /*  Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: AddDeviceMasterScreen(flag: 1,searchText:false,datum:data![0] ,searchData: Data(),)
                  )
              ));*/
          setState(() {
            pageNumber=1;
          });
          await Navigator.of(context)
              .push(
            new MaterialPageRoute(
                builder: (_) =>
                    BlocProvider(
                        create: (context) {
                          return MainBloc(webService: WebService());
                        },
                        child: AddDeviceMasterScreen(flag: 1,searchText:false,datum:data![0] ,searchData: Data(),)
                    )
            ),
          )
              .then((val) {
            if(val){
              data!.clear();
              _getalldevice();
            }
            return false;
          }
            // val ? _getalldevice() : false
          );
        },
        child: Icon(Icons.add,color: MyColors.whiteColorCode,),
      ),
    );
  }

  _deviceMaster(){
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
          if (state is AllDeviceLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AllDeviceLoadedState) {
            setState(() {
              _isLoading = false;
              totalDeviceRecords=state.allDeviceResponse.totalRecords!;

              pageNumber++;
              if(state.allDeviceResponse.data!=null){
                data!.addAll(state.allDeviceResponse.data!);
              }

            });

          }else if (state is AllDeviceErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong",
            );
          }else if (state is SearchDeviceLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchDeviceLoadedState) {
            searchData!.clear();
            setState(() {
              _isLoading = false;
            });
            if(state.searchDeviceResponse.data!=null){
              searchData!.addAll(state.searchDeviceResponse.data!);
            }
          }else if (state is SearchDeviceErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong",
            );
          }
        },
        child: SingleChildScrollView(
          controller: deviceScrollController,
          child:Padding(
            padding: const EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
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
                      borderSide: BorderSide(width: 1,color: MyColors.textColorCode),
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
                    hintText: "Search Record",
                    prefixIcon: Icon(Icons.search,size: 24,color: MyColors.textBoxBorderColorCode,),
                    hintStyle: TextStyle(fontSize: 18,color:  MyColors.searchTextColorCode),
                    errorText: "",
                  ),
                  controller: searchController,
                  onChanged: (value){
                    // searchData!.clear();
                    if(searchController.text.isEmpty){
                      setState(() {
                        isSearch=false;
                      });
                    }else{
                      setState(() {
                        isSearch=true;
                      });
                      _mainBloc.add(SearchDeviceEvents(vendorId: vendorid,branchId :branchid,searchText: searchController.text,token: token));
                    }
                  },
                  obscureText: false,
                ),
                Text(!isSearch ? data!.length!=0 ?  "Showing 1 to ${data!.length} Out of ${totalDeviceRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalDeviceRecords}" :"0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                !isSearch ? data!.length==0 ? Container() :Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                      controller: deviceRecordController,
                      shrinkWrap: true,
                      itemCount: data!.length,
                      itemBuilder: (context,index){
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(top:15,left:14,right:14,bottom: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Icon(Icons.circle,size:10,color: data![index].acStatus=='Active' ? MyColors.greenColorCode:MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(/*index%2==0*/data![index].acStatus=='Active' ? "Active" : "Inactive",style: TextStyle(color:data![index].acStatus=='Active' ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
                                        )
                                    ),
                                    GestureDetector(
                                      onTap: ()async{
                                       /* Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(webService: WebService());
                                                    },
                                                    child: AddDeviceMasterScreen(flag: 2,searchText:false,datum:data![index],searchData: Data(),)
                                                )
                                            ));*/

                                        setState(() {
                                          pageNumber=1;
                                        });
                                        await Navigator.of(context)
                                            .push(
                                          new MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider(
                                                      create: (context) {
                                                        return MainBloc(webService: WebService());
                                                      },
                                                      child: AddDeviceMasterScreen(flag: 2,searchText:false,datum:data![index],searchData: Data(),)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                               if(val){
                                                 data!.clear();
                                                 _getalldevice();
                                               }
                                               return false;
                                            }
                                        // val ? _getalldevice() : false
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                                        decoration: BoxDecoration(
                                            color:MyColors.notificationblueColorCode,
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Sr.No",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(data![index].srNo!.toString(),style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Device Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(data![index].deviceNo==null ? "" : data![index].deviceNo!,textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Model Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(data![index].modelNo==null ? "" : data![index].modelNo!,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Device Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(data![index].deviceName==null ? "" : data![index].deviceName!,textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("IMEI Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                      Text(data![index].imeino==null ? "" : data![index].imeino!,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                ):searchData!.length==0 ? Container() : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                      controller: deviceRecordController,
                      shrinkWrap: true,
                      itemCount: searchData!.length,
                      itemBuilder: (context,index){
                        return Card(
                          margin: EdgeInsets.only(bottom: 15),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.only(top:15,left:14,right:14,bottom: 15),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Icon(Icons.circle,size:10,color: searchData![index].acStatus=='Active' ? MyColors.greenColorCode:MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(searchData![index].acStatus=='Active' ? "Active" : "Inactive",style: TextStyle(color:searchData![index].acStatus=='Active' ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
                                        )
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                        /*Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(webService: WebService());
                                                    },
                                                    child: AddDeviceMasterScreen(flag: 2,searchText:true,datum: data![index],searchData: searchData![index],)
                                                )
                                            ));*/


                                         setState(() {
                                          pageNumber=1;
                                          // searchController.text="";
                                          // searchData!.clear();
                                        });
                                        await Navigator.of(context)
                                            .push(
                                          new MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider(
                                                      create: (context) {
                                                        return MainBloc(webService: WebService());
                                                      },
                                                      child: AddDeviceMasterScreen(flag: 2,searchText:true,datum: data![index],searchData: searchData![index],)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                               if(val){
                                                 data!.clear();
                                                 _getalldevice();
                                               }
                                               return false;
                                            }
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                                        decoration: BoxDecoration(
                                            color:MyColors.notificationblueColorCode,
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Sr.No",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].srNo!.toString(),style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Device Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].deviceNo==null ? "" : searchData![index].deviceNo!,textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Model Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(searchData![index].modelNo==null ? "" : searchData![index].modelNo!,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Device Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].deviceName==null ? "" : searchData![index].deviceName!,textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("IMEI Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                      Text(searchData![index].imeino==null ? "" : searchData![index].imeino!,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
                )
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}

