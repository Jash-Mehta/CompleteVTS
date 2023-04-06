
// To parse this JSON data, do
//
//     final addNewVendorRequest = addNewVendorRequestFromJson(jsonString);

import 'dart:convert';

EditVendorRequest editVendorRequestFromJson(String str) => EditVendorRequest.fromJson(json.decode(str));

String editVendorRequestToJson(EditVendorRequest data) => json.encode(data.toJson());

class EditVendorRequest {
  EditVendorRequest({
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
  String? city;
  String? mobileNo;
  String ?emailId;
  String ?phoneNo;
  String ?address;
  String ?company;
  String? acUser;
  String ?acDate;
  String ?modifiedBy;
  String ?acStatus;

  factory EditVendorRequest.fromJson(Map<String, dynamic> json) => EditVendorRequest(
    srNo:json["vendorCode"]==null ? null :  json["srNo"],
    vendorCode:json["vendorCode"]==null ? null :  json["vendorCode"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
    city:json["city"]==null ? null :  json["city"],
    mobileNo: json["mobileNo"]==null ? null : json["mobileNo"],
    emailId: json["emailId"]==null ? null : json["emailId"],
    phoneNo: json["phoneNo"]==null ? null : json["phoneNo"],
    address: json["address"]==null ? null : json["address"],
    company: json["company"]==null ? null : json["company"],
    acUser: json["acUser"]==null ? null : json["acUser"],
    acDate: json["acDate"]==null ? null : json["acDate"],
    modifiedBy:json["modifiedBy"]==null ? null :  json["modifiedBy"],
    acStatus: json["acStatus"]==null ? null : json["acStatus"],
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
    "acDate": acDate,
    "modifiedBy": modifiedBy,
    "acStatus": acStatus,
  };
}
