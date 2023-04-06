// To parse this JSON data, do
//
//     final searchGeofenceCreateResponse = searchGeofenceCreateResponseFromJson(jsonString);

import 'dart:convert';

SearchGeofenceCreateResponse searchGeofenceCreateResponseFromJson(String str) => SearchGeofenceCreateResponse.fromJson(json.decode(str));

String searchGeofenceCreateResponseToJson(SearchGeofenceCreateResponse data) => json.encode(data.toJson());

class SearchGeofenceCreateResponse {
  SearchGeofenceCreateResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datum>? data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory SearchGeofenceCreateResponse.fromJson(Map<String, dynamic> json) => SearchGeofenceCreateResponse(
    data:json["data"]==null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors:json["errors"]==null ? null : json["errors"],
    message: json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datum {
  Datum({
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.geofenceName,
    this.category,
    this.description,
    this.tolerance,
    this.vehicleSrNo,
    this.vehicleRegno,
    this.showGeofence,
  });

  dynamic? srNo;
  dynamic ?vendorSrNo;
  String? vendorName;
  dynamic ?branchSrNo;
  String? branchName;
  String? geofenceName;
  String ?category;
  String ?description;
  dynamic? tolerance;
  dynamic ?vehicleSrNo;
  String? vehicleRegno;
  String ?showGeofence;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo:json["srNo"]==null ? null : json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName:json["branchName"]==null ? null : json["branchName"],
    geofenceName:json["geofenceName"]==null ? null : json["geofenceName"],
    category: json["category"]==null ? null :json["category"],
    description: json["description"]==null ? null :json["description"],
    tolerance: json["tolerance"]==null ? null :json["tolerance"],
    vehicleSrNo: json["vehicleSrNo"]==null ? null :json["vehicleSrNo"],
    vehicleRegno: json["vehicleRegno"]==null ? null :json["vehicleRegno"],
    showGeofence:json["showGeofence"]==null ? null : json["showGeofence"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "geofenceName": geofenceName,
    "category": category,
    "description": description,
    "tolerance": tolerance,
    "vehicleSrNo": vehicleSrNo,
    "vehicleRegno": vehicleRegno,
    "showGeofence": showGeofence,
  };
}


// -----------------------------------------------------------------------


AddGeofenceRequest addGeofenceRequestFromJson(String str) => AddGeofenceRequest.fromJson(json.decode(str));

String addGeofenceRequestToJson(AddGeofenceRequest data) => json.encode(data.toJson());

class AddGeofenceRequest {
  AddGeofenceRequest({
    this.vendorSrNo,
    this.branchSrNo,
    this.geofenceName,
    this.category,
    this.description,
    this.tolerance,
    this.showGeofence,
    this.locationLatitude,
    this.locationLongitude,
    this.overlayType,
    this.circleBounds,
    this.circleRadius,
    this.circleArea,
    this.circlehectares,
    this.circleKilometer,
    this.circleMiles,
    this.circleCenterLat,
    this.circleCenterLng,
    this.rectangleBounds,
    this.rectangleArea,
    this.rectanglehectares,
    this.rectangleKilometer,
    this.rectangleMiles,
    this.polygonPath,
    this.polygonArea,
    this.polygonhectares,
    this.polygonKilometer,
    this.polygonMiles,
    this.address,
    this.vehicleList,
  });

  int? vendorSrNo;
  int ?branchSrNo;
  String? geofenceName;
  String ?category;
  String ?description;
  int ?tolerance;
  String? showGeofence;
  String ?locationLatitude;
  String ?locationLongitude;
  String ?overlayType;
  String ?circleBounds;
  String ?circleRadius;
  String ?circleArea;
  String ?circlehectares;
  String ?circleKilometer;
  String ?circleMiles;
  String ?circleCenterLat;
  String ?circleCenterLng;
  String ?rectangleBounds;
  String ?rectangleArea;
  String? rectanglehectares;
  String ?rectangleKilometer;
  String? rectangleMiles;
  String? polygonPath;
  String ?polygonArea;
  String? polygonhectares;
  String? polygonKilometer;
  String ?polygonMiles;
  String ?address;
  List<GeofenceVehicleList> ?vehicleList;

  factory AddGeofenceRequest.fromJson(Map<String, dynamic> json) => AddGeofenceRequest(
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    geofenceName: json["geofenceName"]==null ? null :json["geofenceName"],
    category: json["category"]==null ? null :json["category"],
    description:json["description"]==null ? null : json["description"],
    tolerance:json["tolerance"]==null ? null : json["tolerance"],
    showGeofence: json["showGeofence"]==null ? null :json["showGeofence"],
    locationLatitude: json["locationLatitude"]==null ? null :json["locationLatitude"],
    locationLongitude:json["locationLongitude"]==null ? null : json["locationLongitude"],
    overlayType: json["overlayType"]==null ? null :json["overlayType"],
    circleBounds:json["circleBounds"]==null ? null : json["circleBounds"],
    circleRadius:json["circleRadius"]==null ? null : json["circleRadius"],
    circleArea:json["circleArea"]==null ? null : json["circleArea"],
    circlehectares: json["circlehectares"]==null ? null :json["circlehectares"],
    circleKilometer:json["circleKilometer"]==null ? null : json["circleKilometer"],
    circleMiles:json["circleMiles"]==null ? null : json["circleMiles"],
    circleCenterLat: json["circleCenterLat"]==null ? null :json["circleCenterLat"],
    circleCenterLng: json["circleCenterLng"]==null ? null :json["circleCenterLng"],
    rectangleBounds:json["rectangleBounds"]==null ? null : json["rectangleBounds"],
    rectangleArea:json["rectangleArea"]==null ? null : json["rectangleArea"],
    rectanglehectares: json["rectanglehectares"]==null ? null :json["rectanglehectares"],
    rectangleKilometer:json["rectangleKilometer"]==null ? null : json["rectangleKilometer"],
    rectangleMiles: json["rectangleMiles"]==null ? null :json["rectangleMiles"],
    polygonPath: json["polygonPath"]==null ? null :json["polygonPath"],
    polygonArea: json["polygonArea"]==null ? null :json["polygonArea"],
    polygonhectares:json["polygonhectares"]==null ? null : json["polygonhectares"],
    polygonKilometer: json["polygonKilometer"]==null ? null :json["polygonKilometer"],
    polygonMiles:json["polygonMiles"]==null ? null : json["polygonMiles"],
    address: json["address"]==null ? null :json["address"],
    vehicleList: json["vehicleList"]==null ? null :List<GeofenceVehicleList>.from(json["vehicleList"].map((x) => GeofenceVehicleList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "geofenceName": geofenceName,
    "category": category,
    "description": description,
    "tolerance": tolerance,
    "showGeofence": showGeofence,
    "locationLatitude": locationLatitude,
    "locationLongitude": locationLongitude,
    "overlayType": overlayType,
    "circleBounds": circleBounds,
    "circleRadius": circleRadius,
    "circleArea": circleArea,
    "circlehectares": circlehectares,
    "circleKilometer": circleKilometer,
    "circleMiles": circleMiles,
    "circleCenterLat": circleCenterLat,
    "circleCenterLng": circleCenterLng,
    "rectangleBounds": rectangleBounds,
    "rectangleArea": rectangleArea,
    "rectanglehectares": rectanglehectares,
    "rectangleKilometer": rectangleKilometer,
    "rectangleMiles": rectangleMiles,
    "polygonPath": polygonPath,
    "polygonArea": polygonArea,
    "polygonhectares": polygonhectares,
    "polygonKilometer": polygonKilometer,
    "polygonMiles": polygonMiles,
    "address": address,
    "vehicleList": List<dynamic>.from(vehicleList!.map((x) => x.toJson())),
  };
}

class GeofenceVehicleList {
  GeofenceVehicleList({
    this.vehicleId,
  });

  int ?vehicleId;

  factory GeofenceVehicleList.fromJson(Map<String, dynamic> json) => GeofenceVehicleList(
    vehicleId: json["vehicleId"]==null ? null :json["vehicleId"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
  };
}

//---------------------------------------------------------------


AddGeofenceResponse addGeofenceResponseFromJson(String str) => AddGeofenceResponse.fromJson(json.decode(str));

String addGeofenceResponseToJson(AddGeofenceResponse data) => json.encode(data.toJson());

class AddGeofenceResponse {
  AddGeofenceResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<AddGeofenceDatum> ?data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory AddGeofenceResponse.fromJson(Map<String, dynamic> json) => AddGeofenceResponse(
    data:json["data"]==null ? null : List<AddGeofenceDatum>.from(json["data"].map((x) => AddGeofenceDatum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message:json["message"]==null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class AddGeofenceDatum {
  AddGeofenceDatum({
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.geofenceName,
    this.category,
    this.description,
    this.tolerance,
    this.vehicleSrNo,
    this.vehicleRegno,
    this.showGeofence,
  });

  int? srNo;
  int? vendorSrNo;
  String ?vendorName;
  int? branchSrNo;
  String ?branchName;
  String ?geofenceName;
  String ?category;
  String? description;
  int ?tolerance;
  int ?vehicleSrNo;
  String ?vehicleRegno;
  String ?showGeofence;

  factory AddGeofenceDatum.fromJson(Map<String, dynamic> json) => AddGeofenceDatum(
    srNo:json["srNo"]==null ? null : json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    geofenceName:json["geofenceName"]==null ? null : json["geofenceName"],
    category: json["category"]==null ? null :json["category"],
    description: json["description"]==null ? null :json["description"],
    tolerance: json["tolerance"]==null ? null :json["tolerance"],
    vehicleSrNo: json["vehicleSrNo"]==null ? null :json["vehicleSrNo"],
    vehicleRegno:json["vehicleRegno"]==null ? null : json["vehicleRegno"],
    showGeofence: json["showGeofence"]==null ? null :json["showGeofence"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "geofenceName": geofenceName,
    "category": category,
    "description": description,
    "tolerance": tolerance,
    "vehicleSrNo": vehicleSrNo,
    "vehicleRegno": vehicleRegno,
    "showGeofence": showGeofence,
  };
}

