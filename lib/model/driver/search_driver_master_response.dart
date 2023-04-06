// To parse this JSON data, do
//
//     final searchDriverResponse = searchDriverResponseFromJson(jsonString);

import 'dart:convert';

SearchDriverResponse searchDriverResponseFromJson(String str) => SearchDriverResponse.fromJson(json.decode(str));

String searchDriverResponseToJson(SearchDriverResponse data) => json.encode(data.toJson());

class SearchDriverResponse {
  SearchDriverResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool ?succeeded;
  dynamic errors;
  String ?message;

  factory SearchDriverResponse.fromJson(Map<String, dynamic> json) => SearchDriverResponse(
    data:  json["data"]==null ? null : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message:json["message"]==null ? null : json["message"],
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

  int? srNo;
  int? vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String ?branchName;
  String ?driverCode;
  String? driverName;
  String ?licenceNo;
  String ?city;
  String ?mobileNo;
  DateTime? doj;
  String ?driverAddress;
  String ?acUser;
  String ?acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo: json["srNo"]==null ? null :json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    driverCode: json["driverCode"]==null ? null :json["driverCode"],
    driverName: json["driverName"]==null ? null :json["driverName"],
    licenceNo: json["licenceNo"]==null ? null :json["licenceNo"],
    city: json["city"]==null ? null :json["city"],
    mobileNo:json["mobileNo"]==null ? null : json["mobileNo"],
    doj: json["doj"]==null ? null :DateTime.parse(json["doj"]),
    driverAddress: json["driverAddress"]==null ? null :json["driverAddress"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acStatus: json["acStatus"]==null ? null :json["acStatus"],
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



