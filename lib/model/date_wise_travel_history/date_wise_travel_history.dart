class DateWiseTravelHistory {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<DatewiseTravelHistoryData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  DateWiseTravelHistory(
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

  DateWiseTravelHistory.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    // if (json['data'] != null) {
    //   data = <DateWiseTravel>[];
    //   json['data'].forEach((v) {
    //     data!.add(new DateWiseTravel.fromJson(v));
    //   });
    // }
     if (json['data'] != null) {
      data = <DatewiseTravelHistoryData>[];
      json['data'].forEach((v) {
        var datewisetraveldata =
            v['datewiseTravelHistoryData'] as List<dynamic>;
        datewisetraveldata.forEach((element) {
          data!.add(DatewiseTravelHistoryData.fromJson(element));
        });
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

class DateWiseTravel {
  String? fromDate;
  String? toDate;
  List<GroupByDateTotal>? groupByDateTotal;
  List<GroupByVehicleRegNoTotal>? groupByVehicleRegNoTotal;
  double? totalDistanceTravel;
  List<DatewiseTravelHistoryData>? datewiseTravelHistoryData;

  DateWiseTravel(
      {this.fromDate,
      this.toDate,
      this.groupByDateTotal,
      this.groupByVehicleRegNoTotal,
      this.totalDistanceTravel,
      this.datewiseTravelHistoryData});

  DateWiseTravel.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    if (json['groupByDateTotal'] != null) {
      groupByDateTotal = <GroupByDateTotal>[];
      json['groupByDateTotal'].forEach((v) {
        groupByDateTotal!.add(new GroupByDateTotal.fromJson(v));
      });
    }
    if (json['groupByVehicleRegNoTotal'] != null) {
      groupByVehicleRegNoTotal = <GroupByVehicleRegNoTotal>[];
      json['groupByVehicleRegNoTotal'].forEach((v) {
        groupByVehicleRegNoTotal!.add(new GroupByVehicleRegNoTotal.fromJson(v));
      });
    }
    totalDistanceTravel = json['totalDistanceTravel'];
    if (json['datewiseTravelHistoryData'] != null) {
      datewiseTravelHistoryData = <DatewiseTravelHistoryData>[];
      json['datewiseTravelHistoryData'].forEach((v) {
        datewiseTravelHistoryData!
            .add(new DatewiseTravelHistoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    if (this.groupByDateTotal != null) {
      data['groupByDateTotal'] =
          this.groupByDateTotal!.map((v) => v.toJson()).toList();
    }
    if (this.groupByVehicleRegNoTotal != null) {
      data['groupByVehicleRegNoTotal'] =
          this.groupByVehicleRegNoTotal!.map((v) => v.toJson()).toList();
    }
    data['totalDistanceTravel'] = this.totalDistanceTravel;
    if (this.datewiseTravelHistoryData != null) {
      data['datewiseTravelHistoryData'] =
          this.datewiseTravelHistoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupByDateTotal {
  String? transDate;
  double? distanceTravel;

  GroupByDateTotal({this.transDate, this.distanceTravel});

  GroupByDateTotal.fromJson(Map<String, dynamic> json) {
    transDate = json['transDate'];
    distanceTravel = json['distanceTravel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transDate'] = this.transDate;
    data['distanceTravel'] = this.distanceTravel;
    return data;
  }
}

class GroupByVehicleRegNoTotal {
  String? transDate;
  String? vehicleRegNo;
  String? imei;
  int? speedLimit;
  double? distanceTravel;

  GroupByVehicleRegNoTotal(
      {this.transDate,
      this.vehicleRegNo,
      this.imei,
      this.speedLimit,
      this.distanceTravel});

  GroupByVehicleRegNoTotal.fromJson(Map<String, dynamic> json) {
    transDate = json['transDate'];
    vehicleRegNo = json['vehicleRegNo'];
    imei = json['imei'];
    speedLimit = json['speedLimit'];
    distanceTravel = json['distanceTravel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transDate'] = this.transDate;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imei'] = this.imei;
    data['speedLimit'] = this.speedLimit;
    data['distanceTravel'] = this.distanceTravel;
    return data;
  }
}

class DatewiseTravelHistoryData {
  String? vehicleRegNo;
  String? imeino;
  String? latitude;
  String? longitude;
  String? address;
  String? transDate;
  String? transTime;
  String? speed;
  String? updatedOn;
  String? distancetravel;
  int? speedLimit;
  String? gpsFix;
  String? latitudeDir;
  String? longitudeDir;
  String? heading;
  String? noofSatellites;
  String? altitude;
  String? pdop;
  String? hdop;
  String? networkOperatorName;
  String? ignition;
  String? mainPowerStatus;
  String? emergencyStatus;
  String? tamperAlert;
  String? gsmSignalStrength;
  String? nmr;
  String? digitalInputStatus;
  String? digitalOutputStatus;
  String? adC1;
  String? adC2;
  String? frameNumber;
  String? checksum;

  DatewiseTravelHistoryData(
      {this.vehicleRegNo,
      this.imeino,
      this.latitude,
      this.longitude,
      this.address,
      this.transDate,
      this.transTime,
      this.speed,
      this.updatedOn,
      this.distancetravel,
      this.speedLimit,
      this.gpsFix,
      this.latitudeDir,
      this.longitudeDir,
      this.heading,
      this.noofSatellites,
      this.altitude,
      this.pdop,
      this.hdop,
      this.networkOperatorName,
      this.ignition,
      this.mainPowerStatus,
      this.emergencyStatus,
      this.tamperAlert,
      this.gsmSignalStrength,
      this.nmr,
      this.digitalInputStatus,
      this.digitalOutputStatus,
      this.adC1,
      this.adC2,
      this.frameNumber,
      this.checksum});

  DatewiseTravelHistoryData.fromJson(Map<String, dynamic> json) {
    vehicleRegNo = json['vehicleRegNo'];
    imeino = json['imeino'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    address = json['address'];
    transDate = json['transDate'];
    transTime = json['transTime'];
    speed = json['speed'];
    updatedOn = json['updatedOn'];
    distancetravel = json['distancetravel'];
    speedLimit = json['speedLimit'];
    gpsFix = json['gpsFix'];
    latitudeDir = json['latitudeDir'];
    longitudeDir = json['longitudeDir'];
    heading = json['heading'];
    noofSatellites = json['noofSatellites'];
    altitude = json['altitude'];
    pdop = json['pdop'];
    hdop = json['hdop'];
    networkOperatorName = json['networkOperatorName'];
    ignition = json['ignition'];
    mainPowerStatus = json['mainPowerStatus'];
    emergencyStatus = json['emergencyStatus'];
    tamperAlert = json['tamperAlert'];
    gsmSignalStrength = json['gsmSignalStrength'];
    nmr = json['nmr'];
    digitalInputStatus = json['digitalInputStatus'];
    digitalOutputStatus = json['digitalOutputStatus'];
    adC1 = json['adC1'];
    adC2 = json['adC2'];
    frameNumber = json['frameNumber'];
    checksum = json['checksum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imeino'] = this.imeino;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['address'] = this.address;
    data['transDate'] = this.transDate;
    data['transTime'] = this.transTime;
    data['speed'] = this.speed;
    data['updatedOn'] = this.updatedOn;
    data['distancetravel'] = this.distancetravel;
    data['speedLimit'] = this.speedLimit;
    data['gpsFix'] = this.gpsFix;
    data['latitudeDir'] = this.latitudeDir;
    data['longitudeDir'] = this.longitudeDir;
    data['heading'] = this.heading;
    data['noofSatellites'] = this.noofSatellites;
    data['altitude'] = this.altitude;
    data['pdop'] = this.pdop;
    data['hdop'] = this.hdop;
    data['networkOperatorName'] = this.networkOperatorName;
    data['ignition'] = this.ignition;
    data['mainPowerStatus'] = this.mainPowerStatus;
    data['emergencyStatus'] = this.emergencyStatus;
    data['tamperAlert'] = this.tamperAlert;
    data['gsmSignalStrength'] = this.gsmSignalStrength;
    data['nmr'] = this.nmr;
    data['digitalInputStatus'] = this.digitalInputStatus;
    data['digitalOutputStatus'] = this.digitalOutputStatus;
    data['adC1'] = this.adC1;
    data['adC2'] = this.adC2;
    data['frameNumber'] = this.frameNumber;
    data['checksum'] = this.checksum;
    return data;
  }
}
