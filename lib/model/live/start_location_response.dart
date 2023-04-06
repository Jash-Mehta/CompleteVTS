import 'dart:convert';

List<StartLocationResponse> startLocationResponseFromJson(String str) => List<StartLocationResponse>.from(json.decode(str).map((x) => StartLocationResponse.fromJson(x)));

String startLocationResponseToJson(List<StartLocationResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class StartLocationResponse {
  StartLocationResponse({
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
    this.gpsFix,
  });

  int? transactionId;
  String? vehicleRegNo;
  String ?speed;
  String ?latitude;
  String ?longitude;
  String ?driverName;
  int? speedLimit;
  String ?ignition;
  String ?distancetravel;
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
  String ?gpsFix;

  factory StartLocationResponse.fromJson(Map<String, dynamic> json) => StartLocationResponse(
    transactionId: json["transactionId"]==null ? null : json["transactionId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :  json["vehicleRegNo"],
    speed:  json["speed"]==null ? null : json["speed"],
    latitude:  json["latitude"]==null ? null : json["latitude"],
    longitude: json["longitude"]==null ? null :  json["longitude"],
    driverName:  json["driverName"]==null ? null : json["driverName"],
    speedLimit: json["speedLimit"]==null ? null :  json["speedLimit"],
    ignition:  json["ignition"]==null ? null : json["ignition"],
    distancetravel: json["distancetravel"]==null ? null :  json["distancetravel"],
    noOfSatelite:  json["noOfSatelite"]==null ? null : json["noOfSatelite"],
    address: json["address"]==null ? null :  json["address"],
    alertIndication: json["alertIndication"]==null ? null :  json["alertIndication"],
    vehicleType: json["vehicleType"]==null ? null :  json["vehicleType"],
    date:  json["date"]==null ? null : json["date"],
    time:  json["time"]==null ? null : json["time"],
    previousTime: json["previousTime"]==null ? null :  json["previousTime"],
    vehicleStatus:  json["vehicleStatus"]==null ? null : json["vehicleStatus"],
    heading:  json["heading"]==null ? null : json["heading"],
    imei: json["imei"]==null ? null :  json["imei"],
    gpsFix: json["gpsFix"]==null ? null :  json["gpsFix"],
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
    "gpsFix": gpsFix,
  };
}