// To parse this JSON data, do
//
//     final alertNotificationResponse = alertNotificationResponseFromJson(jsonString);

import 'dart:convert';

AlertNotificationResponse alertNotificationResponseFromJson(String str) => AlertNotificationResponse.fromJson(json.decode(str));

String alertNotificationResponseToJson(AlertNotificationResponse data) => json.encode(data.toJson());

class AlertNotificationResponse {
  AlertNotificationResponse({
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
  String ?firstPage;
  String? lastPage;
  int? totalPages;
  int ?totalRecords;
  dynamic ?nextPage;
  dynamic ?previousPage;
  List<AlertNotificationDatum>? data;
  bool ?succeeded;
  dynamic ?errors;
  dynamic message;

  factory AlertNotificationResponse.fromJson(Map<String, dynamic> json) => AlertNotificationResponse(
    pageNumber:  json["pageNumber"]==null ? null :json["pageNumber"],
    pageSize:  json["pageSize"]==null ? null :json["pageSize"],
    firstPage: json["firstPage"]==null ? null : json["firstPage"],
    lastPage:  json["lastPage"]==null ? null :json["lastPage"],
    totalPages:  json["totalPages"]==null ? null :json["totalPages"],
    totalRecords:  json["totalRecords"]==null ? null :json["totalRecords"],
    nextPage: json["nextPage"]==null ? null : json["nextPage"],
    previousPage: json["previousPage"]==null ? null : json["previousPage"],
    data: json["data"]==null ? null : List<AlertNotificationDatum>.from(json["data"].map((x) => AlertNotificationDatum.fromJson(x))),
    succeeded:  json["succeeded"]==null ? null :json["succeeded"],
    errors:  json["errors"]==null ? null :json["errors"],
    message:  json["message"]==null ? null :json["message"],
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

class AlertNotificationDatum {
  AlertNotificationDatum({
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
  String ?vendorName;
  int ?branchSrNo;
  String? branchName;
  int ?vehicleSrNo;
  String ?imei;
  String ?vehicleRegNo;
  String? vehicleType;
  String ?alertCode;
  String ?alertIndication;
  String ?acUser;
  DateTime? acDate;
  String ?displayStatus;
  String ?araiNonarai;

  factory AlertNotificationDatum.fromJson(Map<String, dynamic> json) => AlertNotificationDatum(
    srNo:  json["srNo"]==null ? null :json["srNo"],
    vendorSrNo:  json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null : json["branchSrNo"],
    branchName: json["branchName"]==null ? null : json["branchName"],
    vehicleSrNo: json["vehicleSrNo"]==null ? null : json["vehicleSrNo"],
    imei:  json["imei"]==null ? null :json["imei"],
    vehicleRegNo:  json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    vehicleType: json["vehicleType"]==null ? null : json["vehicleType"],
    alertCode:  json["alertCode"]==null ? null :json["alertCode"],
    alertIndication:  json["alertIndication"]==null ? null :json["alertIndication"],
    acUser:  json["acUser"]==null ? null :json["acUser"],
    acDate:  json["acDate"]==null ? null :DateTime.parse(json["acDate"]),
    displayStatus:  json["displayStatus"]==null ? null :json["displayStatus"],
    araiNonarai:  json["araiNonarai"]==null ? null :json["araiNonarai"],
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