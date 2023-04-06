// To parse this JSON data, do
//
//     final addVehicleRequest = addVehicleRequestFromJson(jsonString);

import 'dart:convert';

EditVehicleRequest editVehicleRequestFromJson(String str) => EditVehicleRequest.fromJson(json.decode(str));

String editVehicleRequestToJson(EditVehicleRequest data) => json.encode(data.toJson());

class EditVehicleRequest {
  EditVehicleRequest({
    this.vsrNo,
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

  int ?vsrNo;
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

  factory EditVehicleRequest.fromJson(Map<String, dynamic> json) => EditVehicleRequest(
    vsrNo: json["vsrNo"],
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
    "vsrNo": vsrNo,
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