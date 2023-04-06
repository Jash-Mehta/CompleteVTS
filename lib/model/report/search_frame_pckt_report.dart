class SearchFramePcktRpt {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<DatewiseFramepacketDatum>? data;
  bool? succeeded;
  String? errors;
  String? message;

  SearchFramePcktRpt(
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

  SearchFramePcktRpt.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber']??0;
    pageSize = json['pageSize']??0;
    firstPage = json['firstPage']??"";
    lastPage = json['lastPage']??"";
    totalPages = json['totalPages']??0;
    totalRecords = json['totalRecords']??0;
    nextPage = json['nextPage']??"";
    previousPage = json['previousPage']??"";

    if (json['data'] != null) {
      data = <DatewiseFramepacketDatum>[];
      json['data'].forEach((v) {
        var searchItem = v['datewiseFramepacketData'] as List<dynamic>;
        searchItem.forEach((element) {
          data!.add(new DatewiseFramepacketDatum.fromJson(element));

        });

      });
    }
    succeeded = json['succeeded']??false;
    errors = json['errors']??"";
    message = json['message']??"";
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

class FramePcktData {
  String? fromDate;
  String? toDate;
  List<GroupByDateTotal>? groupByDateTotal;
  List<GroupByVehicleRegNoTotal>? groupByVehicleRegNoTotal;
  double? totalDistanceTravel;
  List<DatewiseFramepacketDatum>? datewiseFramepacketData;

  FramePcktData(
      {this.fromDate,
        this.toDate,
        this.groupByDateTotal,
        this.groupByVehicleRegNoTotal,
        this.totalDistanceTravel,
        this.datewiseFramepacketData});

  FramePcktData.fromJson(Map<String, dynamic> json) {
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
    if (json['datewiseFramepacketData'] != null) {
      datewiseFramepacketData = <DatewiseFramepacketDatum>[];
      json['datewiseFramepacketData'].forEach((v) {
        datewiseFramepacketData!.add(new DatewiseFramepacketDatum.fromJson(v));
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
    if (this.datewiseFramepacketData != null) {
      data['datewiseFramepacketData'] =
          this.datewiseFramepacketData!.map((v) => v.toJson()).toList();
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
  double? distanceTravel;

  GroupByVehicleRegNoTotal(
      {this.transDate, this.vehicleRegNo, this.imei, this.distanceTravel});

  GroupByVehicleRegNoTotal.fromJson(Map<String, dynamic> json) {
    transDate = json['transDate'];
    vehicleRegNo = json['vehicleRegNo'];
    imei = json['imei'];
    distanceTravel = json['distanceTravel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transDate'] = this.transDate;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imei'] = this.imei;
    data['distanceTravel'] = this.distanceTravel;
    return data;
  }
}

class DatewiseFramepacketDatum {
  int? transID;
  String? header;
  String? vendorID;
  String? packetType;
  String? packetStatus;
  String? imei;
  String? vehicleRegNo;
  String? gpsFix;
  String? date;
  String? time;
  String? latitude;
  String? longitude;
  String? speed;
  String? networkOperatorName;
  String? ignition;
  String? mainPowerStatus;
  String? mainInputVoltage;
  String? internalBatteryVoltage;
  String? altitude;
  String? pdop;
  String? hdop;
  String? gsmSignalStrength;
  String? frameNumber;
  String? distancetravel;
  String? address;
  String? updatedon;
  String? araINONARAI;

  DatewiseFramepacketDatum(
      {this.transID,
        this.header,
        this.vendorID,
        this.packetType,
        this.packetStatus,
        this.imei,
        this.vehicleRegNo,
        this.gpsFix,
        this.date,
        this.time,
        this.latitude,
        this.longitude,
        this.speed,
        this.networkOperatorName,
        this.ignition,
        this.mainPowerStatus,
        this.mainInputVoltage,
        this.internalBatteryVoltage,
        this.altitude,
        this.pdop,
        this.hdop,
        this.gsmSignalStrength,
        this.frameNumber,
        this.distancetravel,
        this.address,
        this.updatedon,
        this.araINONARAI});

  DatewiseFramepacketDatum.fromJson(Map<String, dynamic> json) {
    transID = json['transID']??0;
    header = json['header']??"";
    vendorID = json['vendorID']??"";
    packetType = json['packetType']??"";
    packetStatus = json['packetStatus']??"";
    imei = json['imei']??"";
    vehicleRegNo = json['vehicleRegNo']??"";
    gpsFix = json['gpsFix']??"";
    date = json['date']??"";
    time = json['time']??"";
    latitude = json['latitude']??"";
    longitude = json['longitude']??"";
    speed = json['speed']??"";
    networkOperatorName = json['networkOperatorName']??"";
    ignition = json['ignition']??"";
    mainPowerStatus = json['mainPowerStatus']??"";
    mainInputVoltage = json['mainInputVoltage']??"";
    internalBatteryVoltage = json['internalBatteryVoltage']??"";
    altitude = json['altitude']??"";
    pdop = json['pdop']??"";
    hdop = json['hdop']??"";
    gsmSignalStrength = json['gsmSignalStrength']??"";
    frameNumber = json['frameNumber']??"";
    distancetravel = json['distancetravel']??"";
    address = json['address']??"";
    updatedon = json['updatedon']??"";
    araINONARAI = json['araI_NONARAI']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transID'] = this.transID;
    data['header'] = this.header;
    data['vendorID'] = this.vendorID;
    data['packetType'] = this.packetType;
    data['packetStatus'] = this.packetStatus;
    data['imei'] = this.imei;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['gpsFix'] = this.gpsFix;
    data['date'] = this.date;
    data['time'] = this.time;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['speed'] = this.speed;
    data['networkOperatorName'] = this.networkOperatorName;
    data['ignition'] = this.ignition;
    data['mainPowerStatus'] = this.mainPowerStatus;
    data['mainInputVoltage'] = this.mainInputVoltage;
    data['internalBatteryVoltage'] = this.internalBatteryVoltage;
    data['altitude'] = this.altitude;
    data['pdop'] = this.pdop;
    data['hdop'] = this.hdop;
    data['gsmSignalStrength'] = this.gsmSignalStrength;
    data['frameNumber'] = this.frameNumber;
    data['distancetravel'] = this.distancetravel;
    data['address'] = this.address;
    data['updatedon'] = this.updatedon;
    data['araI_NONARAI'] = this.araINONARAI;
    return data;
  }
}
