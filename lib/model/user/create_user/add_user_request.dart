// To parse this JSON data, do
//
//     final addUserRequest = addUserRequestFromJson(jsonString);

import 'dart:convert';

AddUserRequest addUserRequestFromJson(String str) => AddUserRequest.fromJson(json.decode(str));

String addUserRequestToJson(AddUserRequest data) => json.encode(data.toJson());

class AddUserRequest {
  AddUserRequest({
    this.userId,
    this.userName,
    this.vendorSrNo,
    this.branchSrNo,
    this.userPwd,
    this.userType,
    this.emailId,
    this.acUser,
    this.acFlag,
    this.validFrom,
    this.validTill,
    this.profilePhoto,
    this.vehicleList,
    this.menuList,
  });

  int ?userId;
  String ?userName;
  int ?vendorSrNo;
  int? branchSrNo;
  String ?userPwd;
  String ?userType;
  String? emailId;
  String ?acUser;
  String? acFlag;
  String ?validFrom;
  String? validTill;
  String? profilePhoto;
  List<VehicleList> ?vehicleList;
  List<MenuList> ?menuList;

  factory AddUserRequest.fromJson(Map<String, dynamic> json) => AddUserRequest(
    userId: json["userId"]==null ? null :json["userId"],
    userName:json["userName"]==null ? null : json["userName"],
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    userPwd: json["userPwd"]==null ? null :json["userPwd"],
    // userType:json["userType"]==null ? null : json["userType"],
    userType:json["userTypeId"]==null ? null : json["userTypeId"],
    emailId: json["emailId"]==null ? null :json["emailId"],
    acUser:json["acUser"]==null ? null : json["acUser"],
    acFlag:json["acFlag"]==null ? null : json["acFlag"],
    validFrom: json["validFrom"]==null ? null : json["validFrom"]/*DateTime.parse(json["validFrom"])*/,
    validTill: json["validTill"]==null ? null : json["validTill"]/*DateTime.parse(json["validTill"])*/,
    profilePhoto:json["profilePhoto"]==null ? null : json["profilePhoto"],
    vehicleList: json["vehicleList"]==null ? null :List<VehicleList>.from(json["vehicleList"].map((x) => VehicleList.fromJson(x))),
    menuList:json["menuList"]==null ? null : List<MenuList>.from(json["menuList"].map((x) => MenuList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "userPwd": userPwd,
    "userTypeId": userType,
    // "userType": userType,
    "emailId": emailId,
    "acUser": acUser,
    "acFlag": acFlag,
    "validFrom": validFrom,
    "validTill": validTill,
    "profilePhoto": profilePhoto,
    "vehicleList": List<dynamic>.from(vehicleList!.map((x) => x.toJson())),
    "menuList": List<dynamic>.from(menuList!.map((x) => x.toJson())),
  };
}

class MenuList {
  MenuList({
    this.menuId,
    this.menuCaption,

  });

  int ?menuId;
  String ?menuCaption;

  factory MenuList.fromJson(Map<String, dynamic> json) => MenuList(
    menuId: json["menuId"]==null ? null : json["menuId"],
    menuCaption: json["menuCaption"]==null ? null : json["menuCaption"],

  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuCaption": menuCaption,

  };
}

class VehicleList {
  VehicleList({
    this.vehicleId,
    this.vehicleRegNo
  });

  int ?vehicleId;
  String ?vehicleRegNo;

  factory VehicleList.fromJson(Map<String, dynamic> json) => VehicleList(
    vehicleId: json["vehicleId"]==null ? null : json["vehicleId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null : json["vehicleRegNo"],

  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    'vehicleRegNo':vehicleRegNo,
  };
}
