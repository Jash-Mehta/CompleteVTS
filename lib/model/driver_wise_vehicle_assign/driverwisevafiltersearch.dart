class DriverWiseVAFilterSearchModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<DriverwiseVAData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  DriverWiseVAFilterSearchModel(
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

  DriverWiseVAFilterSearchModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <DriverwiseVAData>[];
      json['data'].forEach((v) {
        data!.add(new DriverwiseVAData.fromJson(v));
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

class DriverwiseVAData {
  int? vsrNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? vehicleRegNo;
  String? vehicleName;
  int? driverSrNo;
  String? driverCode;
  String? driverName;
  String? mobileNo;
  String? acUser;
  String? acStatus;

  DriverwiseVAData(
      {this.vsrNo,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.vehicleRegNo,
      this.vehicleName,
      this.driverSrNo,
      this.driverCode,
      this.driverName,
      this.mobileNo,
      this.acUser,
      this.acStatus});

  DriverwiseVAData.fromJson(Map<String, dynamic> json) {
    vsrNo = json['vsrNo'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    vehicleRegNo = json['vehicleRegNo'];
    vehicleName = json['vehicleName'];
    driverSrNo = json['driverSrNo'];
    driverCode = json['driverCode'];
    driverName = json['driverName'];
    mobileNo = json['mobileNo'];
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
    data['driverSrNo'] = this.driverSrNo;
    data['driverCode'] = this.driverCode;
    data['driverName'] = this.driverName;
    data['mobileNo'] = this.mobileNo;
    data['acUser'] = this.acUser;
    data['acStatus'] = this.acStatus;
    return data;
  }
}
