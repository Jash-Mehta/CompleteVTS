// To parse this JSON data, do
//
//     final getAllCreateUserResponse = getAllCreateUserResponseFromJson(jsonString);

import 'dart:convert';

GetAllCreateUserResponse getAllCreateUserResponseFromJson(String str) => GetAllCreateUserResponse.fromJson(json.decode(str));

String getAllCreateUserResponseToJson(GetAllCreateUserResponse data) => json.encode(data.toJson());

class GetAllCreateUserResponse {
  GetAllCreateUserResponse({
    this.pageNumber,
    this.pageSize,
    this.firstPage,
    this.lastPage,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int ?totalPages;
  int ?totalRecords;
  String? nextPage;
  dynamic ?previousPage;
  List<Datum> ?data;
  bool ?succeeded;
  dynamic? errors;
  dynamic ?message;

  factory GetAllCreateUserResponse.fromJson(Map<String, dynamic> json) => GetAllCreateUserResponse(
    pageNumber:json["pageNumber"]==null ? null : json["pageNumber"],
    pageSize: json["pageSize"]==null ? null :json["pageSize"],
    firstPage: json["firstPage"]==null ? null :json["firstPage"],
    lastPage:json["lastPage"]==null ? null : json["lastPage"],
    totalPages: json["totalPages"]==null ? null :json["totalPages"],
    totalRecords: json["totalRecords"]==null ? null :json["totalRecords"],
    nextPage: json["nextPage"]==null ? null :json["nextPage"],
    previousPage:json["previousPage"]==null ? null : json["previousPage"],
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message: json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "firstPage": firstPage,
    "lastPage": lastPage,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
    "nextPage": nextPage,
    "previousPage": previousPage,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datum {
  Datum({
    this.userId,
    this.userName,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.userPwd,
    this.userTypeId,
    this.userType,
    this.emailId,
    this.acUser,
    this.acFlag,
    this.validFrom,
    this.validTill,
    this.vehicleList,
    this.menuList,
  });

  int? userId;
  String ?userName;
  int ?vendorSrNo;
  String ?vendorName;
  int? branchSrNo;
  String ?branchName;
  String ?userPwd;
  int? userTypeId;
  String? userType;
  String? emailId;
  String ?acUser;
  String ?acFlag;
  DateTime ?validFrom;
  DateTime ?validTill;
  List<VehicleLists>? vehicleList;
  List<MenuLists>? menuList;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["userId"]==null ? null :json["userId"],
    userName: json["userName"]==null ? null :json["userName"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo:json["branchSrNo"]==null ? null : json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    userPwd:json["userPwd"]==null ? null : json["userPwd"],
    userTypeId: json["userTypeId"]==null ? null :json["userTypeId"],
    userType: json["userType"]==null ? null :json["userType"],
    emailId: json["emailId"]==null ? null :json["emailId"],
    acUser: json["acUser"]==null ? null :json["acUser"],
    acFlag: json["acFlag"]==null ? null :json["acFlag"],
    validFrom: json["validFrom"]==null ? null :DateTime.parse(json["validFrom"]),
    validTill:json["validTill"]==null ? null : DateTime.parse(json["validTill"]),
    vehicleList:json["vehicleList"]==null ? null : List<VehicleLists>.from(json["vehicleList"].map((x) => VehicleLists.fromJson(x))),
    menuList: json["menuList"]==null ? null :List<MenuLists>.from(json["menuList"].map((x) => MenuLists.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "userPwd": userPwd,
    "userTypeId": userTypeId,
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


class MenuLists {
  MenuLists({
    this.menuId,
    this.menuCaption,
  });

  int ?menuId;
  String? menuCaption;

  factory MenuLists.fromJson(Map<String, dynamic> json) => MenuLists(
    menuId: json["menuId"]==null ? null :json["menuId"],
    menuCaption: json["menuCaption"]==null ? null :json["menuCaption"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuCaption": menuCaption,
  };
}



class VehicleLists {
  VehicleLists({
    this.vehicleId,
    this.vehicleRegNo,
  });

  int ?vehicleId;
  String ?vehicleRegNo;

  factory VehicleLists.fromJson(Map<String, dynamic> json) => VehicleLists(
    vehicleId: json["vehicleId"]==null ? null :json["vehicleId"],
    vehicleRegNo: json["vehicleRegNo"]==null ? null :json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "vehicleRegNo": vehicleRegNo,
  };
}

