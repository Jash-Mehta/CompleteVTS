import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}
class _FilterScreenState extends State<FilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.textColorCode,
        centerTitle: true,
        title: Text("Filter".toUpperCase()),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                // controller.page == 2
                //?
                Icons.close,
                //  : Icons.help_outline,
                size: 24,
                color: MyColors.whiteColorCode,
              )),
          const SizedBox(
            width: 8.0,
          )
        ],
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(0), //left: 8, top: 16.0, right: 8.0),
          child: Container(
            margin: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: const Text("Filter"),
                              onPressed: () {},
                            ),
                            TextButton(
                              child: const Text("Clear"),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 36,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: MyColors.blueColorCode.withOpacity(0.5)),
                          child: TextButton(
                              child: const Text("Apply",
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {})),
                    ],
                  ),
                ),
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final boxWidth = constraints.constrainWidth();
                    const dashWidth = 2.0;
                    final dashCount = (boxWidth / (2 * dashWidth)).floor();
                    return Flex(
                      children: List.generate(dashCount, (_) {
                        return const SizedBox(
                          width: dashWidth,
                          height: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.black),
                          ),
                        );
                      }),
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                    );
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == "") {
                            return "Please Enter Username";
                          }
                        },
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
                                BorderSide(width: 0.3, color: Colors.grey),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              borderSide: BorderSide(
                                width: 0.5,
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
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Company",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("All"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("M-Tech LTD"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Branch",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("All"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("M-Tech LTD"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Alert Type Selection",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("Harsh Breaking"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("Vehicle Inactive"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("Location Updates"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      const Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          "Vehicle",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      CheckboxListTile(
                        title: Text("Type"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("Type"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("Type"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      CheckboxListTile(
                        title: Text("Type"), //    <-- label
                        value: false,
                        onChanged: (newValue) {},
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // TabBarView(
      //     physics: const NeverScrollableScrollPhysics(),
      //     children: listScreens),
    );
  }
}
