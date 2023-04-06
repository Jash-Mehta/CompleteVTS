import 'dart:convert';

List<VehicleFillResponse> vehicleFillResponseFromJson(String str) => List<VehicleFillResponse>.from(json.decode(str).map((x) => VehicleFillResponse.fromJson(x)));

String vehicleFillResponseToJson(List<VehicleFillResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleFillResponse {
  VehicleFillResponse({
    this.imeiNo,
    this.vehicleRegNo,
  });

  String? imeiNo;
  String ?vehicleRegNo;

  factory VehicleFillResponse.fromJson(Map<String, dynamic> json) => VehicleFillResponse(
    // imeiNo: json["srNo"],
    // vehicleRegNo: json["vehicleType"],
    imeiNo: json["imeiNo"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    // "imeiNo": srNo,
    // "vehicleRegNo": vehicleType,

    "imeiNo": imeiNo,
    "vehicleRegNo": vehicleRegNo,
  };
}

//------------------------------------------------------------

VehicleStatusResponse vehicleStatusResponseFromJson(String str) => VehicleStatusResponse.fromJson(json.decode(str));

String vehicleStatusResponseToJson(VehicleStatusResponse data) => json.encode(data.toJson());

class VehicleStatusResponse {
  VehicleStatusResponse({
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
  dynamic ?firstPage;
  dynamic ?lastPage;
  dynamic ?totalPages;
  dynamic? totalRecords;
  dynamic? nextPage;
  dynamic? previousPage;
  List<VehicleStatusDatum>? data;
  dynamic ?succeeded;
  dynamic ?errors;
  dynamic ?message;

  factory VehicleStatusResponse.fromJson(Map<String, dynamic> json) => VehicleStatusResponse(
    pageNumber:json["pageNumber"]==null ?  null : json["pageNumber"],
    pageSize: json["pageSize"]==null ?  null : json["pageSize"],
    firstPage: json["firstPage"]==null ?  null : json["firstPage"],
    lastPage: json["totalPages"]==null ?  null : json["totalPages"],
    totalPages:json["totalPages"]==null ?  null :  json["totalPages"],
    totalRecords:json["totalRecords"]==null ?  null :  json["totalRecords"],
    nextPage:json["nextPage"]==null ?  null :  json["nextPage"],
    previousPage: json["previousPage"]==null ?  null : json["previousPage"],
    data: json["data"]==null ?  null : List<VehicleStatusDatum>.from(json["data"].map((x) => VehicleStatusDatum.fromJson(x))),
    succeeded:json["succeeded"]==null ?  null :  json["succeeded"],
    errors: json["errors"]==null ?  null : json["errors"],
    message: json["message"]==null ?  null : json["message"],
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

class VehicleStatusDatum {
  VehicleStatusDatum({
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
  dynamic ?date;
  String ?time;
  String ?noOfSatelite;
  String ?address;
  String ?driverName;
  int ?speedLimit;
  String ?heading;
  String? ignition;
  String ?mainPowerStatus;
  String ?gpsFix;
  String ?internalBatteryVoltage;
  String ?ac;
  String ?door;

  factory VehicleStatusDatum.fromJson(Map<String, dynamic> json) => VehicleStatusDatum(
    transactionId: json["transactionId"]==null ?  null : json["transactionId"],
    vehicleRegNo: json["vehicleRegNo"]==null ?  null : json["vehicleRegNo"],
    vehicleStatus: json["vehicleStatus"]==null ?  null : json["vehicleStatus"],
    imei: json["imei"]==null ?  null : json["imei"],
    lat: json["lat"]==null ?  null : json["lat"],
    lng: json["lng"]==null ?  null : json["lng"],
    speed: json["speed"]==null ?  null : json["speed"],
    distancetravel:json["distancetravel"]==null ?  null :  json["distancetravel"],
    date: json["date"]==null ?  null : json["date"],
    time: json["time"]==null ?  null : json["time"],
    noOfSatelite:json["noOfSatelite"]==null ?  null :  json["noOfSatelite"],
    address:json["address"]==null ?  null :  json["address"],
    driverName: json["driverName"]==null ?  null : json["driverName"],
    speedLimit: json["speedLimit"]==null ?  null : json["speedLimit"],
    heading:json["heading"]==null ?  null :  json["heading"],

    ignition: json["ignition"]==null ?  null : json["ignition"],
    mainPowerStatus:json["mainPowerStatus"]==null ?  null :  json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ?  null :  json["gpsFix"],
    internalBatteryVoltage: json["internalBatteryVoltage"]==null ?  null : json["internalBatteryVoltage"],
    ac: json["ac"]==null ?  null : json["ac"],
    door:json["door"]==null ?  null :  json["door"],
  );

  Map<String, dynamic> toJson() => {
    "transactionId": transactionId,
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

