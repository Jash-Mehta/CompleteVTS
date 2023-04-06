// To parse this JSON data, do
//
//     final allDeviceResponse = allDeviceResponseFromJson(jsonString);

import 'dart:convert';

AllDeviceResponse allDeviceResponseFromJson(String str) => AllDeviceResponse.fromJson(json.decode(str));

String allDeviceResponseToJson(AllDeviceResponse data) => json.encode(data.toJson());

class AllDeviceResponse {
  AllDeviceResponse({
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
  int ?totalRecords;
  String ?nextPage;
  dynamic ?previousPage;
  List<Datum>? data;
  bool ?succeeded;
  dynamic ?errors;
  dynamic? message;

  factory AllDeviceResponse.fromJson(Map<String, dynamic> json) => AllDeviceResponse(
    pageNumber:json["pageNumber"]==null ? null : json["pageNumber"],
    pageSize: json["pageSize"]==null ? null :json["pageSize"],
    firstPage: json["firstPage"]==null ? null :json["firstPage"],
    lastPage: json["lastPage"]==null ? null :json["lastPage"],
    totalPages: json["totalPages"]==null ? null :json["totalPages"],
    totalRecords: json["totalRecords"]==null ? null :json["totalRecords"],
    nextPage: json["nextPage"]==null ? null :json["nextPage"],
    previousPage: json["previousPage"]==null ? null :json["previousPage"],
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message: json["message"]==null ? null :json["message"],
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

class Datum {
  Datum({
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.deviceNo,
    this.modelNo,
    this.simNo1,
    this.simNo2,
    this.deviceName,
    this.imeino,
    this.portNo,
    this.acUser,
    this.acStatus,
  });

  int ?srNo;
  int? vendorSrNo;
  String? vendorName;
  int ?branchSrNo;
  String ?branchName;
  String? deviceNo;
  String ?modelNo;
  String ?simNo1;
  String ?simNo2;
  String ?deviceName;
  String? imeino;
  String ?portNo;
  String? acUser;
  String ?acStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["srNo"]==null ? null :json["srNo"],
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName:json["branchName"]==null ? null :json["branchName"],
    deviceNo: json["deviceNo"]==null ? null :json["deviceNo"],
    modelNo: json["modelNo"]==null ? null :json["modelNo"],
    simNo1: json["simNo1"]==null ? null :json["simNo1"],
    simNo2: json["simNo2"]==null ? null :json["simNo2"],
    deviceName:json["deviceName"]==null ? null : json["deviceName"],
    imeino: json["imeino"]==null ? null :json["imeino"],
    portNo: json["portNo"]==null ? null :json["portNo"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acStatus: json["acStatus"]==null ? null :json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "deviceNo": deviceNo,
    "modelNo": modelNo,
    "simNo1": simNo1,
    "simNo2": simNo2,
    "deviceName": deviceName,
    "imeino": imeino,
    "portNo": portNo,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}


