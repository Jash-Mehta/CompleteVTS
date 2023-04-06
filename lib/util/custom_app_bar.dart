import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/notification/filter_alert_notification_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar{

  getCustomAppBar(String title, GlobalKey<ScaffoldState> scaffoldKey,int flag,BuildContext context){
    return AppBar(
      backgroundColor: MyColors.textColorCode,
      title: title=="VTSGPS" ? Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Image.asset("assets/vtsgps_icon.png",/*width: 150,height: 50,*/),
      ) : Text(title),
      actions: [

        title=="DISTANCE SUMMARY" ?  IconButton(
            onPressed: (){
            },
            icon: Icon(Icons.filter_vintage_rounded,size: 30,color:MyColors.whiteColorCode ,)
        ): title=="ALERT/NOTIFICATIONS" ? Center(child: Container(child: Text("Clear All",style: TextStyle(fontSize: 18),),))/*IconButton(
            onPressed: (){
            },
            icon: Icon(Icons.filter_alt_outlined,size: 30,color:MyColors.whiteColorCode ,)
        )*/:flag==2 ? GestureDetector(
          onTap: (){
            Navigator.push(
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
          },
          child: Container(
                margin: EdgeInsets.only(right: 10),
                child:Image.asset("assets/filter.png",height: 40,width: 40,) ,
          ),
        ) :IconButton(
            onPressed: (){
            },
            icon: Icon(Icons.help_outline,size: 30,color:MyColors.whiteColorCode ,)
        ),

        if(flag==2)  PopupMenuButton(
            onSelected: (value){
              if(value=="Item1"){
                // showDialog(
                //     context: context,
                //     builder: (BuildContext context) =>
                //         _buildPopupDialogforLogout(context));
              }else{

              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value:"Item1",
                  child: Text("Clear All")
              ),
            ])

        // IconButton(
        //     onPressed: (){
        //       scaffoldKey.currentState!.openDrawer();
        //     },
        //     icon: Container(
        //         width: 46,
        //         height: 46,
        //         decoration: BoxDecoration(
        //           color: Colors.grey,
        //           shape: BoxShape.circle,
        //         ),
        //         child: Icon(Icons.menu,color: MyColors.whiteColorCode,)
        //     )
        // )
      ],
    );
  }
}