// To parse this JSON data, do
//
//     final searchVehicleResponse = searchVehicleResponseFromJson(jsonString);

import 'dart:convert';

SearchVehicleResponse searchVehicleResponseFromJson(String str) => SearchVehicleResponse.fromJson(json.decode(str));

String searchVehicleResponseToJson(SearchVehicleResponse data) => json.encode(data.toJson());

class SearchVehicleResponse {
  SearchVehicleResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory SearchVehicleResponse.fromJson(Map<String, dynamic> json) => SearchVehicleResponse(
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Data {
  Data({
    this.vsrNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.vehicleRegNo,
    this.vehicleName,
    this.fuelType,
    this.speedLimit,
    this.vehicleType,
    this.vehicleTypeName,
    this.driverSrNo,
    this.driverName,
    this.deviceSrNo,
    this.deviceName,
    this.currentOdometer,
    this.vehicleRc,
    this.vehicleInsurance,
    this.vehiclePuc,
    this.vehicleOther,
    this.acUser,
    this.acStatus,
  });

  int? vsrNo;
  int ?vendorSrNo;
  String ?vendorName;
  int? branchSrNo;
  String ?branchName;
  String ?vehicleRegNo;
  String ?vehicleName;
  String ?fuelType;
  int? speedLimit;
  dynamic ?vehicleType;
  String ?vehicleTypeName;
  int ?driverSrNo;
  String ?driverName;
  int? deviceSrNo;
  String ?deviceName;
  double ?currentOdometer;
  String ?vehicleRc;
  String ?vehicleInsurance;
  String ?vehiclePuc;
  String ?vehicleOther;
  String ?acUser;
  String ?acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    vsrNo: json["vsrNo"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    vehicleRegNo: json["vehicleRegNo"],
    vehicleName: json["vehicleName"],
    fuelType: json["fuelType"],
    speedLimit: json["speedLimit"],
    vehicleType: json["vehicleType"],
    vehicleTypeName: json["vehicleTypeName"]==null ? null :json["vehicleTypeName"],
    driverSrNo: json["driverSrNo"],
    driverName: json["driverName"],
    deviceSrNo: json["deviceSrNo"],
    deviceName: json["deviceName"],
    currentOdometer: json["currentOdometer"].toDouble(),
    vehicleRc: json["vehicleRc"],
    vehicleInsurance: json["vehicleInsurance"],
    vehiclePuc: json["vehiclePuc"],
    vehicleOther: json["vehicleOther"],
    acUser: json["acUser"],
    acStatus: json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "vehicleRegNo": vehicleRegNo,
    "vehicleName": vehicleName,
    "fuelType": fuelType,
    "speedLimit": speedLimit,
    "vehicleType": vehicleType,
    "vehicleTypeName": vehicleTypeName,
    "driverSrNo": driverSrNo,
    "driverName": driverName,
    "deviceSrNo": deviceSrNo,
    "deviceName": deviceName,
    "currentOdometer": currentOdometer,
    "vehicleRc": vehicleRc,
    "vehicleInsurance": vehicleInsurance,
    "vehiclePuc": vehiclePuc,
    "vehicleOther": vehicleOther,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}


