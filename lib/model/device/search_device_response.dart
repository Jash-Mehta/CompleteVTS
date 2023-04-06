// To parse this JSON data, do
//
//     final searchDeviceResponse = searchDeviceResponseFromJson(jsonString);

import 'dart:convert';

SearchDeviceResponse searchDeviceResponseFromJson(String str) => SearchDeviceResponse.fromJson(json.decode(str));

String searchDeviceResponseToJson(SearchDeviceResponse data) => json.encode(data.toJson());

class SearchDeviceResponse {
  SearchDeviceResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data> ?data;
  bool ?succeeded;
  dynamic? errors;
  String? message;

  factory SearchDeviceResponse.fromJson(Map<String, dynamic> json) => SearchDeviceResponse(
    data: json["data"]==null ? null : List<Data>.from(json["data"].map((x) => Data.fromJson(x))),

    // data: Data.fromJson(json["data"]),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    // "data": data!.toJson(),
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

  int? srNo;
  int ?vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String ?branchName;
  String ?deviceNo;
  String ?modelNo;
  String ?simNo1;
  String ?simNo2;
  String ?deviceName;
  String ?imeino;
  String? portNo;
  String ?acUser;
  String? acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    deviceNo: json["deviceNo"],
    modelNo: json["modelNo"],
    simNo1: json["simNo1"],
    simNo2: json["simNo2"],
    deviceName: json["deviceName"],
    imeino: json["imeino"],
    portNo: json["portNo"],
    acUser: json["acUser"],
    acStatus: json["acStatus"],
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
