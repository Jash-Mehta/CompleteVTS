// To parse this JSON data, do
//
//     final addBranchRequest = addBranchRequestFromJson(jsonString);

import 'dart:convert';

AddBranchRequest addBranchRequestFromJson(String str) => AddBranchRequest.fromJson(json.decode(str));

String addBranchRequestToJson(AddBranchRequest data) => json.encode(data.toJson());

class AddBranchRequest {
  AddBranchRequest({
    this.vendorSrNo,
    this.branchCode,
    this.branchName,
    this.city,
    this.mobileNo,
    this.emailId,
    this.address,
    this.acUser,
    this.acStatus,
  });

  int ?vendorSrNo;
  String ?branchCode;
  String? branchName;
  String ?city;
  String ?mobileNo;
  String? emailId;
  String? address;
  String ?acUser;
  String ?acStatus;

  factory AddBranchRequest.fromJson(Map<String, dynamic> json) => AddBranchRequest(
    vendorSrNo: json["vendorSrNo"],
    branchCode: json["branchCode"],
    branchName: json["branchName"],
    city: json["city"],
    mobileNo: json["mobileNo"],
    emailId: json["emailId"],
    address: json["address"],
    acUser: json["acUser"],
    acStatus: json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "vendorSrNo": vendorSrNo,
    "branchCode": branchCode,
    "branchName": branchName,
    "city": city,
    "mobileNo": mobileNo,
    "emailId": emailId,
    "address": address,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
