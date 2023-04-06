
// To parse this JSON data, do
//
//     final vehicleHistoryFilterResponse = vehicleHistoryFilterResponseFromJson(jsonString);

import 'dart:convert';

VehicleHistoryFilterResponse vehicleHistoryFilterResponseFromJson(String str) => VehicleHistoryFilterResponse.fromJson(json.decode(str));

String vehicleHistoryFilterResponseToJson(VehicleHistoryFilterResponse data) => json.encode(data.toJson());

class VehicleHistoryFilterResponse {
  VehicleHistoryFilterResponse({
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

  dynamic ?pageNumber;
  dynamic ?pageSize;
  String ?firstPage;
  String ?lastPage;
  dynamic ?totalPages;
  dynamic ?totalRecords;
  dynamic? nextPage;
  dynamic? previousPage;
  List<VehicleHistoryFilterDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  dynamic ?message;

  factory VehicleHistoryFilterResponse.fromJson(Map<String, dynamic> json) => VehicleHistoryFilterResponse(
    pageNumber: json["pageNumber"]==null ? null :json["pageNumber"],
    pageSize:json["pageSize"]==null ? null : json["pageSize"],
    firstPage: json["firstPage"]==null ? null :json["firstPage"],
    lastPage:json["lastPage"]==null ? null : json["lastPage"],
    totalPages:json["totalPages"]==null ? null : json["totalPages"],
    totalRecords: json["totalRecords"]==null ? null :json["totalRecords"],
    nextPage: json["nextPage"]==null ? null :json["nextPage"],
    previousPage: json["previousPage"]==null ? null :json["previousPage"],
    data: json["data"]==null ? null :List<VehicleHistoryFilterDatum>.from(json["data"].map((x) => VehicleHistoryFilterDatum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
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

class VehicleHistoryFilterDatum {
  VehicleHistoryFilterDatum({
    this.transactionId,
    this.vehicleRegNo,
    this.vehicleStatus,
    this.imei,
    this.lat,
    this.lng,
    this.speed,
    this.distancetravel,
    this.date,
    this.time,
    this.noOfSatelite,
    this.address,
    this.driverName,
    this.speedLimit,
    this.heading,
    this.ignition,
    this.mainPowerStatus,
    this.gpsFix,
    this.internalBatteryVoltage,
    this.ac,
    this.door,
  });

  dynamic? transactionId;
  String? vehicleRegNo;
  String? vehicleStatus;
  String ?imei;
  String ?lat;
  String ?lng;
  String ?speed;
  String ?distancetravel;
  String ?date;
  String ?time;
  String ?noOfSatelite;
  String ?address;
  String ?driverName;
  dynamic ?speedLimit;
  String? heading;
  String ?ignition;
  String ?mainPowerStatus;
  String ?gpsFix;
  String ?internalBatteryVoltage;
  String ?ac;
  String ?door;

  factory VehicleHistoryFilterDatum.fromJson(Map<String, dynamic> json) => VehicleHistoryFilterDatum(
    transactionId: json["transactionId"]==null ? null : json["transactionId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    vehicleStatus:json["vehicleStatus"]==null ? null : json["vehicleStatus"],
    imei: json["imei"]==null ? null :json["imei"],
    lat: json["lat"]==null ? null :json["lat"],
    lng: json["lng"]==null ? null :json["lng"],
    speed:json["speed"]==null ? null : json["speed"],
    distancetravel: json["distancetravel"]==null ? null :json["distancetravel"],
    date: json["date"]==null ? null :json["date"],
    time: json["time"]==null ? null :json["time"],
    noOfSatelite:json["noOfSatelite"]==null ? null : json["noOfSatelite"],
    address: json["address"]==null ? null :json["address"],
    driverName: json["driverName"]==null ? null :json["driverName"],
    speedLimit:json["speedLimit"]==null ? null : json["speedLimit"],
    heading:json["heading"]==null ? null : json["heading"],
    ignition: json["ignition"]==null ? null :json["ignition"],
    mainPowerStatus:json["mainPowerStatus"]==null ? null : json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ? null : json["gpsFix"],
    internalBatteryVoltage: json["internalBatteryVoltage"]==null ? null :json["internalBatteryVoltage"],
    ac:json["ac"]==null ? null : json["ac"],
    door:json["door"]==null ? null : json["door"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleRegNo": vehicleRegNo,
    "vehicleStatus": vehicleStatus,
    "imei": imei,
    "lat": lat,
    "lng": lng,
    "speed": speed,
    "distancetravel": distancetravel,
    "date": date,
    "time": time,
    "noOfSatelite": noOfSatelite,
    "address": address,
    "driverName": driverName,
    "speedLimit": speedLimit,
    "heading": heading,
    "ignition": ignition,
    "mainPowerStatus": mainPowerStatus,
    "gpsFix": gpsFix,
    "internalBatteryVoltage": internalBatteryVoltage,
    "ac": ac,
    "door": door,
  };
}


//----------------------------------------------------------------------

// To parse this JSON data, do
//
//     final vehicleHistoryByIdDetailResponse = vehicleHistoryByIdDetailResponseFromJson(jsonString);


List<VehicleHistoryByIdDetailResponse> vehicleHistoryByIdDetailResponseFromJson(String str) => List<VehicleHistoryByIdDetailResponse>.from(json.decode(str).map((x) => VehicleHistoryByIdDetailResponse.fromJson(x)));

String vehicleHistoryByIdDetailResponseToJson(List<VehicleHistoryByIdDetailResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleHistoryByIdDetailResponse {
  VehicleHistoryByIdDetailResponse({
    this.vehicleRegNo,
    this.vehicleStatus,
    this.imei,
    this.lat,
    this.lng,
    this.speed,
    this.distancetravel,
    this.date,
    this.time,
    this.noOfSatelite,
    this.address,
    this.driverName,
    this.speedLimit,
    this.heading,
    this.ignition,
    this.mainPowerStatus,
    this.gpsFix,
    this.internalBatteryVoltage,
    this.ac,
    this.door,
    this.licenseExpireDate,
    this.mobileNumber,
    this.currentOdometer,
    this.alertIndication,
    this.parking,
    this.runningDuration,
    this.runningDistance,
    this.alerts,
  });

  String ?vehicleRegNo;
  String ?vehicleStatus;
  String ?imei;
  String ?lat;
  String ?lng;
  String ?speed;
  String ?distancetravel;
  String ?date;
  String ?time;
  String? noOfSatelite;
  String ?address;
  String ?driverName;
  dynamic? speedLimit;
  String ?heading;
  String ?ignition;
  String ?mainPowerStatus;
  String ?gpsFix;
  String? internalBatteryVoltage;
  String? ac;
  String? door;
  String ?licenseExpireDate;
  String? mobileNumber;
  dynamic ?currentOdometer;
  dynamic ?alertIndication;
  Parking ?parking;
  Parking? runningDuration;
  RunningDistance ?runningDistance;
  List<Alert> ?alerts;

  factory VehicleHistoryByIdDetailResponse.fromJson(Map<String, dynamic> json) => VehicleHistoryByIdDetailResponse(
    vehicleRegNo: json["vehicleRegNo"],
    vehicleStatus: json["vehicleStatus"],
    imei: json["imei"],
    lat: json["lat"],
    lng: json["lng"],
    speed: json["speed"],
    distancetravel: json["distancetravel"],
    date: json["date"],
    time: json["time"],
    noOfSatelite: json["noOfSatelite"],
    address: json["address"],
    driverName: json["driverName"],
    speedLimit: json["speedLimit"],
    heading: json["heading"],
    ignition: json["ignition"],
    mainPowerStatus: json["mainPowerStatus"],
    gpsFix: json["gpsFix"],
    internalBatteryVoltage: json["internalBatteryVoltage"],
    ac: json["ac"],
    door: json["door"],
    licenseExpireDate: json["licenseExpireDate"],
    mobileNumber: json["mobileNumber"],
    currentOdometer: json["currentOdometer"],
    alertIndication: json["alertIndication"],
    parking: Parking.fromJson(json["parking"]),
    runningDuration: Parking.fromJson(json["runningDuration"]),
    runningDistance: RunningDistance.fromJson(json["runningDistance"]),
    alerts: List<Alert>.from(json["alerts"].map((x) => Alert.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vehicleRegNo": vehicleRegNo,
    "vehicleStatus": vehicleStatus,
    "imei": imei,
    "lat": lat,
    "lng": lng,
    "speed": speed,
    "distancetravel": distancetravel,
    "date": date,
    "time": time,
    "noOfSatelite": noOfSatelite,
    "address": address,
    "driverName": driverName,
    "speedLimit": speedLimit,
    "heading": heading,
    "ignition": ignition,
    "mainPowerStatus": mainPowerStatus,
    "gpsFix": gpsFix,
    "internalBatteryVoltage": internalBatteryVoltage,
    "ac": ac,
    "door": door,
    "licenseExpireDate": licenseExpireDate,
    "mobileNumber": mobileNumber,
    "currentOdometer": currentOdometer,
    "alertIndication": alertIndication,
    "parking": parking!.toJson(),
    "runningDuration": runningDuration!.toJson(),
    "runningDistance": runningDistance!.toJson(),
    "alerts": List<dynamic>.from(alerts!.map((x) => x.toJson())),
  };
}

class Alert {
  Alert({
    this.alertTitle,
    this.alertMesaage,
  });

  String ?alertTitle;
  dynamic alertMesaage;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    alertTitle: json["alertTitle"],
    alertMesaage: json["alertMesaage"],
  );

  Map<String, dynamic> toJson() => {
    "alertTitle": alertTitle,
    "alertMesaage": alertMesaage,
  };
}

class Parking {
  Parking({
    this.atLastStop,
    this.total,
  });

  String? atLastStop;
  String ?total;

  factory Parking.fromJson(Map<String, dynamic> json) => Parking(
    atLastStop: json["atLastStop"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "atLastStop": atLastStop,
    "total": total,
  };
}

class RunningDistance {
  RunningDistance({
    this.fromLastStop,
    this.total,
  });

  String ?fromLastStop;
  String? total;

  factory RunningDistance.fromJson(Map<String, dynamic> json) => RunningDistance(
    fromLastStop: json["fromLastStop"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "fromLastStop": fromLastStop,
    "total": total,
  };
}

