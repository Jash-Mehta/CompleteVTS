import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/utility/adduser/add_user_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_vts/model/user/create_user/get_all_create_user_response.dart';
import 'package:flutter_vts/model/user/create_user/search_created_user_response.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController cretedUserRecordController=new ScrollController();
  TextEditingController searchController=new TextEditingController();
  late bool isSearch = false;

  late bool _isLoading = false;
  late MainBloc _mainBloc;
  int pageNumber=1;
  int pageSize=10;
  int totalUserRecords=0;


  // List<Datum> ? datalist=[];
  List<Datum> ?data=[];

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
          _getallusers();
        });

      }
    });
  }

  _getallusers(){
    _mainBloc.add(AllCreateUserEvents(vendorId: vendorid,branchId : branchid,pagenumber: pageNumber,pagesize: 10,token: token));
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
      _getallusers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: CustomAppBar().getCustomAppBar("CREATE USER",_scaffoldKey,0,context),
      body: _createuser(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.blueColorCode,
        onPressed: () async{

          // Navigator.push(context,
          //     MaterialPageRoute(builder: (_) =>
          //         BlocProvider(
          //             create: (context) {
          //               return MainBloc(webService: WebService());
          //             },
          //             child: AddUserScreen(flag: 1,searchText:false,datum: data!.length==0 ? null! :data![0],searchData: Data(),)
          //         )));


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
                        child: AddUserScreen(flag: 1,searchText:false,datum: data!.length==0 ? null! :data![0],searchData: Data(),)
                    )
            ),
          )
              .then((val) {
            if(val!=null){
              if(val){
                data!.clear();
                _getallusers();
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

  _createuser(){
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
          if (state is AllCreatedUserLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is AllCreatedUserLoadedState) {
            setState(() {
              _isLoading = false;
              totalUserRecords=state.getAllCreateUserResponse.totalRecords!;
              pageNumber++;
              if(state.getAllCreateUserResponse.data!=null){
                data!.addAll(state.getAllCreateUserResponse.data!);
              }

            });

          }else if (state is AllCreatedUserErrorState) {
            setState(() {
              _isLoading = false;
            });
            Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong,please try again",
            );
          }else if (state is SearchCreatedUserLoadingState) {
            setState(() {
              _isLoading = true;
            });
          }else if (state is SearchCreatedUserLoadedState) {
            setState(() {
              searchData!.clear();

              _isLoading = false;
              pageNumber++;
              if(state.searchCreatedUserResponse.data!=null){
                searchData!.addAll(state.searchCreatedUserResponse.data!);
              }
            });
          }else if (state is SearchCreatedUserErrorState) {
            setState(() {
              _isLoading = false;
            });
           /* Fluttertoast.showToast(
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              msg: "Something went wrong,please try again",
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
                      _mainBloc.add(SearchCreateUserEvents(vendorId:vendorid,branchId: branchid,searchText: searchController.text,token: token));
                    }
                  },
                  obscureText: false,
                ),
                Text(
                  !isSearch ? data!.length!=0 ?  "Showing 1 to ${data!.length} Out of ${totalUserRecords}" : "0 RECORDS" : searchData!.length!=0 ?  "Showing 1 to ${searchData!.length} Out of ${totalUserRecords}" :

                  "0 RECORDS",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                !isSearch ? data!.length==0 ? Container() :

                Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child:ListView.builder(
                      shrinkWrap: true,
                      controller: cretedUserRecordController,
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
                                      child: Icon(Icons.circle,size:10,color:
                                      data![index].acFlag=="Active" ? MyColors.greenColorCode:
                                      MyColors.redColorCode,),
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            data![index].acFlag=="Active"   ? "Active" :
                                            "Inactive",style: TextStyle(color:
                                          data![index].acFlag=="Active" ? MyColors.greenColorCode:
                                          MyColors.redColorCode,fontSize: 20),),
                                        )
                                    ),
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
                                                      child: AddUserScreen(flag: 2,searchText:false,datum:data![index],searchData: Data(),)
                                                  )
                                          ),
                                        )
                                            .then((val) {
                                              if(val!=null){
                                                if(val){
                                                  data!.clear();
                                                  _getallusers();
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
                                        child: Text("EDIT",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.analyticActiveColorCode,fontSize: 18),),
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
                                            Text("User ID",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              data![index].userId!=null ? data![index].userId!.toString() :
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
                                                data![index].userName!=null ? data![index].userName! :
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
                                            data![index].vendorName!=null ? data![index].vendorName! :
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
                                              data![index].branchName!=null ? data![index].branchName!:
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
                                            Text("User Type",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(
                                              data![index].userType!=null ? data![index].userType! :
                                              "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Email ID",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                              Text(
                                                data![index].emailId!=null ? data![index].emailId! :
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
                    controller: cretedUserRecordController,
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
                                    child: Icon(Icons.circle,size:10,color: searchData![index].acFlag=='Active' ? MyColors.greenColorCode:MyColors.redColorCode,),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(searchData![index].acFlag=='Active' ? "Active" : "Inactive",style: TextStyle(color:searchData![index].acFlag=='Active' ? MyColors.greenColorCode: MyColors.redColorCode,fontSize: 20),),
                                      )
                                  ),
                                  GestureDetector(
                                    onTap: ()async{
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
                                                    child: AddUserScreen(flag: 2,searchText:true,datum:data![0],searchData: searchData![index],)
                                                )
                                        ),
                                      )
                                          .then((val) {
                                            if(val!=null){
                                              if(val){
                                                data!.clear();
                                                _getallusers();
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
                                          Text("User ID",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(searchData![index].userId!=null ? searchData![index].userId!.toString() : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
                                          Text("User Type",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                          Text(searchData![index].userType!=null ? searchData![index].userType!  : "",style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Email ID",style: TextStyle(color: MyColors.textprofiledetailColorCode,fontSize: 18),),
                                            Text(searchData![index].emailId!=null ? searchData![index].emailId!: "",textAlign:TextAlign.left,style: TextStyle(color: MyColors.text5ColorCode,fontSize: 18),),
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
