class VTSHistorySpeedParameter {
  Details? details;
  String? time;

  VTSHistorySpeedParameter({this.details, this.time});

  VTSHistorySpeedParameter.fromJson(Map<String, dynamic> json) {
    details =
        json['Details'] != null ? new Details.fromJson(json['Details']) : null;
    time = json['Time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.details != null) {
      data['Details'] = this.details!.toJson();
    }
    data['Time'] = this.time;
    return data;
  }
}

class Details {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<VTSHistorySpeedData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  Details(
      {this.pageNumber,
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
      this.message});

  Details.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <VTSHistorySpeedData>[];
      json['data'].forEach((v) {
        data!.add(new VTSHistorySpeedData.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    errors = json['errors'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['firstPage'] = this.firstPage;
    data['lastPage'] = this.lastPage;
    data['totalPages'] = this.totalPages;
    data['totalRecords'] = this.totalRecords;
    data['nextPage'] = this.nextPage;
    data['previousPage'] = this.previousPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class VTSHistorySpeedData {
  var transactionId;
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
  var speedLimit;
  String? heading;
  String? ignition;
  String? mainPowerStatus;
  String? gpsFix;
  String? internalBatteryVoltage;
  String? ac;
  String? door;
  String? vehicleType;
  String? previousTime;
  var odometer;

  VTSHistorySpeedData(
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
      this.vehicleType,
      this.previousTime,
      this.odometer});

  VTSHistorySpeedData.fromJson(Map<String, dynamic> json) {
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
    vehicleType = json['vehicleType'];
    previousTime = json['previousTime'];
    odometer = json['odometer'];
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
    data['vehicleType'] = this.vehicleType;
    data['previousTime'] = this.previousTime;
    data['odometer'] = this.odometer;
    return data;
  }
}
