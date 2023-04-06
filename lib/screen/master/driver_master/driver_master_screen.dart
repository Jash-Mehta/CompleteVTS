import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/master/driver_master/add_driver_master_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_validator/email_validator.dart';

import '../../../model/driver/all_driver_master_response.dart';
import '../../../model/driver/search_driver_master_response.dart';


class DriverMasterScreen extends StatefulWidget {
  const DriverMasterScreen({Key? key}) : super(key: key);

  @override
  _DriverMasterScreenState createState() => _DriverMasterScreenState();
}

class _DriverMasterScreenState extends State<DriverMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController driverRecordController=new ScrollController();
  TextEditingController searchController=new TextEditingController();
  late bool isSearch = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber=1;
  int pageSize=10;
  int totaldriverRecords=0;


  List<Datum> ? alldriverDetaildatalist=[];
  List<Data>? searchData=[];

  bool isDataAvailable=false;
  final controller=ScrollController();
  List<String> items=List.generate(15, (index) => 'Item ${index+1}');

  late String userName="";
  late String vendorName="",branchName="",userType="";
  late SharedPreferences sharedPreferences;
  late String token="";
  late int branchid=0,vendorid=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);

    getdata();
    controller.addListener(() {
      if(controller.position.maxScrollExtent==controller.offset){
        setState(() {
          print("Scroll ${pageNumber}");
          _getdriverdetail();
        });

      }
    });
  }

  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
      print("token ${token}");

    }
    if(sharedPreferences.getInt("VendorId")!=null){
      vendorid=sharedPreferences.getInt("VendorId")!;
    }
    if(sharedPreferences.getInt("BranchId")!=null){
      branchid=sharedPreferences.getInt("BranchId")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    if(sharedPreferences.getString("VendorName")!=null){
      vendorName=sharedPreferences.getString("VendorName")!;

    }
    if(sharedPreferences.getString("BranchName")!=null){
      branchName=sharedPreferences.getString("BranchName")!;
    }
    if(sharedPreferences.getString("UserType")!=null){
      userType=sharedPreferences.getString("UserType")!;
    }



    print("branchid ${branchid}   Vendor id   ${vendorid}");

    print(""+vendorid.toString()+" "+branchid.toString()+" "+userName+" "+vendorName+" "+branchName+" "+userType);


    if(token!="" || vendorid!=0 || branchid!=0 ||vendorName!="" || branchName!=""){
      _getdriverdetail();
    }

  }


  _getdriverdetail(){
    _mainBloc.add(AllDriverEvents(vendorId: vendorid,branchId: branchid,pageNumber: pageNumber,pageSize: pageSize,token: token));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    driverRecordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("DRIVER ENTRY MASTER",_scaffoldKey,0,context),
      body: _vehicleMaster(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blueColorCode,
        onPressed: () async {
          /* Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: AddDriverMasterScreen(flag: 1,searchText:false,alldriverDetaildatalist: alldriverDetaildatalist![0],searchData: Data(),)
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
                        child: AddDriverMasterScreen(flag: 1,searchText:false,alldriverDetaildatalist: alldriverDetaildatalist![0],searchData: Data(),)
                    )
            ),
          )
              .then((val) {
                if(val!=null){
                  if(val){
                    alldriverDetaildatalist!.clear();
                    _getdriverdetail();
                  }
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



  _vehicleMaster(){
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
          if (state is AllDriverLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is AllDriverLoadedState) {
            setState(() {
              _isLoading = false;
              totaldriverRecords=state.allDriverResponse.totalRecords!;
              if(state.allDriverResponse.data!.length==0){
                isDataAvailable=false;

              }else{
                isDataAvailable=true;
                alldriverDetaildatalist!.addAll(state.allDriverResponse.data!);
                pageNumber++;
              }

            });

          }else if (state is AllDriverErrorState) {
            setState(() {
              _isLoading = false;
            });
          }else if (state is SearchDriverLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchDriverLoadedState) {
            searchData!.clear();
            setState(() {
              _isLoading = false;
            });
            if(state.searchDriverResponse.data!=null){
              searchData!.addAll(state.searchDriverResponse.data!);
            }
          }else if (state is SearchDriverErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong,Please try again",
            );
          }
        },
        child: SingleChildScrollView(
          controller: controller,
          child:Padding(
            padding: const EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: searchController,
                  enabled: true, // to trigger disabledBorder
                  decoration: const InputDecoration(
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
                    prefixIcon: Icon(Icons.search,size: 24,color: MyColors.text3greyColorCode,),
                    hintStyle: TextStyle(fontSize: 18,color:  MyColors.searchTextColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  onChanged: (value) {

                    if(searchController.text.isEmpty){
                      setState(() {
                        isSearch=false;
                      });
                    }else{
                      setState(() {
                        isSearch=true;
                      });
                      _mainBloc.add(SearchDriverEvents(vendorId: 1,branchId :1,searchText: searchController.text,token: token));
                    }
                  },
                  obscureText: false,
                ),
                Text(!isSearch ? alldriverDetaildatalist!.length!=0 ?  "Showing 1 to ${alldriverDetaildatalist!.length} Out of ${totaldriverRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totaldriverRecords}" :"0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                !isSearch ? alldriverDetaildatalist!.length==0 ? Container() :Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:ListView.builder(
                      shrinkWrap: true,
                      controller: driverRecordController,
                      itemCount: alldriverDetaildatalist!.length,
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
                                      child: Icon(Icons.circle,size:10,color: alldriverDetaildatalist![index].acStatus=="Active" ? MyColors.greenColorCode:MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(alldriverDetaildatalist![index].acStatus=="Active"   ? "Active" : "Inactive",style: TextStyle(color:alldriverDetaildatalist![index].acStatus=="Active" ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
                                        )
                                    ),
                                    GestureDetector(
                                      onTap: () async{

                                       /*  Navigator.push(context,
                                          MaterialPageRoute(builder: (_) =>
                                              BlocProvider(
                                                  create: (context) {
                                                    return MainBloc(webService: WebService());
                                                  },
                                                  child: AddDriverMasterScreen(flag: 2,searchText:false,alldriverDetaildatalist: alldriverDetaildatalist![index],searchData: Data(),)
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
                                                      child: AddDriverMasterScreen(flag: 2,searchText:false,alldriverDetaildatalist: alldriverDetaildatalist![index],searchData: Data(),)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                              if(val!=null){
                                                if(val){
                                                  alldriverDetaildatalist!.clear();
                                                  _getdriverdetail();
                                                }
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
                                            Text(alldriverDetaildatalist![index].srNo!=null ? alldriverDetaildatalist![index].srNo!.toString() : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Driver Code",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(alldriverDetaildatalist![index].driverCode!=null ? alldriverDetaildatalist![index].driverCode! :"",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text("Driver Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(alldriverDetaildatalist![index].driverName!=null ? alldriverDetaildatalist![index].driverName! :"",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("DOJ",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(alldriverDetaildatalist![index].doj!=null ? alldriverDetaildatalist![index].doj!.day.toString()+"/"+ alldriverDetaildatalist![index].doj!.month.toString()+"/"+ alldriverDetaildatalist![index].doj!.year.toString() :"",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    )
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top:15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("License Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(alldriverDetaildatalist![index].licenceNo!=null ? alldriverDetaildatalist![index].licenceNo! :"",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Mobile Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(alldriverDetaildatalist![index].mobileNo!=null ? alldriverDetaildatalist![index].mobileNo!.toString() :"9999999999",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                      },
                    )
                ): searchData!.length==0 ? Center(child: Text("No data found")) :ListView.builder(
                      controller: driverRecordController,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
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
                                                    child: AddDriverMasterScreen(flag: 2,searchText:true,alldriverDetaildatalist: alldriverDetaildatalist![0],searchData: searchData![index],)
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
                                                      child: AddDriverMasterScreen(flag: 2,searchText:true,alldriverDetaildatalist: alldriverDetaildatalist![0],searchData: searchData![index],)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                          if(val){
                                            alldriverDetaildatalist!.clear();
                                            _getdriverdetail();
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
                                            Text(searchData![index].srNo!=null ? searchData![index].srNo!.toString() : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Driver code",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].driverCode!=null ? searchData![index].driverCode! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text("Driver Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(searchData![index].driverName!=null ? searchData![index].driverName! : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("DOJ",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].doj!=null ? searchData![index].doj!.day.toString()+"/"+ searchData![index].doj!.month.toString()+"/"+ searchData![index].doj!.year.toString() : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    )
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top:15.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("License Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].licenceNo!=null ? searchData![index].licenceNo! : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Mobile Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].mobileNo!=null ? searchData![index].mobileNo!.toString() : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                            ],
                                          )
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                  ),
              ],
            ),
          ) ,
        ),
      ),
    );
  }
}









