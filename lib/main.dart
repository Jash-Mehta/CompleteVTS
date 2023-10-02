import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/login/login_screen.dart';
import 'package:flutter_vts/screen/splash/splash_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/simple_bloc_observer.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
         appBarTheme: AppBarTheme(
            color: MyColors.appBarColorCode,
          ),
          primarySwatch: Colors.blue,
        ),
        // home: const VendorMasterScreen(),
        home: BlocProvider(
            create: (context) {
              return MainBloc(webService: WebService());
            },
            child: SplashScreen()
            // SplashScreen()/*NotificationScreen(isappbar: true,)*//*VehicleAnalyticsReportsStatusScreen(truckImage: '', analyticTiltle: '', colorCode: MyColors.whiteColorCode,)*//*NotificationScreen(isappbar: true,)*/
            ));
  }
}


// Google Map - AIzaSyCzJ9rnQfwR2O7lfUnJt2UGwNicQP_eTUk

// bitbucket password : BjtNkcSDgW8h6vdzAvtX
// swagger
// https://vtsgpsapi.m-techinnovations.com/swagger/index.ht

// https://vtsnew.m-techinnovations.com/VTSGPSLogin.aspx
    //Techno  Techno@8521$  userid:16(Techno1234,Techno@123,Techno123)  19diJC9yqSaXf/QgO4P8gQ==
// "username": "satyam",(admin123) (B40mvYG7HgiARPJRwjwjJg==)
// "password": "admin@123$"

// "username": "satyam",
// "password": "KJO4M39YLFf7WFiGo2z8cA=="
// admin/admin@123$


// Value="1" Text="Admin"
// Value="2" Text="Demo"
// Value="3" Text="Normal"


// https://www.naukri.com/flutter-developer-jobs-in-pune-3?k


//19diJC9yqSaXf/QgO4P8gQ==

// SU4DfRV2SmwfWhfz7jjX   (Bitbucket password)



