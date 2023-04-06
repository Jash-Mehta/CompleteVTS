import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/vehicle/all_vehicle_detail_response.dart';
import 'package:flutter_vts/screen/master/vehicle_master/add_new_vehicle_master/add_vehicle_master_screen.dart';
import 'package:flutter_vts/screen/onboarding/OnboardingScreen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_vts/model/vehicle/search_vehicle_response.dart';

class VehicleMasterScreen extends StatefulWidget {
  const VehicleMasterScreen({Key? key}) : super(key: key);

  @override
  _VehicleMasterScreenState createState() => _VehicleMasterScreenState();
}

class _VehicleMasterScreenState extends State<VehicleMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vehicleRecordController=new ScrollController();
  TextEditingController searchController=new TextEditingController();
  late bool isSearch = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber=1;
  int pageSize=10;
  List<Datum> ? allVehicleDetaildatalist=[];
  List<Data>? searchData=[];
  int totalVehicleRecords=0;

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
          _getvehicledetail();
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



    print(token);
    print(""+vendorid.toString()+" "+branchid.toString()+" "+userName+" "+vendorName+" "+branchName+" "+userType);


    if(token!="" || vendorid!=0 || branchid!=0 ||vendorName!="" || branchName!=""){
      _getvehicledetail();
    }

  }


  _getvehicledetail(){
    _mainBloc.add(AllVehicleDetailEvents(vendorId: vendorid,branchId: branchid,pageNumber: pageNumber,pageSize: pageSize,token: token));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    vehicleRecordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("VEHICLE MASTER",_scaffoldKey,0,context),
      body: _vehicleMaster(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blueColorCode,
        onPressed: () async {
          /*Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: AddVehicleMasterScreen(flag: 1,datum:allVehicleDetaildatalist![0])
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
                        child: AddVehicleMasterScreen(flag: 1,searchText:false,datum:allVehicleDetaildatalist![0],searchData: Data(),)
                    )
            ),
          )
              .then((val) {
                if(val!=null){
                  if(val){
                    allVehicleDetaildatalist!.clear();
                    _getvehicledetail();
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
          if (state is AllVehicleDetailLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is AllVehicleDetailLoadedState) {
            setState(() {
              _isLoading = false;
              totalVehicleRecords=state.allVehicleDetailResponse.totalRecords!;
              if(state.allVehicleDetailResponse.data!.length==0){
                isDataAvailable=false;
               /* Fluttertoast.showToast(
                  msg: "More data not availble",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );*/
              }else{
                isDataAvailable=true;
                allVehicleDetaildatalist!.addAll(state.allVehicleDetailResponse.data!);
                pageNumber++;
              }

            });

          }else if (state is AllVehicleDetailErrorState) {
            setState(() {
              _isLoading = false;
            });
          }else if (state is SearchVehicleDetailLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchVehicleDetailLoadedState) {
            setState(() {
              _isLoading = false;
              searchData!.clear();

            });
            if(state.searchVehicleResponse.data!=null){
              searchData!.addAll(state.searchVehicleResponse.data!);
            }
          }else if (state is SearchVehicleDetailErrorState) {
            setState(() {
              _isLoading = false;
              searchData!.clear();

            });

           /* Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something Went Wrong,Please try again",
            );*/
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
                      _mainBloc.add(SearchVehicleEvents(vendorId: vendorid,branchId :branchid,searchText: searchController.text,token: token));
                    }
                  },
                  obscureText: false,
                ),
                Text(!isSearch ? allVehicleDetaildatalist!.length!=0 ?  "Showing 1 to ${allVehicleDetaildatalist!.length} Out of ${totalVehicleRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length}  Out of ${totalVehicleRecords}" :"0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                !isSearch ?
                allVehicleDetaildatalist!.length==0 ?
                Container() :
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child:ListView.builder(
                    shrinkWrap: true,
                    controller: vehicleRecordController,
                    itemCount: allVehicleDetaildatalist!.length,
                    itemBuilder: (context,index){
                    /*if(index<allVehicleDetaildatalist!.length){
                        final item=allVehicleDetaildatalist![index];*/
                        // return ListTile(title: Text(allVehicleDetaildatalist![index].vehicleName!),);
                     /* }else{
                        return isDataAvailable ? Center(child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: CircularProgressIndicator(),
                        ),):Container();
                      }*/

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
                                    child: Icon(Icons.circle,size:10,color: allVehicleDetaildatalist![index].acStatus=="Active" ? MyColors.greenColorCode:MyColors.redColorCode,),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(allVehicleDetaildatalist![index].acStatus=="Active"  ? "Active" : "Inactive",style: TextStyle(color:allVehicleDetaildatalist![index].acStatus=="Active" ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
                                      )
                                  ),
                                  GestureDetector(
                                    onTap: () async{
                                     /* print(allVehicleDetaildatalist![index].vsrNo.toString());
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) =>
                                              BlocProvider(
                                                  create: (context) {
                                                    return MainBloc(webService: WebService());
                                                  },
                                                  child: AddVehicleMasterScreen(flag: 2,datum: allVehicleDetaildatalist![index],)
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
                                                    child: AddVehicleMasterScreen(flag: 2,searchText:false,datum: allVehicleDetaildatalist![index],searchData: Data(),)
                                                )
                                        ),
                                      )
                                          .then((val) {
                                            if(val!=null){
                                              if(val){
                                                allVehicleDetaildatalist!.clear();
                                                _getvehicledetail();
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
                                          Text("Vehicle ID",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(allVehicleDetaildatalist![index].vsrNo!=null ? allVehicleDetaildatalist![index].vsrNo!.toString() : "0",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Vehicle Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(allVehicleDetaildatalist![index].vehicleRegNo!=null ? allVehicleDetaildatalist![index].vehicleRegNo! :"",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                        Text("Vehicle Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                        Text(allVehicleDetaildatalist![index].vehicleName!=null ? allVehicleDetaildatalist![index].vehicleName! :"",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Fuel Type",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(allVehicleDetaildatalist![index].fuelType!=null ? allVehicleDetaildatalist![index].fuelType! :"",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text("Vehicle Type",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(allVehicleDetaildatalist![index].vehicleType!=null ? allVehicleDetaildatalist![index].vehicleType! :"0",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Speed Limit",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(allVehicleDetaildatalist![index].speedLimit!=null ? allVehicleDetaildatalist![index].speedLimit!.toString() :"",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                ): searchData!.length==0
                    ? Container() :
                ListView.builder(
                      controller: vehicleRecordController,
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
                                        print(allVehicleDetaildatalist![index].vendorSrNo.toString());

                                        /*  Navigator.push(context,
                                            MaterialPageRoute(builder: (_) =>
                                                BlocProvider(
                                                    create: (context) {
                                                      return MainBloc(webService: WebService());
                                                    },
                                                    child: AddVehicleMasterScreen(flag: 2,datum: allVehicleDetaildatalist![index],)
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
                                                      child: AddVehicleMasterScreen(flag: 2,searchText:true,datum: allVehicleDetaildatalist![0],searchData: searchData![index],)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                              if(val!=null){
                                                if(val){
                                                  setState(() {
                                                    isSearch=false;
                                                    allVehicleDetaildatalist!.clear();
                                                    searchData!.clear();
                                                    searchController.text="";
                                                    _getvehicledetail();

                                                  });

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
                                            Text("Vehicle ID",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].vsrNo!=null ? searchData![index].vsrNo!.toString() : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Vehicle Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].vehicleRegNo!=null ? searchData![index].vehicleRegNo! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text("Vehicle Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(searchData![index].vehicleName!=null ? searchData![index].vehicleName! : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Fuel Type",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].fuelType!=null ? searchData![index].fuelType! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                            Text("Vehicle Type",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].vehicleType!=null ? searchData![index].vehicleType! : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Speed Limit",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].speedLimit!=null ? searchData![index].speedLimit!.toString() : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
