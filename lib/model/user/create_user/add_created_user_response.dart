// To parse this JSON data, do
//
//     final addCreatedUserResponse = addCreatedUserResponseFromJson(jsonString);

import 'dart:convert';

AddCreatedUserResponse addCreatedUserResponseFromJson(String str) => AddCreatedUserResponse.fromJson(json.decode(str));

String addCreatedUserResponseToJson(AddCreatedUserResponse data) => json.encode(data.toJson());

class AddCreatedUserResponse {
  AddCreatedUserResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool? succeeded;
  dynamic? errors;
  String? message;

  factory AddCreatedUserResponse.fromJson(Map<String, dynamic> json) => AddCreatedUserResponse(
    // data: json["data"]==null ? null :Data.fromJson(json["data"]),
    data: json["data"]==null ? null :List<Data>.from(json["data"].map((x) => Data.fromJson(x))),

    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message: json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    // "data": data!.toJson(),
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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
    this.userPwd,
    this.userType,
    this.emailId,
    this.acUser,
    this.acFlag,
    this.validFrom,
    this.validTill,
    this.vehicleList,
    this.menuList,
  });

  int ?userId;
  String? userName;
  int? vendorSrNo;
  String ?vendorName;
  int? branchSrNo;
  String ?branchName;
  String ?userPwd;
  String ?userType;
  String ?emailId;
  String? acUser;
  String ?acFlag;
  DateTime? validFrom;
  DateTime ?validTill;
  List<VehiclesList> ?vehicleList;
  List<MenusList> ?menuList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["userId"]==null ? null :json["userId"],
    userName: json["userName"]==null ? null :json["userName"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName:json["branchName"]==null ? null : json["branchName"],
    userPwd: json["userPwd"]==null ? null :json["userPwd"],
    userType:json["userType"]==null ? null : json["userType"],
    emailId: json["emailId"]==null ? null :json["emailId"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acFlag: json["acFlag"]==null ? null :json["acFlag"],
    validFrom:json["validFrom"]==null ? null : DateTime.parse(json["validFrom"]),
    validTill: DateTime.parse(json["validTill"]),
    vehicleList:json["vehicleList"]==null ? null : List<VehiclesList>.from(json["vehicleList"].map((x) => VehiclesList.fromJson(x))),
    menuList: json["menuList"]==null ? null :List<MenusList>.from(json["menuList"].map((x) => MenusList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "userPwd": userPwd,
    "userType": userType,
    "emailId": emailId,
    "acUser": acUser,
    "acFlag": acFlag,
    "validFrom": validFrom!.toIso8601String(),
    "validTill": validTill!.toIso8601String(),
    "vehicleList": List<dynamic>.from(vehicleList!.map((x) => x.toJson())),
    "menuList": List<dynamic>.from(menuList!.map((x) => x.toJson())),
  };
}

class MenusList {
  MenusList({
    this.menuId,
    this.menuCaption,
  });

  int ?menuId;
  String ?menuCaption;

  factory MenusList.fromJson(Map<String, dynamic> json) => MenusList(
    menuId: json["menuId"]==null ? null :json["menuId"],
    menuCaption:json["menuCaption"]==null ? null : json["menuCaption"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuCaption": menuCaption,
  };
}

class VehiclesList {
  VehiclesList({
    this.vehicleId,
    this.vehicleRegNo,
  });

  int ?vehicleId;
  String? vehicleRegNo;

  factory VehiclesList.fromJson(Map<String, dynamic> json) => VehiclesList(
    vehicleId:  json["vehicleId"]==null ? null : json["vehicleId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "vehicleRegNo": vehicleRegNo,
  };
}
