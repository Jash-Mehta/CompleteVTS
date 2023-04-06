import 'dart:convert';

AnalyticReportDetailsResponse analyticReportDetailsResponseFromJson(String str) => AnalyticReportDetailsResponse.fromJson(json.decode(str));

String analyticReportDetailsResponseToJson(AnalyticReportDetailsResponse data) => json.encode(data.toJson());

class AnalyticReportDetailsResponse {
  AnalyticReportDetailsResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<AnalyticREportDetailDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory AnalyticReportDetailsResponse.fromJson(Map<String, dynamic> json) => AnalyticReportDetailsResponse(
    data:json["data"]==null ? null : List<AnalyticREportDetailDatum>.from(json["data"].map((x) => AnalyticREportDetailDatum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message:json["message"]==null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class AnalyticREportDetailDatum {
  AnalyticREportDetailDatum({
    this.srNo,
    this.status,
    this.vehicleNo,
    this.imei,
    this.ignition,
    this.latitude,
    this.longitude,
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
    this.travelDistance,

  });

  int?srNo;
  String ?status;
  String ?vehicleNo;
  String ?imei;
  String ?ignition;
  String ?latitude;
  String ?longitude;
  String? mainPowerStatus;
  int ?gpsFix;
  String? internalBatteryVoltage;
  String ?speed;
  int ?speedLimit;
  String ?address;
  dynamic ?date;
  dynamic ?time;
  String ?ac;
  String ?door;
  String? driverName;
  String? travelDistance;

  factory AnalyticREportDetailDatum.fromJson(Map<String, dynamic> json) => AnalyticREportDetailDatum(
    srNo: json["srNo"]==null ? null :json["srNo"],
    status:json["status"]==null ? null : json["status"],
    vehicleNo:json["vehicleNo"]==null ? null : json["vehicleNo"],
    imei:json["imei"]==null ? null : json["imei"],
    ignition: json["ignition"]==null ? null :json["ignition"],
    latitude:json["latitude"]==null ? null : json["latitude"],
    longitude: json["longitude"]==null ? null :json["longitude"],
    mainPowerStatus: json["mainPowerStatus"]==null ? null :json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ? null : json["gpsFix"],
    internalBatteryVoltage:json["internalBatteryVoltage"]==null ? null : json["internalBatteryVoltage"],
    speed:json["speed"]==null ? null : json["speed"],
    speedLimit: json["speedLimit"]==null ? null :json["speedLimit"],
    address: json["address"]==null ? null :json["address"],
    date: json["date"]==null ? null :json["date"],
    time: json["time"]==null ? null :json["time"],
    ac: json["door"]==null ? null :json["ac"],
    door: json["door"]==null ? null :json["door"],
    driverName:json["driverName"]==null ? null : json["driverName"],
    travelDistance:json["travelDistance"]==null ? null : json["travelDistance"],

  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "status": status,
    "vehicleNo": vehicleNo,
    "imei": imei,
    "ignition": ignition,
    "latitude": latitude,
    "longitude": longitude,
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
    "travelDistance": travelDistance,

  };
}
