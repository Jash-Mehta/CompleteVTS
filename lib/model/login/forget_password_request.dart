// To parse this JSON data, do
//
//     final forgetPasswordRequest = forgetPasswordRequestFromJson(jsonString);

import 'dart:convert';

ForgetPasswordRequest forgetPasswordRequestFromJson(String str) => ForgetPasswordRequest.fromJson(json.decode(str));

String forgetPasswordRequestToJson(ForgetPasswordRequest data) => json.encode(data.toJson());

class ForgetPasswordRequest {
  ForgetPasswordRequest({
    this.userId,
    this.vendorSrNo,
    this.branchSrNo,
    this.newPassword,
    this.confirmPassword,
  });

  int? userId;
  int ?vendorSrNo;
  int ?branchSrNo;
  String? newPassword;
  String ?confirmPassword;

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) => ForgetPasswordRequest(
    userId: json["userId"],
    vendorSrNo: json["vendorSrNo"],
    branchSrNo: json["branchSrNo"],
    newPassword: json["newPassword"],
    confirmPassword: json["confirmPassword"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "newPassword": newPassword,
    "confirmPassword": confirmPassword,
  };
}

//---------------------------------------------------------------



ResetPasswordRequest rorgetPasswordRequestFromJson(String str) => ResetPasswordRequest.fromJson(json.decode(str));

String resetPasswordRequestToJson(ResetPasswordRequest data) => json.encode(data.toJson());

class ResetPasswordRequest {
  ResetPasswordRequest({
    this.userId,
    this.vendorSrNo,
    this.branchSrNo,
    this.resetBy,
    // this.confirmPassword,
  });

  int? userId;
  int ?vendorSrNo;
  int ?branchSrNo;
  String? resetBy;
  // String ?confirmPassword;

  factory ResetPasswordRequest.fromJson(Map<String, dynamic> json) => ResetPasswordRequest(
    userId: json["userId"],
    vendorSrNo: json["vendorSrNo"],
    branchSrNo: json["branchSrNo"],
    resetBy: json["resetBy"],
    // confirmPassword: json["confirmPassword"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "resetBy": resetBy,
    // "confirmPassword": confirmPassword,
  };
}
