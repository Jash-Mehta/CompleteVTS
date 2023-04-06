import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/custome_dialog.dart';

class RouteDefineScreen extends StatefulWidget {
  const RouteDefineScreen({Key? key}) : super(key: key);

  @override
  _RouteDefineScreenState createState() => _RouteDefineScreenState();
}

class _RouteDefineScreenState extends State<RouteDefineScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vendorRecordController = new ScrollController();
  bool isaddwaypoint = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MenuDrawer().getMenuDrawer(context),
      appBar: CustomAppBar().getCustomAppBar("VTS ROUTE DEFINE", _scaffoldKey,0,context),
      body: _routeDefine(),
    );
  }

  _routeDefine() {
    return SingleChildScrollView(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
        child: Column(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 17.0, bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        "Route Name",
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("*",
                            style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                      )
                    ],
                  ),
                )),
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
                  borderSide: BorderSide(
                      width: 1, color: MyColors.textBoxBorderColorCode),
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
                hintText: "Searchable Dropdown",
                hintStyle: TextStyle(
                    fontSize: 16, color: MyColors.textFieldHintColorCode),
                errorText: "",
              ),
              // controller: _passwordController,
              // onChanged: _authenticationFormBloc.onPasswordChanged,
              obscureText: false,
            ),
            Divider(
              height: 2,
              color: MyColors.text3greyColorCode,
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        "Start Location",
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("*",
                            style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                      )
                    ],
                  ),
                )),
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
                  borderSide: BorderSide(
                      width: 1, color: MyColors.textBoxBorderColorCode),
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
                hintText: "Searchable Dropdown",
                hintStyle: TextStyle(
                    fontSize: 16, color: MyColors.textFieldHintColorCode),
                errorText: "",
              ),
              // controller: _passwordController,
              // onChanged: _authenticationFormBloc.onPasswordChanged,
              obscureText: false,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(
                    width: 2, color: MyColors.textBoxBorderColorCode),
                color: MyColors.whiteColorCode,
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      /*  setState(() {
                        isaddwaypoint=true;
                      });*/
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                            color: MyColors.appDefaultColorCode,
                            size: 18,
                          ),
                          Text(
                            "Add Way Point",
                            style: TextStyle(
                                fontSize: 18,
                                color: MyColors.appDefaultColorCode,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  /* !isaddwaypoint ? Container() : */ Column(
                    children: [
                      Divider(
                        color: MyColors.text3greyColorCode,
                        height: 1,
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, left: 8.0, bottom: 10),
                            child: Text(
                              "Way Point",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: TextField(
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
                                  width: 1,
                                  color: MyColors.textBoxBorderColorCode),
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
                                    width: 2, color: MyColors.buttonColorCode)),
                            hintText: "Searchable Dropdown",
                            hintStyle: TextStyle(
                                fontSize: 16,
                                color: MyColors.textFieldHintColorCode),
                            errorText: "",
                          ),
                          // controller: _passwordController,
                          // onChanged: _authenticationFormBloc.onPasswordChanged,
                          obscureText: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 8),
                  child: Row(
                    children: [
                      Text(
                        "Destination Location",
                        style: TextStyle(fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 3.0),
                        child: Text("*",
                            style: TextStyle(
                                fontSize: 18, color: MyColors.redColorCode)),
                      )
                    ],
                  ),
                )),
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
                  borderSide: BorderSide(
                      width: 1, color: MyColors.textBoxBorderColorCode),
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
                hintText: "Searchable Dropdown",
                hintStyle: TextStyle(
                    fontSize: 16, color: MyColors.textFieldHintColorCode),
                errorText: "",
              ),
              // controller: _passwordController,
              // onChanged: _authenticationFormBloc.onPasswordChanged,
              obscureText: false,
            ),
            SizedBox(
              height: 48,
              child:MaterialButton(
                onPressed: () {
                  CustomDialog()
                      .popUp(context, "Well done! Record Save Successfully");
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  "Save Route Details",
                  style:
                      TextStyle(fontSize: 18, color: MyColors.whiteColorCode),
                ),
                color: MyColors.buttonColorCode,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                "View Map",
                style: TextStyle(
                    fontSize: 18,
                    color: MyColors.appDefaultColorCode,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
