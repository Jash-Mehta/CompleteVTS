
import 'dart:convert';

SearchAnalyticReportStatusClickResponse searchanalyticReportStatusClickResponseFromJson(String str) => SearchAnalyticReportStatusClickResponse.fromJson(json.decode(str));

String searchanalyticReportStatusClickResponseToJson(SearchAnalyticReportStatusClickResponse data) => json.encode(data.toJson());

class SearchAnalyticReportStatusClickResponse {
  SearchAnalyticReportStatusClickResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<AnalytivReportDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory SearchAnalyticReportStatusClickResponse.fromJson(Map<String, dynamic> json) => SearchAnalyticReportStatusClickResponse(
    data: json["data"]==null ? null :List<AnalytivReportDatum>.from(json["data"].map((x) => AnalytivReportDatum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors:json["errors"]==null ? null : json["errors"],
    message:json["message"]==null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class AnalytivReportDatum {
  AnalytivReportDatum({
    this.srNo,
    this.status,
    this.vehicleNo,
    this.vehicleSrNo,
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

  int? srNo;
  String ?status;
  String ?vehicleNo;
  String ?vehicleSrNo;
  String ?imei;
  String? ignition;
  String? mainPowerStatus;
  int ?gpsFix;
  String ?internalBatteryVoltage;
  String ?speed;
  int ?speedLimit;
  String ?address;
  dynamic? date;
  dynamic ?time;
  String ?ac;
  String ?door;
  String ?driverName;

  factory AnalytivReportDatum.fromJson(Map<String, dynamic> json) => AnalytivReportDatum(
    srNo: json["srNo"]==null ? null :json["srNo"],
    status: json["status"]==null ? null :json["status"],
    vehicleNo:json["vehicleNo"]==null ? null : json["vehicleNo"],
    vehicleSrNo:json["vehicleSrNo"]==null ? null : json["vehicleSrNo"],
    imei: json["imei"]==null ? null :json["imei"],
    ignition:json["ignition"]==null ? null : json["ignition"],
    mainPowerStatus:json["mainPowerStatus"]==null ? null : json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ? null : json["gpsFix"],
    internalBatteryVoltage: json["internalBatteryVoltage"]==null ? null :json["internalBatteryVoltage"],
    speed: json["speed"]==null ? null :json["speed"],
    speedLimit: json["speedLimit"]==null ? null :json["speedLimit"],
    address:json["address"]==null ? null : json["address"],
    date: json["date"]==null ? null :json["date"],
    time:json["time"]==null ? null : json["time"],
    ac: json["ac"]==null ? null :json["ac"],
    door: json["door"]==null ? null :json["door"],
    driverName: json["driverName"]==null ? null :json["driverName"],
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