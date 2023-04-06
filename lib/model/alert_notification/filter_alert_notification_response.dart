// To parse this JSON data, do
//
//     final filterAlertNotificationResponse = filterAlertNotificationResponseFromJson(jsonString);

import 'dart:convert';

FilterAlertNotificationResponse filterAlertNotificationResponseFromJson(String str) => FilterAlertNotificationResponse.fromJson(json.decode(str));

String filterAlertNotificationResponseToJson(FilterAlertNotificationResponse data) => json.encode(data.toJson());

class FilterAlertNotificationResponse {
  FilterAlertNotificationResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datum>? data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory FilterAlertNotificationResponse.fromJson(Map<String, dynamic> json) => FilterAlertNotificationResponse(
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors:json["errors"]==null ? null : json["errors"],
    message: json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
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
    this.vehicleSrNo,
    this.imei,
    this.vehicleRegNo,
    this.vehicleType,
    this.alertCode,
    this.alertIndication,
    this.acUser,
    this.acDate,
    this.displayStatus,
    this.araiNonarai,
  });

  int ?srNo;
  int ?vendorSrNo;
  String? vendorName;
  int ?branchSrNo;
  String? branchName;
  int ?vehicleSrNo;
  String? imei;
  String ?vehicleRegNo;
  String ?vehicleType;
  String ?alertCode;
  String ?alertIndication;
  String ?acUser;
  DateTime? acDate;
  String? displayStatus;
  String ?araiNonarai;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo:  json["srNo"]==null ? null :json["srNo"],
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo:json["branchSrNo"]==null ? null : json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    vehicleSrNo:json["vehicleSrNo"]==null ? null : json["vehicleSrNo"],
    imei: json["imei"]==null ? null :json["imei"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    vehicleType:json["vehicleType"]==null ? null : json["vehicleType"],
    alertCode: json["alertCode"]==null ? null :json["alertCode"],
    alertIndication:json["alertIndication"]==null ? null : json["alertIndication"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acDate: json["acDate"]==null ? null :DateTime.parse(json["acDate"]),
    displayStatus:json["displayStatus"]==null ? null : json["displayStatus"],
    araiNonarai:json["araiNonarai"]==null ? null : json["araiNonarai"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "vehicleSrNo": vehicleSrNo,
    "imei": imei,
    "vehicleRegNo": vehicleRegNo,
    "vehicleType": vehicleType,
    "alertCode": alertCode,
    "alertIndication": alertIndication,
    "acUser": acUser,
    "acDate": acDate!.toIso8601String(),
    "displayStatus": displayStatus,
    "araiNonarai": araiNonarai,
  };
}
