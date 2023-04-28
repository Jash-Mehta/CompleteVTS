import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';
import 'package:flutter_vts/model/alert/vehicle_fill_srno_response.dart';
import 'package:flutter_vts/model/geofence/search_geofence_create_response.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'dart:async';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart' as loc;
import '../../../model/vehicle/all_vehicle_detail_response.dart';

const googleApiKey = "AIzaSyCzJ9rnQfwR2O7lfUnJt2UGwNicQP_eTUk";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: googleApiKey);

class CreateGeofenceScreen extends StatefulWidget {
  const CreateGeofenceScreen({Key? key}) : super(key: key);

  @override
  _CreateGeofenceScreenState createState() => _CreateGeofenceScreenState();
}

class _CreateGeofenceScreenState extends State<CreateGeofenceScreen> {
  TextEditingController _vendorNamecontroller = new TextEditingController();
  TextEditingController _branchNamecontroller = new TextEditingController();
  TextEditingController _geofenceNamecontroller = new TextEditingController();
  TextEditingController _descriptiCncontroller = new TextEditingController();
  TextEditingController _toleranceController = new TextEditingController();
  GoogleMapController? mapController;

  bool onseaerchtextn = false;
  TextEditingController searchController = new TextEditingController();
  late double latitude;
  late double longitute;
  bool alertbox = false;
  var geofencename, description, tolerance;
  bool iscontainerselected = false;
  var vehiclename, vehicleid, longlatitude, longlongitude, checkstatus;
  static late LatLng latLng = new LatLng(18.6298, 73.7997);
  final mapErrorScaffoldKey = GlobalKey<ScaffoldState>();
  final Set<Marker> _marker = {};
  String dropdownvalueprovider = 'Area';
  var provideritems = ["Area", "Stay in Zone", "Stay Away from zone"];
  String categorydropdown = '';
  String dropdownvalue = 'Y';

  // List of items in our dropdown menu
  var items = ['Y', 'N'];
  late SharedPreferences sharedPreferences;
  late String userName = "";
  late String vendorName = "", branchName = "", userType = "";
  late int branchid = 1, vendorid = 1;
  late String token = "";
  late bool _isLoading = false;
  List categoryDataList = [];
  List<String> list = [];
  List<VehiclesDetail> vehicleSrNoDetailslist = [];
  List<VehiclesDetail> selectedvehicleSrNoDetailslist = [];
  List<VechileDetailsbyID>? vehiclelistbyid = [];
  List<VehicleDatums> vehicleSrNolist = [];
  bool activeStatus = false;
  String location = "";
  String addresslocation = "";
  late MainBloc _mainBloc;
  String? _currentAddress;
  Position? _currentPosition;
  loc.Location gps = loc.Location();
  late var vehicleresult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    // _handleLocationPermission();
    _mainBloc = BlocProvider.of(context);

    getdata();
    setState(() {});
  }

  //! For Address----------------------
  final _placesApiClient =
      GoogleMapsPlaces(apiKey: 'AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY');

  List<Prediction> _predictions = [];

  void _onSearchTextChanged(String value) async {
    if (value.isNotEmpty) {
      onseaerchtextn = true;
      setState(() {});
      PlacesAutocompleteResponse response = await _placesApiClient.autocomplete(
        value,
        language: "en",
        types: [],
        components: [Component(Component.country, "IND")],
      );
      setState(() {
        _predictions = response.predictions;
      });
    } else {
      setState(() {
        _predictions = [];
      });
    }
  }

  void _onPredictionSelected(Prediction prediction) async {
    PlacesDetailsResponse details =
        await _placesApiClient.getDetailsByPlaceId(prediction.placeId!);

    LatLng latLng = LatLng(details.result.geometry!.location.lat,
        details.result.geometry!.location.lng);
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 17)));
    _marker.add(Marker(
      markerId: MarkerId("Selected Address"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
    ));
    longlatitude = details.result.geometry!.location.lat;
    longlongitude = details.result.geometry!.location.lng;
    setState(() {
      _predictions = [];
    });
  }

  //! handle the google permission----------------
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      print("Permission-----------" + hasPermission.toString());
      print("Here is you current location----------" +
          _currentPosition!.latitude.toString() +
          "" +
          _currentPosition!.longitude.toString() +
          "" +
          _currentAddress.toString());
    }).catchError((e) {
      debugPrint(e);
    });
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (sharedPreferences.getString("Username") != null) {
      userName = sharedPreferences.getString("Username")!;
    }
    vendorName = sharedPreferences.getString("VendorName")!;
    branchName = sharedPreferences.getString("BranchName")!;
    userType = sharedPreferences.getString("UserType")!;
    vendorid = sharedPreferences.getInt("VendorId")!;
    branchid = sharedPreferences.getInt("BranchId")!;

    if (userType != "") {
      _vendorNamecontroller.text = vendorName;
      _branchNamecontroller.text = branchName;
    }
    if (token != "") {
      _mainBloc.add(AllVehicleDetailEvents(
          token: token, vendorId: 1, branchId: 1, pageNumber: 1, pageSize: 10));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CREATE GEOFENCE"),
      ),
      body: _addvehiclemaster(),
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
                  GestureDetector(
                    onTap: () {
                      _descriptiCncontroller.text = "";
                      _geofenceNamecontroller.text = "";
                      _toleranceController.text = "";
                      vehiclename = "--select--";
                      location = "";
                      searchController.text = "";
                      setState(() {});
                    },
                    child: Icon(
                      Icons.phonelink_erase_rounded,
                      color: MyColors.text4ColorCode,
                    ),
                  ),
                  Text("Clear",
                      style: TextStyle(
                          color: MyColors.text4ColorCode,
                          decoration: TextDecoration.underline,
                          fontSize: 20)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close,
                          size: 25, color: MyColors.text4ColorCode)),
                  Text(
                    "Close",
                    style: TextStyle(
                        color: MyColors.text4ColorCode,
                        decoration: TextDecoration.underline,
                        fontSize: 20),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: InkWell(
                  onTap: () {
                    if (_geofenceNamecontroller.text.isNotEmpty &&
                        _descriptiCncontroller.text.isNotEmpty &&
                        _toleranceController.text.isNotEmpty) {
                      _mainBloc.add(AddGeofenceEvents(
                          token: token,
                          vendorid: vendorid,
                          branchid: branchid,
                          geofencename: geofencename,
                          category: dropdownvalueprovider,
                          description: description,
                          tolerance: int.parse(tolerance),
                          showgeofence: dropdownvalue,
                          latitude: longlatitude.toString() ??
                              _currentPosition!.latitude.toString(),
                          longitude: longlongitude.toString() ??
                              _currentPosition!.longitude.toString(),
                          overlaytype: "Rectangle",
                          rectanglebond: "12.56",
                          rectanglearea: "23.4",
                          rectanglehectares: "34.5",
                          rectanglekilometer: "25.6",
                          rectanglemiles: "2.3",
                          address: addresslocation.toString(),
                          vehicleid: vehicleid));
                      alertbox = true;
                      setState(() {});
                    } else {
                      final snackBar = SnackBar(
                        content: const Text("Fill Required Detail"),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    alertbox
                        ? CustomDialog().popUp(context,
                            "Well done! Record Save Successfully....!!")
                        : SizedBox();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 148,
                    height: 56,
                    margin: const EdgeInsets.only(left: 15),
                    padding: const EdgeInsets.only(
                        top: 6.0, bottom: 6, left: 20, right: 20),
                    decoration: BoxDecoration(
                        color: MyColors.buttonColorCode,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border:
                            Border.all(color: MyColors.textBoxBorderColorCode)),
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: MyColors.whiteColorCode, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// AllVehicleDetailEvents -----------
  _addvehiclemaster() {
    return LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.5,
      color: Colors.white,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: Color(0xFFCE4A6F),
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
      child: BlocListener<MainBloc, MainState>(
        listener: (context, state) {
          //! VechileId and vechile number in flutter---------------------
          if (state is AllVehicleDetailLoadingState) {
          } else if (state is AllVehicleDetailLoadedState) {
            if (state.allVehicleDetailResponse.data != null) {
              vehiclelistbyid!.addAll(state.allVehicleDetailResponse.data!);
            } else {
              print("Your data is null");
            }
          } else if (state is AllVehicleDetailErrorState) {}
          //! AddGeofence Create--------
          if (state is AddGeofenceLoadingState) {
            setState(() {
              _isLoading = true;
            });
          } else if (state is AddGeofenceLoadedState) {
            setState(() {
              _isLoading = false;
            });
          } else if (state is AddGeofenceErrorState) {
            setState(() {
              _isLoading = false;
            });
          }
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
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Text(
                            "Vendor Name",
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
                  controller: _vendorNamecontroller,
                  enabled: false, // to trigger disabledBorder
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
                    hintText: "Type here",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                /*Container(
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
                          */ /* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*/ /*
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
                ),*/
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Branch Name",
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
                  controller: _branchNamecontroller,
                  enabled: false, // to trigger disabledBorder
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
                    hintText: "Type here",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                ),
                /*Container(
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
                          */ /* decoration: BoxDecoration(
                            border: Border.all(color:MyColors.text3greyColorCode )
                          ),*/ /*
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
                ),*/
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17.0, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Geofence Name",
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
                    geofencename = value.toString();
                    setState(() {});
                  },
                  controller: _geofenceNamecontroller,
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp('^[a-zA-Z][a-zA-Z ]*')),
                  ],
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
                    hintText: "Type here",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
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
                          Text(
                            "Category",
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
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: MyColors.textBoxBorderColorCode, width: 2),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: MyColors.whiteColorCode,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: dropdownvalueprovider,
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                      items: provideritems.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 18.0),
                            child: Text(
                              items,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15.0),
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalueprovider = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 17, bottom: 8.0),
                      child: Row(
                        children: [
                          Text(
                            "Description",
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
                  controller: _descriptiCncontroller,
                  onChanged: (value) {
                    description = value.toString();
                  },
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp('^[a-zA-Z][a-zA-Z ]*')),
                  ],
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
                    hintText: "Type here",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
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
                          Text(
                            "Tolerance",
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
                    tolerance = value.toString();
                  },
                  controller: _toleranceController,
                  enabled: true, // to trigger disabledBorder
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
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
                    hintText: "Type here",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
                    errorText: "",
                  ),
                  // controller: _passwordController,
                  // onChanged: _authenticationFormBloc.onPasswordChanged,
                  obscureText: false,
                  keyboardType: TextInputType.number,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Select Vehicle",
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
                GestureDetector(
                  onTap: () {
                    iscontainerselected = true;
                    setState(() {});
                  },
                  child: Container(
                    height: 40.0,
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.grey)),
                    child: ListTile(
                      leading: Text(vehiclename ?? "--select--"),
                      trailing: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
                iscontainerselected
                    ? Card(
                        elevation: 3.0,
                        child: Container(
                          height: 150.0,
                          width: double.infinity,
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: ListView.builder(
                            itemCount: vehiclelistbyid!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      iscontainerselected = false;
                                      vehicleid = vehiclelistbyid![index].vsrNo;
                                      vehiclename = vehiclelistbyid![index]
                                          .vehicleRegNo
                                          .toString();
                                      setState(() {});
                                    },
                                    child: SizedBox(
                                      height: 40.0,
                                      width: 50.0,
                                      child: Text(vehiclelistbyid![index]
                                          .vehicleRegNo
                                          .toString()),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      )
                    : SizedBox(),
                selectedvehicleSrNoDetailslist.length == 0
                    ? Container()
                    : GridView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 10 / 4,
                          mainAxisSpacing: 6.0,
                          crossAxisSpacing: 6.0,
                        ),
                        itemCount: selectedvehicleSrNoDetailslist.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: MyColors.dateIconColorCode,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(22))),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    selectedvehicleSrNoDetailslist[index]
                                        .vehicleRegNo!,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: MyColors.whiteColorCode,
                                        fontSize: 16),
                                  )),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedvehicleSrNoDetailslist
                                              .removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: MyColors.whiteColorCode,
                                      ))
                                ],
                              ));
                        }),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            "Status",
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
                Container(
                  height: 50.0,
                  width: double.infinity,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: DropdownButton(
                    // Initial Value
                    value: dropdownvalue,

                    // Down Arrow Icon

                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
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
                    BlocBuilder<MainBloc, MainState>(
                      builder: (context, state) {
                        return Container(
                          margin: const EdgeInsets.only(top: 17, bottom: 8),
                          height: 400,
                          decoration: BoxDecoration(
                              color: MyColors.appDefaultColorCode,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: GoogleMap(
                            zoomGesturesEnabled: true,
                            myLocationEnabled:
                                true, //enable Zoom in, out on map
                            myLocationButtonEnabled: true,
                           
                            initialCameraPosition: CameraPosition(
                              //innital position in map
                              target: LatLng(
                                  _currentPosition!.latitude == null
                                      ? 18.5204
                                      : _currentPosition!.latitude,
                                  _currentPosition!.longitude == null
                                      ? 73.8567
                                      : _currentPosition!
                                          .longitude), //initial position
                              zoom: 13.0,
                              //initial zoom level
                            ),
                            markers: _marker,
                            onMapCreated: (controller) {
                              //method called when map is created
                              setState(() {
                                mapController = controller;
                              });
                            },
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30.0, left: 15, right: 15),
                      child: TextField(
                        controller: searchController,

                        onChanged: (value) => _onSearchTextChanged(value),
                        enabled: true,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp("[0-9a-zA-Z]")),
                        ], // to trigger disabledBorder
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColors.whiteColorCode,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                width: 1, color: MyColors.buttonColorCode),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide:
                                BorderSide(width: 1, color: Colors.orange),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                width: 1, color: MyColors.textColorCode),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                width: 1,
                              )),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: MyColors.textBoxBorderColorCode)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              borderSide: BorderSide(
                                  width: 2, color: MyColors.buttonColorCode)),
                          hintText: location ?? "Select",
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.black),
                          errorText: "",
                        ),
                        obscureText: false,
                      ),
                    ),
                    onseaerchtextn
                        ? Container(
                            margin: EdgeInsets.only(
                                top: 115.0, left: 20.0, right: 20.0),
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(color: Colors.white),
                            child: ListView.builder(
                              itemCount: _predictions.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    location = _predictions[index]
                                        .description
                                        .toString();
                                    searchController.text = _predictions[index]
                                        .description
                                        .toString();
                                    onseaerchtextn = false;
                                    addresslocation = location
                                        .replaceAll(",", "")
                                        .replaceAll(" ", "");
                                    _onPredictionSelected(_predictions[index]);
                                    setState(() {});
                                  },
                                  title: Text(_predictions[index]
                                      .description
                                      .toString()),
                                );
                              },
                            ),
                          )
                        : SizedBox()
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  validation() {
    if (_geofenceNamecontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Geofence Name..!!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
    if (_geofenceNamecontroller.text.length < 3) {
      Fluttertoast.showToast(
        msg: "Geofence Name must be 3 digit..!!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (categorydropdown == '') {
      Fluttertoast.showToast(
        msg: "Please select geofence category name...!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_descriptiCncontroller.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please Enter Description..!!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else if (_descriptiCncontroller.text.length < 3) {
      Fluttertoast.showToast(
        msg: "Description must be 3 digit..!!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
    if (selectedvehicleSrNoDetailslist.length == 0) {
      Fluttertoast.showToast(
        msg: "Please select vehicles..!!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    } else {
      Fluttertoast.showToast(
        msg: "success...!!",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
      );
    }
  }

  Future<String> getCategorylist() async {
    setState(() {
      _isLoading = true;
    });
    print(Constant.geofenceCategoryUrl);

    var response = await http.get(
      Uri.parse(Constant.geofenceCategoryUrl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      var resBody = json.decode(response.body);
      setState(() {
        _isLoading = false;
        categoryDataList = resBody;
        // }
      });
      print(resBody);
      return "Success";
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load data.');
    }
  }

  Future<String> getvehiclelist() async {
    setState(() {
      _isLoading = true;
    });
    String url = Constant.vehicleFillSrnoUrl +
        "" +
        vendorid.toString() +
        "/" +
        branchid.toString();

    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    var resBody = json.decode(response.body);
    vehicleSrNolist = vehicleFillSrNoResponseFromJson(response.body).data!;
    setState(() {
      _isLoading = false;
    });
    for (int i = 0; i < vehicleSrNolist.length; i++) {
      list.add(vehicleSrNolist[i].vehicleRegNo!);
      vehicleSrNoDetailslist.add(VehiclesDetail(
          vsrNo: vehicleSrNolist[i].vsrNo,
          vehicleRegNo: vehicleSrNolist[i].vehicleRegNo!));
    }

    return "Success";
  }

  void _showMultiSelect() async {
    vehicleresult = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiVehicleSelect(
          items: list,
          vehiclelist: vehicleSrNoDetailslist,
          selectedvehicleSrNoDetailslist: selectedvehicleSrNoDetailslist,
        );
      },
    );

    if (vehicleresult != null && vehicleresult.containsKey('VehicleList')) {
      setState(() {
        print("vehicle list : ${vehicleresult["VehicleList"]}");
      });
    }
    if (vehicleresult != null && vehicleresult.containsKey('VehicleListDemo')) {
      setState(() {
        selectedvehicleSrNoDetailslist = vehicleresult["VehicleListDemo"];
      });
    }
  }
}

class MultiVehicleSelect extends StatefulWidget {
  List<String> items;
  // List<VehicleFillResponse> vehiclelist=[];
  List<VehiclesDetail> vehiclelist = [];
  List<VehiclesDetail> selectedvehicleSrNoDetailslist = [];

  MultiVehicleSelect(
      {Key? key,
      required this.items,
      required this.vehiclelist,
      required this.selectedvehicleSrNoDetailslist})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiVehicleSelectState();
}

class _MultiVehicleSelectState extends State<MultiVehicleSelect> {
  // this variable holds the selected items
  final List<String> _selectedItems = [];
  // final List<VehicleFillResponse> _selectedItemslist = [];
  List<VehiclesDetail> _selectedItemslist = [];

  List<bool> _isChecked = [];
  List<VehicleList> vehiclelist = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (int i = 0; i < widget.selectedvehicleSrNoDetailslist.length; i++) {
      _selectedItems
          .add(widget.selectedvehicleSrNoDetailslist[i].vehicleRegNo!);
      _selectedItemslist.add(VehiclesDetail(
          vsrNo: widget.selectedvehicleSrNoDetailslist[i].vsrNo,
          vehicleRegNo: widget.selectedvehicleSrNoDetailslist[i].vehicleRegNo));
    }

    for (int i = 0; i < widget.items.length; i++) {
      vehiclelist
          .add(VehicleList(vehicleno: widget.items[i], vehicleselected: false));
    }

    for (int i = 0; i < widget.items.length; i++) {
      for (int j = 0; j < widget.selectedvehicleSrNoDetailslist.length; j++) {
        if (widget.items[i] ==
            widget.selectedvehicleSrNoDetailslist[j].vehicleRegNo) {
          vehiclelist[i].vehicleselected = true;
        } else {}
      }
    }

    for (int i = 0; i < vehiclelist.length; i++) {
      print("Selected vehicle list :${vehiclelist[i].vehicleselected}");
    }
  }

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
        for (int i = 0; i < widget.vehiclelist.length; i++) {
          if (widget.vehiclelist[i].vehicleRegNo == itemValue) {
            _selectedItemslist.add(VehiclesDetail(
                vsrNo: widget.vehiclelist[i].vsrNo,
                vehicleRegNo: widget.vehiclelist[i].vehicleRegNo));
          }
        }
      } else {
        _selectedItems.remove(itemValue);
        _selectedItemslist
            .removeWhere((item) => item.vehicleRegNo == itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    print(_selectedItems);
    for (int i = 0; i < _selectedItemslist.length; i++) {
      print("selected list : ${_selectedItemslist[i].vehicleRegNo}");
    }

    Navigator.pop(context, {
      "VehicleList": _selectedItems,
      "VehicleListDemo": _selectedItemslist,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Vehicle'),
      content: SingleChildScrollView(
        child: ListBody(
          children: vehiclelist
              .map((item) => CheckboxListTile(
                    value: _selectedItems.contains(item.vehicleno),
                    title: Text(item.vehicleno),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) {
                      _itemChange(item.vehicleno, isChecked!);
                    },
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: _cancel,
        ),
        ElevatedButton(
          child: const Text('Submit'),
          onPressed: _submit,
        ),
      ],
    );
  }
}

class VehicleList {
  late String vehicleno;
  late bool vehicleselected;

  VehicleList({required this.vehicleno, required this.vehicleselected});
}
