// To parse this JSON data, do
//
//     final addDriverRequest = addDriverRequestFromJson(jsonString);

import 'dart:convert';

AddDriverRequest addDriverRequestFromJson(String str) => AddDriverRequest.fromJson(json.decode(str));

String addDriverRequestToJson(AddDriverRequest data) => json.encode(data.toJson());

class AddDriverRequest {
  AddDriverRequest({
    this.srNo,
    this.vendorSrNo,
    this.branchSrNo,
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
  int ?branchSrNo;
  String ?driverCode;
  String? driverName;
  String ?licenceNo;
  String ?city;
  String ?mobileNo;
  String ?doj;
  String ?driverAddress;
  String ?acUser;
  String ?acStatus;

  factory AddDriverRequest.fromJson(Map<String, dynamic> json) => AddDriverRequest(
    srNo:json["srNo"]==null ? null : json["srNo"],
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    branchSrNo:json["branchSrNo"]==null ? null : json["branchSrNo"],
    driverCode: json["driverCode"]==null ? null :json["driverCode"],
    driverName:json["driverName"]==null ? null : json["driverName"],
    licenceNo:json["licenceNo"]==null ? null : json["licenceNo"],
    city: json["city"]==null ? null :json["city"],
    mobileNo: json["mobileNo"]==null ? null :json["mobileNo"],
    doj:json["doj"]==null ? null : json["doj"],
    driverAddress: json["driverAddress"]==null ? null :json["driverAddress"],
    acUser:json["acUser"]==null ? null : json["acUser"],
    acStatus: json["acStatus"]==null ? null :json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "driverCode": driverCode,
    "driverName": driverName,
    "licenceNo": licenceNo,
    "city": city,
    "mobileNo": mobileNo,
    "doj": doj,
    "driverAddress": driverAddress,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}


