// To parse this JSON data, do
//
//     final addNewVendorResponse = addNewVendorResponseFromJson(jsonString);

import 'dart:convert';

AddNewVendorResponse addNewVendorResponseFromJson(String str) => AddNewVendorResponse.fromJson(json.decode(str));

String addNewVendorResponseToJson(AddNewVendorResponse data) => json.encode(data.toJson());

class AddNewVendorResponse {
  AddNewVendorResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  Data ?data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory AddNewVendorResponse.fromJson(Map<String, dynamic> json) => AddNewVendorResponse(
    data: json["data"]==null ? null : Data.fromJson(json["data"]),
    succeeded: json["succeeded"]==null ? null : json["succeeded"],
    errors:json["errors"]==null ? null :  json["errors"],
    message:json["message"]==null ? null :  json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data!.toJson(),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Data {
  Data({
    this.srNo,
    this.vendorCode,
    this.vendorName,
    this.city,
    this.mobileNo,
    this.emailId,
    this.address,
    this.company,
    this.acUser,
    this.acStatus,
  });

  int ?srNo;
  String ?vendorCode;
  String? vendorName;
  String ?city;
  String ?mobileNo;
  String ?emailId;
  String ?address;
  String ?company;
  String? acUser;
  String? acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo:json["srNo"]==null ? null :  json["srNo"],
    vendorCode: json["vendorCode"]==null ? null : json["vendorCode"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    city:json["city"]==null ? null :  json["city"],
    mobileNo:json["mobileNo"]==null ? null :  json["mobileNo"],
    emailId:json["emailId"]==null ? null :  json["emailId"],
    address: json["address"]==null ? null : json["address"],
    company: json["company"]==null ? null : json["company"],
    acUser:json["acUser"]==null ? null :  json["acUser"],
    acStatus: json["acStatus"]==null ? null : json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorCode": vendorCode,
    "vendorName": vendorName,
    "city": city,
    "mobileNo": mobileNo,
    "emailId": emailId,
    "address": address,
    "company": company,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
