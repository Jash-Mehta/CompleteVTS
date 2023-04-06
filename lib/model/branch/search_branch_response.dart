// To parse this JSON data, do
//
//     final searchBranchResponse = searchBranchResponseFromJson(jsonString);

import 'dart:convert';

SearchBranchResponse searchBranchResponseFromJson(String str) => SearchBranchResponse.fromJson(json.decode(str));

String searchBranchResponseToJson(SearchBranchResponse data) => json.encode(data.toJson());

class SearchBranchResponse {
  SearchBranchResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory SearchBranchResponse.fromJson(Map<String, dynamic> json) => SearchBranchResponse(
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
  String? branchName;
  String ?city;
  String ?mobileNo;
  String? emailId;
  String? address;
  String? acUser;
  String ?acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo: json["srNo"]==null ? null :json["srNo"],
    vendorSrNo: json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName:  json["vendorName"]==null ? null :json["vendorName"],
    branchCode: json["branchCode"]==null ? null : json["branchCode"],
    branchName:  json["branchName"]==null ? null :json["branchName"],
    city:  json["city"]==null ? null :json["city"],
    mobileNo:  json["mobileNo"]==null ? null :json["mobileNo"],
    emailId:  json["emailId"]==null ? null :json["emailId"],
    address:  json["address"]==null ? null :json["address"],
    acUser: json["acUser"]==null ? null : json["acUser"],
    acStatus: json["acStatus"]==null ? null : json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
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
