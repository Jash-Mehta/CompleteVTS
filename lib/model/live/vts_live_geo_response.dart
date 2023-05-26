// To parse this JSON data, do
//
//     final vtsLiveGeo = vtsLiveGeoFromJson(jsonString);

import 'dart:convert';

List<VtsLiveGeo> vtsLiveGeoFromJson(String str) =>
    List<VtsLiveGeo>.from(json.decode(str).map((x) => VtsLiveGeo.fromJson(x)));

String vtsLiveGeoToJson(List<VtsLiveGeo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VtsLiveGeo {
  var srNo;
  var vendorSrNo;
  var branchSrNo;
  String geofenceName;
  String category;
  String description;
  var tolerance;
  var vehicleSrNo;
  String showGeofence;
  String locationLatitude;
  String locationLongitude;
  String overlayType;
  String circleBounds;
  String circleRadius;
  String circleArea;
  String circlehectares;
  String circleKilometer;
  String circleMiles;
  String circleCenterLat;
  String circleCenterLng;
  String rectangleBounds;
  String rectangleArea;
  String rectanglehectares;
  String rectangleKilometer;
  String rectangleMiles;
  String polygonPath;
  String polygonArea;
  String polygonhectares;
  String polygonKilometer;
  String polygonMiles;
  String address;

  VtsLiveGeo({
    required this.srNo,
    required this.vendorSrNo,
    required this.branchSrNo,
    required this.geofenceName,
    required this.category,
    required this.description,
    required this.tolerance,
    required this.vehicleSrNo,
    required this.showGeofence,
    required this.locationLatitude,
    required this.locationLongitude,
    required this.overlayType,
    required this.circleBounds,
    required this.circleRadius,
    required this.circleArea,
    required this.circlehectares,
    required this.circleKilometer,
    required this.circleMiles,
    required this.circleCenterLat,
    required this.circleCenterLng,
    required this.rectangleBounds,
    required this.rectangleArea,
    required this.rectanglehectares,
    required this.rectangleKilometer,
    required this.rectangleMiles,
    required this.polygonPath,
    required this.polygonArea,
    required this.polygonhectares,
    required this.polygonKilometer,
    required this.polygonMiles,
    required this.address,
  });

  factory VtsLiveGeo.fromJson(Map<String, dynamic> json) => VtsLiveGeo(
        srNo: json["srNo"],
        vendorSrNo: json["vendorSrNo"],
        branchSrNo: json["branchSrNo"],
        geofenceName: json["geofenceName"],
        category: json["category"],
        description: json["description"],
        tolerance: json["tolerance"],
        vehicleSrNo: json["vehicleSrNo"],
        showGeofence: json["showGeofence"],
        locationLatitude: json["locationLatitude"],
        locationLongitude: json["locationLongitude"],
        overlayType: json["overlayType"],
        circleBounds: json["circleBounds"],
        circleRadius: json["circleRadius"],
        circleArea: json["circleArea"],
        circlehectares: json["circlehectares"],
        circleKilometer: json["circleKilometer"],
        circleMiles: json["circleMiles"],
        circleCenterLat: json["circleCenterLat"],
        circleCenterLng: json["circleCenterLng"],
        rectangleBounds: json["rectangleBounds"],
        rectangleArea: json["rectangleArea"],
        rectanglehectares: json["rectanglehectares"],
        rectangleKilometer: json["rectangleKilometer"],
        rectangleMiles: json["rectangleMiles"],
        polygonPath: json["polygonPath"],
        polygonArea: json["polygonArea"],
        polygonhectares: json["polygonhectares"],
        polygonKilometer: json["polygonKilometer"],
        polygonMiles: json["polygonMiles"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "srNo": srNo,
        "vendorSrNo": vendorSrNo,
        "branchSrNo": branchSrNo,
        "geofenceName": geofenceName,
        "category": category,
        "description": description,
        "tolerance": tolerance,
        "vehicleSrNo": vehicleSrNo,
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
      };
}
