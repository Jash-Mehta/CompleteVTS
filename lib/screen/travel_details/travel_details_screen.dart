import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/menu_drawer.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snippet_coder_utils/FormHelper.dart';

class TravelDetailsScreen extends StatefulWidget {
  // const TravelDetailsScreen({Key? key}) : super(key: key);

  @override
  _TravelDetailsScreenState createState() => _TravelDetailsScreenState();
}

class _TravelDetailsScreenState extends State<TravelDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late bool _isLoading = false;
  String selectedVehicle = '';
  List data =[];
  String vehicletypedropdown = '';
  late int vehicleid=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuDrawer(),
      appBar: CustomAppBar().getCustomAppBar("TRAVEL DETAILS(DAIRY)",_scaffoldKey,0,context),
      body: _traveldetail(),
    );
  }

  _traveldetail(){
    return LoadingOverlay(
        isLoading: _isLoading,
        opacity: 0.5,
        color: Colors.white,
        progressIndicator: CircularProgressIndicator(
          backgroundColor: Color(0xFFCE4A6F),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
        ),
        child:BlocListener<MainBloc, MainState>(
          listener: (context,state){

          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text("Select Vehicle",style: TextStyle(fontSize: 18),),
                            Padding(
                              padding: const EdgeInsets.only(left: 3.0),
                              child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                            )
                          ],
                        ),
                      )
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color:MyColors.whiteColorCode,

                    ),
                    width: MediaQuery.of(context).size.width,
                    child: FormHelper.dropDownWidget(
                      context,
                      // "Select product",
                      selectedVehicle=='' ?  "Select" :selectedVehicle,
                      this.vehicletypedropdown,
                      this.data,
                          (onChangeVal){
                        setState(() {
                          this.vehicletypedropdown=onChangeVal;
                          vehicleid=int.parse(onChangeVal);
                          print("Selected Product : $onChangeVal");
                        });

                      },
                          (onValidateval){
                        if(onValidateval==null){
                          return "Please select country";
                        }
                        return null;
                      },
                      borderColor:MyColors.whiteColorCode,
                      borderFocusColor: MyColors.whiteColorCode,
                      borderRadius: 10,
                      optionValue: "srNo",
                      optionLabel: "vehicleType",
                      // paddingLeft:20

                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(
                            left: 0.0,top: 10),
                        child: RichText(
                          text: const TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Text(
                                        "From Date / Time",style: TextStyle(fontSize: 18))),
                                WidgetSpan(
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                          color:
                                          Colors.red),
                                    )),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon:
                                const Icon(Icons
                                    .calendar_today_rounded),
                                isDense: true,

                                hintText:
                                "DD/MM/YYYY",

                                fillColor:
                                const Color(
                                    0xFFF2F2F2),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon:
                                const Icon(Icons
                                    .watch_later_outlined),
                                isDense: true,

                                hintText: "hh:mm:a",

                                fillColor:
                                const Color(
                                    0xFFF2F2F2),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    const BorderRadius
                                        .all(
                                        Radius.circular(
                                            4)),
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors
                                            .grey
                                            .withOpacity(
                                            0.5))),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Padding(
                        padding:
                        const EdgeInsets.only(
                            left: 0.0),
                        child: RichText(
                          text: const TextSpan(
                              children: [
                                WidgetSpan(
                                    child: Text(
                                        "To Date / Time",style: TextStyle(fontSize: 18))),
                                WidgetSpan(
                                    child: Text(
                                      "*",
                                      style: TextStyle(
                                          color:
                                          Colors.red),
                                    )),
                              ]),
                        ),
                      ),
                      const SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon: const Icon(Icons
                                    .calendar_today_rounded),
                                isDense: true,
                                hintText: "DD/MM/YYYY",
                                fillColor: const Color(
                                    0xFFF2F2F2),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              enabled:
                              true, // to trigger disabledBorder
                              decoration:
                              InputDecoration(
                                suffixIcon:
                                const Icon(Icons
                                    .watch_later_outlined),
                                isDense: true,

                                hintText: "hh:mm:a",

                                fillColor:
                                const Color(
                                    0xFFF2F2F2),
                                focusedBorder:
                                OutlineInputBorder(
                                  borderRadius:
                                  const BorderRadius
                                      .all(
                                      Radius
                                          .circular(
                                          4)),
                                  borderSide: BorderSide(
                                      width: 0.5,
                                      color: Colors
                                          .grey
                                          .withOpacity(
                                          0.5)),
                                ),
                                disabledBorder:
                                const OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius
                                      .all(Radius
                                      .circular(
                                      4)),
                                  borderSide:
                                  BorderSide(
                                      width: 1,
                                      color: Colors
                                          .orange),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                    const BorderRadius
                                        .all(
                                        Radius.circular(
                                            4)),
                                    borderSide: BorderSide(
                                        width: 0.5,
                                        color: Colors
                                            .grey
                                            .withOpacity(
                                            0.5))),
                                border:
                                const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(
                                        Radius.circular(
                                            4)),
                                    borderSide:
                                    BorderSide(
                                      width: 1,
                                    )),

                                errorBorder:  OutlineInputBorder(
                                    borderRadius: BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide: BorderSide(
                                        width: 1,
                                        color: MyColors
                                            .textBoxBorderColorCode)),
                                focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius
                                        .all(Radius
                                        .circular(
                                        4)),
                                    borderSide:
                                    BorderSide(
                                        width: 1,
                                        color: Colors
                                            .grey)),
                                // hintText: "HintText",
                                alignLabelWithHint:
                                true,
                                hintStyle:
                                const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              // onChanged: _authenticationFormBloc.onPasswordChanged,
                              obscureText: false,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [

                          Container(
                            padding: EdgeInsets.only(left: 15,right: 15),
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius
                                  .circular(8.0),
                              color: MyColors
                                  .blueColorCode,
                            ),
                            child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Show Location",
                                  style: TextStyle(
                                      color: Colors
                                          .white),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}