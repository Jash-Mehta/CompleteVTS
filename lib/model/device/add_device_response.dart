// To parse this JSON data, do
//
//     final addDeviceRequest = addDeviceRequestFromJson(jsonString);

import 'dart:convert';

AddDeviceResponse addDeviceResponseFromJson(String str) => AddDeviceResponse.fromJson(json.decode(str));

String addDeviceResponseToJson(AddDeviceResponse data) => json.encode(data.toJson());

class AddDeviceResponse {
  AddDeviceResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  Data ?data;
  bool? succeeded;
  dynamic errors;
  String ?message;

  factory AddDeviceResponse.fromJson(Map<String, dynamic> json) => AddDeviceResponse(
    data: json["data"]==null ? null :  Data.fromJson(json["data"]),
    succeeded:  json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null :  json["errors"],
    message:  json["message"]==null ? null : json["message"],
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
  String ?vendorName;
  int ?branchSrNo;
  String ?branchName;
  String ?deviceNo;
  String ?modelNo;
  String ?simNo1;
  String? simNo2;
  String ?deviceName;
  String ?imeino;
  String? portNo;
  String ?acUser;
  String ?acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo: json["srNo"]==null ? null : json["srNo"],
    vendorSrNo:  json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :  json["vendorName"],
    branchSrNo:  json["branchSrNo"]==null ? null : json["branchSrNo"],
    branchName:  json["branchName"]==null ? null : json["branchName"],
    deviceNo:  json["deviceNo"]==null ? null : json["deviceNo"],
    modelNo: json["modelNo"]==null ? null :  json["modelNo"],
    simNo1:  json["simNo1"]==null ? null : json["simNo1"],
    simNo2:  json["simNo2"]==null ? null : json["simNo2"],
    deviceName:  json["deviceName"]==null ? null : json["deviceName"],
    imeino: json["imeino"]==null ? null :  json["imeino"],
    portNo:  json["portNo"]==null ? null : json["portNo"],
    acUser:  json["acUser"]==null ? null : json["acUser"],
    acStatus:  json["acStatus"]==null ? null : json["acStatus"],
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
