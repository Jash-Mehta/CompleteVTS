// To parse this JSON data, do
//
//     final allBranchMasterResponse = allBranchMasterResponseFromJson(jsonString);

import 'dart:convert';

AllBranchMasterResponse allBranchMasterResponseFromJson(String str) => AllBranchMasterResponse.fromJson(json.decode(str));

String allBranchMasterResponseToJson(AllBranchMasterResponse data) => json.encode(data.toJson());

class AllBranchMasterResponse {
  AllBranchMasterResponse({
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
  int ?pageSize;
  String? firstPage;
  String ?lastPage;
  int ?totalPages;
  int ?totalRecords;
  String ?nextPage;
  String ?previousPage;
  List<Datum>? data;
  bool ?succeeded;
  dynamic? errors;
  dynamic ?message;

  factory AllBranchMasterResponse.fromJson(Map<String, dynamic> json) => AllBranchMasterResponse(
    pageNumber: json["pageNumber"]==null ? null :json["pageNumber"],
    pageSize: json["pageSize"]==null ? null :json["pageSize"],
    firstPage: json["firstPage"]==null ? null :json["firstPage"],
    lastPage: json["lastPage"]==null ? null :json["lastPage"],
    totalPages: json["totalPages"]==null ? null :json["totalPages"],
    totalRecords:json["totalRecords"]==null ? null : json["totalRecords"],
    nextPage: json["nextPage"]==null ? null :json["nextPage"],
    previousPage: json["previousPage"]==null ? null :json["previousPage"],
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["succeeded"]==null ? null :json["errors"],
    message: json["pageNumber"]==null ? null :json["errors"],
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
    this.branchCode,
    this.branchName,
    this.city,
    this.mobileNo,
    this.emailId,
    this.address,
    this.acUser,
    this.acStatus,
  });

  int ?srNo;
  int ?vendorSrNo;
  String ?vendorName;
  String ?branchCode;
  String ?branchName;
  String ?city;
  String? mobileNo;
  String? emailId;
  String? address;
  String ?acUser;
  String ?acStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["vendorSrNo"]==null ? null :json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName:json["vendorName"]==null ? null : json["vendorName"],
    branchCode: json["branchCode"]==null ? null :json["branchCode"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    city: json["city"]==null ? null :json["city"],
    mobileNo: json["emailId"]==null ? null :json["mobileNo"],
    emailId: json["emailId"]==null ? null :json["emailId"],
    address:json["address"]==null ? null : json["address"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acStatus: json["acStatus"]==null ? null :json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName":vendorName,
    "branchCode": branchCode,
    "branchName": branchName,
    "city": city,
    "mobileNo": mobileNo,
    "emailId": emailId,
    "address": address,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}

