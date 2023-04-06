// To parse this JSON data, do
//
//     final searchAlertMasterResponse = searchAlertMasterResponseFromJson(jsonString);

import 'dart:convert';

SearchAlertMasterResponse searchAlertMasterResponseFromJson(String str) => SearchAlertMasterResponse.fromJson(json.decode(str));

String searchAlertMasterResponseToJson(SearchAlertMasterResponse data) => json.encode(data.toJson());

class SearchAlertMasterResponse {
  SearchAlertMasterResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory SearchAlertMasterResponse.fromJson(Map<String, dynamic> json) => SearchAlertMasterResponse(
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
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.alertGroupName,
    this.acUser,
    this.vehicleDetails,
    this.alertDetails,
  });

  int? vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String ?branchName;
  String ?alertGroupName;
  String ?acUser;
  List<VehicleDetail>? vehicleDetails;
  List<AlertDetail> ?alertDetails;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
    "acUser": acUser,
    "vehicleDetails": List<dynamic>.from(vehicleDetails!.map((x) => x.toJson())),
    "alertDetails": List<dynamic>.from(alertDetails!.map((x) => x.toJson())),
  };
}

class AlertDetail {
  AlertDetail({
    this.alertCode,
    this.alertIndication,
  });

  String? alertCode;
  String ?alertIndication;

  factory AlertDetail.fromJson(Map<String, dynamic> json) => AlertDetail(
    alertCode: json["alertCode"],
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
  String? vehicleRegNo;

  factory VehicleDetail.fromJson(Map<String, dynamic> json) => VehicleDetail(
    vsrNo: json["vsrNo"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vehicleRegNo": vehicleRegNo,
  };
}
