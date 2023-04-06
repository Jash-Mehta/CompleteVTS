import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/master/alert/add_alert_master_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/alert/all_alert_master_response.dart';
import '../../../model/alert/search_alert_master_screen.dart';

class AlertMasterScreen extends StatefulWidget {
  const AlertMasterScreen({Key? key}) : super(key: key);

  @override
  _AlertMasterScreenState createState() => _AlertMasterScreenState();
}

class _AlertMasterScreenState extends State<AlertMasterScreen> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController alertController=new ScrollController();
  TextEditingController searchController=new TextEditingController();
  late bool isSearch = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber=1;
  int pageSize=10;

  int totalAlertRecords=0;

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
          _getalertdetail();
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
      _getalertdetail();
    }

  }

  _getalertdetail(){
    _mainBloc.add(AllAlertMasterEvents(token:token,vendorId: vendorid,branchId: branchid,pagenumber: pageNumber,pagesize: pageSize));
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("ALERT MASTER",_scaffoldKey,0,context),
      body: _alertscreen(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blueColorCode,
        onPressed: () async{

         /* Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: AddAlertMasterScreen(flag: 1,searchFlag:false,datalist: datalist![0],searchData: Data())
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
                        child: AddAlertMasterScreen(flag: 1,searchFlag:false,datalist: datalist![0],searchData: Data(),)
                    )
            ),
          )
              .then((val) {
                if(val!=null){
                  if(val){
                    datalist!.clear();
                    _getalertdetail();
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


  _alertscreen(){
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
          if (state is AllAlertLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else  if (state is AllAlertLoadedState) {
            setState(() {
              _isLoading = false;
              totalAlertRecords=state.alertMasterResponse.totalRecords!;
              if(state.alertMasterResponse.data!.length==0){
                isDataAvailable=false;

              }else{
                isDataAvailable=true;
                datalist!.addAll(state.alertMasterResponse.data!);
                pageNumber++;
              }

            });

          }else if (state is AllAlertErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
          else if (state is SearchAlertLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchAlertLoadedState) {
            setState(() {
              _isLoading = false;
              searchData!.clear();
            });
            if(state.searchAlertMasterResponse.data!=null){
              searchData!.addAll(state.searchAlertMasterResponse.data!);
            }
          }else if (state is SearchAlertErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something Went Wrong, please try again",
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
                      _mainBloc.add(SearchAlertEvents(vendorId: vendorid,branchId: branchid,searchText: searchController.text,token:token));
                    }
                  },
                  obscureText: false,
                ),
                Text(
                  !isSearch ? datalist!.length!=0 ?  "Showing 1 to ${datalist!.length} Out of ${totalAlertRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalAlertRecords}" :
                  "0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                !isSearch ? datalist!.length==0 ? Container() :
                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:ListView.builder(
                      shrinkWrap: true,
                      controller: alertController,
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

                                Padding(
                                  padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                    /*  Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Sr.No",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              datalist![index].vendorSrNo!=null ? datalist![index].vendorSrNo!.toString() :
                                              "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),*/
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Vendor Sr.No",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(
                                                datalist![index].vendorSrNo!=null ? datalist![index].vendorSrNo!.toString() :
                                                "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                            ],
                                          )
                                      ),
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
                                            Text("Alert Group Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              datalist![index].alertGroupName!=null ? datalist![index].alertGroupName!:
                                              "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    ),

                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () async{


                                         /* Navigator.push(context,
                                          MaterialPageRoute(builder: (_) =>
                                              BlocProvider(
                                                  create: (context) {
                                                    return MainBloc(webService: WebService());
                                                  },
                                                  child: AddAlertMasterScreen(flag: 2,searchFlag:false ,datalist: datalist![index],searchData: searchData!.length!=0  ? searchData![0] :Data())
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
                                                      child: AddAlertMasterScreen(flag: 2,searchFlag:false ,datalist: datalist![index],searchData: searchData!.length!=0  ? searchData![0] :Data(),)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                              if(val!=null){
                                                if(val){
                                                  datalist!.clear();
                                                  _getalertdetail();
                                                }
                                              }

                                          return false;
                                        }
                                          // val ? _getalldevice() : false
                                        );

                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(top: 15),
                                        padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                                        decoration: BoxDecoration(
                                            color:MyColors.notificationblueColorCode,
                                            borderRadius: BorderRadius.all(Radius.circular(20))
                                        ),
                                        child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.analyticActiveColorCode,fontSize: 18),),
                                      ),
                                    ),
                                  ],
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
                    controller: alertController,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: searchData!.length,
                    itemBuilder: (context,index){
                      return  Card(
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

                              Padding(
                                padding: const EdgeInsets.only(top: 15.0,bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                  /*  Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Sr.No",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(
                                            searchData![index].vendorSrNo!=null ? searchData![index].vendorSrNo!.toString() :
                                            "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),*/
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Vendor Sr.No",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              searchData![index].vendorSrNo!=null ? searchData![index].vendorSrNo!.toString() :
                                              "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Vendor Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(
                                            searchData![index].vendorName!=null ? searchData![index].vendorName! :
                                            "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
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
                                          Text("Alert Group Name",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(
                                            searchData![index].alertGroupName!=null ? searchData![index].alertGroupName!:
                                            "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      )
                                  ),

                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async{


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
                                                    child: AddAlertMasterScreen(flag: 2,searchFlag:true, datalist: datalist![0],searchData: searchData![index],)
                                                )
                                        ),
                                      )
                                          .then((val) {
                                            if(val!=null){
                                              if(val){
                                                datalist!.clear();
                                                _getalertdetail();
                                              }
                                            }

                                        return false;
                                      }
                                        // val ? _getalldevice() : false
                                      );


                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 15),
                                      padding: EdgeInsets.only(left: 20,right: 20,top: 6,bottom: 6),
                                      decoration: BoxDecoration(
                                          color:MyColors.notificationblueColorCode,
                                          borderRadius: BorderRadius.all(Radius.circular(20))
                                      ),
                                      child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.analyticActiveColorCode,fontSize: 18),),
                                    ),
                                  ),
                                ],
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

class ReplyTile{
  String member_photo;
  String member_id;
  String date;
  String member_name;
  String id;
  String text;

  ReplyTile({required this.member_photo,required this.member_id,required this.date,required this.member_name,required this.id ,required this.text});

}
