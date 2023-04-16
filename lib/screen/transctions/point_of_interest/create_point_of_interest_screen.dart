import 'package:flutter/material.dart';
import 'package:flutter_vts/bloc/main_bloc.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_vts/util/MyColor.dart';
import 'package:flutter_vts/util/custome_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../model/point_of_interest/dropdown_point_of_interest.dart';
import '../../../model/point_of_interest/poi_post.dart';
import '../../../model/point_of_interest/poi_type.dart';
import '../../../model/vehicle/all_vehicle_detail_response.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:location/location.dart' as loc;

class CreatePointOfInterestScreen extends StatefulWidget {
  const CreatePointOfInterestScreen({Key? key}) : super(key: key);

  @override
  _CreatePointOfInterestScreenState createState() =>
      _CreatePointOfInterestScreenState();
}

class _CreatePointOfInterestScreenState
    extends State<CreatePointOfInterestScreen> {
  late SharedPreferences sharedPreferences;
  late String token = "";
  late MainBloc _mainBloc;
  bool poitypeselected = false;
  bool vehicleselect = false;
  bool alertbox = false;
  var poitypetext, vehiclelisttext, vehicleselectbyid;
  bool containerselected = false;
  TextEditingController _selectcontroller = TextEditingController();
  TextEditingController _poinamecontroller = TextEditingController();

  TextEditingController _descriptioncontroller = TextEditingController();

  TextEditingController _tolerancecontroller = TextEditingController();

  Set<Marker> markers = Set();
  String dropdownvalue = 'Y';

  // List of items in our dropdown menu
  var items = ['Y', 'N'];
  List<VechileDetailsbyID>? vehiclelistbyid = [];
  List<AddPOIPostdata>? poipostdata = [];
  String? _currentAddress;
  Position? _currentPosition;
  bool onseaerchtextn = false;
  final places =
      GoogleMapsPlaces(apiKey: 'AIzaSyBfnxY2sLZfwZDVvZ3voaxPu911U696PZE');
  GoogleMapController? mapController;
  loc.Location gps = loc.Location();
  String location = "";
  String addresslocation = "";
  var poiname, description, tolerance, address, numinded, latitude, longitude;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    _getCurrentPosition();

    _mainBloc = BlocProvider.of(context);
    setState(() {});
    _selectcontroller.addListener(() {
      setState(() {
        location = _selectcontroller.text;
      });
    });
  }

  getdata() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("auth_token") != null) {
      token = sharedPreferences.getString("auth_token")!;
    }
    if (token != "") {
      print(token);
      getallbranch();
      setState(() {});
    } else {
      print("null");
    }
  }

  getallbranch() {
    _mainBloc.add(Poitype(
      token: token,
    ));
    _mainBloc.add(AllVehicleDetailEvents(
        token: token, vendorId: 1, branchId: 1, pageNumber: 1, pageSize: 10));
  }

  //! handle the google permission----------------
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      gps.requestService();
      setState(() {});
      openAppSettings();
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
    markers.add(Marker(
      markerId: MarkerId("Selected Address"),
      position: latLng,
      icon: BitmapDescriptor.defaultMarker,
    ));
    latitude = details.result.geometry!.location.lat;
    longitude = details.result.geometry!.location.lng;
    setState(() {
      _predictions = [];
    });
  }

  //! fetching current location----------------------
  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      getAddressFromLatLng(
          _currentPosition!.latitude, _currentPosition!.longitude);
      setState(() {});
    }).catchError((e) {
      debugPrint(e);
    });
  }

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
                  GestureDetector(
                    onTap: () {
                      _poinamecontroller.text = "";
                      poitypetext = "";
                      _descriptioncontroller.text = "";
                      _tolerancecontroller.text = "";
                      vehiclelisttext = "";
                      _selectcontroller.text = "";
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
                onTap: () {
                  if (_poinamecontroller.text.isNotEmpty &&
                      _descriptioncontroller.text.isNotEmpty &&
                      _tolerancecontroller.text.isNotEmpty &&
                      _selectcontroller.text.isNotEmpty) {
                    _mainBloc.add(PoiPostdata(
                        token: token,
                        vendorid: 1,
                        branchid: 1,
                        poiname: poiname.toString(),
                        poitypeID: numinded,
                        description: description.toString(),
                        tolerance: int.parse(tolerance),
                        locationlatitude: latitude.toString() ??
                            _currentPosition!.latitude.toString(),
                        locationlongitude: longitude.toString() ??
                            _currentPosition!.longitude.toString(),
                        showpoi: dropdownvalue.toString(),
                        address:
                            addresslocation.toString() ?? address.toString(),
                        vehicleid: int.parse(vehicleselectbyid)));
                    alertbox = true;
                    setState(() {});
                  } else {
                    final snackBar = SnackBar(
                      content: const Text("Fill Required Detail"),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  alertbox
                      ? CustomDialog().popUp(
                          context, "Well done! Record Save Successfully....!!")
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
                  child: const Text(
                    "Save POI",
                    style:
                        TextStyle(color: MyColors.whiteColorCode, fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _pointofinterest() {
    return BlocListener<MainBloc, MainState>(
      listener: (context, state) {
        //! POI Post data to serever------------
        if (state is POIPostLoadingState) {
          print("poi enter in the loading state");
        } else if (state is POIPostLoadedState) {
          if (state.poipost.data != null) {
            poipostdata!.addAll(state.poipost.data!);
          }
        } else if (state is POIPostErrorState) {
          print(state.msg.toString());
          print("Enter in the error state");
        }
        //! VechileId and vechile number in flutter---------------------
        if (state is AllVehicleDetailLoadingState) {
        } else if (state is AllVehicleDetailLoadedState) {
          if (state.allVehicleDetailResponse.data != null) {
            vehiclelistbyid!.addAll(state.allVehicleDetailResponse.data!);
          } else {
            print("Your data is null");
          }
        } else if (state is AllVehicleDetailErrorState) {}
//! poitypelist------------------------------------
        if (state is POITypeLoadingState) {
        } else if (state is POITypeLoadedState) {
          print(
              "POIType list enter in the loaded state------------------------");

          poitypelist;
        } else if (state is POITypeErrorState) {}
        if (state is PointofInterestDropdownLoadingState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PointofInterestDropdownLoadedState) {
          if (state.dropdownPointOfInterest != null) {
            print("Filter data is printed!!");
          } else {
            print("Something went worong in Filter data");
          }
        } else if (state is TravelSummaryFilterErrorState) {
          print("Something went Wrong Filter data");
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20.0, left: 15, right: 15, bottom: 20),
          child: Column(
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          "Vendor Name",
                          style: TextStyle(
                              fontSize: 18, color: MyColors.blackColorCode),
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
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromARGB(255, 198, 197, 197)),
                    color: Colors.white),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 15.0),
                  child: Text(
                    "M-Tech",
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17, bottom: 8),
                    child: Row(
                      children: const [
                        Text(
                          "Branch Name",
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
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Color.fromARGB(255, 198, 197, 197)),
                    color: Colors.white),
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 15.0),
                  child: Text(
                    "Hinjawadi",
                    style: TextStyle(color: Colors.black, fontSize: 17.0),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17.0, bottom: 8),
                    child: Row(
                      children: const [
                        Text(
                          "POI Name",
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
              TextFormField(
                onChanged: (value) {
                  poiname = value;
                  setState(() {});
                },
                controller: _poinamecontroller,
                validator: (value) {
                  value!.isEmpty ? "Enter the poiname" : null;
                },

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
                          "POI Type",
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
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.only(top: 10.0, right: 3.0, left: 3.0),
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      poitypeselected = true;
                      setState(() {});
                    },
                    child: ListTile(
                      leading: Text(poitypetext ?? "All"),
                      trailing: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ),
                ),
              ),
              poitypeselected
                  ? Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 198, 197, 197)),
                          color: Colors.white),
                      child: Padding(
                          padding: EdgeInsets.only(left: 8.0, top: 15.0),
                          child: ListView.builder(
                            itemCount: poitypelist.length,
                            itemBuilder: (BuildContext context, int index) {
                              var article = poitypelist[index];

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    poitypetext = poitypelist[index];

                                    poitypeselected = false;
                                    numinded = index + 1;
                                    print(numinded.toString());
                                    setState(() {});
                                  },
                                  child: Text(
                                    article.toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                  ),
                                ),
                              );
                            },
                          )),
                    )
                  : SizedBox(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17, bottom: 8.0),
                    child: Row(
                      children: const [
                        Text(
                          "Description",
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
              TextFormField(
                onChanged: (value) {
                  description = value;
                  setState(() {});
                },
                validator: (value) {
                  value!.isEmpty ? "Enter the description" : null;
                },
                controller: _descriptioncontroller,
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
                                  fontSize: 18, color: MyColors.redColorCode)),
                        )
                      ],
                    ),
                  )),
              TextFormField(
                onChanged: (value) {
                  tolerance = value;
                  setState(() {});
                },
                validator: (value) {
                  value!.isEmpty ? "Enter the tolerance" : null;
                },
                controller: _tolerancecontroller,
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
                    hintText: "Type here",
                    hintStyle: TextStyle(
                        fontSize: 16, color: MyColors.textFieldHintColorCode),
                    errorText: ""),
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
                          "Select Vehicle",
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
              GestureDetector(
                onTap: () {
                  containerselected = true;
                  setState(() {});
                },
                child: Container(
                  height: 50.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.0, color: Colors.grey),
                  ),
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Text(vehiclelisttext ?? "All"),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                ),
              ),
              containerselected
                  ? Container(
                      height: 200.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                      ),
                      margin: EdgeInsets.only(left: 3.0, right: 3.0),
                      child: ListView.builder(
                        itemCount: vehiclelistbyid!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              vehiclelisttext =
                                  vehiclelistbyid![index].vehicleRegNo;
                              vehicleselectbyid =
                                  vehiclelistbyid![index].vsrNo.toString();
                              print(vehicleselectbyid);

                              containerselected = false;
                              setState(() {});
                            },
                            child: SizedBox(
                                height: 40.0,
                                width: 50.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(vehiclelistbyid![index]
                                      .vehicleRegNo
                                      .toString()),
                                )),
                          );
                        },
                      ),
                    )
                  : SizedBox(),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 17, bottom: 8),
                    child: Row(
                      children: [
                        Text(
                          "Show Geofence",
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
                        height: 394,
                        child: GoogleMap(
                          zoomGesturesEnabled: true,
                          myLocationEnabled: true, //enable Zoom in, out on map
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
                          markers: markers,
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
                        const EdgeInsets.only(top: 50.0, left: 15, right: 15),
                    child: TextFormField(
                      onChanged: (value) => _onSearchTextChanged(value),
                      enabled: true,

                      // onChanged: (value) {
                      //   final plist = GoogleMapsPlaces(
                      //     apiKey: "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY",

                      //     //from google_api_headers package
                      //   );
                      //   final response = plist.autocomplete(value);
                      //   print(response.);
                      // },
                      // onTap: () async {
                      // var place = await PlacesAutocomplete.show(
                      //     context: context,
                      //     apiKey: "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY",
                      //     mode: Mode.overlay,
                      //     types: [],
                      //     strictbounds: false,
                      //     components: [Component(Component.country, 'ind')],
                      //     //google_map_webservice package
                      //     onError: (err) {
                      //       print("this is error=----------");
                      //       print(err.errorMessage);
                      //     });

                      // if (place != null) {
                      //   setState(() {
                      //     location = place.description.toString();
                      //     addresslocation = location
                      //         .replaceAll(",", "")
                      //         .replaceAll(" ", "");
                      //     print("Location of the map------------" +
                      //         addresslocation.toString());
                      //   });

                      //   //form google_maps_webservice package
                      //   final plist = GoogleMapsPlaces(
                      //     apiKey: "AIzaSyBnJPusnfAjrL9xofBjC_R5heU4uPZXgDY",

                      //     //from google_api_headers package
                      //   );

                      //   String placeid = place.placeId ?? "0";
                      //   final detail =
                      //       await plist.getDetailsByPlaceId(placeid);
                      //   final geometry = detail.result.geometry!;
                      //   final lat = geometry.location.lat;
                      //   final lang = geometry.location.lng;
                      //   var newlatlang = LatLng(lat, lang);
                      //   markers.add(Marker(
                      //       markerId: MarkerId(location),
                      //       position: newlatlang));
                      //   latitude = lat;
                      //   longitude = lang;
                      //   setState(() {});
                      //   //move map camera to selected place with animation
                      //   mapController?.animateCamera(
                      //       CameraUpdate.newCameraPosition(CameraPosition(
                      //           target: newlatlang, zoom: 17)));
                      // } else {
                      //   print("Something went wrong on the textfield");
                      // }
                      // },
                      controller: _selectcontroller,
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
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                              width: 1,
                            )),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                width: 1,
                                color: MyColors.textBoxBorderColorCode)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            borderSide: BorderSide(
                                width: 2, color: MyColors.buttonColorCode)),
                        hintText: location ?? "Select",
                        hintStyle: TextStyle(fontSize: 18, color: Colors.black),
                        errorText: "",
                      ),
                      // controller: _passwordController,
                      // onChanged: _authenticationFormBloc.onPasswordChanged,
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
                                  _selectcontroller.text = _predictions[index]
                                      .description
                                      .toString();
                                  onseaerchtextn = false;
                                  addresslocation = location
                                      .replaceAll(",", "")
                                      .replaceAll(" ", "");
                                  _onPredictionSelected(_predictions[index]);
                                  setState(() {});
                                },
                                title: Text(
                                    _predictions[index].description.toString()),
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
}
