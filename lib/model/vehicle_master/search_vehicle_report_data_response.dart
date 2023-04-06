// To parse this JSON data, do
//
//     final searchingVehicleDetailsReportData = searchingVehicleDetailsReportDataFromJson(jsonString);

import 'dart:convert';

SearchingVehicleDetailsReportData searchingVehicleDetailsReportDataFromJson(String str) => SearchingVehicleDetailsReportData.fromJson(json.decode(str));

String searchingVehicleDetailsReportDataToJson(SearchingVehicleDetailsReportData data) => json.encode(data.toJson());

class SearchingVehicleDetailsReportData {
  SearchingVehicleDetailsReportData({
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
  List<SearchingVehItemInfo>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory SearchingVehicleDetailsReportData.fromJson(Map<String, dynamic> json) => SearchingVehicleDetailsReportData(
    pageNumber: json["pageNumber"]??0,
    pageSize: json["pageSize"]??0,
    firstPage: json["firstPage"]??"",
    lastPage: json["lastPage"]??"",
    totalPages: json["totalPages"]??0,
    totalRecords: json["totalRecords"]??0,
    nextPage: json["nextPage"]??"",
    previousPage: json["previousPage"]??"",
    data: json["data"] == null ? [] : List<SearchingVehItemInfo>.from(json["data"]!.map((x) => SearchingVehItemInfo.fromJson(x))),
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
    "data": data == null ? [] : List<SearchingVehItemInfo>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class SearchingVehItemInfo {
  SearchingVehItemInfo({
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

  factory SearchingVehItemInfo.fromJson(Map<String, dynamic> json) => SearchingVehItemInfo(
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
