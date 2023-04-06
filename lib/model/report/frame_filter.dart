class FramePacketFilterModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  Null? previousPage;
  List<FrameFilterData>? data;
  bool? succeeded;
  Null? errors;
  Null? message;

  FramePacketFilterModel(
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

  FramePacketFilterModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <FrameFilterData>[];
      json['data'].forEach((v) {
        var framedata = v['datewiseFramepacketData'] as List<dynamic>;
        framedata.forEach((element) {
          data!.add(new FrameFilterData.fromJson(element));
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
  List<FrameFilterData>? datewiseFramepacketData;

  Data(
      {this.fromDate,
      this.toDate,
      this.groupByDateByCountTotal,
      this.groupByVehicleRegNoByCountTotal,
      this.totalRecordsCount,
      this.datewiseFramepacketData});

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
    if (json['datewiseFramepacketData'] != null) {
      datewiseFramepacketData = <FrameFilterData>[];
      json['datewiseFramepacketData'].forEach((v) {
        datewiseFramepacketData!.add(new FrameFilterData.fromJson(v));
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
    if (this.datewiseFramepacketData != null) {
      data['datewiseFramepacketData'] =
          this.datewiseFramepacketData!.map((v) => v.toJson()).toList();
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

class FrameFilterData {
  int? transID;
  String? imei;
  String? header;
  String? vehicleRegNo;
  String? firmwareversionHardware;
  String? firmwareversionSoftware;
  String? latitude;
  String? latitudeDir;
  String? longitude;
  String? longitudeDir;
  String? updatedOn;

  FrameFilterData(
      {this.transID,
      this.imei,
      this.header,
      this.vehicleRegNo,
      this.firmwareversionHardware,
      this.firmwareversionSoftware,
      this.latitude,
      this.latitudeDir,
      this.longitude,
      this.longitudeDir,
      this.updatedOn});

  FrameFilterData.fromJson(Map<String, dynamic> json) {
    transID = json['transID']??0;
    imei = json['imei']??"";
    header = json['header']??"";
    vehicleRegNo = json['vehicleRegNo']??"";
    firmwareversionHardware = json['firmwareversionHardware']??"";
    firmwareversionSoftware = json['firmwareversionSoftware']??"";
    latitude = json['latitude']??"";
    latitudeDir = json['latitudeDir']??"";
    longitude = json['longitude']??"";
    longitudeDir = json['longitudeDir']??"";
    updatedOn = json['updatedOn']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transID'] = this.transID;
    data['imei'] = this.imei;
    data['header'] = this.header;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['firmwareversionHardware'] = this.firmwareversionHardware;
    data['firmwareversionSoftware'] = this.firmwareversionSoftware;
    data['latitude'] = this.latitude;
    data['latitudeDir'] = this.latitudeDir;
    data['longitude'] = this.longitude;
    data['longitudeDir'] = this.longitudeDir;
    data['updatedOn'] = this.updatedOn;
    return data;
  }
}
