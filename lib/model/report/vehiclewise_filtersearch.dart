class VehicleWiseFilterSearchModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  Null? previousPage;
  List<VehicleWiseFilterSearchData>? data;
  bool? succeeded;
  Null? errors;
  Null? message;

  VehicleWiseFilterSearchModel(
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

  VehicleWiseFilterSearchModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <VehicleWiseFilterSearchData>[];
      json['data'].forEach((v) {
        // data!.add(new VehicleWiseFilterSearchData.fromJson(v));
         var searchdata = v['datewiseTravelHistoryData'] as List<dynamic>;
        searchdata.forEach((element) {
          data!.add(new VehicleWiseFilterSearchData.fromJson(element));
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
  List<GroupByDateTotal>? groupByDateTotal;
  List<GroupByVehicleRegNoTotal>? groupByVehicleRegNoTotal;
  double? totalDistanceTravel;
  List<VehicleWiseFilterSearchData>? datewiseTravelHistoryData;

  Data(
      {this.fromDate,
      this.toDate,
      this.groupByDateTotal,
      this.groupByVehicleRegNoTotal,
      this.totalDistanceTravel,
      this.datewiseTravelHistoryData});

  Data.fromJson(Map<String, dynamic> json) {
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
      datewiseTravelHistoryData = <VehicleWiseFilterSearchData>[];
      json['datewiseTravelHistoryData'].forEach((v) {
        datewiseTravelHistoryData!
            .add(new VehicleWiseFilterSearchData.fromJson(v));
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

class VehicleWiseFilterSearchData {
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

  VehicleWiseFilterSearchData(
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
      this.speedLimit});

  VehicleWiseFilterSearchData.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
