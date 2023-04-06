// To parse this JSON data, do
//
//     final vendorNameResponse = vendorNameResponseFromJson(jsonString);

import 'dart:convert';

List<BranchNameResponse> BranchNameResponseFromJson(String str) => List<BranchNameResponse>.from(json.decode(str).map((x) => BranchNameResponse.fromJson(x)));

String branchNameResponseToJson(List<BranchNameResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchNameResponse {
  BranchNameResponse({
    this.branchId,
    this.branchName,
  });

  int? branchId;
  String ?branchName;

  factory BranchNameResponse.fromJson(Map<String, dynamic> json) => BranchNameResponse(
    branchId: json["branchId"]==null ? null : json["branchId"],
    branchName:json["branchName"]==null ? null :  json["branchName"],
  );

  Map<String, dynamic> toJson() => {
    "branchId": branchId,
    "branchName": branchName,
  };
}
