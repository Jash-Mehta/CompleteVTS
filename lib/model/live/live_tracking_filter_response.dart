// To parse this JSON data, do
//
//     final liveTrackingFilterResponse = liveTrackingFilterResponseFromJson(jsonString);
import 'dart:convert';


LiveTrackingFilterResponse liveTrackingFilterResponseFromJson(String str) => LiveTrackingFilterResponse.fromJson(json.decode(str));

String liveTrackingFilterResponseToJson(LiveTrackingFilterResponse data) => json.encode(data.toJson());

class LiveTrackingFilterResponse {
  LiveTrackingFilterResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory LiveTrackingFilterResponse.fromJson(Map<String, dynamic> json) => LiveTrackingFilterResponse(
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
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
    this.transactionId,
    this.vehicleRegNo,
    this.speed,
    this.latitude,
    this.longitude,
    this.driverName,
    this.speedLimit,
    this.ignition,
    this.distancetravel,
    this.noOfSatelite,
    this.address,
    this.alertIndication,
    this.vehicleType,
    this.date,
    this.time,
    this.previousTime,
    this.vehicleStatus,
    this.heading,
    this.imei,
    this.mainPowerStatus,
    this.gpsFix,
    this.internalBatteryVoltage,
    this.ac,
    this.door,
    this.odometer,
  });

  dynamic? transactionId;
  String? vehicleRegNo;
  String ?speed;
  String ?latitude;
  String ?longitude;
  String ?driverName;
  dynamic ?speedLimit;
  String? ignition;
  String? distancetravel;
  String ?noOfSatelite;
  String ?address;
  String ?alertIndication;
  String ?vehicleType;
  String ?date;
  String ?time;
  String ?previousTime;
  String ?vehicleStatus;
  String ?heading;
  String ?imei;
  String ?mainPowerStatus;
  String ?gpsFix;
  String ?internalBatteryVoltage;
  String ?ac;
  String ?door;
  dynamic ?odometer;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    transactionId: json["transactionId"]==null ? null :json["transactionId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    speed: json["speed"]==null ? null :json["speed"],
    latitude: json["latitude"]==null ? null :json["latitude"],
    longitude:json["longitude"]==null ? null : json["longitude"],
    driverName:json["driverName"]==null ? null : json["driverName"],
    speedLimit:json["speedLimit"]==null ? null : json["speedLimit"],
    ignition: json["ignition"]==null ? null :json["ignition"],
    distancetravel: json["distancetravel"]==null ? null :json["distancetravel"],
    noOfSatelite:json["noOfSatelite"]==null ? null : json["noOfSatelite"],
    address:json["address"]==null ? null : json["address"],
    alertIndication: json["alertIndication"]==null ? null :json["alertIndication"],
    vehicleType: json["vehicleType"]==null ? null :json["vehicleType"],
    date: json["date"]==null ? null :json["date"],
    time: json["time"]==null ? null :json["time"],
    previousTime:json["previousTime"]==null ? null : json["previousTime"],
    vehicleStatus: json["vehicleStatus"]==null ? null :json["vehicleStatus"],
    heading:json["heading"]==null ? null : json["heading"],
    imei:json["imei"]==null ? null : json["imei"],
    mainPowerStatus: json["mainPowerStatus"]==null ? null :json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ? null : json["gpsFix"],
    internalBatteryVoltage:json["internalBatteryVoltage"]==null ? null : json["internalBatteryVoltage"],
    ac:json["ac"]==null ? null : json["ac"],
    door: json["door"]==null ? null :json["door"],
    odometer:json["odometer"]==null ? null : json["odometer"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
    "vehicleRegNo": vehicleRegNo,
    "speed": speed,
    "latitude": latitude,
    "longitude": longitude,
    "driverName": driverName,
    "speedLimit": speedLimit,
    "ignition": ignition,
    "distancetravel": distancetravel,
    "noOfSatelite": noOfSatelite,
    "address": address,
    "alertIndication": alertIndication,
    "vehicleType": vehicleType,
    "date": date,
    "time": time,
    "previousTime": previousTime,
    "vehicleStatus": vehicleStatus,
    "heading": heading,
    "imei": imei,
    "mainPowerStatus": mainPowerStatus,
    "gpsFix": gpsFix,
    "internalBatteryVoltage": internalBatteryVoltage,
    "ac": ac,
    "door": door,
    "odometer": odometer,
  };
}
