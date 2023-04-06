// To parse this JSON data, do
//
//     final dashbordResponse = dashbordResponseFromJson(jsonString);

import 'dart:convert';

DashbordResponse dashbordResponseFromJson(String str) => DashbordResponse.fromJson(json.decode(str));

String dashbordResponseToJson(DashbordResponse data) => json.encode(data.toJson());

class DashbordResponse {
  DashbordResponse({
    this.gridViewResponse,
    this.countList,
    this.totalCount,
    this.totalStatus,
    this.alerts,

  });

  GridViewResponse ?gridViewResponse;
  List<CountList> ?countList;
  int ?totalCount;
  String? totalStatus;
  List<Alert> ?alerts;

  factory DashbordResponse.fromJson(Map<String, dynamic> json) => DashbordResponse(
    gridViewResponse:  json["gridViewResponse"]==null ? null :GridViewResponse.fromJson(json["gridViewResponse"]),
    countList: json["countList"]==null ? null :List<CountList>.from(json["countList"].map((x) => CountList.fromJson(x))),
    alerts:json["alerts"]==null ? null : List<Alert>.from(json["alerts"].map((x) => Alert.fromJson(x))),
    totalCount:json["totalCount"]==null ? null : json["totalCount"],
    totalStatus:json["totalStatus"]==null ? null : json["totalStatus"],
  );

  Map<String, dynamic> toJson() => {
    "gridViewResponse": gridViewResponse!.toJson(),
    "countList": List<dynamic>.from(countList!.map((x) => x.toJson())),
    "alerts": List<dynamic>.from(alerts!.map((x) => x.toJson())),
    "totalCount": totalCount,
    "totalStatus": totalStatus,

  };
}

class Alert {
  Alert({
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
  int? branchSrNo;
  String? branchName;
  int ?vehicleSrNo;
  String ?imei;
  String? vehicleRegNo;
  String? vehicleType;
  String ?alertCode;
  String? alertIndication;
  String? acUser;
  DateTime? acDate;
  String ?displayStatus;
  String? araiNonarai;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    srNo:json["srNo"]==null ? null : json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName:json["vendorName"]==null ? null : json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    vehicleSrNo: json["vehicleSrNo"]==null ? null :json["vehicleSrNo"],
    imei:json["imei"]==null ? null : json["imei"],
    vehicleRegNo:json["vehicleRegNo"]==null ? null : json["vehicleRegNo"],
    vehicleType: json["vehicleType"]==null ? null :json["vehicleType"],
    alertCode:json["alertCode"]==null ? null : json["alertCode"],
    alertIndication: json["alertIndication"]==null ? null :json["alertIndication"],
    acUser:json["acUser"]==null ? null : json["acUser"],
    acDate: json["acDate"]==null ? null :DateTime.parse(json["acDate"]),
    displayStatus: json["displayStatus"]==null ? null :json["displayStatus"],
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


class CountList {
  CountList({
    this.tCount,
    this.status,
  });

  int? tCount;
  String ?status;

  factory CountList.fromJson(Map<String, dynamic> json) => CountList(
    tCount: json["tCount"]==null ? null :json["tCount"],
    status:json["status"]==null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "tCount": tCount,
    "status": status,
  };
}

class GridViewResponse {
  GridViewResponse({
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
  int? pageSize;
  String? firstPage;
  String ?lastPage;
  int ?totalPages;
  int? totalRecords;
  dynamic? nextPage;
  dynamic ?previousPage;
  List<Datum> ?data;
  bool ?succeeded;
  dynamic ?errors;
  dynamic message;

  factory GridViewResponse.fromJson(Map<String, dynamic> json) => GridViewResponse(
    pageNumber:json["pageNumber"]==null ? null : json["pageNumber"],
    pageSize: json["pageSize"]==null ? null :json["pageSize"],
    firstPage: json["firstPage"]==null ? null :json["firstPage"],
    lastPage: json["lastPage"]==null ? null :json["lastPage"],
    totalPages: json["totalPages"]==null ? null :json["totalPages"],
    totalRecords:json["totalRecords"]==null ? null : json["totalRecords"],
    nextPage:json["nextPage"]==null ? null : json["nextPage"],
    previousPage: json["previousPage"]==null ? null :json["previousPage"],
    data:json["data"]==null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors:json["errors"]==null ? null : json["errors"],
    message: json["message"]==null ? null :json["message"],
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
    this.srNo,
    this.status,
    this.vehicleNo,
    this.imei,
    this.ignition,
    this.mainPowerStatus,
    this.gpsFix,
    this.internalBatteryVoltage,
    this.speed,
    this.speedLimit,
    this.address,
    this.date,
    this.time,
  });

  int ?srNo;
  String? status;
  String? vehicleNo;
  String? imei;
  String? ignition;
  String? mainPowerStatus;
  int ?gpsFix;
  String? internalBatteryVoltage;
  String ?speed;
  int? speedLimit;
  String ?address;
  String ?date;
  String? time;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["srNo"]==null ? null :json["srNo"],
    status:json["status"]==null ? null : json["status"],
    vehicleNo: json["vehicleNo"]==null ? null :json["vehicleNo"],
    imei: json["imei"]==null ? null :json["imei"],
    ignition: json["ignition"]==null ? null :json["ignition"],
    mainPowerStatus:json["mainPowerStatus"]==null ? null : json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ? null : json["gpsFix"],
    internalBatteryVoltage:json["internalBatteryVoltage"]==null ? null : json["internalBatteryVoltage"],
    speed:json["speed"]==null ? null : json["speed"],
    speedLimit: json["speedLimit"]==null ? null :json["speedLimit"],
    address:json["address"]==null ? null : json["address"],
    date:json["date"]==null ? null : /*DateTime.parse(json["date"])*/json["date"],
    time: json["time"]==null ? null :/*DateTime.parse(json["time"])*/json["time"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "status": status,
    "vehicleNo": vehicleNo,
    "imei": imei,
    "ignition": ignition,
    "mainPowerStatus": mainPowerStatus,
    "gpsFix": gpsFix,
    "internalBatteryVoltage": internalBatteryVoltage,
    "speed": speed,
    "speedLimit": speedLimit,
    "address": address,
    "date": date/*!.toIso8601String()*/,
    "time": time/*!.toIso8601String()*/,
  };
}


//---------------------------------------------------



