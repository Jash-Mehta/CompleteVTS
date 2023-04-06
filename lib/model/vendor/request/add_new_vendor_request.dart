// To parse this JSON data, do
//
//     final addNewVendorRequest = addNewVendorRequestFromJson(jsonString);

import 'dart:convert';

AddNewVendorRequest addNewVendorRequestFromJson(String str) => AddNewVendorRequest.fromJson(json.decode(str));

String addNewVendorRequestToJson(AddNewVendorRequest data) => json.encode(data.toJson());

class AddNewVendorRequest {
  AddNewVendorRequest({
    // this.srno,
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

  // int ?srno;

  String ?vendorCode;
  String ?vendorName;
  String? city;
  String? mobileNo;
  String ?emailId;
  String ?address;
  String ?company;
  String? acUser;
  String ?acStatus;

  factory AddNewVendorRequest.fromJson(Map<String, dynamic> json) => AddNewVendorRequest(
    // srno:json["srNo"]==null ? null :  json["srNo"],
    vendorCode:json["vendorCode"]==null ? null :  json["vendorCode"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    city:json["city"]==null ? null :  json["city"],
    mobileNo: json["mobileNo"]==null ? null : json["mobileNo"],
    emailId: json["emailId"]==null ? null : json["emailId"],
    address: json["address"]==null ? null : json["address"],
    company: json["company"]==null ? null : json["company"],
    acUser: json["acUser"]==null ? null : json["acUser"],
    acStatus: json["acStatus"]==null ? null : json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    // "srNo": vendorCode,
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
