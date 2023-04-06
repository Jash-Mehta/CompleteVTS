
import 'dart:convert';

AllVendorDetailResponse allVendorDetailResponseFromJson(String str) => AllVendorDetailResponse.fromJson(json.decode(str));

String allVendorDetailResponseToJson(AllVendorDetailResponse data) => json.encode(data.toJson());

class AllVendorDetailResponse {
  AllVendorDetailResponse({
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
  String ?firstPage;
  String? lastPage;
  int ?totalPages;
  int ?totalRecords;
  String ?nextPage;
  dynamic? previousPage;
  List<Datum>? data;
  bool ?succeeded;
  dynamic? errors;
  dynamic? message;

  factory AllVendorDetailResponse.fromJson(Map<String, dynamic> json) => AllVendorDetailResponse(
    pageNumber:  json["pageNumber"]==null ? null :json["pageNumber"],
    pageSize:  json["pageSize"]==null ? null :json["pageSize"],
    firstPage:  json["firstPage"]==null ? null :json["firstPage"],
    lastPage:  json["lastPage"]==null ? null :json["lastPage"],
    totalPages:  json["totalPages"]==null ? null :json["totalPages"],
    totalRecords: json["totalRecords"]==null ? null : json["totalRecords"],
    nextPage: json["nextPage"]==null ? null : json["nextPage"],
    previousPage: json["previousPage"]==null ? null : json["previousPage"],
    data:  json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded:  json["succeeded"]==null ? null :json["succeeded"],
    errors: json["errors"]==null ? null : json["errors"],
    message:  json["message"]==null ? null :json["message"],
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
     this.vendorCode,
     this.vendorName,
     this.city,
     this.mobileNo,
     this.emailId,
     this.phoneNo,
     this.address,
     this.company,
     this.acUser,
     this.acDate,
     this.modifiedBy,
     this.acStatus,
  });

  int? srNo;
  String ?vendorCode;
  String ?vendorName;
  String ?city;
  String ?mobileNo;
  String? emailId;
  String ?phoneNo;
  String? address;
  String ?company;
  String ?acUser;
  DateTime? acDate;
  String? modifiedBy;
  String? acStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["srNo"]==null ? null :json["srNo"],
    vendorCode:json["vendorCode"]==null ? null : json["vendorCode"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    city:json["city"]==null ? null : json["city"],
    mobileNo:json["mobileNo"]==null ? null : json["mobileNo"],
    emailId:json["emailId"]==null ? null : json["emailId"],
    phoneNo: json["phoneNo"]==null ? null :json["phoneNo"],
    address: json["address"]==null ? null :json["address"],
    company:json["company"]==null ? null : json["company"],
    acUser:json["acUser"]==null ? null : json["acUser"],
    acDate: json["acDate"]==null ? null :DateTime.parse(json["acDate"]),
    modifiedBy:json["modifiedBy"]==null ? null : json["modifiedBy"],
    acStatus:json["acStatus"]==null ? null : json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorCode": vendorCode,
    "vendorName": vendorName,
    "city": city,
    "mobileNo": mobileNo,
    "emailId": emailId,
    "phoneNo": phoneNo,
    "address": address,
    "company": company,
    "acUser": acUser,
    "acDate": acDate!.toIso8601String(),
    "modifiedBy": modifiedBy,
    "acStatus": acStatus,
  };
}

