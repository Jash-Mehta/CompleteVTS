import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/vendor/search_vendor_response.dart';
import 'package:flutter_vts/screen/edit/edit_vendor_master_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/add_vendor_new_master/add_new_vendor_master_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_vts/util/session_manager.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../model/vendor/all_vendor_detail_response.dart';

class VendorMasterScreen extends StatefulWidget {
  const VendorMasterScreen({Key? key}) : super(key: key);

  @override
  _VendorMasterScreenState createState() => _VendorMasterScreenState();
}

class _VendorMasterScreenState extends State<VendorMasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vendorRecordController=new ScrollController();
  ScrollController vendorScrollController=new ScrollController();
  TextEditingController searchController=new TextEditingController();

  late bool _isLoading = false;
  late bool isSearch = false;

  late MainBloc _mainBloc;
  SessionManager sessionManager =  SessionManager();
  late String token="";
  late List<Datum> data=[];
   int pageNumber=1;
  List<SearchData>? searchData=[];

  int totalVendorRecords=0;
  late SharedPreferences sharedPreferences;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _mainBloc = BlocProvider.of(context);


    getdata();
   /* Future<String> authToken = sessionManager.getUserToken();
    authToken.then((data) {
      token=data.toString();
      print("authToken " + data.toString());
      if(token!=""){
        _getallvendors();
      }
    },onError: (e) {
      print(e);
    });*/

    vendorScrollController.addListener(() {
      if(vendorScrollController.position.maxScrollExtent==vendorScrollController.offset){
        setState(() {
          print("Scroll ${pageNumber}");
          _getallvendors();
        });

      }
    });

    // print(SessionManager.getUserToken());

  }


  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    token=sharedPreferences.getString("auth_token")!;

    if(token!=""){
      _getallvendors();
    }else{
    }
  }


  _getallvendors(){
    _mainBloc.add(AllVendorDetailEvents(pageNumber: pageNumber,pageSize: 10,token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("VENDOR MASTER",_scaffoldKey,0,context),
      body: _vendorMaster(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blueColorCode,
        onPressed: () async {
        /*  Navigator.push(context,
              MaterialPageRoute(builder: (_) =>
                  BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: AddNewVendorMasterScreen(flag: 1,)
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
                        child: AddNewVendorMasterScreen(flag: 1,)
                    )
            ),
          )
              .then((val) {
                if(val!=null){
                  if(val){
                    data.clear();
                    _getallvendors();
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



  _vendorMaster(){
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
          if (state is AllVendorDetailLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AllVendorDetailLoadedState) {
            setState(() {
              _isLoading = false;
              pageNumber++;
              totalVendorRecords=state.allVendorDetailResponse.totalRecords!;
            });
            // data=state.allVendorDetailResponse.data;
            data.addAll(state.allVendorDetailResponse.data!);

          }else if (state is AllVendorDetailErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              msg:"Something went wrong,Please try again",
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
            );
          }else if (state is SearchVendorLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchVendorLoadedState) {
            setState(() {
              _isLoading = false;
              searchData!.clear();

            });

            if(state.searchVendorResponse.data!=null){
              searchData!.addAll(state.searchVendorResponse.data!);
            }

          }else if (state is SearchVendorErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        child: SingleChildScrollView(
          controller: vendorScrollController,
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
                        borderSide: BorderSide(width: 1,color:MyColors.textBoxBorderColorCode,)
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
                      _mainBloc.add(SearchVendorEvents(searchText: searchController.text,token: token));
                    }
                  },
                  obscureText: false,
                ),
                Text(!isSearch ? data.length!=0 ?  "Showing 1 to ${data.length} Out of ${totalVendorRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalVendorRecords}" :"0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                !isSearch ? data.length==0 ? Container() :Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ListView.builder(
                      controller: vendorRecordController,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context,index){
                        return Card(
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
                                      child: Icon(Icons.circle,size:10,color: /*index%2==0*/data[index].acStatus=="Active"  ? MyColors.greenColorCode:MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(data[index].acStatus=="Active" ? "Active" : "Inactive",style: TextStyle(color:/*index%2==0*/data[index].acStatus=="Active"  ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
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
                                                    child: EditVendorMasterScreen(srno: data[index].srNo!,searchText:false,data: data[index],searchData: SearchData(),)
                                                )
                                            ));*/

                                     /*   await Navigator.of(context)
                                            .push(
                                          new MaterialPageRoute(
                                              builder: (_) =>
                                                  BlocProvider(
                                                      create: (context) {
                                                        return MainBloc(webService: WebService());
                                                      },
                                                      child: EditVendorMasterScreen(srno: data[index].srNo!,searchText:false,data: data[index],searchData: SearchData(),)
                                                  )
                                          ),
                                        )
                                            .then((val) =>
                                        val ? _getallvendors(1) : false);*/

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
                                                      child: EditVendorMasterScreen(srno: data[index].srNo!,searchText:false,data: data[index],searchData: SearchData(),)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                              if(val!=null){
                                                if(val){
                                                  data.clear();
                                                  _getallvendors();
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
                                            Text(data[index].srNo.toString()!=null ? data[index].srNo.toString() : "0",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Vendor Code",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(data[index].vendorCode!=null ? data[index].vendorCode! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text(data[index].vendorName!=null ? data[index].vendorName! : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Mobile Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(data[index].mobileNo!=null ? data[index].mobileNo! :  "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    )

                                  ],
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
                      controller: vendorRecordController,
                      shrinkWrap: true,
                      itemCount: searchData!.length,
                      itemBuilder: (context,index){
                        return Card(
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
                                      child: Icon(Icons.circle,size:10,color: /*index%2==0*/searchData![index].acStatus=="Active"  ? MyColors.greenColorCode:MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(searchData![index].acStatus=="Active" ? "Active" : "Inactive",style: TextStyle(color:/*index%2==0*/searchData![index].acStatus=="Active"  ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
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
                                                    child: EditVendorMasterScreen(srno: searchData![index].srNo!,searchText:true,data: data[0],searchData: searchData![index],)
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
                                                      child: EditVendorMasterScreen(srno: searchData![index].srNo!,searchText:true,data: data[0],searchData: searchData![index],)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                          if(val){
                                            data.clear();
                                            _getallvendors();
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
                                            Text(searchData![index].srNo.toString()!=null ? searchData![index].srNo.toString() : "0",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Vendor Code",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(searchData![index].vendorCode!=null ? searchData![index].vendorCode! : "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                            Text("Mobile Number",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].mobileNo!=null ? searchData![index].mobileNo! :  "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        )
                                    )

                                  ],
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
