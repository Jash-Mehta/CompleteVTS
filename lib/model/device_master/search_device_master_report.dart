// To parse this JSON data, do
//
//     final searchDeviceMasterReport = searchDeviceMasterReportFromJson(jsonString);

import 'dart:convert';

SearchDeviceMasterReport searchDeviceMasterReportFromJson(String str) => SearchDeviceMasterReport.fromJson(json.decode(str));

String searchDeviceMasterReportToJson(SearchDeviceMasterReport data) => json.encode(data.toJson());

class SearchDeviceMasterReport {
  SearchDeviceMasterReport({
    this.pageNumber,
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
    this.message,
  });

  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  dynamic nextPage;
  dynamic previousPage;
  List<SearchDMReportData>? data;
  bool? succeeded;
  dynamic errors;
  dynamic message;

  factory SearchDeviceMasterReport.fromJson(Map<String, dynamic> json) => SearchDeviceMasterReport(
    pageNumber: json["pageNumber"]??0,
    pageSize: json["pageSize"]??0,
    firstPage: json["firstPage"]??"",
    lastPage: json["lastPage"]??"",
    totalPages: json["totalPages"]??0,
    totalRecords: json["totalRecords"]??0,
    nextPage: json["nextPage"]??"",
    previousPage: json["previousPage"]??"",
    data: json["data"] == null ? [] : List<SearchDMReportData>.from(json["data"]!.map((x) => SearchDMReportData.fromJson(x))),
    succeeded: json["succeeded"]??false,
    errors: json["errors"]??"",
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "firstPage": firstPage,
    "lastPage": lastPage,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
    "nextPage": nextPage,
    "previousPage": previousPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class SearchDMReportData {
  SearchDMReportData({
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.deviceNo,
    this.modelNo,
    this.simNo1,
    this.simNo2,
    this.deviceName,
    this.imeino,
    this.portNo,
    this.acUser,
    this.acStatus,
  });

  int? srNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? deviceNo;
  String? modelNo;
  String? simNo1;
  String? simNo2;
  String? deviceName;
  String? imeino;
  String? portNo;
  String? acUser;
  String? acStatus;

  factory SearchDMReportData.fromJson(Map<String, dynamic> json) => SearchDMReportData(
    srNo: json["srNo"]??0,
    vendorSrNo: json["vendorSrNo"]??0,
    vendorName: json["vendorName"]??"",
    branchSrNo: json["branchSrNo"]??0,
    branchName: json["branchName"]??"",
    deviceNo: json["deviceNo"]??"",
    modelNo: json["modelNo"]??"",
    simNo1: json["simNo1"]??"",
    simNo2: json["simNo2"]??"",
    deviceName: json["deviceName"]??"",
    imeino: json["imeino"]??"",
    portNo: json["portNo"]??"",
    acUser: json["acUser"]??"",
    acStatus: json["acStatus"]??"",
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "deviceNo": deviceNo,
    "modelNo": modelNo,
    "simNo1": simNo1,
    "simNo2": simNo2,
    "deviceName": deviceName,
    "imeino": imeino,
    "portNo": portNo,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
