// To parse this JSON data, do
//
//     final searchVendorResponse = searchVendorResponseFromJson(jsonString);

import 'dart:convert';

SearchVendorResponse searchVendorResponseFromJson(String str) => SearchVendorResponse.fromJson(json.decode(str));

String searchVendorResponseToJson(SearchVendorResponse data) => json.encode(data.toJson());

class SearchVendorResponse {
  SearchVendorResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<SearchData>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory SearchVendorResponse.fromJson(Map<String, dynamic> json) => SearchVendorResponse(
    data: json["data"]==null ? null : List<SearchData>.from(json["data"].map((x) => SearchData.fromJson(x))),
    succeeded: json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null : json["errors"],
    message:json["message"]==null ? null :  json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class SearchData {
  SearchData({
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

  int ?srNo;
  String ?vendorCode;
  String ?vendorName;
  String ?city;
  String ?mobileNo;
  String ?emailId;
  String? phoneNo;
  String ?address;
  String ?company;
  String ?acUser;
  DateTime ?acDate;
  String ?modifiedBy;
  String ?acStatus;

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
    srNo: json["srNo"]==null ? null : json["srNo"],
    vendorCode: json["vendorCode"]==null ? null : json["vendorCode"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    city:json["city"]==null ? null :  json["city"],
    mobileNo: json["mobileNo"]==null ? null : json["mobileNo"],
    emailId: json["emailId"]==null ? null : json["emailId"],
    phoneNo: json["phoneNo"]==null ? null : json["phoneNo"],
    address:json["address"]==null ? null :  json["address"],
    company: json["company"]==null ? null : json["company"],
    acUser: json["acUser"]==null ? null : json["acUser"],
    acDate: json["acDate"]==null ? null : DateTime.parse(json["acDate"]),
    modifiedBy:json["modifiedBy"]==null ? null :  json["modifiedBy"],
    acStatus:json["acStatus"]==null ? null :  json["acStatus"],
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
