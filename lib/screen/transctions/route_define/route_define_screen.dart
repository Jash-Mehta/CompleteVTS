import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/screen/transctions/route_define/route_define_map.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custom_app_bar.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:google_maps_webservice/places.dart' as wp;
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as loc;

import '../../../bloc/main_event.dart';
import '../../../model/route_define/custom_textfield.dart';
import '../../../model/route_define/route_define_post.dart';

class RouteDefineScreen extends StatefulWidget {
  const RouteDefineScreen({Key? key}) : super(key: key);

  @override
  _RouteDefineScreenState createState() => _RouteDefineScreenState();
}

class _RouteDefineScreenState extends State<RouteDefineScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController vendorRecordController = new ScrollController();
  bool isaddwaypoint = false;
  bool onseaerchtextn = false;
  bool onendpointchanged = false;
  String _allText = '';
  //! For Starting Point address---------------
  final _placesApiClient =
      wp.GoogleMapsPlaces(apiKey: 'AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY');

  List<wp.Prediction> _startingpredictions = [];
  List<wp.Prediction> _endpredictions = [];
  List<wp.Prediction> _waypredictions = [];
  List<wp.Prediction> _waypredictions2 = [];
  late MainBloc _mainBloc;
  late SharedPreferences sharedPreferences;
  late String token = "";
  List<RoutePost>? _routepost = [];
  double? fromlatitude;
  double? fromlongitude;
  bool _isloading = false;
  double? tolatitude;
  double? tolongitude;
  bool startpoint = false;
  bool midwaypoint = false;
  bool midwaypoint2 = false;
  TextEditingController _startcontroller = TextEditingController();
  TextEditingController _endcontroller = TextEditingController();
  TextEditingController _waypointcontrollers = TextEditingController();
  TextEditingController _waypointcontrollers2 = TextEditingController();
  TextEditingController _routernamecontrollers = TextEditingController();

  List<Map<String, double>>? coordinatesList = [];
  List<TextEditingController> _controllers = [];
  List<CustomTextformfield> _textFields = [];

  bool endpoint = false;
  List<String> mergeString = [];
  var textchanged1, textchanges2;
  int i = 0;
  var address, startaddress, endaddress, waypoint;
  void _onSearchTextChanged(String value) async {
    if (value.isNotEmpty) {
      onseaerchtextn = true;
      setState(() {});
      wp.PlacesAutocompleteResponse response =
          await _placesApiClient.autocomplete(
        value,
        language: "en",
        types: [],
        components: [wp.Component(wp.Component.country, "IND")],
      );
      setState(() {
        _startingpredictions = response.predictions;
      });
    } else {
      setState(() {
        _startingpredictions = [];
      });
    }
  }

  //! Add new feild----------------------->
  void _addNewTextField() {}

//! End point location --------------------------------.
  void _onEndpointChanged(String value) async {
    if (value.isNotEmpty) {
      // onendpointchanged = true;
      setState(() {});
      wp.PlacesAutocompleteResponse response =
          await _placesApiClient.autocomplete(
        value,
        language: "en",
        types: [],
        components: [wp.Component(wp.Component.country, "IND")],
      );
      setState(() {
        _endpredictions = response.predictions;
      });
    } else {
      setState(() {
        _endpredictions = [];
      });
    }
  }

//! Mid Way point Addresss(1)------------------------------------>
  void _onwaypoin1(String value) async {
    if (value.isNotEmpty) {
      setState(() {});
      wp.PlacesAutocompleteResponse response =
          await _placesApiClient.autocomplete(
        value,
        language: "en",
        types: [],
        components: [wp.Component(wp.Component.country, "IND")],
      );
      setState(() {
        _waypredictions = response.predictions;
      });
    } else {
      _waypredictions = [];
    }
  }

  //! Mid Way Point Address(2)
  void _onwaypoin2(String value) async {
    if (value.isNotEmpty) {
      setState(() {});
      wp.PlacesAutocompleteResponse response =
          await _placesApiClient.autocomplete(
        value,
        language: "en",
        types: [],
        components: [wp.Component(wp.Component.country, "IND")],
      );
      setState(() {
        _waypredictions2 = response.predictions;
      });
    } else {
      _waypredictions2 = [];
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    setState(() {});
    _mainBloc = BlocProvider.of(context);
    _controllers.forEach((controller) {
      controller.addListener(() {
        _updateAllText();
      });
    });
  }

  void _updateAllText() {
    setState(() {
      _allText = _controllers.map((controller) => controller.text).join('\$');
    });
    print(_allText.toString());
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "") {
      print(token);

      setState(() {});
    } else {
      print("null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: MenuDrawer().getMenuDrawer(context),
      appBar: CustomAppBar()
          .getCustomAppBar("VTS ROUTE DEFINE", _scaffoldKey, 0, context),
      body: _routeDefine(),
    );
  }

  _routeDefine() {
    //! Bloc Listener is present here---------------->
    return LoadingOverlay(
      isLoading: _isloading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: MyColors.appDefaultColorCode,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          if (state is RouteDefinePostLoadingState) {
          } else if (state is RouteDefinePostLoadedState) {
            if (state.routedefinepost.data != null) {
              // _routepost!.addAll(state.routedefinepost.data!.);
            }
          } else if (state is RouteDefinePostErrorState) {}
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, left: 15, right: 15, bottom: 20),
            child: Column(
              children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17.0, bottom: 8),
                      child: Row(
                        children: const [
                          Text(
                            "Route Name",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  controller: _routernamecontrollers,
                  enabled: true,
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
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)),
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
                        children: const [
                          Text(
                            "Start Location",
                            style: TextStyle(fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text("*",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  onChanged: (value) {
                    if (value.isEmpty) {
                      startpoint = false;
                      setState(() {});
                    } else {
                      startpoint = true;
                      setState(() {});
                    }
                    _onSearchTextChanged(value);
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  controller: _startcontroller,
                  enabled: true, // to trigger disabledBorder
                  decoration: const InputDecoration(
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
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)),
                    hintText: "Searchable Dropdown",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                startpoint
                    ? Container(
                        height: 130.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ListView.builder(
                          itemCount: _startingpredictions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                startaddress = _startingpredictions[index]
                                    .description
                                    .toString();
                                _startcontroller.text =
                                    _startingpredictions[index]
                                        .description
                                        .toString();
                                // startpoint = false;
                                _onPredictionSelected(
                                    _startingpredictions[index]
                                        .description
                                        .toString());
                                startpoint = false;
                                setState(() {});
                              },
                              title: Text(_startingpredictions[index]
                                  .description
                                  .toString()),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
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
                      Divider(
                        color: MyColors.text3greyColorCode,
                        height: 1,
                      ),
                      Container(
                        height: 40.0,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 20, right: 20.0),
                        child: Center(
                            child: GestureDetector(
                          onTap: () {
                            TextEditingController controller =
                                TextEditingController();
                            CustomTextformfield textField = CustomTextformfield(
                              controller: controller,
                              onTextChanged: (response) {},
                            );

                            setState(() {
                              _controllers.add(controller);
                              _textFields.add(textField);
                            });
                            controller.addListener(() {
                              _updateAllText();
                            });
                          },
                          child: Text(
                            "+ Add Way Point",
                            style: TextStyle(
                                color: Color.fromARGB(255, 5, 49, 124),
                                fontSize: 18.0,
                                fontWeight: FontWeight.w500),
                          ),
                        )),
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
                      Column(
                        children: [
                          SizedBox(
                            height: 100.0,
                            child: ListView.builder(
                              itemCount: _textFields.length,
                              itemBuilder: (BuildContext context, int index) {
                                var personfield =
                                    _controllers[index].text.toString();

                                return _textFields[index];
                              },
                            ),
                          )
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
                                    fontSize: 18,
                                    color: MyColors.redColorCode)),
                          )
                        ],
                      ),
                    )),
                TextField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                  ],
                  onChanged: (value) {
                    if (value.isEmpty) {
                      endpoint = false;
                      setState(() {});
                    } else {
                      endpoint = true;
                      setState(() {});
                    }
                    _onEndpointChanged(value);
                  },
                  controller: _endcontroller,
                  enabled: true, // to trigger disabledBorder
                  decoration: const InputDecoration(
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
                        borderSide: BorderSide(
                            width: 2, color: MyColors.buttonColorCode)),
                    hintText: "Searchable Dropdown",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                endpoint
                    ? Container(
                        height: 100.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.grey)),
                        margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ListView.builder(
                          itemCount: _endpredictions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                endaddress = _endpredictions[index]
                                    .description
                                    .toString();
                                _endcontroller.text = _endpredictions[index]
                                    .description
                                    .toString();
                                endpoint = false;
                                _onPredictionendpoint(_endpredictions[index]
                                    .description
                                    .toString());
                                setState(() {});
                              },
                              title: Text(_endpredictions[index]
                                  .description
                                  .toString()),
                            );
                          },
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 48,
                  child: MaterialButton(
                    onPressed: () {
                      _isloading = true;
                      setState(() {});
                      if (_routernamecontrollers.text.isEmpty &&
                          fromlatitude == null &&
                          fromlongitude == null &&
                          tolatitude == null &&
                          tolongitude == null) {
                        _isloading = false;
                        setState(() {});
                        final snackBar = SnackBar(
                          content: const Text("Fill Required Detail"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else if (_allText.isEmpty) {
                        Future.delayed(Duration(seconds: 3), () {
                          _isloading = false;

                          setState(() {});
                          _mainBloc.add(RouteDefinePostEvents(
                              token: token,
                              vendorid: 1,
                              branchid: 1,
                              routefrom: _startcontroller.text,
                              routeto: _endcontroller.text,
                              routename: _routernamecontrollers.text,
                              midwaypoint: "Not there"));
                        }).whenComplete(() => CustomDialog().popUp(
                            context, "Well done! Record Save Successfully"));
                      } else {
                        Future.delayed(Duration(seconds: 3), () {
                          _isloading = false;
                          _midaddress(_allText.toString());
                          setState(() {});
                          _mainBloc.add(RouteDefinePostEvents(
                              token: token,
                              vendorid: 1,
                              branchid: 1,
                              routefrom: _startcontroller.text,
                              routeto: _endcontroller.text,
                              routename: _routernamecontrollers.text,
                              midwaypoint: _allText.toString()));
                        }).whenComplete(() => CustomDialog().popUp(
                            context, "Well done! Record Save Successfully"));
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Text(
                      "Save Route Details",
                      style: TextStyle(
                          fontSize: 18, color: MyColors.whiteColorCode),
                    ),
                    color: MyColors.buttonColorCode,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      _isloading = true;
                      setState(() {});
                      if (_routernamecontrollers.text.isEmpty &&
                          fromlatitude == null &&
                          fromlongitude == null &&
                          tolatitude == null &&
                          tolongitude == null) {
                        _isloading = false;
                        setState(() {});
                        final snackBar = SnackBar(
                          content: const Text("Fill Required Detail"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        _midaddress(_allText.toString());
                        Future.delayed(Duration(seconds: 5), () {
                          _isloading = false;
                          setState(() {});
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return VTSRouteDefineMap(
                                routename: _routernamecontrollers.text,
                                fromlatitude: fromlatitude!,
                                fromlongitude: fromlongitude!,
                                tolatitude: tolatitude!,
                                tolongitude: tolongitude!,
                                coordinatesList: coordinatesList!);
                          }));
                        });
                      }
                    },
                    child: Text(
                      "View Map",
                      style: TextStyle(
                          fontSize: 18,
                          color: MyColors.appDefaultColorCode,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //! GetAddressfromLarling-------------------------------------------------
  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      address = "${place.locality}${place.country}";
      setState(() {});
      return "${place.name}${place.locality}${place.postalCode}${place.country}";
    } catch (e) {
      return "Unable to get address for this location.";
    }
  }

//! Starting Point Prediction---------------------
  void _onPredictionSelected(String address) async {
    List<Location> locations = await locationFromAddress(address.toString());
    // locations.clear();
    Location location = locations[0];
    fromlatitude = 0.0;
    fromlongitude = 0.0;
    fromlatitude = location.latitude;
    fromlongitude = location.longitude;
    setState(() {});
    print("Latitude: $fromlatitude, Longitude: $fromlongitude");
    print("Route From Address----------------" + address.toString());
  }

  //! End Point Prediction ---------------------------
  void _onPredictionendpoint(String address) async {
    List<Location> tolocations = await locationFromAddress(address.toString() ??
        "Dange Chowk Rd, Hinjawadi Village, Hinjawadi, Pimpri-Chinchwad, Maharashtra 411057, India");
    // tolocations.clear();

    Location tolocation = tolocations[0];

    tolatitude = tolocation.latitude;
    tolongitude = tolocation.longitude;
    setState(() {});

    print("ToLatitude: $tolatitude, ToLongitude: $tolongitude");
  }

  //! Mid way point address------------>
  Future<void> _midaddress(String midaddress) async {
    try {
      List<String> addressList = midaddress.split('\$');
      for (String address in addressList) {
        List<Location> locations = await locationFromAddress(address);
        Location location = locations.first;
        double latitude = location.latitude;
        double longitude = location.longitude;
        Map<String, double> coordinates = {
          "latitude": latitude,
          "longitude": longitude
        };

        coordinatesList!.add(coordinates);
        setState(() {});

        print("Here is your coordinates list" + coordinatesList.toString());
      }
    } catch (e) {
      print("Data not found");
    }
  }
}
