import 'dart:convert';

searchDriverMasterReportResponse searchDriverMasterReportResponseFromJson(String str) => searchDriverMasterReportResponse.fromJson(json.decode(str));

String searchDriverMasterReportResponseToJson(searchDriverMasterReportResponse data) => json.encode(data.toJson());


class searchDriverMasterReportResponse {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  Null? nextPage;
  Null? previousPage;
  List<Data>? data;
  bool? succeeded;
  Null? errors;
  Null? message;

  searchDriverMasterReportResponse(
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

  searchDriverMasterReportResponse.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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
  int? srNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? driverCode;
  String? driverName;
  String? licenceNo;
  String? city;
  String? mobileNo;
  String? doj;
  String? driverAddress;
  String? acUser;
  String? acStatus;

  Data(
      {this.srNo,
        this.vendorSrNo,
        this.vendorName,
        this.branchSrNo,
        this.branchName,
        this.driverCode,
        this.driverName,
        this.licenceNo,
        this.city,
        this.mobileNo,
        this.doj,
        this.driverAddress,
        this.acUser,
        this.acStatus});

  Data.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    driverCode = json['driverCode'];
    driverName = json['driverName'];
    licenceNo = json['licenceNo'];
    city = json['city'];
    mobileNo = json['mobileNo'];
    doj = json['doj'];
    driverAddress = json['driverAddress'];
    acUser = json['acUser'];
    acStatus = json['acStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['driverCode'] = this.driverCode;
    data['driverName'] = this.driverName;
    data['licenceNo'] = this.licenceNo;
    data['city'] = this.city;
    data['mobileNo'] = this.mobileNo;
    data['doj'] = this.doj;
    data['driverAddress'] = this.driverAddress;
    data['acUser'] = this.acUser;
    data['acStatus'] = this.acStatus;
    return data;
  }
}
