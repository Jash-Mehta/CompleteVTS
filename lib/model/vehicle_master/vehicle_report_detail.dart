// To parse this JSON data, do
//
//     final vehicleDetails = vehicleDetailsFromJson(jsonString);

import 'dart:convert';

VehicleReportDetails vehicleDetailsFromJson(String str) => VehicleReportDetails.fromJson(json.decode(str));

String vehicleDetailsToJson(VehicleReportDetails data) => json.encode(data.toJson());

class VehicleReportDetails {
  VehicleReportDetails({
    this.pageNumber,
    this.pageSize,
    this.firstPage,
    this.lastPage,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<VehicleInfo>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory VehicleReportDetails.fromJson(Map<String, dynamic> json) => VehicleReportDetails(
    pageNumber: json["pageNumber"]??0,
    pageSize: json["pageSize"]??0,
    firstPage: json["firstPage"]??"",
    lastPage: json["lastPage"]??"",
    totalPages: json["totalPages"]??0,
    totalRecords: json["totalRecords"]??0,
    nextPage: json["nextPage"]??"",
    previousPage: json["previousPage"]??"",
    data: json["data"] == null ? [] : List<VehicleInfo>.from(json["data"]!.map((x) => VehicleInfo.fromJson(x))).toList(),
    succeeded: json["succeeded"]??false,
    errors: json["errors"]??"",
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "firstPage": firstPage,
    "lastPage": lastPage,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
    "nextPage": nextPage,
    "previousPage": previousPage,
    "data": data == null ? [] : List<VehicleInfo>.from(data!.map((x) => x.toJson())).toList(),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class VehicleInfo {
  VehicleInfo({
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
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? vehicleRegNo;
  String? vehicleName;
  String? fuelType;
  int? speedLimit;
  String? vehicleType;
  String? vehicleTypeName;
  int? driverSrNo;
  String? driverName;
  int? deviceSrNo;
  String? deviceName;
  double? currentOdometer;
  String? vehicleRc;
  String? vehicleInsurance;
  String? vehiclePuc;
  String? vehicleOther;
  String? acUser;
  String? acStatus;

  factory VehicleInfo.fromJson(Map<String, dynamic> json) => VehicleInfo(
    vsrNo: json["vsrNo"]??0,
    vendorSrNo: json["vendorSrNo"]??0,
    vendorName: json["vendorName"]??"",
    branchSrNo: json["branchSrNo"]??0,
    branchName: json["branchName"]??"",
    vehicleRegNo: json["vehicleRegNo"]??"",
    vehicleName: json["vehicleName"]??"",
    fuelType: json["fuelType"]??"",
    speedLimit: json["speedLimit"]??0,
    vehicleType: json["vehicleType"]??"",
    vehicleTypeName: json["vehicleTypeName"]??"",
    driverSrNo: json["driverSrNo"]??0,
    driverName: json["driverName"]??"",
    deviceSrNo: json["deviceSrNo"]??0,
    deviceName: json["deviceName"]??"",
    currentOdometer: json["currentOdometer"]??0.0,
    vehicleRc: json["vehicleRc"]??"",
    vehicleInsurance: json["vehicleInsurance"]??"",
    vehiclePuc: json["vehiclePuc"]??"",
    vehicleOther: json["vehicleOther"]??"",
    acUser: json["acUser"]??"",
    acStatus: json["acStatus"]??"",
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
