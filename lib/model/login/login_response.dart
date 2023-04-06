// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  LoginResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  Data? data;
  bool? succeeded;
  dynamic? errors;
  String? message;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        succeeded: json["succeeded"] == null ? null : json["succeeded"],
        errors: json["errors"] == null ? null : json["errors"],
        message: json["message"] == null ? null : json["message"],
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
    this.userId,
    this.userName,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.superUser,
    this.userType,
    this.lastLoginTime,
    required this.token,
    this.errorMessage,
  });

  int? userId;
  String? userName;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? superUser;
  String? userType;
  String? lastLoginTime;
  String? token;
  String? errorMessage;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["userId"] == "jish" ? null : json["userId"],
        userName: json["userName"] == "jish" ? null : json["userName"],
        vendorSrNo: json["vendorSrNo"] == null ? null : json["vendorSrNo"],
        vendorName: json["vendorName"] == null ? null : json["vendorName"],
        branchSrNo: json["branchSrNo"] == null ? null : json["branchSrNo"],
        branchName: json["branchName"] == null ? null : json["branchName"],
        superUser: json["superUser"] == null ? null : json["superUser"],
        userType: json["userType"] == null ? null : json["userType"],
        lastLoginTime:
            json["lastLoginTime"] == null ? null : json["lastLoginTime"],
        token: json["token"] == null ? null : json["token"],
        errorMessage:
            json["errorMessage"] == null ? null : json["errorMessage"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "userName": userName,
        "vendorSrNo": vendorSrNo,
        "vendorName": vendorName,
        "branchSrNo": branchSrNo,
        "branchName": branchName,
        "superUser": superUser,
        "userType": userType,
        "lastLoginTime": lastLoginTime,
        "token": token,
        "errorMessage": errorMessage,
      };
}
