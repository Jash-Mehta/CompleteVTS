import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';

class AlertNotificationScreen extends StatefulWidget {
  const AlertNotificationScreen({Key? key}) : super(key: key);

  @override
  State<AlertNotificationScreen> createState() =>
      _AlertNotificationScreenState();
}

class _AlertNotificationScreenState extends State<AlertNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColorCode,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Card(
                color: MyColors.greyColorCode,
                elevation: 4,
                margin: const EdgeInsets.all(0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("22-02-2022"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("3:19:54 PM")
                              ],
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Text("-"),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("26-02-2022"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("3:19:54 PM")
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: 96,
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          child: TextButton(
                              onPressed: () {
                                //  GetPlatform.isAndroid
                                // ?
                                showDialog(
                                    context: context,
                                    builder: (v) {
                                      return Dialog(
                                        //                                titlePadding: EdgeInsets.only(top: 12, left: 24, right: 12),
                                        // contentPadding: EdgeInsets.only(top: 12, left: 24, bottom: 20),
                                        insetPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50.0)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0.0),
                                                  child: RichText(
                                                    text: const TextSpan(
                                                        children: [
                                                          WidgetSpan(
                                                              child: Text(
                                                                  "From Date / Time")),
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
                                                                  "To Date / Time")),
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
                                                  height: 16,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: const Text(
                                                                  "Clear")),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: const Text(
                                                                  "Close")),
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      width: 80,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        color: MyColors
                                                            .blueColorCode,
                                                      ),
                                                      child: TextButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                            "Apply",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                                //  : CupertinoDialog();
                              },
                              child: const Text("Change",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal)))),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      child: TextFormField(
                        enabled: true, // to trigger disabledBorder
                        decoration: const InputDecoration(
                          isDense: true,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),

                          hintText: "Search",

                          fillColor: Color(0xFFF2F2F2),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.grey),
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
                              borderSide:
                                  BorderSide(width: 1, color: Colors.grey)),
                          // hintText: "HintText",
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        // onChanged: _authenticationFormBloc.onPasswordChanged,
                        obscureText: false,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
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
                                        height: 40,
                                        width: 40,
                                      ),
                                      Container(
                                          decoration: const BoxDecoration(
                                            color: MyColors.lightgreyColorCode,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4.0)),
                                          ),
                                          child: const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                  child: Text(
                                                "3:19:54 PM",
                                                style: TextStyle(
                                                    color: MyColors
                                                        .blackColorCode),
                                              )),
                                            ),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  const Text("Vehicle No: DL223245678"),
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  const Text("Vehicle is out from POI...!!!"),
                                  Visibility(
                                    visible: index == 1 ? true : false,
                                    child: const SizedBox(
                                      height: 12,
                                    ),
                                  ),
                                  Visibility(
                                    visible: index == 1 ? true : false,
                                    child: const Text(
                                      "Shivaji Chowk Hinjewadi, Hinjewadi Road, Hinjewadi Village, Hinjewadi,Pimpri-Chinchwad, Maharastra",
                                      style: TextStyle(height: 1.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
