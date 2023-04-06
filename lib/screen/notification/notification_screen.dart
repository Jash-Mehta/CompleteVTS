import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert_notification/alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/date_wise_search_alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/search_alert_notification_response.dart';
import 'package:flutter_vts/screen/notification/filter_alert_notification_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jiffy/jiffy.dart';
import 'package:intl/intl.dart';
import '../../model/alert_notification/filter_alert_notification_response.dart';

class NotificationScreen extends StatefulWidget {
  bool isappbar;
   NotificationScreen({Key? key,required this.isappbar}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  ScrollController notificationController = new ScrollController();
  ScrollController dateWiseNotificationController = new ScrollController();

  TextEditingController _fromdatecontroller = new TextEditingController();
  TextEditingController _fromTimecontroller = new TextEditingController();
  TextEditingController _todatecontroller = new TextEditingController();
  TextEditingController _toTimecontroller = new TextEditingController();


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> items = ["aaa", "bb", "cc", "dd", "ee"];

  bool _isLoading = false;

  bool isSelected = false;
  String radiolist = "radio";
  late int value = 0;
  late int notificationPosition = 0;
  late MainBloc _mainBloc;
  late SharedPreferences sharedPreferences;
  late int vendorid=0;
  int pageNumber=1,FilterPageNumber=0,searchFilterPageNumber=1,searchPageNumber=1;
  int searchDateWisePageNumber=1;

  int total=10;
  late String token="";
  late bool isSearch = false;
  late bool isDateWiseSearch = false;

  late String userName="";
  late String vendorName="",branchName="",userType="";
  late int branchid=0;
  List<AlertNotificationDatum>? data=[];
  List<SearchAlertNotification>? searchData=[];
  List<DateWiseSearchAlertDatum>? searchDateWiseData=[];

  final controller=ScrollController();
  TextEditingController searchController=new TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  DateTime currentdate = DateTime.now();

  late String date='',todate='',fromTime='',toTime='';
  late var filteralertresult;
  List<Datum>? filterAlertdataList=[];
  late bool isFilterAlertSearch = false;

  List<int> selectedvehicleSrNolist=[];
  List<String> selectedalerttypeList=[];
  late int selectedVendorid=0,selectedbranchid=0;
  late bool searchFilter = false;
  late String searchText='';
  late bool searchscroll = false;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _mainBloc = BlocProvider.of(context);
    getdata();

    setState(() {
      // _fromdatecontroller.text=currentdate.day.toString()+"/"+currentdate.month.toString()+"/"+currentdate.year.toString();
      // _todatecontroller.text=currentdate.day.toString()+"/"+currentdate.month.toString()+"/"+currentdate.year.toString();
      // _fromTimecontroller.text=currentdate.hour.toString()+":"+currentdate.minute.toString()+":"+currentdate.second.toString();
      // _toTimecontroller.text=currentdate.hour.toString()+":"+currentdate.minute.toString()+":"+currentdate.second.toString();
      todate = Jiffy(currentdate).format('d-MMMM-yyyy');
      date=Jiffy(currentdate).format('d-MMMM-yyyy');
      fromTime=currentdate.hour.toString()+":"+currentdate.minute.toString()+":"+currentdate.second.toString();
      toTime=currentdate.hour.toString()+":"+currentdate.minute.toString()+":"+currentdate.second.toString();
      // print("time ");
      // print(DateFormat.jm().format(DateFormat("hh:mm:ss").parse(toTime)));
    });
    controller.addListener(() {
      if(controller.position.maxScrollExtent==controller.offset){
        if(FilterPageNumber==0){
          if(isDateWiseSearch){
            setState(() {
              // searchDateWisePageNumber++;
              print("Scroll date ${searchDateWisePageNumber}");
              // _getdatewisealertnotification();
            });
          }else{
            setState(() {
              if(isSearch){
                searchscroll=true;
                searchPageNumber++;
                print("Scroll ${searchPageNumber}");

                searchALertNotification();
              }else{
                searchscroll=false;

                print("Search alert Scroll ${pageNumber}");

                getalertNotification();
              }
            });
          }

        }else{
          print("filter scroll");
          getAlertFilterNotifivation();
        }


      }
    });
  }

  getAlertFilterNotifivation(){
    if(searchFilter){
      _mainBloc.add(SearchFilteralertNotificationEvents(token:token,vendorId:selectedVendorid, branchId: selectedbranchid, araiNoarai: 'nonarai', username: userName,  displayStatus: 'n',vehiclesrNo: selectedvehicleSrNolist,alertCode: selectedalerttypeList, searchText: searchText,pageNumber:FilterPageNumber ,pageSize:10 ));
    }else{
      _mainBloc.add(FilteralertNotificationEvents(token:token,vendorId:selectedVendorid, branchId: selectedbranchid, araiNoarai: 'nonarai', username: userName,  displayStatus: 'n',vehiclesrNo: selectedvehicleSrNolist,alertCode: selectedalerttypeList,pageNumber:FilterPageNumber ,pageSize:10 ));
    }
  }

  searchALertNotification(){
    print(searchPageNumber);
    _mainBloc.add(SearchAlertNotificationEvents(token: token,vendorId: vendorid,branchId:branchid,arai:"nonarai",username: userName,displayStatus: "N",search: searchController.text,pageNumber: searchPageNumber,pageSize: 10));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        // firstDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now()
    );
    if (picked != null/* && picked != selectedDate*/) {
      setState(() {
        selectedDate = picked;
        _fromdatecontroller.text=selectedDate.day.toString()+"/"+selectedDate.month.toString()+"/"+selectedDate.year.toString();
        // date=selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();
        date = Jiffy(selectedDate).format('d-MMMM-yyyy');
        print(date);
      });
    }
  }
  Future<void> _toDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedToDate,
        // firstDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        // firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime.now()
    );
    if (picked != null/* && picked != selectedToDate*/) {
      setState(() {
        selectedToDate = picked;
        _todatecontroller.text=selectedToDate.day.toString()+"/"+selectedToDate.month.toString()+"/"+selectedToDate.year.toString();
        // todate=selectedDate.year.toString()+"-"+selectedDate.month.toString()+"-"+selectedDate.day.toString();
        todate = Jiffy(selectedToDate).format('d-MMMM-yyyy');
        print(todate);
      });
    }
  }

   Future<void>   _selectTime(BuildContext context) async {
    TimeOfDay? timeOfDay=await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if(timeOfDay != null/* && timeOfDay != selectedTime*/)
    {
      setState(() {
        selectedTime = timeOfDay;
        _fromTimecontroller.text=selectedTime.hour.toString()+":"+selectedTime.minute.toString();
        fromTime=selectedTime.hour.toString()+":"+selectedTime.minute.toString();
        print(selectedTime);

      });
    }
  }

  Future<void>   _selectToTime(BuildContext context) async {
    TimeOfDay? timeOfDay=await showTimePicker(
      context: context,
      initialTime: selectedToTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );

    if(timeOfDay != null/* && timeOfDay != selectedToTime*/)
    {
      setState(() {
        selectedToTime = timeOfDay;
        _toTimecontroller.text=selectedToTime.hour.toString()+":"+selectedToTime.minute.toString();
        print(selectedToTime);
        toTime=selectedToTime.hour.toString()+":"+selectedToTime.minute.toString();
      });
    }
  }


  getdata()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
    }
    if(sharedPreferences.getString("Username")!=null){
      userName=sharedPreferences.getString("Username")!;
    }
    vendorName=sharedPreferences.getString("VendorName")!;
    branchName=sharedPreferences.getString("BranchName")!;
    userType=sharedPreferences.getString("UserType")!;
    vendorid=sharedPreferences.getInt("VendorId")!;
    branchid=sharedPreferences.getInt("BranchId")!;
    print(token);
    if(token!=""){
      getalertNotification();
    }
  }

  getalertNotification(){
    _mainBloc.add(AlertNotificationEvents(token: token,vendorId: vendorid,branchId:branchid,arai:"nonarai",username:userName,displayStatus:"Y",pagenumber: pageNumber,pagesize: total));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      // appBar:
      //     widget.isappbar ? CustomAppBar().getCustomAppBar("ALERT/NOTIFICATIONS", _scaffoldKey):null,
      appBar: /*widget.isappbar ?*/ AppBar(
        title: Text("ALERT/NOTIFICATIONS"),
        actions: [
          GestureDetector(
            onTap: (){
              _filterAlertList();
            },
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child:Image.asset("assets/filter.png",height: 40,width: 40,) ,
            ),
          ),
           PopupMenuButton(
               onSelected: (value){
                  if(value=="Item1"){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialogforLogout(context));
                 }else{

                 }
               },
               itemBuilder: (context) => [
                  PopupMenuItem(
                      value:"Item1",
                      child: Text("Clear All")
                  ),
               ]
           )
          /*  Center(
                child: GestureDetector(
                  onTap: (){
                    print("click");
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupDialogforLogout(context));
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text("Clear All",style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
            )*/

        ],
      ) ,/*:null,*/


      body: _notification(),
    );
  }



  void _filterAlertList() async {

    filteralertresult=await   Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) =>
                BlocProvider(
                    create: (context) {
                      return MainBloc(
                          webService: WebService());
                    },
                    child: FilterAlertNotificationScreen())
        )
    );

    if (filteralertresult != null && filteralertresult.containsKey('FilterAlertDataList')) {
      setState(() {
        filterAlertdataList=filteralertresult["FilterAlertDataList"];
        print("Filter Alert Notification list : ${filteralertresult["FilterAlertDataList"]}");
        if(filterAlertdataList!.length!=0){
          isFilterAlertSearch=true;
        }else{
          isFilterAlertSearch=false;
        }
      });
    }

    if (filteralertresult != null && filteralertresult.containsKey('FilterAlert')) {
      setState(() {
        print(filteralertresult["FilterAlert"]);
        selectedvehicleSrNolist.clear();
        selectedalerttypeList.clear();
        filterAlertdataList!.clear();
        FilterPageNumber=0;
        isFilterAlertSearch=false;
      });
    }

    if (filteralertresult != null && filteralertresult.containsKey('SearchFilter')) {
      searchFilter=filteralertresult["SearchFilter"];
    }

    if (filteralertresult != null && filteralertresult.containsKey('SearchText')) {
      searchText=filteralertresult["SearchText"];
    }

    if (filteralertresult != null && filteralertresult.containsKey('FilterPageNumber')) {
      setState(() {
        FilterPageNumber=filteralertresult["FilterPageNumber"];
      });
    }
    if (filteralertresult != null && filteralertresult.containsKey('SelectedVehicleList')) {
       selectedvehicleSrNolist=filteralertresult["SelectedVehicleList"];
    }
    if (filteralertresult != null && filteralertresult.containsKey('SelectedAlertCodeList')) {
      selectedalerttypeList=filteralertresult["SelectedAlertCodeList"];
    }
    if (filteralertresult != null && filteralertresult.containsKey('SelectedVendorId')) {
      selectedVendorid=filteralertresult["SelectedVendorId"];
    }
    if (filteralertresult != null && filteralertresult.containsKey('SelectedBranchId')) {
    selectedbranchid=filteralertresult["SelectedBranchId"];
    }

  }



  _notification() {
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
            if (state is AlertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is AlertNotificationLoadedState) {
              setState(() {
                _isLoading = false;
              });
              print(state.alertNotificationResponse.succeeded);
              if (state.alertNotificationResponse.succeeded!) {
                setState(() {
                  // =state.alertNotificationResponse.data!;
                  data!.addAll(state.alertNotificationResponse.data!);
                  if(state.alertNotificationResponse.data!.length!=0){
                    pageNumber++;
                  }
                });

                if( state.alertNotificationResponse.message!=null){
                  Fluttertoast.showToast(
                    msg: state.alertNotificationResponse.message!,
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                  );
                }

              } else {
                Fluttertoast.showToast(
                  msg: state.alertNotificationResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }
            }else if (state is AlertNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }else if (state is SearchAlertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is SearchNotificationLoadedState) {
              setState(() {

                if(searchscroll){

                }else{
                  searchData!.clear();
                }
                _isLoading = false;
                if(state.searchAlertNotificationResponse.data!=null){
                  if(state.searchAlertNotificationResponse.data!.length!=0){
                    // searchPageNumber++;
                  }
                }

              });
              if(state.searchAlertNotificationResponse.data!=null){
                searchData!.addAll(state.searchAlertNotificationResponse.data!);
              }
             /* if (state.searchAlertNotificationResponse.succeeded!) {

              }else{

              }*/

            }else if (state is SearchNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }else if (state is DateWiseSearchAlertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is DateWiseSearchNotificationLoadedState) {
              setState(() {
                _isLoading = false;
                searchDateWiseData!.clear();
                if(state.dateWiseSearchAlertNotificationResponse.data!.length==0){
                  Fluttertoast.showToast(
                    msg:"Search record not found,please try again...!",
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                  );
                }

                  if(state.dateWiseSearchAlertNotificationResponse.data!=null){
                  searchDateWiseData!.addAll(state.dateWiseSearchAlertNotificationResponse.data!);
                  if(state.dateWiseSearchAlertNotificationResponse.data!.length!=0){
                    // searchDateWisePageNumber++;
                  }

                }
              });

            }else if (state is DateWiseSearchNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }else if (state is ClearAlertNotificationByIdLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is ClearAlertNotificationByIdLoadedState) {
              setState(() {
                _isLoading = false;
                getalertNotification();
                data!.removeAt(notificationPosition);

              });


            }else if (state is ClearAlertNotificationByIdErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                msg:"Something Went Wrong,Please try again",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }else if (state is ClearAllAlertNotificationByIdLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is ClearAllAlertNotificationByIdLoadedState) {
              setState(() {
                _isLoading = false;
                data!.clear();
                getalertNotification();
              });
              if(state.editDeviceResponse.succeeded!){
                Fluttertoast.showToast(
                  msg:state.editDeviceResponse.message!,
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }else{
                Fluttertoast.showToast(
                  msg:"No Record Found To Clear",
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                );
              }


            }else if (state is ClearAllAlertNotificationByIdErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                msg:"Something Went Wrong,Please try again",
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
              );
            }else if (state is FilteralertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else  if (state is FilteralertNotificationLoadedState) {
              setState(() {
                _isLoading = false;

                if(state.filterAlertNotificationResponse.data!=null){
                  if(state.filterAlertNotificationResponse.data!.length!=0){
                    FilterPageNumber++;
                  }
                }
              });

              if(state.filterAlertNotificationResponse.succeeded!){
                filterAlertdataList!.addAll(state.filterAlertNotificationResponse.data!);
              }else{
                /*if(state.filterAlertNotificationResponse.message!=null){
                  Fluttertoast.showToast(
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    msg: state.filterAlertNotificationResponse.message!,
                  );
                }*/
              }

            }else  if (state is FilteralertNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: "Something Went Wrong,Please try again",
              );
            }else  if (state is SearchFilteralertNotificationLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else  if (state is SearchFilteralertNotificationLoadedState) {
              setState(() {
                _isLoading = false;
                if(state.filterAlertNotificationResponse.data!=null){
                  if(state.filterAlertNotificationResponse.data!.length!=0){
                    FilterPageNumber++;
                  }
                }
              });
              if(state.filterAlertNotificationResponse.succeeded!){
                filterAlertdataList!.addAll(state.filterAlertNotificationResponse.data!);
              }else{
                if(state.filterAlertNotificationResponse.message!=null){
                  // Fluttertoast.showToast(
                  //   toastLength: Toast.LENGTH_SHORT,
                  //   timeInSecForIosWeb: 1,
                  //   msg: state.filterAlertNotificationResponse.message!,
                  // );
                }
              }
            }else  if (state is SearchFilteralertNotificationErrorState) {
              setState(() {
                _isLoading = false;
              });
            }
          },
        child: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: MyColors.lightgreyColorCode,
                    boxShadow: [
                      BoxShadow(blurRadius: 10, color: MyColors.shadowGreyColorCode)
                    ]),
                // width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(_fromdatecontroller.text.isEmpty ? date : _fromdatecontroller.text),
                          Text(_fromTimecontroller.text.isEmpty ? fromTime: _fromTimecontroller.text),
                        ],
                      ),
                    ),
                    Text("-"),
                    Expanded(child: Column(
                      children: [
                        Text(_todatecontroller.text.isEmpty ? todate :_todatecontroller.text),
                        Text(_toTimecontroller.text.isEmpty ? toTime:_toTimecontroller.text),
                      ],
                    ),
                    ),

                    GestureDetector(
                      onTap: () {
                        /*DateTime currentTime = DateTime.now();

                        String result1 = Jiffy(currentTime).format('d-MMMM-yyyy');
                        print(result1);

                        String result2 = Jiffy(currentTime).format('MMM do yy');
                        print(result2);*/
                        // searchController.clear();
                        // print( isSearch.toString()+""+isDateWiseSearch.toString() );

                        changeDatepopUp(context);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: MyColors.greyColorCode,
                            borderRadius: BorderRadius.all(Radius.circular(20))),
                        child: Text(
                          "Change",
                          style: TextStyle(
                              color: MyColors.text4ColorCode, fontSize: 18),
                        ),
                      ),
                    )

                    // Text("10 NOTIFICATIONS",style: TextStyle(fontSize: 18),),
                    // Text("CLEAR ALL",style: TextStyle(decoration: TextDecoration.underline,color: MyColors.appDefaultColorCode,fontSize: 18),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 15, right: 15, bottom: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      enabled: true, // to trigger disabledBorder
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
                          borderSide:
                              BorderSide(width: 1, color: MyColors.textColorCode),
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
                        hintText: "Search Record",
                        prefixIcon: Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                            fontSize: 18, color: MyColors.searchTextColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      onChanged: (value){
                        if(searchController.text.isEmpty){
                          setState(() {
                            searchPageNumber=1;
                            isSearch=false;
                          });
                        }else{
                          setState(() {
                            searchData!.clear();
                            searchscroll=false;
                            isFilterAlertSearch=false;
                            searchPageNumber=1;

                            FilterPageNumber=0;
                            isSearch=true;
                          });
                          searchALertNotification();
                        }
                      },
                      obscureText: false,
                    ),
                    isFilterAlertSearch ? ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: filterAlertdataList!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              // _mainBloc.add(ClearAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName,alertNotificatioID:searchData![index].srNo!));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: MyColors.textBoxBorderColorCode),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 14, right: 14, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/alert.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                        /*Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColors.notificationblueColorCode,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.notifications_none,color: MyColors.appDefaultColorCode,),
                                        ),*/
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: MyColors.textBoxColorCode,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          child: Text(filterAlertdataList![index].acDate!.hour.toString()+":"+filterAlertdataList![index].acDate!.minute.toString()+":"+filterAlertdataList![index].acDate!.second.toString()),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Vehicle No. ${filterAlertdataList![index].vehicleRegNo}",
                                        style: TextStyle(
                                            color: MyColors.text4ColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 10.0, bottom: 4),
                                      child: Text(
                                        "${filterAlertdataList![index].alertIndication}",
                                        style: TextStyle(
                                            color: MyColors.appDefaultColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    // Text(
                                    //   "Shivaji Chowk Hinjawadi, Hinjawadi Road, Hinjawadi Village, Hinajawadi, Pimpri - Chinchwad, Maharastra,India.",
                                    //   style: TextStyle(
                                    //       color: MyColors.text4ColorCode,
                                    //       fontSize: 18),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }):
                    isSearch || isDateWiseSearch ?
                    isSearch ? ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: searchData!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                              // _mainBloc.add(ClearAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName,alertNotificatioID:searchData![index].srNo!));
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: MyColors.textBoxBorderColorCode),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 14, right: 14, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/alert.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                        /*Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColors.notificationblueColorCode,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.notifications_none,color: MyColors.appDefaultColorCode,),
                                        ),*/
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: MyColors.textBoxColorCode,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          child: Text(searchData![index].acDate!.hour.toString()+":"+searchData![index].acDate!.minute.toString()+":"+searchData![index].acDate!.second.toString()),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Vehicle No. ${searchData![index].vehicleRegNo}",
                                        style: TextStyle(
                                            color: MyColors.text4ColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 10.0, bottom: 4),
                                      child: Text(
                                        "${searchData![index].alertIndication}",
                                        style: TextStyle(
                                            color: MyColors.appDefaultColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    // Text(
                                    //   "Shivaji Chowk Hinjawadi, Hinjawadi Road, Hinjawadi Village, Hinajawadi, Pimpri - Chinchwad, Maharastra,India.",
                                    //   style: TextStyle(
                                    //       color: MyColors.text4ColorCode,
                                    //       fontSize: 18),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                        :ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: searchDateWiseData!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: (){
                                // _mainBloc.add(ClearAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName,alertNotificatioID:searchData![index].srNo!));
                              },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: MyColors.textBoxBorderColorCode),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 14, right: 14, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/alert.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                        /*Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColors.notificationblueColorCode,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.notifications_none,color: MyColors.appDefaultColorCode,),
                                        ),*/
                                        Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: MyColors.textBoxColorCode,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(3))),
                                          child: Text(searchDateWiseData![index].acDate!.hour.toString()+":"+searchDateWiseData![index].acDate!.minute.toString()+":"+searchDateWiseData![index].acDate!.second.toString()),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Vehicle No. ${searchDateWiseData![index].vehicleRegNo}",
                                        style: TextStyle(
                                            color: MyColors.text4ColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.only(top: 10.0, bottom: 4),
                                      child: Text(
                                        "${searchDateWiseData![index].alertIndication}",
                                        style: TextStyle(
                                            color: MyColors.appDefaultColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }):
                    data!.length==0 ? Container() :ListView.builder(
                        controller: notificationController,
                        shrinkWrap: true,
                        itemCount: data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: (){
                             /* setState(() {
                                notificationPosition=index;
                                _mainBloc.add(ClearAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName,alertNotificatioID:data![index].srNo!));
                              });*/
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                    width: 1, color: MyColors.textBoxBorderColorCode),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 10, left: 14, right: 14, bottom: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/alert.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                        /* Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: MyColors.notificationblueColorCode,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.notifications_none,color: MyColors.appDefaultColorCode,),
                                        ),*/
                                        Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 6),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                  color: MyColors.textBoxColorCode,
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(3))),
                                              child: Text(data![index].acDate!.hour.toString()+":"+data![index].acDate!.minute.toString()+":"+data![index].acDate!.second.toString()),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  notificationPosition=index;
                                                  _mainBloc.add(ClearAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName,alertNotificatioID:data![index].srNo!));
                                                });
                                              },
                                              child: Image.asset(
                                                "assets/delete_icon.png",
                                                width: 40,
                                                height: 40,
                                              )/*Container(
                                                margin: EdgeInsets.only(left: 10),

                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color:MyColors.notificationblueColorCode,
                                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                                ),
                                                child: Text("Delete"),
                                              )*/,
                                            ),
                                            // IconButton(
                                            //     onPressed: (){}, icon: Icon(Icons.delete))
                                          ],
                                        ),
                                      ],
                                    ),
                                    // data![index].srNo!=null ?  Text(data![index].srNo!.toString()):Container(),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Vehicle No. ${data![index].vehicleRegNo}",
                                        style: TextStyle(
                                            color: MyColors.text4ColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10.0, bottom: 4),
                                      child: Text(
                                        "${data![index].alertIndication}",
                                        style: TextStyle(
                                            color: MyColors.appDefaultColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                    /*Text(
                                      "Shivaji Chowk Hinjawadi, Hinjawadi Road, Hinjawadi Village, Hinajawadi, Pimpri - Chinchwad, Maharastra,India.",
                                      style: TextStyle(
                                          color: MyColors.text4ColorCode,
                                          fontSize: 18),
                                    ),*/
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  changeDatepopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 310,
              width: MediaQuery.of(context).size.width - 20,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                      child: Text(
                        "From Date/Time",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _fromdatecontroller,
                            enabled: true, // to trigger disabledBorder
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyColors.whiteColorCode,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.buttonColorCode),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.textColorCode),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.textBoxBorderColorCode)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: MyColors.buttonColorCode)),
                              hintText: "DD/MM/YY",
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                size: 24,
                                color: MyColors.dateIconColorCode,
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.searchTextColorCode),
                              errorText: "",
                            ),
                            // controller: _passwordController,
                            // onChanged: _authenticationFormBloc.onPasswordChanged,
                            obscureText: false,
                            onTap: (){
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _selectDate(context);
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              controller: _fromTimecontroller,
                              enabled: true, // to trigger disabledBorder
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: MyColors.whiteColorCode,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.buttonColorCode),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: MyColors.textColorCode),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            MyColors.textBoxBorderColorCode)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: MyColors.buttonColorCode)),
                                hintText: "hh:mm:AM",
                                suffixIcon: Icon(
                                  Icons.watch_later_outlined,
                                  size: 24,
                                  color: MyColors.dateIconColorCode,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.searchTextColorCode),
                                errorText: "",
                              ),
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                _selectTime(context);
                              },
                              onChanged: (value){

                              },
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 10),
                      child: Text(
                        "To Date/Time",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _todatecontroller,
                            enabled: true, // to trigger disabledBorder
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: MyColors.whiteColorCode,
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.buttonColorCode),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide:
                                    BorderSide(width: 1, color: Colors.orange),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                                borderSide: BorderSide(
                                    width: 1, color: MyColors.textColorCode),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  )),
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.textBoxBorderColorCode)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 2,
                                      color: MyColors.buttonColorCode)),
                              hintText: "DD/MM/YY",
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                size: 24,
                                color: MyColors.dateIconColorCode,
                              ),
                              hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: MyColors.searchTextColorCode),
                              errorText: "",
                            ),
                            // controller: _passwordController,
                            // onChanged: _authenticationFormBloc.onPasswordChanged,
                            onTap: (){
                              FocusScope.of(context).requestFocus(new FocusNode());
                              _toDate(context);

                            },
                            onChanged: (value){
                              // FocusScope.of(context).requestFocus(new FocusNode());
                            },
                            obscureText: false,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: TextField(
                              controller: _toTimecontroller,
                              enabled: true, // to trigger disabledBorder
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: MyColors.whiteColorCode,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1,
                                      color: MyColors.buttonColorCode),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: Colors.orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 1, color: MyColors.textColorCode),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                      width: 1,
                                    )),
                                errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color:
                                            MyColors.textBoxBorderColorCode)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4)),
                                    borderSide: BorderSide(
                                        width: 2,
                                        color: MyColors.buttonColorCode)),
                                hintText: "hh:mm:AM",
                                suffixIcon: Icon(
                                  Icons.watch_later_outlined,
                                  size: 24,
                                  color: MyColors.dateIconColorCode,
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.searchTextColorCode),
                                errorText: "",
                              ),
                              // controller: _passwordController,
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                _selectToTime(context);
                              },
                              onChanged: (value){
                              },
                              obscureText: false,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: (){
                              _fromdatecontroller.clear();
                              _toTimecontroller.clear();
                              _fromTimecontroller.clear();
                              _todatecontroller.clear();
                              setState(() {
                                searchDateWiseData!.clear();
                                isDateWiseSearch=false;
                              });
                              // Navigator.pop(context);

                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phonelink_erase_rounded,
                                  color: MyColors.text4ColorCode,
                                ),
                                Text("Clear",
                                    style: TextStyle(
                                        color: MyColors.text4ColorCode,
                                        decoration: TextDecoration.underline,
                                        fontSize: 20)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.close,
                                  color: MyColors.text4ColorCode,
                                ),
                                Text("Close",
                                    style: TextStyle(
                                        color: MyColors.text4ColorCode,
                                        decoration: TextDecoration.underline,
                                        fontSize: 20)),
                              ],
                            ),
                          ),
                        ),
                        // IconButton(
                        //     onPressed: (){
                        //
                        //     },
                        //     icon: Icon(Icons.)),
                        Expanded(
                          flex: 2,
                          child:MaterialButton(
                            onPressed: () {
                              _validation();
                              // print(date.toString()+","+todate+","+fromTime+""+toTime);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, top: 8, bottom: 8),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.whiteColorCode),
                              ),
                            ),
                            color: MyColors.buttonColorCode,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }



  _validation(){
    if(_fromdatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select From Date",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_fromTimecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select From Time",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_todatecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select To Time",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(_toTimecontroller.text.isEmpty){
      Fluttertoast.showToast(
        msg: "Please Select To Time",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(selectedDate.compareTo(selectedToDate)==1){
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date should be less than to End date...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else if(selectedDate.month!=selectedToDate.month){
      Fluttertoast.showToast(
        msg: "Please check Start & End date! Start date and end date Month Will be Same...!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }else{
    /*  Fluttertoast.showToast(
        msg: "Success",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );*/
      // Navigator.pop(context);

      _getdatewisealertnotification();

    }
  }

  _getdatewisealertnotification(){
    setState(() {
      isDateWiseSearch=true;
      searchDateWisePageNumber=1;
    });
    _mainBloc.add(DateWiseSearchAlertNotificationEvents(token:token,vendorId: vendorid,branchId:branchid,arai:"nonarai",username:userName,displayStatus:"Y",fromDate:date,formTime:_fromTimecontroller.text,toDate:todate,toTime:_toTimecontroller.text,pageNumber: searchDateWisePageNumber,pageSize: total));
    Navigator.of(context).pop();
  }

  Widget _buildPopupDialogforLogout(BuildContext context) {
    return new AlertDialog(
      // title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Clear All Alert",style: TextStyle(fontSize:20,color: MyColors.appDefaultColorCode,fontWeight: FontWeight.bold),),
          SizedBox(
            height: 20,
          ),
          Text("Are you sure you want to clear all alert notification?",style: TextStyle(fontSize: 18),),
        ],
      ),
      actions: <Widget>[
        new TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text(
            'CANCEL',
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        new TextButton(
          onPressed: () {
            Navigator.pop(context);
            clearAllAlertNotification();

          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text(
            'CONFIRM',
            style: TextStyle(
              fontSize: 14.0,
              color: MyColors.orangeColorCode,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  clearAllAlertNotification(){
    print(userName+""+vendorid.toString()+""+branchid.toString());
    _mainBloc.add(ClearAllAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName));
  }

}
