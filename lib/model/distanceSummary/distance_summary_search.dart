class DistanceSummarySearchModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<DistanceSummarySearch>? data;
  bool? succeeded;
  String? errors;
  String? message;

  DistanceSummarySearchModel(
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

  DistanceSummarySearchModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <DistanceSummarySearch>[];
      json['data'].forEach((v) {
         var searchItem = v['distanceSummary'] as List<dynamic>;
        searchItem.forEach((element) {
          data!.add(new DistanceSummarySearch.fromJson(element));
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
  String? totalDistanceSummary;
  String? totalAlertsCount;
  List<DistanceSummarySearch>? distanceSummary;

  Data(
      {this.fromDate,
      this.toDate,
      this.totalDistanceSummary,
      this.totalAlertsCount,
      this.distanceSummary});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    totalDistanceSummary = json['totalDistanceSummary'];
    totalAlertsCount = json['totalAlertsCount'];
    if (json['distanceSummary'] != null) {
      distanceSummary = <DistanceSummarySearch>[];
      json['distanceSummary'].forEach((v) {
        distanceSummary!.add(new DistanceSummarySearch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['totalDistanceSummary'] = this.totalDistanceSummary;
    data['totalAlertsCount'] = this.totalAlertsCount;
    if (this.distanceSummary != null) {
      data['distanceSummary'] =
          this.distanceSummary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DistanceSummarySearch {
  int? transactionID;
  String? vehicleregNo;
  String? imei;
  String? tDate;
  String? tTime;
  String? previousTime;
  String? nextTime;
  String? vehicleStatus;
  int? avgSpeed;
  double? runningDistanceTravel;
  int? alertCount;
  String? driverName;
  String? address;
  String? nextAddress;

  DistanceSummarySearch(
      {this.transactionID,
      this.vehicleregNo,
      this.imei,
      this.tDate,
      this.tTime,
      this.previousTime,
      this.nextTime,
      this.vehicleStatus,
      this.avgSpeed,
      this.runningDistanceTravel,
      this.alertCount,
      this.driverName,
      this.address,
      this.nextAddress});

  DistanceSummarySearch.fromJson(Map<String, dynamic> json) {
    transactionID = json['transactionID'];
    vehicleregNo = json['vehicleregNo'];
    imei = json['imei'];
    tDate = json['tDate'];
    tTime = json['tTime'];
    previousTime = json['previousTime'];
    nextTime = json['nextTime'];
    vehicleStatus = json['vehicleStatus'];
    avgSpeed = json['avgSpeed'];
    runningDistanceTravel = json['runningDistanceTravel'];
    alertCount = json['alertCount'];
    driverName = json['driverName'];
    address = json['address'];
    nextAddress = json['nextAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transactionID'] = this.transactionID;
    data['vehicleregNo'] = this.vehicleregNo;
    data['imei'] = this.imei;
    data['tDate'] = this.tDate;
    data['tTime'] = this.tTime;
    data['previousTime'] = this.previousTime;
    data['nextTime'] = this.nextTime;
    data['vehicleStatus'] = this.vehicleStatus;
    data['avgSpeed'] = this.avgSpeed;
    data['runningDistanceTravel'] = this.runningDistanceTravel;
    data['alertCount'] = this.alertCount;
    data['driverName'] = this.driverName;
    data['address'] = this.address;
    data['nextAddress'] = this.nextAddress;
    return data;
  }
}
