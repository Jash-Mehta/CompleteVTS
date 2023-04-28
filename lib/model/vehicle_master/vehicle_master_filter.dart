class VehicleReportFilter {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<VehicleFilterData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  VehicleReportFilter(
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

  VehicleReportFilter.fromJson(Map<String, dynamic> json) {
    // print("Entering in json api body" + json.toString());
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <VehicleFilterData>[];
      json['data'].forEach((v) {
        data!.add(new VehicleFilterData.fromJson(v));
        // print("v data is ---> " + v);
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

class VehicleFilterData {
  int? vsrNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? vehicleRegNo;
  String? vehicleName;
  String? fuelType;
  int? speedLimit;
  String? vehicleType;
  String? vehicleTypeName;
  int? driverSrNo;
  String? driverName;
  int? deviceSrNo;
  String? deviceName;
  double? currentOdometer;
  String? vehicleRc;
  String? vehicleInsurance;
  String? vehiclePuc;
  String? vehicleOther;
  String? acUser;
  String? acStatus;

  VehicleFilterData(
      {this.vsrNo,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.vehicleRegNo,
      this.vehicleName,
      this.fuelType,
      this.speedLimit,
      this.vehicleType,
      this.vehicleTypeName,
      this.driverSrNo,
      this.driverName,
      this.deviceSrNo,
      this.deviceName,
      this.currentOdometer,
      this.vehicleRc,
      this.vehicleInsurance,
      this.vehiclePuc,
      this.vehicleOther,
      this.acUser,
      this.acStatus});

  VehicleFilterData.fromJson(Map<String, dynamic> json) {
    vsrNo = json['vsrNo'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    vehicleRegNo = json['vehicleRegNo'];
    vehicleName = json['vehicleName'];
    fuelType = json['fuelType'];
    speedLimit = json['speedLimit'];
    vehicleType = json['vehicleType'];
    vehicleTypeName = json['vehicleTypeName'];
    driverSrNo = json['driverSrNo'];
    driverName = json['driverName'];
    deviceSrNo = json['deviceSrNo'];
    deviceName = json['deviceName'];
    currentOdometer = json['currentOdometer'];
    vehicleRc = json['vehicleRc'];
    vehicleInsurance = json['vehicleInsurance'];
    vehiclePuc = json['vehiclePuc'];
    vehicleOther = json['vehicleOther'];
    acUser = json['acUser'];
    acStatus = json['acStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vsrNo'] = this.vsrNo;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['vehicleName'] = this.vehicleName;
    data['fuelType'] = this.fuelType;
    data['speedLimit'] = this.speedLimit;
    data['vehicleType'] = this.vehicleType;
    data['vehicleTypeName'] = this.vehicleTypeName;
    data['driverSrNo'] = this.driverSrNo;
    data['driverName'] = this.driverName;
    data['deviceSrNo'] = this.deviceSrNo;
    data['deviceName'] = this.deviceName;
    data['currentOdometer'] = this.currentOdometer;
    data['vehicleRc'] = this.vehicleRc;
    data['vehicleInsurance'] = this.vehicleInsurance;
    data['vehiclePuc'] = this.vehiclePuc;
    data['vehicleOther'] = this.vehicleOther;
    data['acUser'] = this.acUser;
    data['acStatus'] = this.acStatus;
    return data;
  }
}
