class FrameGridFilterSearchModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<FrameGridFilterSearchData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  FrameGridFilterSearchModel(
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

  FrameGridFilterSearchModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <FrameGridFilterSearchData>[];
      json['data'].forEach((v) {
        // data!.add(new FrameGridFilterSearchData.fromJson(v));
         var searchdata = v['datewiseFramePacketGridViewData'] as List<dynamic>;
        searchdata.forEach((element) {
          data!.add(new FrameGridFilterSearchData.fromJson(element));
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

class Data {
  String? fromDate;
  String? toDate;
  List<GroupByDateByCountTotal>? groupByDateByCountTotal;
  List<GroupByVehicleRegNoByCountTotal>? groupByVehicleRegNoByCountTotal;
  int? totalRecordsCount;
  List<FrameGridFilterSearchData>? datewiseFramePacketGridViewData;

  Data(
      {this.fromDate,
      this.toDate,
      this.groupByDateByCountTotal,
      this.groupByVehicleRegNoByCountTotal,
      this.totalRecordsCount,
      this.datewiseFramePacketGridViewData});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    if (json['groupByDateByCountTotal'] != null) {
      groupByDateByCountTotal = <GroupByDateByCountTotal>[];
      json['groupByDateByCountTotal'].forEach((v) {
        groupByDateByCountTotal!.add(new GroupByDateByCountTotal.fromJson(v));
      });
    }
    if (json['groupByVehicleRegNoByCountTotal'] != null) {
      groupByVehicleRegNoByCountTotal = <GroupByVehicleRegNoByCountTotal>[];
      json['groupByVehicleRegNoByCountTotal'].forEach((v) {
        groupByVehicleRegNoByCountTotal!
            .add(new GroupByVehicleRegNoByCountTotal.fromJson(v));
      });
    }
    totalRecordsCount = json['totalRecordsCount'];
    if (json['datewiseFramePacketGridViewData'] != null) {
      datewiseFramePacketGridViewData = <FrameGridFilterSearchData>[];
      json['datewiseFramePacketGridViewData'].forEach((v) {
        datewiseFramePacketGridViewData!
            .add(new FrameGridFilterSearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    if (this.groupByDateByCountTotal != null) {
      data['groupByDateByCountTotal'] =
          this.groupByDateByCountTotal!.map((v) => v.toJson()).toList();
    }
    if (this.groupByVehicleRegNoByCountTotal != null) {
      data['groupByVehicleRegNoByCountTotal'] =
          this.groupByVehicleRegNoByCountTotal!.map((v) => v.toJson()).toList();
    }
    data['totalRecordsCount'] = this.totalRecordsCount;
    if (this.datewiseFramePacketGridViewData != null) {
      data['datewiseFramePacketGridViewData'] =
          this.datewiseFramePacketGridViewData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupByDateByCountTotal {
  String? transDate;
  int? transIDCount;

  GroupByDateByCountTotal({this.transDate, this.transIDCount});

  GroupByDateByCountTotal.fromJson(Map<String, dynamic> json) {
    transDate = json['transDate'];
    transIDCount = json['transIDCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transDate'] = this.transDate;
    data['transIDCount'] = this.transIDCount;
    return data;
  }
}

class GroupByVehicleRegNoByCountTotal {
  String? transDate;
  String? vehicleRegNo;
  String? imei;
  int? transIDCount;

  GroupByVehicleRegNoByCountTotal(
      {this.transDate, this.vehicleRegNo, this.imei, this.transIDCount});

  GroupByVehicleRegNoByCountTotal.fromJson(Map<String, dynamic> json) {
    transDate = json['transDate'];
    vehicleRegNo = json['vehicleRegNo'];
    imei = json['imei'];
    transIDCount = json['transIDCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transDate'] = this.transDate;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imei'] = this.imei;
    data['transIDCount'] = this.transIDCount;
    return data;
  }
}

class FrameGridFilterSearchData {
  int? transID;
  String? header;
  String? vendorID;
  String? firmwareVersion;
  String? imei;
  String? batteryPercentage;
  String? lowBatteryThresholdValue;
  String? memoryPercentage;
  String? dataUpdateRateWhenIgnitionON;
  String? dataUpdateRateWhenIgnitionOFF;
  String? digitalInputStatus;
  String? digitalOutputStatus;
  String? analogIOStatus1;
  String? analogIOStatus2;
  String? updatedOn;
  String? vehicleRegNo;
  String? araINONARAI;

  FrameGridFilterSearchData(
      {this.transID,
      this.header,
      this.vendorID,
      this.firmwareVersion,
      this.imei,
      this.batteryPercentage,
      this.lowBatteryThresholdValue,
      this.memoryPercentage,
      this.dataUpdateRateWhenIgnitionON,
      this.dataUpdateRateWhenIgnitionOFF,
      this.digitalInputStatus,
      this.digitalOutputStatus,
      this.analogIOStatus1,
      this.analogIOStatus2,
      this.updatedOn,
      this.vehicleRegNo,
      this.araINONARAI});

  FrameGridFilterSearchData.fromJson(Map<String, dynamic> json) {
    transID = json['transID'];
    header = json['header'];
    vendorID = json['vendorID'];
    firmwareVersion = json['firmwareVersion'];
    imei = json['imei'];
    batteryPercentage = json['batteryPercentage'];
    lowBatteryThresholdValue = json['lowBatteryThresholdValue'];
    memoryPercentage = json['memoryPercentage'];
    dataUpdateRateWhenIgnitionON = json['dataUpdateRateWhenIgnitionON'];
    dataUpdateRateWhenIgnitionOFF = json['dataUpdateRateWhenIgnitionOFF'];
    digitalInputStatus = json['digitalInputStatus'];
    digitalOutputStatus = json['digitalOutputStatus'];
    analogIOStatus1 = json['analogIOStatus1'];
    analogIOStatus2 = json['analogIOStatus2'];
    updatedOn = json['updatedOn'];
    vehicleRegNo = json['vehicleRegNo'];
    araINONARAI = json['araI_NONARAI'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transID'] = this.transID;
    data['header'] = this.header;
    data['vendorID'] = this.vendorID;
    data['firmwareVersion'] = this.firmwareVersion;
    data['imei'] = this.imei;
    data['batteryPercentage'] = this.batteryPercentage;
    data['lowBatteryThresholdValue'] = this.lowBatteryThresholdValue;
    data['memoryPercentage'] = this.memoryPercentage;
    data['dataUpdateRateWhenIgnitionON'] = this.dataUpdateRateWhenIgnitionON;
    data['dataUpdateRateWhenIgnitionOFF'] = this.dataUpdateRateWhenIgnitionOFF;
    data['digitalInputStatus'] = this.digitalInputStatus;
    data['digitalOutputStatus'] = this.digitalOutputStatus;
    data['analogIOStatus1'] = this.analogIOStatus1;
    data['analogIOStatus2'] = this.analogIOStatus2;
    data['updatedOn'] = this.updatedOn;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['araI_NONARAI'] = this.araINONARAI;
    return data;
  }
}
