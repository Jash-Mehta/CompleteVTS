import 'dart:convert';

AllDriverResponse allDriverResponseFromJson(String str) => AllDriverResponse.fromJson(json.decode(str));

String allDriverResponseToJson(AllDriverResponse data) => json.encode(data.toJson());

class AllDriverResponse {
  AllDriverResponse({
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

  int ?pageNumber;
  int ?pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int ?totalRecords;
  String? nextPage;
  dynamic ?previousPage;
  List<Datum>? data;
  bool ?succeeded;
  dynamic? errors;
  dynamic ?message;

  factory AllDriverResponse.fromJson(Map<String, dynamic> json) => AllDriverResponse(
    pageNumber:  json["pageNumber"]==null ? null : json["pageNumber"],
    pageSize: json["pageSize"]==null ? null :  json["pageSize"],
    firstPage:  json["firstPage"]==null ? null : json["firstPage"],
    lastPage:  json["lastPage"]==null ? null : json["lastPage"],
    totalPages:  json["totalPages"]==null ? null : json["totalPages"],
    totalRecords:  json["totalRecords"]==null ? null : json["totalRecords"],
    nextPage: json["nextPage"]==null ? null :  json["nextPage"],
    previousPage:  json["previousPage"]==null ? null : json["previousPage"],
    data:  json["data"]==null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :  json["succeeded"],
    errors:  json["errors"]==null ? null : json["errors"],
    message: json["message"]==null ? null :  json["message"],
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
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datum {
  Datum({
    this.srNo,
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
    this.acStatus,
  });

  int ?srNo;
  int? vendorSrNo;
  String? vendorName;
  int ?branchSrNo;
  String ?branchName;
  String ?driverCode;
  String? driverName;
  String ?licenceNo;
  String ?city;
  String ?mobileNo;
  DateTime ?doj;
  String ?driverAddress;
  String ?acUser;
  String ?acStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo:json["srNo"]==null ? null :  json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null :  json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    branchSrNo:json["branchSrNo"]==null ? null :  json["branchSrNo"],
    branchName: json["branchName"]==null ? null : json["branchName"],
    driverCode: json["driverCode"]==null ? null : json["driverCode"],
    driverName:json["driverName"]==null ? null :  json["driverName"],
    licenceNo: json["licenceNo"]==null ? null : json["licenceNo"],
    city: json["city"]==null ? null : json["city"],
    mobileNo:json["mobileNo"]==null ? null :  json["mobileNo"],
    doj: json["doj"]==null ? null : DateTime.parse(json["doj"]),
    driverAddress: json["driverAddress"]==null ? null : json["driverAddress"],
    acUser: json["acUser"]==null ? null : json["acUser"],
    acStatus:json["acStatus"]==null ? null :  json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "driverCode": driverCode,
    "driverName": driverName,
    "licenceNo": licenceNo,
    "city": city,
    "mobileNo": mobileNo,
    "doj": doj!.toIso8601String(),
    "driverAddress": driverAddress,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
