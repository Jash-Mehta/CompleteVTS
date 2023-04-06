// To parse this JSON data, do
//
//     final addSubscriptionResponse = addSubscriptionResponseFromJson(jsonString);

import 'dart:convert';

EditSubscriptionRequest editSubscriptionRequestFromJson(String str) => EditSubscriptionRequest.fromJson(json.decode(str));

String editSubscriptionRequestToJson(EditSubscriptionRequest data) => json.encode(data.toJson());

class EditSubscriptionRequest {
  EditSubscriptionRequest({
    this.srNo,
    this.vendorSrNo,
    this.branchSrNo,
    this.userId,
    this.validFrom,
    this.validTill,
    this.acUser,
    this.acStatus,
  });

  int? srNo;
  int ?vendorSrNo;
  int ?branchSrNo;
  int ?userId;
  String? validFrom;
  String? validTill;
  String ?acUser;
  String ?acStatus;

  factory EditSubscriptionRequest.fromJson(Map<String, dynamic> json) => EditSubscriptionRequest(
    srNo: json["srNo"]==null ?  null :json["srNo"],
    vendorSrNo: json["vendorSrNo"]==null ?  null :json["vendorSrNo"],
    branchSrNo: json["branchSrNo"]==null ?  null :json["branchSrNo"],
    userId:json["userId"]==null ?  null : json["userId"],
    validFrom: json["validFrom"]==null ?  null :json["validFrom"],
    validTill: json["validTill"]==null ?  null :json["validTill"],
    acUser:json["acUser"]==null ?  null : json["acUser"],
    acStatus:json["acStatus"]==null ?  null : json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "userId": userId,
    "validFrom": validFrom,
    "validTill": validTill,
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
