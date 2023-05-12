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
  int? transactionId;
  String? vehicleRegNo;
  String? vehicleStatus;
  String? imei;
  String? latitude;
  String? longitude;
  String? speed;
  String? distancetravel;
  String? date;
  String? time;
  String? noOfSatelite;
  String? address;
  String? driverName;
  int? speedLimit;
  String? heading;
  String? ignition;
  String? mainPowerStatus;
  String? gpsFix;
  String? internalBatteryVoltage;
  String? ac;
  String? door;
  String? licenseExpireDate;
  String? mobileNumber;
  Null? alertIndication;
  String? vehicleType;
  String? previousTime;
  dynamic? odometer;
  Parking? parking;
  Parking? runningDuration;
  RunningDistance? runningDistance;
  List<Alerts>? alerts;

  VehicleStatusDatum(
      {this.transactionId,
        this.vehicleRegNo,
        this.vehicleStatus,
        this.imei,
        this.latitude,
        this.longitude,
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
        this.alertIndication,
        this.vehicleType,
        this.previousTime,
        this.odometer,
        this.parking,
        this.runningDuration,
        this.runningDistance,
        this.alerts});

  VehicleStatusDatum.fromJson(Map<String, dynamic> json) {
    transactionId = json['transactionId'];
    vehicleRegNo = json['vehicleRegNo'];
    vehicleStatus = json['vehicleStatus'];
    imei = json['imei'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    speed = json['speed'];
    distancetravel = json['distancetravel'];
    date = json['date'];
    time = json['time'];
    noOfSatelite = json['noOfSatelite'];
    address = json['address'];
    driverName = json['driverName'];
    speedLimit = json['speedLimit'];
    heading = json['heading'];
    ignition = json['ignition'];
    mainPowerStatus = json['mainPowerStatus'];
    gpsFix = json['gpsFix'];
    internalBatteryVoltage = json['internalBatteryVoltage'];
    ac = json['ac'];
    door = json['door'];
    licenseExpireDate = json['licenseExpireDate'];
    mobileNumber = json['mobileNumber'];
    alertIndication = json['alertIndication'];
    vehicleType = json['vehicleType'];
    previousTime = json['previousTime'];
    odometer = json['odometer'];
    parking =
    json['parking'] != null ? new Parking.fromJson(json['parking']) : null;
    runningDuration = json['runningDuration'] != null
        ? new Parking.fromJson(json['runningDuration'])
        : null;
    runningDistance = json['runningDistance'] != null
        ? new RunningDistance.fromJson(json['runningDistance'])
        : null;
    if (json['alerts'] != null) {
      alerts = <Alerts>[];
      json['alerts'].forEach((v) {
        alerts!.add(new Alerts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionId'] = this.transactionId;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['vehicleStatus'] = this.vehicleStatus;
    data['imei'] = this.imei;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['speed'] = this.speed;
    data['distancetravel'] = this.distancetravel;
    data['date'] = this.date;
    data['time'] = this.time;
    data['noOfSatelite'] = this.noOfSatelite;
    data['address'] = this.address;
    data['driverName'] = this.driverName;
    data['speedLimit'] = this.speedLimit;
    data['heading'] = this.heading;
    data['ignition'] = this.ignition;
    data['mainPowerStatus'] = this.mainPowerStatus;
    data['gpsFix'] = this.gpsFix;
    data['internalBatteryVoltage'] = this.internalBatteryVoltage;
    data['ac'] = this.ac;
    data['door'] = this.door;
    data['licenseExpireDate'] = this.licenseExpireDate;
    data['mobileNumber'] = this.mobileNumber;
    data['alertIndication'] = this.alertIndication;
    data['vehicleType'] = this.vehicleType;
    data['previousTime'] = this.previousTime;
    data['odometer'] = this.odometer;
    if (this.parking != null) {
      data['parking'] = this.parking!.toJson();
    }
    if (this.runningDuration != null) {
      data['runningDuration'] = this.runningDuration!.toJson();
    }
    if (this.runningDistance != null) {
      data['runningDistance'] = this.runningDistance!.toJson();
    }
    if (this.alerts != null) {
      data['alerts'] = this.alerts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parking {
  String? atLastStop;
  String? total;

  Parking({this.atLastStop, this.total});

  Parking.fromJson(Map<String, dynamic> json) {
    atLastStop = json['atLastStop'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['atLastStop'] = this.atLastStop;
    data['total'] = this.total;
    return data;
  }
}

class RunningDistance {
  String? fromLastStop;
  String? total;

  RunningDistance({this.fromLastStop, this.total});

  RunningDistance.fromJson(Map<String, dynamic> json) {
    fromLastStop = json['fromLastStop'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromLastStop'] = this.fromLastStop;
    data['total'] = this.total;
    return data;
  }
}

class Alerts {
  String? alertTitle;
  Null? alertMesaage;

  Alerts({this.alertTitle, this.alertMesaage});

  Alerts.fromJson(Map<String, dynamic> json) {
    alertTitle = json['alertTitle'];
    alertMesaage = json['alertMesaage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['alertTitle'] = this.alertTitle;
    data['alertMesaage'] = this.alertMesaage;
    return data;
  }
}

