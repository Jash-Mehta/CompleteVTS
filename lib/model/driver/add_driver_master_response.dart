// To parse this JSON data, do
//
//     final addDriverResponse = addDriverResponseFromJson(jsonString);

import 'dart:convert';

AddDriverResponse addDriverResponseFromJson(String str) => AddDriverResponse.fromJson(json.decode(str));

String addDriverResponseToJson(AddDriverResponse data) => json.encode(data.toJson());

class AddDriverResponse {
  AddDriverResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  Data? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory AddDriverResponse.fromJson(Map<String, dynamic> json) => AddDriverResponse(
    data: json["data"] ==null ? null :Data.fromJson(json["data"]),
    succeeded: json["succeeded"] ==null ? null :json["succeeded"],
    errors: json["errors"] ==null ? null :json["errors"],
    message: json["message"] ==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
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
    this.branchSrNo,
    this.branchName,
    this.driverCode,
    this.driverName,
    this.licenceNo,
    this.city,
    this.mobileNo,
    this.doj,
    this.driverAddress,
    this.acUser,
    this.acStatus,
  });

  int ?srNo;
  int ?vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String ?branchName;
  String? driverCode;
  String ?driverName;
  String? licenceNo;
  String ?city;
  String ?mobileNo;
  DateTime ?doj;
  String ?driverAddress;
  String ?acUser;
  String ?acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    driverCode: json["driverCode"],
    driverName: json["driverName"],
    licenceNo: json["licenceNo"],
    city: json["city"],
    mobileNo: json["mobileNo"],
    doj: DateTime.parse(json["doj"]),
    driverAddress: json["driverAddress"],
    acUser: json["acUser"],
    acStatus: json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "driverCode": driverCode,
    "driverName": driverName,
    "licenceNo": licenceNo,
    "city": city,
    "mobileNo": mobileNo,
    "doj": doj!.toIso8601String(),
    "driverAddress": driverAddress,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
