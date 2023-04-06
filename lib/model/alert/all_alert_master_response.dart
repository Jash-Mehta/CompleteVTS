// To parse this JSON data, do
//
//     final allAlertMasterResponse = allAlertMasterResponseFromJson(jsonString);

import 'dart:convert';

AllAlertMasterResponse allAlertMasterResponseFromJson(String str) => AllAlertMasterResponse.fromJson(json.decode(str));

String allAlertMasterResponseToJson(AllAlertMasterResponse data) => json.encode(data.toJson());

class AllAlertMasterResponse {
  AllAlertMasterResponse({
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
  String ?lastPage;
  int? totalPages;
  int ?totalRecords;
  String ?nextPage;
  String? previousPage;
  List<Datum> ?data;
  bool ?succeeded;
  dynamic ?errors;
  dynamic? message;

  factory AllAlertMasterResponse.fromJson(Map<String, dynamic> json) => AllAlertMasterResponse(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    firstPage: json["firstPage"],
    lastPage: json["lastPage"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
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
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.alertGroupName,
    this.acUser,
    this.vehicleDetails,
    this.alertDetails,
  });

  int ?vendorSrNo;
  String ?vendorName;
  int? branchSrNo;
  String ?branchName;
  String ?alertGroupName;
  String ?acUser;
  List<VehicleDetail>? vehicleDetails;
  List<AlertDetail> ?alertDetails;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    alertGroupName: json["alertGroupName"],
    acUser: json["acUser"],
    vehicleDetails: List<VehicleDetail>.from(json["vehicleDetails"].map((x) => VehicleDetail.fromJson(x))),
    alertDetails: List<AlertDetail>.from(json["alertDetails"].map((x) => AlertDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "alertGroupName": alertGroupName,
    "acUser":acUser,
    "vehicleDetails": List<dynamic>.from(vehicleDetails!.map((x) => x.toJson())),
    "alertDetails": List<dynamic>.from(alertDetails!.map((x) => x.toJson())),
  };
}



class AlertDetail {
  AlertDetail({
    this.alertCode,
    this.alertIndication,
  });

  String ?alertCode;
  String ?alertIndication;

  factory AlertDetail.fromJson(Map<String, dynamic> json) => AlertDetail(
    alertCode:json["alertCode"],
    alertIndication: json["alertIndication"],
  );

  Map<String, dynamic> toJson() => {
    "alertCode": alertCode,
    "alertIndication": alertIndication,
  };
}


class VehicleDetail {
  VehicleDetail({
    this.vsrNo,
    this.vehicleRegNo,
  });

  int ?vsrNo;
  String ?vehicleRegNo;

  factory VehicleDetail.fromJson(Map<String, dynamic> json) => VehicleDetail(
    vsrNo: json["vsrNo"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vehicleRegNo": vehicleRegNo,
  };
}




