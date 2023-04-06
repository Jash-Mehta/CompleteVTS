// To parse this JSON data, do
//
//     final addDeviceRequest = addDeviceRequestFromJson(jsonString);

import 'dart:convert';

AddDeviceRequest addDeviceRequestFromJson(String str) => AddDeviceRequest.fromJson(json.decode(str));

String addDeviceRequestToJson(AddDeviceRequest data) => json.encode(data.toJson());

class AddDeviceRequest {
  AddDeviceRequest({
    this.srNo,
    this.vendorSrNo,
    this.branchSrNo,
    this.deviceNo,
    this.modelNo,
    this.simNo1,
    this.simNo2,
    this.deviceName,
    this.imeino,
    this.portNo,
    this.acStatus,
    this.acUser,
  });

  int? srNo;
  int ?vendorSrNo;
  int ?branchSrNo;
  String ?deviceNo;
  String? modelNo;
  String? simNo1;
  String ?simNo2;
  String? deviceName;
  String ?imeino;
  String? portNo;
  String? acStatus;
  String ?acUser;

  factory AddDeviceRequest.fromJson(Map<String, dynamic> json) => AddDeviceRequest(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    branchSrNo: json["branchSrNo"],
    deviceNo: json["deviceNo"],
    modelNo: json["modelNo"],
    simNo1: json["simNo1"],
    simNo2: json["simNo2"],
    deviceName: json["deviceName"],
    imeino: json["imeino"],
    portNo: json["portNo"],
    acStatus: json["acStatus"],
    acUser: json["acUser"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "deviceNo": deviceNo,
    "modelNo": modelNo,
    "simNo1": simNo1,
    "simNo2": simNo2,
    "deviceName": deviceName,
    "imeino": imeino,
    "portNo": portNo,
    "acStatus": acStatus,
    "acUser": acUser,
  };
}
