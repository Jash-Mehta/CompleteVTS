
import 'dart:convert';

import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/master/subscription_master/add_subscription_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/custome_dialog.dart';

import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '../../../model/subscription/subscription_master_response.dart';

class SubscriptionMasterScreen extends StatefulWidget {
  const   SubscriptionMasterScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionMasterScreenState createState() => _SubscriptionMasterScreenState();
}

class _SubscriptionMasterScreenState extends State<SubscriptionMasterScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController subscriptionRecordController=new ScrollController();
  TextEditingController searchController=new TextEditingController();
  late bool isSearch = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber=1;
  int pageSize=10;
  List<Datum> ? datalist=[];
  List<Data>? searchData=[];

  bool isDataAvailable=false;
  final controller=ScrollController();
  List<String> items=List.generate(15, (index) => 'Item ${index+1}');

  late String userName="";
  late String vendorName="",branchName="",userType="";
  late SharedPreferences sharedPreferences;
  late String token="";
  late int branchid=0,vendorid=0;
  int totalSubscruiptionRecords=0;


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
          _getsubscriptiondetail();
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
      _getsubscriptiondetail();
    }

  }

  _getsubscriptiondetail(){
    _mainBloc.add(AllSubscriptionEvents(vendorid: vendorid,branchid: branchid,pagesize: pageNumber,totalpage: pageSize,token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("USER SUBSCRIPTION MASTER",_scaffoldKey,0,context),
      body: _subscriptionMaster(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blueColorCode,
        onPressed: () async {
         /* Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                        },
                      child: AddSubscriptionMasterScreen(flag: 1,searchText:false,datalist: datalist![0],searchData: Data(),)
                  )));*/

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
                        child: AddSubscriptionMasterScreen(flag: 1,searchText:false,datalist: datalist![0],searchData: Data(),)
                    )
            ),
          )
              .then((val) {
            if(val!=null){
              datalist!.clear();
              _getsubscriptiondetail();
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


  _subscriptionMaster(){
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
          if (state is AllSubscriptionLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is AllSubscriptionLoadedState) {
            setState(() {
              _isLoading = false;
              totalSubscruiptionRecords=state.subscriptionMasterRespose.totalRecords!;

              if(state.subscriptionMasterRespose.data!.length==0){
                isDataAvailable=false;

              }else{
                isDataAvailable=true;
                datalist!.addAll(state.subscriptionMasterRespose.data!);
                pageNumber++;
              }

            });

          }else if (state is AllSubscriptionErrorState) {
            setState(() {
              _isLoading = false;
            });
          }else if (state is SearchSubscriptionLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchSubscriptionLoadedState) {
            searchData!.clear();
            setState(() {
              _isLoading = false;
            });
            if(state.searchSubscriptionResponse.data!=null){
              searchData!.addAll(state.searchSubscriptionResponse.data!);
            }
          }else if (state is SearchSubscriptionErrorState) {
            setState(() {
              _isLoading = false;
            });
           /* Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Search record not found",
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
                      _mainBloc.add(SearchSubscriptionEvents(token:token,branchid: branchid,vendorid: vendorid,searchtext: searchController.text));
                    }
                  },
                  obscureText: false,
                ),
                Text(
                  !isSearch ? datalist!.length!=0 ?  "Showing 1 to ${datalist!.length} Out of ${totalSubscruiptionRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalSubscruiptionRecords}" :

                  "0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                   !isSearch ? datalist!.length==0 ? Container() :

                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:ListView.builder(
                      shrinkWrap: true,
                      controller: subscriptionRecordController,
                      itemCount: datalist!.length,
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
                                      child: Icon(Icons.circle,size:10,color:
                                      datalist![index].acStatus=="Active" ? MyColors.greenColorCode:
                                      MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                                  datalist![index].acStatus=="Active"   ? "Active" :
                                                  "Inactive",style: TextStyle(color:
                                                  datalist![index].acStatus=="Active" ? MyColors.greenColorCode:
                                                  MyColors.redColorCode,fontSize: 20),),
                                        )
                                    ),
                                    GestureDetector(
                                      onTap: () async{
                                         /* Navigator.push(context,
                                          MaterialPageRoute(builder: (_) =>
                                              BlocProvider(
                                                  create: (context) {
                                                    return MainBloc(webService: WebService());
                                                  },
                                                  child: AddSubscriptionMasterScreen(flag: 2,searchText: false, datalist: datalist![index],searchData: Data(),)
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
                                                      child: AddSubscriptionMasterScreen(flag: 2,searchText:false,datalist: datalist![index],searchData: Data(),)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                              if(val!=null){
                                                if(val){
                                                  datalist!.clear();
                                                  _getsubscriptiondetail();
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
                                            Text(
                                            datalist![index].srNo!=null ? datalist![index].srNo!.toString() :
                                            "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("User Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(
                                                datalist![index].userName!=null ? datalist![index].userName! :
                                                 "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text("Vendor Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(
                                            datalist![index].vendorName!=null ? datalist![index].vendorName! :
                                            "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Branch Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              datalist![index].branchName!=null ? datalist![index].branchName!:
                                              "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                            Text("Valid From",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              datalist![index].validFrom!=null ? datalist![index].validFrom!.day.toString()+"/"+datalist![index].validFrom!.month.toString()+"/"+datalist![index].validFrom!.year.toString() : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Valid Till ",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(
                                                datalist![index].validTill!=null ? datalist![index].validTill!.day.toString()+"/"+datalist![index].validTill!.month.toString()+"/"+datalist![index].validTill!.year.toString() :
                                                 "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                )
                  : searchData!.length==0 ? Container()
                       :ListView.builder(
                        controller: subscriptionRecordController,
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
                                                      child: AddSubscriptionMasterScreen(flag: 2,searchText: true, datalist: datalist![0],searchData: searchData![index],)
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
                                                        child:AddSubscriptionMasterScreen(flag: 2,searchText: true, datalist: datalist![0],searchData: searchData![index],)
                                                    )
                                            ),
                                          )
                                              .then((val) {
                                            if(val){
                                              datalist!.clear();
                                              _getsubscriptiondetail();
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
                                                Text("Username",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                                Text(searchData![index].userName!=null ? searchData![index].userName! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                            Text("Vendor Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].vendorName!=null ? searchData![index].vendorName! : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Branch Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].branchName!=null ? searchData![index].branchName! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                              Text("Valid From",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].validFrom!=null ? searchData![index].validFrom!.day.toString()+"/"+searchData![index].validFrom!.month.toString()+"/"+searchData![index].validFrom!.year.toString()  : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Valid Till",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                                Text(searchData![index].validTill!=null ? searchData![index].validTill!.day.toString()+"/"+searchData![index].validTill!.month.toString()+"/"+searchData![index].validTill!.year.toString() : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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









