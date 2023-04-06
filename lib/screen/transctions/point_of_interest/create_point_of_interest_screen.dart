import 'package:flutter/material.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custome_dialog.dart';

class CreatePointOfInterestScreen extends StatefulWidget {
  const CreatePointOfInterestScreen({Key? key}) : super(key: key);

  @override
  _CreatePointOfInterestScreenState createState() => _CreatePointOfInterestScreenState();
}

class _CreatePointOfInterestScreenState extends State<CreatePointOfInterestScreen> {
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CREATE POI"),
      ),
      body: _pointofinterest(),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phonelink_erase_rounded,color: MyColors.text4ColorCode,),
                  Text("Clear",style: TextStyle(color: MyColors.text4ColorCode,decoration: TextDecoration.underline,fontSize: 20)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close,size: 25,color: MyColors.text4ColorCode),
                  Text("Close",style: TextStyle(color: MyColors.text4ColorCode,decoration: TextDecoration.underline,fontSize: 20),),
                ],
              ),
              GestureDetector(
                onTap: (){
                  CustomDialog().popUp(context,"Well done! Record Save Successfully....!!");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 148,
                  height: 56,
                  margin: const EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.only(top:6.0,bottom: 6,left: 20,right: 20),
                  decoration: BoxDecoration(
                      color: MyColors.buttonColorCode,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: MyColors.textBoxBorderColorCode)
                  ),
                  child: Text("Save POI",style: TextStyle(color: MyColors.whiteColorCode,fontSize: 20),),
                ),
              )

            ],
          ),
        ),

      ),
    );
  }

  _pointofinterest(){
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:20.0,left: 15,right: 15,bottom: 20),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text("Vendor Name",style: TextStyle(fontSize: 18,color:MyColors.blackColorCode),),
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
                    color: MyColors.textFieldBackgroundColorCode,
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                ),
                child: DropdownButton(
                  value: dropdownvalue,
                  underline: SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                        /* decoration: BoxDecoration(
                        border: Border.all(color:MyColors.text3greyColorCode )
                      ),*/
                          padding: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width-58,
                          child: Text(items,style: TextStyle(fontSize: 18))
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:17,bottom: 8),
                    child: Row(
                      children: [
                        Text("Branch Name",style: TextStyle(fontSize: 18),),
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
                    color: MyColors.textFieldBackgroundColorCode,
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                ),
                child: DropdownButton(
                  value: dropdownvalue,
                  underline: SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                        /* decoration: BoxDecoration(
                        border: Border.all(color:MyColors.text3greyColorCode )
                      ),*/
                          padding: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width-58,
                          child: Text(items,style: TextStyle(fontSize: 18))
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:17.0,bottom: 8),
                    child: Row(
                      children: [
                        Text("POI Name",style: TextStyle(fontSize: 18),),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                        )
                      ],
                    ),
                  )
              ),
              TextField(
                enabled: true, // to trigger disabledBorder
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.whiteColorCode,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: Colors.orange),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                  ),
                  hintText: "Type here",
                  hintStyle: TextStyle(fontSize: 16,color:  MyColors.textFieldHintColorCode),
                  errorText: "",
                ),
                // controller: _passwordController,
                // onChanged: _authenticationFormBloc.onPasswordChanged,
                obscureText: false,
              ),

              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text("POI Type",style: TextStyle(fontSize: 18),),
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
                    color: MyColors.whiteColorCode,
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                ),
                child: DropdownButton(
                  value: dropdownvalue,
                  underline: SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                        /* decoration: BoxDecoration(
                        border: Border.all(color:MyColors.text3greyColorCode )
                      ),*/
                          padding: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width-58,
                          child: Text(items,style: TextStyle(fontSize: 18))
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:17,bottom: 8.0),
                    child: Row(
                      children: [
                        Text("Description",style: TextStyle(fontSize: 18),),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                        )
                      ],
                    ),
                  )
              ),
              TextField(
                enabled: true, // to trigger disabledBorder
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.whiteColorCode,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: Colors.orange),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                  ),
                  hintText: "Type here",
                  hintStyle: TextStyle(fontSize: 16,color:  MyColors.textFieldHintColorCode),
                  errorText: "",
                ),
                // controller: _passwordController,
                // onChanged: _authenticationFormBloc.onPasswordChanged,
                obscureText: false,
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text("Tolerance",style: TextStyle(fontSize: 18),),
                        Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text("*",style: TextStyle(fontSize: 18,color: MyColors.redColorCode)),
                        )
                      ],
                    ),
                  )
              ),
              TextField(
                enabled: true, // to trigger disabledBorder
                decoration: InputDecoration(
                  filled: true,
                  fillColor: MyColors.whiteColorCode,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: Colors.orange),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,)
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                  ),
                  hintText: "Type here",
                  hintStyle: TextStyle(fontSize: 16,color:  MyColors.textFieldHintColorCode),
                  errorText: "",
                ),
                // controller: _passwordController,
                // onChanged: _authenticationFormBloc.onPasswordChanged,
                obscureText: false,
              ),
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
                    color: MyColors.whiteColorCode,
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                ),
                child: DropdownButton(
                  value: dropdownvalue,
                  underline: SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                        /* decoration: BoxDecoration(
                        border: Border.all(color:MyColors.text3greyColorCode )
                      ),*/
                          padding: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width-58,
                          child: Text(items,style: TextStyle(fontSize: 18))
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top:17,bottom: 8),
                    child: Row(
                      children: [
                        Text("Show Geofence",style: TextStyle(fontSize: 18),),
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
                    color: MyColors.whiteColorCode,
                    border: Border.all(color: MyColors.textBoxBorderColorCode,width: 2)
                ),
                child: DropdownButton(
                  value: dropdownvalue,
                  underline: SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Container(
                        /* decoration: BoxDecoration(
                        border: Border.all(color:MyColors.text3greyColorCode )
                      ),*/
                          padding: EdgeInsets.only(left: 10),
                          width: MediaQuery.of(context).size.width-58,
                          child: Text(items,style: TextStyle(fontSize: 18))
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownvalue = newValue!;
                    });
                  },
                ),
              ),
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top:17,bottom: 8),
                    height: 394,
                    decoration: BoxDecoration(
                        color: MyColors.appDefaultColorCode,
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0,left: 15,right: 15),
                    child:TextField(
                      enabled: true, // to trigger disabledBorder
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: MyColors.whiteColorCode,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1,color: MyColors.buttonColorCode),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1,color: Colors.orange),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(width: 1,color: MyColors.textColorCode),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 1,)
                        ),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 1,color: MyColors.textBoxBorderColorCode)
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(width: 2,color: MyColors.buttonColorCode)
                        ),
                        hintText: "Select",
                        hintStyle: TextStyle(fontSize: 18,color:  MyColors.searchTextColorCode),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      // onChanged: _authenticationFormBloc.onPasswordChanged,
                      obscureText: false,
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      );
  }
}
