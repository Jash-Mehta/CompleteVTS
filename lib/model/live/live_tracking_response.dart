import 'dart:convert';

LiveTrackingResponse liveTrackingResponseFromJson(String str) => LiveTrackingResponse.fromJson(json.decode(str));

String liveTrackingResponseToJson(LiveTrackingResponse data) => json.encode(data.toJson());

class LiveTrackingResponse {
  LiveTrackingResponse({
    this.liveTrackingDetails,
    this.liveStatusCountList,
    this.status,
    this.message
  });

  List<LiveTrackingDetail>? liveTrackingDetails;
  List<LiveStatusCountList>? liveStatusCountList;
  bool? status;
  String? message;


  factory LiveTrackingResponse.fromJson(Map<String, dynamic> json) => LiveTrackingResponse(
    liveTrackingDetails: json["liveTrackingDetails"]==null ? null :List<LiveTrackingDetail>.from(json["liveTrackingDetails"].map((x) => LiveTrackingDetail.fromJson(x))),
    liveStatusCountList: json["liveStatusCountList"]==null ? null :List<LiveStatusCountList>.from(json["liveStatusCountList"].map((x) => LiveStatusCountList.fromJson(x))),
    status: json["succeeded"]==null ? null :json["succeeded"],
    message: json["message"]==null ? null :json["message"],

  );

  Map<String, dynamic> toJson() => {
    "liveTrackingDetails": List<dynamic>.from(liveTrackingDetails!.map((x) => x.toJson())),
    "liveStatusCountList": List<dynamic>.from(liveStatusCountList!.map((x) => x.toJson())),
    "succeeded": status,
    "message": message,

  };
}

class LiveStatusCountList {
  LiveStatusCountList({
    this.tCount,
    this.status,
  });

  dynamic? tCount;
  String? status;

  factory LiveStatusCountList.fromJson(Map<String, dynamic> json) => LiveStatusCountList(
    tCount: json["TCount"]==null ? null :json["TCount"],
    status: json["Status"]==null ? null : json["Status"],
  );

  Map<String, dynamic> toJson() => {
    "TCount": tCount,
    "Status": status,
  };
}

class LiveTrackingDetail {
  LiveTrackingDetail({
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

  dynamic ?transactionId;
  String? vehicleRegNo;
  String? speed;
  String ?latitude;
  String ?longitude;
  String ?driverName;
  dynamic ?speedLimit;
  String ?ignition;
  String? distancetravel;
  String ?noOfSatelite;
  String ?address;
  String ?alertIndication;
  String ?vehicleType;
  String? date;
  String? time;
  String ?previousTime;
  String? vehicleStatus;
  String? heading;
  String ?imei;
  String ?mainPowerStatus;
  String ?gpsFix;
  String ?internalBatteryVoltage;
  String? ac;
  String ?door;
  dynamic? odometer;

  factory LiveTrackingDetail.fromJson(Map<String, dynamic> json) => LiveTrackingDetail(
    transactionId: json["TransactionId"]==null ? null : json["TransactionId"],
    vehicleRegNo: json["VehicleRegNo"]==null ? null : json["VehicleRegNo"],
    speed:  json["Speed"]==null ? null :json["Speed"],
    latitude:  json["Latitude"]==null ? null :json["Latitude"],
    longitude: json["Longitude"]==null ? null : json["Longitude"],
    driverName:  json["DriverName"]==null ? null :json["DriverName"],
    speedLimit: json["SpeedLimit"]==null ? null : json["SpeedLimit"],
    ignition: json["Ignition"]==null ? null : json["Ignition"],
    distancetravel:  json["Distancetravel"]==null ? null :json["Distancetravel"],
    noOfSatelite: json["NoOfSatelite"]==null ? null : json["NoOfSatelite"],
    address: json["Address"]==null ? null : json["Address"],
    alertIndication:  json["AlertIndication"]==null ? null :json["AlertIndication"],
    vehicleType: json["VehicleType"]==null ? null : json["VehicleType"],
    date: json["Date"]==null ? null : json["Date"],
    time:  json["Time"]==null ? null :json["Time"],
    previousTime:  json["PreviousTime"]==null ? null :json["PreviousTime"],
    vehicleStatus:  json["VehicleStatus"]==null ? null :json["VehicleStatus"],
    heading: json["Heading"]==null ? null : json["Heading"],
    imei:  json["IMEI"]==null ? null :json["IMEI"],
    mainPowerStatus:json["MainPowerStatus"]==null ? null : json["MainPowerStatus"],
    gpsFix: json["GPSFix"]==null ? null : json["GPSFix"],
    internalBatteryVoltage:  json["InternalBatteryVoltage"]==null ? null :json["InternalBatteryVoltage"],
    ac:  json["AC"]==null ? null :json["AC"],
    door:  json["DOOR"]==null ? null :json["DOOR"],
    odometer:  json["Odometer"]==null ? null :json["Odometer"],
  );

  Map<String, dynamic> toJson() => {
    "TransactionId": transactionId,
    "VehicleRegNo": vehicleRegNo,
    "Speed": speed,
    "Latitude": latitude,
    "Longitude": longitude,
    "DriverName": driverName,
    "SpeedLimit": speedLimit,
    "Ignition": ignition,
    "Distancetravel": distancetravel,
    "NoOfSatelite": noOfSatelite,
    "Address": address,
    "AlertIndication": alertIndication,
    "VehicleType": vehicleType,
    "Date": date,
    "Time": time,
    "PreviousTime": previousTime,
    "VehicleStatus": vehicleStatus,
    "Heading": heading,
    "IMEI": imei,
    "MainPowerStatus": mainPowerStatus,
    "GPSFix": gpsFix,
    "InternalBatteryVoltage": internalBatteryVoltage,
    "AC": ac,
    "DOOR": door,
    "Odometer": odometer,
  };
}


//-------------------------------------------------
// To parse this JSON data, do
//
//     final liveTrackingByIdResponse = liveTrackingByIdResponseFromJson(jsonString);


List<LiveTrackingByIdResponse> liveTrackingByIdResponseFromJson(String str) => List<LiveTrackingByIdResponse>.from(json.decode(str).map((x) => LiveTrackingByIdResponse.fromJson(x)));

String liveTrackingByIdResponseToJson(List<LiveTrackingByIdResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LiveTrackingByIdResponse {
  LiveTrackingByIdResponse({
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
    this.parking,
    this.runningDuration,
    this.runningDistance,
    this.alerts,
  });

  dynamic? transactionId;
  String ?vehicleRegNo;
  String? speed;
  String? latitude;
  String ?longitude;
  String  ?driverName;
  dynamic  ?speedLimit;
  String  ?ignition;
  String ? distancetravel;
  String  ?noOfSatelite;
  String  ?address;
  String  ?alertIndication;
  String  ?vehicleType;
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
  Parking? parking;
  Parking ?runningDuration;
  RunningDistance? runningDistance;
  List<Alert> ?alerts;

  factory LiveTrackingByIdResponse.fromJson(Map<String, dynamic> json) => LiveTrackingByIdResponse(
    transactionId: json["transactionId"]==null ? null : json["transactionId"],
    vehicleRegNo:  json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    speed:  json["speed"]==null ? null :json["speed"],
    latitude: json["latitude"]==null ? null : json["latitude"],
    longitude:  json["longitude"]==null ? null :json["longitude"],
    driverName:  json["driverName"]==null ? null :json["driverName"],
    speedLimit:  json["speedLimit"]==null ? null :json["speedLimit"],
    ignition: json["ignition"]==null ? null : json["ignition"],
    distancetravel: json["distancetravel"]==null ? null : json["distancetravel"],
    noOfSatelite:  json["noOfSatelite"]==null ? null :json["noOfSatelite"],
    address:  json["address"]==null ? null :json["address"],
    alertIndication: json["alertIndication"]==null ? null : json["alertIndication"],
    vehicleType: json["vehicleType"]==null ? null : json["vehicleType"],
    date:  json["date"]==null ? null :json["date"],
    time: json["time"]==null ? null : json["time"],
    previousTime:  json["previousTime"]==null ? null :json["previousTime"],
    vehicleStatus: json["vehicleStatus"]==null ? null : json["vehicleStatus"],
    heading: json["heading"]==null ? null : json["heading"],
    imei:  json["imei"]==null ? null :json["imei"],
    mainPowerStatus: json["mainPowerStatus"]==null ? null : json["mainPowerStatus"],
    gpsFix: json["mainPowerStatus"]==null ? null : json["mainPowerStatus"],
    internalBatteryVoltage:  json["internalBatteryVoltage"]==null ? null :json["internalBatteryVoltage"],
    ac:  json["ac"]==null ? null :json["ac"],
    door: json["door"]==null ? null : json["door"],
    odometer: json["odometer"]==null ? null : json["odometer"],
    parking: json["parking"]==null ? null : Parking.fromJson(json["parking"]),
    runningDuration:  json["runningDuration"]==null ? null :Parking.fromJson(json["runningDuration"]),
    runningDistance: json["runningDistance"]==null ? null : RunningDistance.fromJson(json["runningDistance"]),
    alerts:  json["alerts"]==null ? null :List<Alert>.from(json["alerts"].map((x) => Alert.fromJson(x))),
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
  String ?alertMesaage;

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
    alertTitle: json["alertTitle"]==null ? null : json["alertTitle"],
    alertMesaage:  json["alertMesaage"]==null ? null :json["alertMesaage"],
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
    atLastStop: json["atLastStop"]==null ? null : json["atLastStop"],
    total:  json["total"]==null ? null :json["total"],
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
    fromLastStop: json["fromLastStop"]==null ? null : json["fromLastStop"],
    total: json["total"]==null ? null : json["total"],
  );

  Map<String, dynamic> toJson() => {
    "fromLastStop": fromLastStop,
    "total": total,
  };
}
//----------------------------------------------
// To parse this JSON data, do
//
//     final searchLiveTrackingResponse = searchLiveTrackingResponseFromJson(jsonString);


List<SearchLiveTrackingResponse> searchLiveTrackingResponseFromJson(String str) => List<SearchLiveTrackingResponse>.from(json.decode(str).map((x) => SearchLiveTrackingResponse.fromJson(x)));

String searchLiveTrackingResponseToJson(List<SearchLiveTrackingResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchLiveTrackingResponse {
  SearchLiveTrackingResponse({
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
  String? speed;
  String ?latitude;
  String ?longitude;
  String? driverName;
  dynamic ?speedLimit;
  String? ignition;
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
  String ?mainPowerStatus;
  String ?gpsFix;
  String ?internalBatteryVoltage;
  String ?ac;
  String ?door;
  dynamic ?odometer;

  factory SearchLiveTrackingResponse.fromJson(Map<String, dynamic> json) => SearchLiveTrackingResponse(
    transactionId: json["transactionId"]==null ? null :json["transactionId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
    speed: json["speed"]==null ? null :json["speed"],
    latitude:json["latitude"]==null ? null : json["latitude"],
    longitude: json["longitude"]==null ? null :json["longitude"],
    driverName:json["driverName"]==null ? null : json["driverName"],
    speedLimit: json["speedLimit"]==null ? null :json["speedLimit"],
    ignition: json["ignition"]==null ? null :json["ignition"],
    distancetravel:json["distancetravel"]==null ? null : json["distancetravel"],
    noOfSatelite: json["noOfSatelite"]==null ? null :json["noOfSatelite"],
    address: json["address"]==null ? null :json["address"],
    alertIndication:json["alertIndication"]==null ? null : json["alertIndication"],
    vehicleType:json["vehicleType"]==null ? null : json["vehicleType"],
    date:json["date"]==null ? null : json["date"],
    time: json["time"]==null ? null :json["time"],
    previousTime: json["previousTime"]==null ? null :json["previousTime"],
    vehicleStatus:json["vehicleStatus"]==null ? null : json["vehicleStatus"],
    heading: json["heading"]==null ? null :json["heading"],
    imei:json["imei"]==null ? null : json["imei"],
    mainPowerStatus:json["mainPowerStatus"]==null ? null : json["mainPowerStatus"],
    gpsFix:json["gpsFix"]==null ? null : json["gpsFix"],
    internalBatteryVoltage:json["internalBatteryVoltage"]==null ? null : json["internalBatteryVoltage"],
    ac: json["ac"]==null ? null :json["ac"],
    door:json["door"]==null ? null : json["door"],
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

