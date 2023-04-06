// To parse this JSON data, do
//
//     final addVehicleRequest = addVehicleRequestFromJson(jsonString);

import 'dart:convert';

AddVehicleRequest addVehicleRequestFromJson(String str) => AddVehicleRequest.fromJson(json.decode(str));

String addVehicleRequestToJson(AddVehicleRequest data) => json.encode(data.toJson());

class AddVehicleRequest {
  AddVehicleRequest({
    // this.vsrNo,
    this.vendorSrNo,
    this.branchSrNo,
    this.vehicleRegNo,
    this.vehicleName,
    this.fuelType,
    this.speedLimit,
    this.vehicleType,
    this.driverSrNo,
    this.deviceSrNo,
    this.currentOdometer,
    this.vehicleRc,
    this.vehicleInsurance,
    this.vehiclePuc,
    this.vehicleOther,
    this.acUser,
    this.acStatus,
  });

  // int ?vsrNo;
  int ?vendorSrNo;
  int ?branchSrNo;
  String? vehicleRegNo;
  String ?vehicleName;
  String ?fuelType;
  int ?speedLimit;
  String ?vehicleType;
  int ?driverSrNo;
  int ?deviceSrNo;
  double ?currentOdometer;
  String? vehicleRc;
  String ?vehicleInsurance;
  String ?vehiclePuc;
  String ?vehicleOther;
  String ?acUser;
  String ?acStatus;

  factory AddVehicleRequest.fromJson(Map<String, dynamic> json) => AddVehicleRequest(
    // vsrNo: json["vsrNo"],
    vendorSrNo: json["vendorSrNo"],
    branchSrNo: json["branchSrNo"],
    vehicleRegNo: json["vehicleRegNo"],
    vehicleName: json["vehicleName"],
    fuelType: json["fuelType"],
    speedLimit: json["speedLimit"],
    vehicleType: json["vehicleType"],
    driverSrNo: json["driverSrNo"],
    deviceSrNo: json["deviceSrNo"],
    currentOdometer: json["currentOdometer"],
    vehicleRc: json["vehicleRc"],
    vehicleInsurance: json["vehicleInsurance"],
    vehiclePuc: json["vehiclePuc"],
    vehicleOther: json["vehicleOther"],
    acUser: json["acUser"],
    acStatus: json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    // "vsrNo": vsrNo,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "vehicleRegNo": vehicleRegNo,
    "vehicleName": vehicleName,
    "fuelType": fuelType,
    "speedLimit": speedLimit,
    "vehicleType": vehicleType,
    "driverSrNo": driverSrNo,
    "deviceSrNo": deviceSrNo,
    "currentOdometer": currentOdometer,
    "vehicleRc": vehicleRc,
    "vehicleInsurance": vehicleInsurance,
    "vehiclePuc": vehiclePuc,
    "vehicleOther": vehicleOther,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
//-------------------------------------------


// To parse this JSON data, do
//
//     final addVehicleResponse = addVehicleResponseFromJson(jsonString);


AddVehicleResponse addVehicleResponseFromJson(String str) => AddVehicleResponse.fromJson(json.decode(str));

String addVehicleResponseToJson(AddVehicleResponse data) => json.encode(data.toJson());

class AddVehicleResponse {
  AddVehicleResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  Datas ?data;
  bool ?succeeded;
  dynamic? errors;
  String? message;

  factory AddVehicleResponse.fromJson(Map<String, dynamic> json) => AddVehicleResponse(
    data:  json["data"]==null ? null :Datas.fromJson(json["data"]),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors:  json["errors"]==null ? null :json["errors"],
    message:  json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datas {
  Datas({
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

  int ?vsrNo;
  int ?vendorSrNo;
  String? vendorName;
  int ?branchSrNo;
  String? branchName;
  String ?vehicleRegNo;
  String ?vehicleName;
  String ?fuelType;
  int ?speedLimit;
  String ?vehicleType;
  int ?driverSrNo;
  String? driverName;
  int ?deviceSrNo;
  String ?deviceName;
  double? currentOdometer;
  String ?vehicleRc;
  String ?vehicleInsurance;
  String? vehiclePuc;
  String ?vehicleOther;
  String ?acUser;
  String ?acStatus;

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
    vsrNo: json["vsrNo"]==null ? null : json["vsrNo"],
    vendorSrNo:  json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    branchSrNo:  json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName:  json["branchName"]==null ? null :json["branchName"],
    vehicleRegNo:  json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    vehicleName:  json["vehicleName"]==null ? null :json["vehicleName"],
    fuelType:  json["fuelType"]==null ? null :json["fuelType"],
    speedLimit: json["speedLimit"]==null ? null : json["speedLimit"],
    vehicleType:  json["vehicleType"]==null ? null :json["vehicleType"],
    driverSrNo: json["driverSrNo"]==null ? null : json["driverSrNo"],
    driverName:  json["driverName"]==null ? null :json["driverName"],
    deviceSrNo: json["deviceSrNo"]==null ? null : json["deviceSrNo"],
    deviceName:  json["deviceName"]==null ? null :json["deviceName"],
    currentOdometer: json["currentOdometer"]==null ? null : json["currentOdometer"].toDouble(),
    vehicleRc:  json["vehicleRc"]==null ? null :json["vehicleRc"],
    vehicleInsurance:  json["vehicleInsurance"]==null ? null :json["vehicleInsurance"],
    vehiclePuc:  json["vehiclePuc"]==null ? null :json["vehiclePuc"],
    vehicleOther: json["vehicleOther"]==null ? null : json["vehicleOther"],
    acUser:  json["acUser"]==null ? null :json["acUser"],
    acStatus: json["succeedacStatused"]==null ? null : json["acStatus"],
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
