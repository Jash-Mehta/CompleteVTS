import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/home/home_screen.dart';
import 'package:flutter_vts/screen/live_tracking_screen.dart';
import 'package:flutter_vts/screen/notification/notification_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late List<Widget> listScreens = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late int selectedTap=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listScreens = [
      BlocProvider(
          create: (context) {
            return MainBloc(webService: WebService());
          },
          child:HomeScreen()
      ),
      BlocProvider(
          create: (context) {
            return MainBloc(webService: WebService());
          },
          child:LiveTrackingScreen()
      ),
      Center(child: Text("Live tracking")),
      BlocProvider(
          create: (context) {
            return MainBloc(webService: WebService());
          },
          child:NotificationScreen(isappbar: false,)
      ),
      Center(child: Text("Setting")),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // appBar: selectedTap==2 ? null :CustomAppBar().getCustomAppBar("VTSGPS",_scaffoldKey,selectedTap,context),

        drawer: MenuDrawer()/*.getMenuDrawer(context)*/,

        backgroundColor: MyColors.backgroundColorCode,
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(), children: listScreens),
        bottomNavigationBar: Container(
          /*decoration: BoxDecoration(
              color: MyColors.lightgreyColorCode,
              boxShadow: [
                BoxShadow(
                    blurRadius: 2,
                    color: MyColors.shadowGreyColorCode
                )
              ]
          ),*/
          color: MyColors.whiteColorCode,
          child: TabBar(
            indicatorColor: MyColors.whiteColorCode,
            labelColor: MyColors.appDefaultColorCode,
            unselectedLabelColor: Colors.grey,
            onTap: (value) {
              print(value);
              setState(() {
                selectedTap=value;
              });
            },
            tabs: [
              Tab(
                  text: 'Home',
                  icon: Icon(
                    Icons.home_outlined,
                    size: 30,
                  )),
              Tab(
                  text: 'Live Tracking',
                  icon: Icon(
                    Icons.location_on_outlined,
                    size: 30,
                  )),
              Tab(
                  text: 'Alert',
                  icon: Icon(
                    Icons.add_alert,
                    size: 30,
                  )),
              Tab(
                  text: 'Settings',
                  icon: Icon(
                    Icons.settings,
                    size: 30,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
