import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/profile/profile_detail/profile_detail_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // drawer: MenuDrawer().getMenuDrawer(context),
      // endDrawer: MenuDrawer().getMenuDrawer(context) ,
      appBar: CustomAppBar().getCustomAppBar("VTSGPS",_scaffoldKey,0,context),
      body: _profile(),
    );
  }


  _profile(){
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0,bottom: 10),
                child: Image.asset("assets/profile.png",width: 116,height: 116,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text("Techno",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                              create: (context) {
                                return MainBloc(webService: WebService());
                              },
                              child: ProfileDetailScreen()))
                  );
                },
                child:_profileDetail("View Profile Details",1) ,
              ),
              _profileDetail("Change Password",2),
              _profileDetail("Help Center",3),
              _profileDetail("Logout",4),
            ],
          ),
        ),
      ),
    );
  }


  _profileDetail(String title,int flag){
    return GestureDetector(
      onTap: (){
        if(flag==1){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: ProfileDetailScreen()))
          );
        }

        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (context) => ProfileDetailScreen()));
      },
      child: Card(
        margin: EdgeInsets.only(top:15),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,style: TextStyle(fontSize: 16),),
              Icon(Icons.arrow_forward_ios_sharp,color: MyColors.textColorCode,)
            ],
          )
        ),
      ),
    );
  }
}
