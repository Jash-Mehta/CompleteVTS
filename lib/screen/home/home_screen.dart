import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/dashbord/dashboard_response.dart';
import 'package:flutter_vts/screen/alert_notitication_screen.dart';
import 'package:flutter_vts/screen/change_password/change_password_screen.dart';
import 'package:flutter_vts/screen/notification/notification_screen.dart';
import 'package:flutter_vts/screen/vehicle_analytics_reports_status/vehicle_analytics_reports_status_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _recordCountController = ScrollController();
  ScrollController alertController = ScrollController();
  String dropdownValue = 'Today';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool value = false;
  String dropdownvalue = 'Today';

  late String userName="";

  late String vendorName="",branchName="",userType="",lastlogin="";
  late SharedPreferences sharedPreferences;
  late String token="", vendorname;
  List<CountList> ?countList=[];
  List<CountList> ?colorList=[];
  List<Alert> ?alertsList=[];
  late Timer timer;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  // List of items in our dropdown menu
  var items = ['Today', 'Week', 'Months', 'Custom'];
  late bool _isLoading = false;
  late MainBloc mainBloc;
  late int branchid=0,vendorid=0,notificationPosition=0;
  int pageNumber=1;

  late DashbordResponse dashbordResponse=new DashbordResponse();
  List<ChartData> data = [
    ChartData('Running', 08, MyColors.greenChartColorCode),
    ChartData('In-Active', 02, MyColors.analyticActiveColorCode),
    ChartData('Over Speed', 03, MyColors.analyticoverSpeedlColorCode),
    ChartData('No Data', 02, MyColors.dateIconColorCode),
    ChartData('Stopped', 01, MyColors.analyticStoppedColorCode),
    ChartData('Idle             ', 06, MyColors.analyticIdelColorCode),
    ChartData('Parking', 02, MyColors.yellowChartColorCode),
  ];

  @override
  void initState() {
    super.initState();
    mainBloc = BlocProvider.of(context);
    // getdashbord();
    timer = Timer.periodic(Duration(seconds: 60), (Timer t) => getdashbord());
    print(dashbordResponse);
    getData();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    print("cancel");
    timer.cancel();
  }

  @override
  void dispose() {
    // timer.cancel();
    print("cancel");
    timer.cancel();
    super.dispose();
  }

  getdashbord() async {
    mainBloc.add(DashboradEvents(vendorId: vendorid,branchId: branchid,optionClicked:"RUNNING"/*"RUNNING_COUNT"*/,aRAI_NONARAI: 'NONARAI', username: userName,pageNumber: pageNumber,pageSize: 10,token:token));
  }


  getData()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getString("auth_token")!=null){
      token=sharedPreferences.getString("auth_token")!;
      // print("token ${token}");

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
    if(sharedPreferences.getString("LastLoginDateTime")!=null){
      lastlogin=sharedPreferences.getString("LastLoginDateTime")!;
    }

    if(token!="" || vendorid!=0 || branchid!=0 ||vendorName!="" || branchName!=""){
      getdashbord();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer()/*.getMenuDrawer(context)*/,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Image.asset("assets/vtsgps_icon.png",/*width: 150,height: 50,*/),
        ) ,
        actions: [
          IconButton(
              onPressed: (){
              },
              icon: Icon(Icons.help_outline,size: 30,color:MyColors.whiteColorCode ,)
          )
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: MyColors.backgroundColorCode,
      body: _dashborddesign(),
    );
  }

  _dashborddesign() {
    return RefreshIndicator(
      key: refreshKey,
      onRefresh: () async{
        setState(() {
          _isLoading = true;
          getdashbord();
        });
      },
      child: LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Color(0xFFCE4A6F),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child:  BlocListener<MainBloc, MainState>(
          listener: (context,state){
            if (state is DashbordLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is DashbordLoadedState) {
              setState(() {
                _isLoading = false;
                dashbordResponse=state.dashbordResponse;
                countList=state.dashbordResponse.countList;
                alertsList=state.dashbordResponse.alerts;
              });

            /*  for(int i=0;i<countList!.length;i++){
                if(countList![i].status=="RUNNING"){

                }
              }*/
            }else if (state is DashbordErrorState) {
              setState(() {
                _isLoading = false;
              });

              Fluttertoast.showToast(
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                msg: "Something went wrong,please try again",
              );
            }else if (state is ClearAlertNotificationByIdLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }else if (state is ClearAlertNotificationByIdLoadedState) {
              setState(() {
                _isLoading = false;
                getdashbord();
                data.removeAt(notificationPosition);

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
            }
          },
          child: dashbordResponse==null ? Container() :  SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
              child: Column(
                children: [
                  Row(
                    children:  [
                      Text("Welcome Back ",
                          style: TextStyle(
                              fontSize: 22,
                              color: MyColors.text5ColorCode,
                              fontWeight: FontWeight.normal)),
                      Text("${userName} !",
                          style: TextStyle(
                              fontSize: 22,
                              color: MyColors.appDefaultColorCode,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 15),
                    child: Row(
                      children:  [
                        Text("Your last sign in at ",
                            style: TextStyle(
                                fontSize: 18,
                                color: MyColors.text5ColorCode,
                                fontStyle: FontStyle.italic)),
                        Expanded(
                          child: Text(
                              lastlogin=="" ? ""/*"Monday, 31/01/2022 04:38:09 PM"*/ :lastlogin.toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  color: MyColors.text5ColorCode,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  countList==null ? Container() : countList!.length==0 ? Container() : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Analytics Report",
                          style: TextStyle(
                              fontSize: 20,
                              color: MyColors.text5ColorCode,
                              fontWeight: FontWeight.bold)),
                      /*Container(
                        color: MyColors.lightblueColorCode,
                        width: 120,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            isDense: true,
                            value: dropdownValue,
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              color: MyColors.blueColorCode,
                            ),
                            elevation: 16,
                            style: const TextStyle(color: MyColors.blueColorCode),
                            underline: Container(
                              height: 0,
                              color: MyColors.blueColorCode,
                            ),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['Today', 'Week', 'Month', 'Custom']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      )*/
                      // Container(
                      //   height: 36,
                      //   padding: EdgeInsets.all(8),
                      //   color: MyColors.lightblueColorCode,
                      //   child: DropdownButton(
                      //     value: dropdownvalue,
                      //     underline: SizedBox(),
                      //     icon: const Icon(
                      //       Icons.keyboard_arrow_down,
                      //       color: MyColors.appDefaultColorCode,
                      //     ),
                      //     items: items.map((String items) {
                      //       return DropdownMenuItem(
                      //         value: items,
                      //         child: Container(
                      //             child: Text(items,
                      //                 style: TextStyle(
                      //                     fontSize: 18,
                      //                     color: MyColors.appDefaultColorCode))),
                      //       );
                      //     }).toList(),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         dropdownvalue = newValue!;
                      //       });
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                  countList==null ? Container() : countList!.length==0 ? Container() : Card(
                    margin: const EdgeInsets.only(top: 10),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          width: 1, color: MyColors.textBoxBorderColorCode),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(left: 14, right: 14),
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                         /* SfCircularChart(
                                legend: Legend(
                                  height: "100",
                                  isVisible: true,
                                  overflowMode: LegendItemOverflowMode.wrap,
                                  position: LegendPosition.bottom,
                                  // legendItemBuilder: (String name, dynamic series, dynamic point, int index){
                                  //
                                  //   return Container(
                                  //     height: 20,
                                  //     width: 10,
                                  //     child: Container(child: Text(point.y.toString()))
                                  //   );
                                  // }
                                  // orientation: LegendItemOrientation.vertical
                                ),
                                annotations: [
                                  CircularChartAnnotation(
                                      widget: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children:  [
                                          Container(
                                            // padding: const EdgeInsets.only(left: 20, top: 10),
                                            child: Wrap(
                                              alignment: WrapAlignment.center,
                                              // direction: Axis.horizontal,
                                              children: <Widget>[
                                                for (var i = 0;
                                                i < countList!.length;
                                                i++)
                                                  if(countList![i].status=='TOTAL')
                                                    Text(
                                                      countList![i].tCount.toString(),
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          color: MyColors.appDefaultColorCode,
                                                          fontSize: 24,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                              ],
                                            ),
                                          ),
                                    ],
                                  ))
                                ],
                              series: <CircularSeries>[
                                // Render pie chart
                                DoughnutSeries<CountList, String>(
                                  legendIconType: LegendIconType.rectangle,
                                  dataSource: countList,
                                  onPointTap: (value){
                                    // print("Chart click :  ${value.}");
                                  },
                                  radius: "80%",
                                  innerRadius: '70%',
                                  xValueMapper: (CountList data, _) => data.status!+" (${data.tCount})",
                                  yValueMapper: (CountList data, _) => data.tCount!,
                                  pointColorMapper: (CountList data, _) {
                                    if(data.status=='STOPPED'){
                                        return MyColors.analyticStoppedColorCode;
                                    }else if(data.status=='NODATA'){
                                      return MyColors.analyticnodataColorCode;
                                    }else if(data.status=='OVERSPEED'){
                                      return MyColors.analyticoverSpeedlColorCode;
                                    }else if(data.status=='RUNNING'){
                                      return MyColors.analyticGreenColorCode;
                                    }else if(data.status=='IDLE'){
                                      return  MyColors.analyticIdelColorCode;
                                    }else if(data.status=='INACTIVE'){
                                      return MyColors.analyticActiveColorCode;
                                    }if(data.status=='TOTAL'){
                                      return MyColors.yellowColorCode;
                                    }
                                  },
                                  // dataLabelSettings: DataLabelSettings(isVisible: true),
                                  // enableTooltip: true
                                )
                              ]
                                // series: <CircularSeries>[
                                //   // Render pie chart
                                //   DoughnutSeries<ChartData, String>(
                                //     legendIconType: LegendIconType.rectangle,
                                //     dataSource: data,
                                //     radius: "80%",
                                //     innerRadius: '70%',
                                //     xValueMapper: (ChartData data, _) => data.year+"(0)",
                                //     yValueMapper: (ChartData data, _) => data.sales,
                                //     pointColorMapper: (ChartData data, _) =>
                                //         data.color,
                                //     // dataLabelSettings: DataLabelSettings(isVisible: true),
                                //     // enableTooltip: true
                                //   )
                                // ]
                            ),*/

                          /*Container(
                              child: SfCircularChart(
                                  legend: Legend(
                                      isVisible: true,
                                      overflowMode: LegendItemOverflowMode.wrap,
                                      position: LegendPosition.bottom,
                                      // Templating the legend item
                                      legendItemBuilder: (String name, dynamic series, dynamic point, int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            print(index);
                                            print(series);
                                            print(name);
                                            print(point);


                                          },
                                          child: Container(
                                              height: 20,
                                              width: 10,
                                              child: Container(child: Text(point.x.toString()))
                                          ),
                                        );
                                      },
                                    orientation: LegendItemOrientation.vertical

                                  ),
                                  series: <CircularSeries>[
                                    DoughnutSeries<CountList, String>(
                                      legendIconType: LegendIconType.rectangle,
                                      dataSource: countList,
                                      onPointTap: (value){
                                        // print("Chart click :  ${value.}");
                                      },
                                      radius: "80%",
                                      innerRadius: '70%',
                                      xValueMapper: (CountList data, _) => data.status!+" (${data.tCount})",
                                      yValueMapper: (CountList data, _) => data.tCount!,
                                      pointColorMapper: (CountList data, _) {
                                        if(data.status=='STOPPED'){
                                          return MyColors.analyticStoppedColorCode;
                                        }else if(data.status=='NODATA'){
                                          return MyColors.analyticnodataColorCode;
                                        }else if(data.status=='OVERSPEED'){
                                          return MyColors.analyticoverSpeedlColorCode;
                                        }else if(data.status=='RUNNING'){
                                          return MyColors.analyticGreenColorCode;
                                        }else if(data.status=='IDLE'){
                                          return  MyColors.analyticIdelColorCode;
                                        }else if(data.status=='INACTIVE'){
                                          return MyColors.analyticActiveColorCode;
                                        }if(data.status=='TOTAL'){
                                          return MyColors.yellowColorCode;
                                        }


                                        // for(int i=0;i<data1.length;i++){
                                        //   return data1[i].color;
                                        // }
                                      },
                                      // dataLabelSettings: DataLabelSettings(isVisible: true),
                                      // enableTooltip: true
                                    )
                                  ]
                              )
                          )*/


                          SfCircularChart(
                              legend: Legend(
                                // height: "100",
                                isVisible: true,
                                toggleSeriesVisibility: false,
                                overflowMode: LegendItemOverflowMode.wrap,
                                orientation: LegendItemOrientation.vertical,
                                position: LegendPosition.bottom,
                                legendItemBuilder: (String name, dynamic series, dynamic point, int index){
                                  return GestureDetector(
                                    onTap: (){
                                      print("click");
                                        if(countList![index].tCount==0){
                                          print(countList![index].status);
                                          Fluttertoast.showToast(
                                            toastLength: Toast.LENGTH_SHORT,
                                            timeInSecForIosWeb: 1,
                                            msg: "${countList![index].status} count is 0.please select another Analytic report status",
                                          );
                                        }else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      BlocProvider(
                                                          create: (context) {
                                                            return MainBloc(
                                                                webService: WebService());
                                                          },
                                                          child: VehicleAnalyticsReportsStatusScreen(
                                                            analyticTiltle: countList![index].status!,colorCode: countList![index].status=="STOPPED" ? MyColors.analyticStoppedColorCode :countList![index].status=="NODATA" ? MyColors.analyticnodataColorCode : countList![index].status=="OVERSPEED" ? MyColors.analyticoverSpeedlColorCode:countList![index].status=="RUNNING" ? MyColors.analyticGreenColorCode :countList![index].status=="IDLE" ? MyColors.analyticIdelColorCode :countList![index].status=="INACTIVE" ? MyColors.analyticActiveColorCode :countList![index].status=="TOTAL" ? MyColors.yellowColorCode :MyColors.blackColorCode,truckImage: countList![index].status=="STOPPED" ? "assets/stopped_truck.png" :countList![index].status=="NODATA" ? "assets/no_data_truck.png" : countList![index].status=="OVERSPEED" ? "assets/overspeed_truck.png":countList![index].status=="RUNNING" ? "assets/running_truck.png" :countList![index].status=="IDLE" ? "assets/idle_truck.png" :countList![index].status=="INACTIVE" ? "assets/inactive_truck.png" :countList![index].status=="TOTAL" ? "assets/idle_truck.png" :"assets/idle_truck.png",))
                                              )
                                          );
                                        }
                                    },
                                    child:  Container(
                                      // margin: EdgeInsets.all(2),
                                        padding: EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(right: 4),
                                              height: 10,
                                              width: 10,
                                              color: countList![index].status=="STOPPED" ? MyColors.analyticStoppedColorCode :countList![index].status=="NODATA" ? MyColors.analyticnodataColorCode : countList![index].status=="OVERSPEED" ? MyColors.analyticoverSpeedlColorCode:countList![index].status=="RUNNING" ? MyColors.analyticGreenColorCode :countList![index].status=="IDLE" ? MyColors.analyticIdelColorCode :countList![index].status=="INACTIVE" ? MyColors.analyticActiveColorCode :countList![index].status=="TOTAL" ? MyColors.yellowColorCode :MyColors.blackColorCode,
                                            ),
                                            Text(point.x.toString()),
                                          ],
                                        )
                                    )

                                  );
                                }
                                // orientation: LegendItemOrientation.vertical
                              ),
                              annotations: [
                                CircularChartAnnotation(
                                    widget: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children:  [
                                        Container(
                                          // padding: const EdgeInsets.only(left: 20, top: 10),
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            // direction: Axis.horizontal,
                                            children: <Widget>[
                                              // for (var i = 0;
                                              // i < countList!.length;
                                              // i++)
                                              //   if(countList![i].status=='TOTAL')
                                                  Column(
                                                    children: [
                                                      Text(dashbordResponse.totalCount.toString()
                                                        /*countList![i].tCount.toString()*/,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: MyColors.appDefaultColorCode,
                                                            fontSize: 28,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                         "Total",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: MyColors.appDefaultColorCode,
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                    ],
                                                  ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                              series: <CircularSeries>[
                                // Render pie chart
                                DoughnutSeries<CountList, String>(
                                  legendIconType: LegendIconType.rectangle,
                                  dataSource: countList,
                                  onPointTap: (value){
                                    print("Chart click :  ${value}");
                                  },
                                  radius: "80%",
                                  innerRadius: '70%',
                                  xValueMapper: (CountList data, _) => data.status!+" (${data.tCount})",
                                  yValueMapper: (CountList data, _) => data.tCount!,
                                  pointColorMapper: (CountList data, _) {
                                    if(data.status=='STOPPED'){
                                      return MyColors.analyticStoppedColorCode;
                                    }else if(data.status=='NODATA'){
                                      return MyColors.analyticnodataColorCode;
                                    }else if(data.status=='OVERSPEED'){
                                      return MyColors.analyticoverSpeedlColorCode;
                                    }else if(data.status=='RUNNING'){
                                      return MyColors.analyticGreenColorCode;
                                    }else if(data.status=='IDLE'){
                                      return  MyColors.analyticIdelColorCode;
                                    }else if(data.status=='INACTIVE'){
                                      return MyColors.analyticActiveColorCode;
                                    }if(data.status=='TOTAL'){
                                      return MyColors.yellowColorCode;
                                    }
                                  },
                                  // dataLabelSettings: DataLabelSettings(isVisible: true),
                                  // enableTooltip: true
                                )
                              ]
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  alertsList==null ? Container() : alertsList!.length==0 ? Container() : Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text("Alert(${alertsList!.length})",
                            style: TextStyle(
                                fontSize: 16,
                                color: MyColors.text5ColorCode,
                                fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap:(){
                            Navigator.of(context)
                                .push(
                              new MaterialPageRoute(
                                  builder: (_) =>
                                      BlocProvider(
                                          create: (context) {
                                            return MainBloc(webService: WebService());
                                          },
                                          child: NotificationScreen(isappbar: true,)
                                      )
                              ),
                            );
                         },
                          child: Text("See All",
                              style: TextStyle(
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  color: MyColors.text5ColorCode,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  alertsList==null ? Container() :alertsList!.length==0 ? Container() : ListView.builder(
                      controller: alertController,
                      shrinkWrap: true,
                      itemCount:alertsList!.length > 3 ? 3 :alertsList!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              notificationPosition=index;
                            });
                            mainBloc.add(ClearAlertNotificationByIdEvents(token: token,vendorId: vendorid,branchId:branchid,araiNoarai:"nonarai",username:userName,alertNotificatioID:alertsList![index].srNo!));
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 1, color: MyColors.textBoxBorderColorCode),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/alert.png",
                                        width: 36,
                                        height: 36,
                                      ),
                                     /* Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                              color: MyColors.textBoxColorCode,
                                              borderRadius:
                                                  BorderRadius.all(Radius.circular(3))),
                                          child:  Text(alertsList![index].acDate!.hour.toString()+":"+alertsList![index].acDate!.minute.toString()+":"+alertsList![index].acDate!.second.toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: MyColors.text5ColorCode))),*/
                                    ],
                                  ),
                                   Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "Vehicle No :${alertsList![index].vehicleRegNo} ",
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                   Text(alertsList![index].alertIndication!,
                                    style: TextStyle(
                                        color: MyColors.blueColorCode, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _dashboardDesign() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: MyColors.text3greyColorCode,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    userName+"!",
                    //"Techno!",
                    style: TextStyle(
                        color: MyColors.text2ColorCode,
                        fontWeight: FontWeight.bold,
                        fontSize: 26),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Row(
                children: [
                  Text(
                    "Your last sign in at",
                    style: TextStyle(
                        color: MyColors.text3greyColorCode, fontSize: 16),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: Text(
                        "Monday, 31/01/2022 04:38:09 PM",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: MyColors.textColorCode,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.only(bottom: 20),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                margin: EdgeInsets.only(top: 24),

                padding:
                    EdgeInsets.only(left: 14, right: 14, top: 24, bottom: 10),
                height: 165,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                    colors: [
                      MyColors.linearGradient1ColorCode,
                      MyColors.linearGradient2ColorCode,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 33,
                          color: MyColors.whiteColorCode,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Mon,31 January 2022 | 22:18:11 PM",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: MyColors.whiteColorCode, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 21.0),
                      child: Row(
                        children: [
                          // Lottie.network(
                          //     'https://assets2.lottiefiles.com/packages/lf20_trr3kzyu.json',width: 38,height: 38),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Pimpri-Chinchwad,Pune",
                              style: TextStyle(
                                  color: MyColors.whiteColorCode, fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Text("             "),
                        Text(
                          "Temp : 86 F (30 C)",
                          style: TextStyle(
                              color: MyColors.whiteColorCode, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ), //declare your widget here
              ),
            ),
            Text(
              "Analyst Reports",
              style: TextStyle(
                  color: MyColors.textColorCode,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  Checkbox(
                      value: value,
                      onChanged: (checkvalue) {
                        setState(() {
                          value = checkvalue!;
                        });
                      }),
                  Expanded(
                      child: Text(
                    "Auto Refresh (If Check Page Will Auto Refresh After 60 Second)",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 18),
                  ))
                ],
              ),
            ),
            Card(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Container(
                padding: EdgeInsets.only(left: 14, right: 14),
                height: 100,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: MyColors.pinkColorCode,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Lottie.network(
                    //     'https://assets1.lottiefiles.com/packages/lf20_p7ki6kij.json',width: 45,height: 51),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Alerts",
                        style: TextStyle(
                            color: MyColors.textColorCode,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                    Text(
                      "20",
                      style: TextStyle(
                          color: MyColors.redColorCode,
                          fontSize: 31,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            GridView(
              controller: _recordCountController,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              children: [
                _counToRecord(10, "Total Device", MyColors.textColorCode),
                _counToRecord(2, "Idle", MyColors.yellowColorCode),
                _counToRecord(3, "Running", MyColors.greenColorCode),
                _counToRecord(1, "Stop", MyColors.faluRedColorCode),
                _counToRecord(4, "No Data", MyColors.text3greyColorCode),
                _counToRecord(0, "In-Active", MyColors.redColorCode),
                _counToRecord(0, "Over Speed", MyColors.orangeColorCode),
                _counToRecord(2, "Parking", MyColors.orangeColorCode)
              ],
            )
          ],
        ),
      ),
    );
  }

  _counToRecord(int count, String title, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: MyColors.textBoxBorderColorCode),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.only(left: 14, right: 14),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                  color: color, fontSize: 35, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                title,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.year, this.sales, this.color);

  final String year;
  final double sales;
  final Color color;
}
