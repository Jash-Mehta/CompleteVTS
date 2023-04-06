// To parse this JSON data, do
//
//     final editBranchRequest = editBranchRequestFromJson(jsonString);

import 'dart:convert';

EditBranchRequest editBranchRequestFromJson(String str) => EditBranchRequest.fromJson(json.decode(str));

String editBranchRequestToJson(EditBranchRequest data) => json.encode(data.toJson());

class EditBranchRequest {
  EditBranchRequest({
    this.srNo,
    this.vendorSrNo,
    this.branchCode,
    this.branchName,
    this.city,
    this.mobileNo,
    this.emailId,
    this.phoneNo,
    this.address,
    this.acUser,
    this.acStatus,
  });

  int ?srNo;
  int ?vendorSrNo;
  String? branchCode;
  String ?branchName;
  String ?city;
  String ?mobileNo;
  String ?emailId;
  dynamic? phoneNo;
  String ?address;
  String ?acUser;
  String ?acStatus;

  factory EditBranchRequest.fromJson(Map<String, dynamic> json) => EditBranchRequest(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    branchCode: json["branchCode"],
    branchName: json["branchName"],
    city: json["city"],
    mobileNo: json["mobileNo"],
    emailId: json["emailId"],
    phoneNo: json["phoneNo"],
    address: json["address"],
    acUser: json["acUser"],
    acStatus: json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "branchCode": branchCode,
    "branchName": branchName,
    "city": city,
    "mobileNo": mobileNo,
    "emailId": emailId,
    "phoneNo": phoneNo,
    "address": address,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
