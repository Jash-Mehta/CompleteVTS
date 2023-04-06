// To parse this JSON data, do
//
//     final analyticReportStatusClickResponse = analyticReportStatusClickResponseFromJson(jsonString);


import 'dart:convert';


AnalyticReportStatusClickResponse analyticReportStatusClickResponseFromJson(String str) => AnalyticReportStatusClickResponse.fromJson(json.decode(str));

String analyticReportStatusClickResponseToJson(AnalyticReportStatusClickResponse data) => json.encode(data.toJson());

class AnalyticReportStatusClickResponse {
  AnalyticReportStatusClickResponse({
    this.gridViewResponse,
    this.countList,
    this.alerts,
  });

  GridViewResponse? gridViewResponse;
  List<CountList> ?countList;
  List<dynamic> ?alerts;

  factory AnalyticReportStatusClickResponse.fromJson(Map<String, dynamic> json) => AnalyticReportStatusClickResponse(
    gridViewResponse: GridViewResponse.fromJson(json["gridViewResponse"]),
    countList: List<CountList>.from(json["countList"].map((x) => CountList.fromJson(x))),
    alerts: List<dynamic>.from(json["alerts"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "gridViewResponse": gridViewResponse!.toJson(),
    "countList": List<dynamic>.from(countList!.map((x) => x.toJson())),
    "alerts": List<dynamic>.from(alerts!.map((x) => x)),
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
    tCount: json["tCount"],
    status: json["status"],
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

  int? pageNumber;
  int? pageSize;
  String ?firstPage;
  String? lastPage;
  int ?totalPages;
  int? totalRecords;
  dynamic ?nextPage;
  dynamic? previousPage;
  List<Datum> ?data;
  bool ?succeeded;
  dynamic ?errors;
  dynamic? message;

  factory GridViewResponse.fromJson(Map<String, dynamic> json) => GridViewResponse(
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
    this.srNo,
    this.vehicleSrNo,
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
    this.ac,
    this.door,
    this.driverName,
  });

  int ?srNo;
  String ?status;
  String ?vehicleNo;
  String ?vehicleSrNo;
  String ?imei;
  String ?ignition;
  String? mainPowerStatus;
  int ?gpsFix;
  String ?internalBatteryVoltage;
  String? speed;
  int ?speedLimit;
  String ?address;
  String ?date;
  String ?time;
  String? ac;
  String ?door;
  String ?driverName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["srNo"],
    status: json["status"],
    vehicleNo: json["vehicleNo"],
    vehicleSrNo: json["vehicleSrNo"],
    imei: json["imei"],
    ignition: json["ignition"],
    mainPowerStatus: json["mainPowerStatus"],
    gpsFix: json["gpsFix"],
    internalBatteryVoltage: json["internalBatteryVoltage"],
    speed: json["speed"],
    speedLimit: json["speedLimit"],
    address: json["address"],
    date: json["date"],
    time: json["time"],
    ac: json["ac"],
    door: json["door"],
    driverName: json["driverName"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "status": status,
    "vehicleNo": vehicleNo,
    "vehicleSrNo": vehicleSrNo,
    "imei": imei,
    "ignition": ignition,
    "mainPowerStatus": mainPowerStatus,
    "gpsFix": gpsFix,
    "internalBatteryVoltage": internalBatteryVoltage,
    "speed": speed,
    "speedLimit": speedLimit,
    "address": address,
    "date": date,
    "time": time,
    "ac": ac,
    "door": door,
    "driverName": driverName,
  };
}

// ---------------------------------------------------------------------

//------------------------------------------------------------------


