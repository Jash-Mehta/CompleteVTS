import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/screen/transctions/point_of_interest/create_point_of_interest_screen.dart';
import 'package:flutter_vts/service/web_service.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PointOfInterestScreen extends StatefulWidget {
  const PointOfInterestScreen({Key? key}) : super(key: key);

  @override
  _PointOfInterestScreenState createState() => _PointOfInterestScreenState();
}

class _PointOfInterestScreenState extends State<PointOfInterestScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vendorRecordController = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  drawer: MenuDrawer().getMenuDrawer(context),
      appBar: CustomAppBar()
          .getCustomAppBar("POINT OF INTEREST CREATE", _scaffoldKey,0,context),
      body: _geofenceCreate(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.buttonColorCode,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BlocProvider(
                      create: (context) {
                        return MainBloc(webService: WebService());
                      },
                      child: CreatePointOfInterestScreen())));
        },
        child: Icon(
          Icons.add,
          color: MyColors.whiteColorCode,
        ),
      ),
    );
  }

  _geofenceCreate() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
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
                    borderSide:
                        BorderSide(width: 2, color: MyColors.buttonColorCode)),
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
              // onChanged: _authenticationFormBloc.onPasswordChanged,
              obscureText: false,
            ),
            Text(
              "10 RECORDS",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ListView.builder(
                  controller: vendorRecordController,
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 15),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            width: 1, color: MyColors.textBoxBorderColorCode),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: EdgeInsets.only(
                            top: 15, left: 14, right: 14, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Sr.No",
                                          style: TextStyle(
                                              color: MyColors
                                                  .textprofiledetailColorCode,
                                              fontSize: 18),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            "18",
                                            style: TextStyle(
                                                color: MyColors.text5ColorCode,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "POI Name",
                                        style: TextStyle(
                                            color: MyColors
                                                .textprofiledetailColorCode,
                                            fontSize: 18),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "AAAA",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: MyColors.text5ColorCode,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "POI Type",
                                        style: TextStyle(
                                            color: MyColors
                                                .textprofiledetailColorCode,
                                            fontSize: 18),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "Area",
                                          style: TextStyle(
                                              color: MyColors.text5ColorCode,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Tolerance",
                                      style: TextStyle(
                                          color: MyColors
                                              .textprofiledetailColorCode,
                                          fontSize: 18),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "200",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: MyColors.text5ColorCode,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, bottom: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Vehicle Reg.No",
                                          style: TextStyle(
                                              color: MyColors
                                                  .textprofiledetailColorCode,
                                              fontSize: 18),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            "MH4545353",
                                            style: TextStyle(
                                                color: MyColors.text5ColorCode,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Show POI",
                                        style: TextStyle(
                                            color: MyColors
                                                .textprofiledetailColorCode,
                                            fontSize: 18),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          "Yes",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: MyColors.text5ColorCode,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description",
                                  style: TextStyle(
                                      color:
                                          MyColors.textprofiledetailColorCode,
                                      fontSize: 18),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    "M-Tech Solutions",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: MyColors.text5ColorCode,
                                        fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                // _deleteRecordConfirmation();
                              },
                              child: Container(
                                height: 37,
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.only(
                                    left: 20, right: 20, top: 6, bottom: 6),
                                decoration: BoxDecoration(
                                    color: MyColors.pinkBackgroundColorCode,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Text(
                                  "Delete",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: MyColors.redColorCode,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  _deleteRecordConfirmation() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Delete Record",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                      child: Text(
                        "Are you sure want to delete records...??",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 18, color: MyColors.whiteColorCode),
                          ),
                          color: MyColors.text3greyColorCode,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: MaterialButton(
                            // padding: const EdgeInsets.only(left:15.0,right: 15,top: 4,bottom: 4),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                  fontSize: 18, color: MyColors.whiteColorCode),
                            ),
                            color: MyColors.redColorCode,
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
}
