// To parse this JSON data, do
//
//     final allVehicleDetailResponse = allVehicleDetailResponseFromJson(jsonString);

import 'dart:convert';

AllVehicleDetailResponse allVehicleDetailResponseFromJson(String str) => AllVehicleDetailResponse.fromJson(json.decode(str));

String allVehicleDetailResponseToJson(AllVehicleDetailResponse data) => json.encode(data.toJson());

class AllVehicleDetailResponse {
  AllVehicleDetailResponse({
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

  int ?pageNumber;
  int? pageSize;
  String ?firstPage;
  String ?lastPage;
  int ?totalPages;
  int? totalRecords;
  dynamic nextPage;
  String? previousPage;
  List<VechileDetailsbyID> ?data;
  bool ?succeeded;
  dynamic errors;
  dynamic  message;

  factory AllVehicleDetailResponse.fromJson(Map<String, dynamic> json) => AllVehicleDetailResponse(
    pageNumber: json["pageNumber"]==null ? null : json["pageNumber"],
    pageSize:  json["pageSize"]==null ? null :json["pageSize"],
    firstPage:  json["firstPage"]==null ? null :json["firstPage"],
    lastPage:  json["lastPage"]==null ? null :json["lastPage"],
    totalPages:  json["totalPages"]==null ? null :json["totalPages"],
    totalRecords:  json["totalRecords"]==null ? null :json["totalRecords"],
    nextPage: json["nextPage"]==null ? null : json["nextPage"],
    previousPage:  json["previousPage"]==null ? null :json["previousPage"],
    data: json["data"]==null ? null : List<VechileDetailsbyID>.from(json["data"].map((x) => VechileDetailsbyID.fromJson(x))),
    succeeded:  json["succeeded"]==null ? null :json["succeeded"],
    errors:  json["errors"]==null ? null :json["errors"],
    message:  json["message"]==null ? null :json["message"],
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
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class VechileDetailsbyID {
  VechileDetailsbyID({
    this.vsrNo,
    this.vendorSrNo,
    this.branchSrNo,
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
    this.acStatus,
    this.acUser,
    this.acDate,
    this.modifiedBy,
  });

  int ?vsrNo;
  int? vendorSrNo;
  int ?branchSrNo;
  String ?vehicleRegNo;
  String ?vehicleName;
  String ?fuelType;
  int? speedLimit;
  String ?vehicleType;
  String ?vehicleTypeName;
  int ?driverSrNo;
  String ?driverName;
  int ?deviceSrNo;
  String ?deviceName;
  double ?currentOdometer;
  String ?vehicleRc;
  String ?vehicleInsurance;
  String? vehiclePuc;
  String ?vehicleOther;
  String ?acStatus;
  String ?acUser;
  DateTime ?acDate;
  String? modifiedBy;

  factory VechileDetailsbyID.fromJson(Map<String, dynamic> json) => VechileDetailsbyID(
    vsrNo:json["vsrNo"]==null ? null : json["vsrNo"],
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    vehicleRegNo:json["vehicleRegNo"]==null ? null : json["vehicleRegNo"],
    vehicleName: json["vehicleName"]==null ? null :json["vehicleName"],
    fuelType: json["fuelType"]==null ? null :json["fuelType"],
    speedLimit: json["speedLimit"]==null ? null :json["speedLimit"],
    vehicleType: json["vehicleType"]==null ? null :json["vehicleType"],
    vehicleTypeName: json["vehicleTypeName"]==null ? null :json["vehicleTypeName"],

    driverSrNo: json["driverSrNo"]==null ? null :json["driverSrNo"],
    driverName: json["driverName"]==null ? null :json["driverName"],
    deviceSrNo:json["deviceSrNo"]==null ? null : json["deviceSrNo"],
    deviceName: json["deviceName"]==null ? null :json["deviceName"],
    currentOdometer: json["currentOdometer"]==null ? null :json["currentOdometer"].toDouble(),
    vehicleRc: json["vehicleRc"]==null ? null :json["vehicleRc"],
    vehicleInsurance:json["vehicleInsurance"]==null ? null : json["vehicleInsurance"],
    vehiclePuc: json["vehiclePuc"]==null ? null :json["vehiclePuc"],
    vehicleOther:json["vehicleOther"]==null ? null : json["vehicleOther"],
    acStatus: json["acStatus"]==null ? null :json["acStatus"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acDate: json["acDate"]==null ? null :DateTime.parse(json["acDate"]),
    modifiedBy: json["modifiedBy"] == null ? null : json["modifiedBy"],
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
    "vehicleTypeName": vehicleTypeName,
    "driverSrNo": driverSrNo,
    "deviceSrNo": deviceSrNo,
    "currentOdometer": currentOdometer,
    "vehicleRc": vehicleRc,
    "vehicleInsurance": vehicleInsurance,
    "vehiclePuc": vehiclePuc,
    "vehicleOther": vehicleOther,
    "acStatus": acStatus,
    "acUser": acUser,
    "acDate": acDate!.toIso8601String(),
    "modifiedBy": modifiedBy == null ? null : modifiedBy,
  };
}
