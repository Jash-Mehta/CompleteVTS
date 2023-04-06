// To parse this JSON data, do
//
//     final branchResponse = branchResponseFromJson(jsonString);

import 'dart:convert';

BranchResponse branchResponseFromJson(String str) => BranchResponse.fromJson(json.decode(str));

String branchResponseToJson(BranchResponse data) => json.encode(data.toJson());

class BranchResponse {
  BranchResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<BranchDatum> ?data;
  bool? succeeded;
  dynamic? errors;
  String ?message;

  factory BranchResponse.fromJson(Map<String, dynamic> json) => BranchResponse(
    data: json["data"]==null ? null :List<BranchDatum>.from(json["data"].map((x) => BranchDatum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message:json["message"]==null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class BranchDatum {
  BranchDatum({
    this.branchId,
    this.branchName,
  });

  dynamic? branchId;
  String? branchName;

  factory BranchDatum.fromJson(Map<String, dynamic> json) => BranchDatum(
    branchId: json["branchId"]==null ? null :json["branchId"],
    branchName: json["branchName"]==null ? null :json["branchName"],
  );

  Map<String, dynamic> toJson() => {
    "branchId": branchId,
    "branchName": branchName,
  };
}
