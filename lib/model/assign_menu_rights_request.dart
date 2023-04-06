// To parse this JSON data, do
//
//     final assignMenuRightsResponse = assignMenuRightsResponseFromJson(jsonString);

import 'dart:convert';

AssignMenuRightsRequest assignMenuRightsRquestFromJson(String str) => AssignMenuRightsRequest.fromJson(json.decode(str));

String assignMenuRightsRequestToJson(AssignMenuRightsRequest data) => json.encode(data.toJson());

class AssignMenuRightsRequest {
  AssignMenuRightsRequest({
    this.vendorSrNo,
    this.branchSrNo,
    this.updatedBy,
    this.userList,
    this.menuList,
  });

  int ?vendorSrNo;
  int ?branchSrNo;
  String? updatedBy;
  List<UserList>? userList;
  List<MenuList>? menuList;

  factory AssignMenuRightsRequest.fromJson(Map<String, dynamic> json) => AssignMenuRightsRequest(
    vendorSrNo: json["vendorSrNo"]==null ? null :json["vendorSrNo"],
    branchSrNo:json["branchSrNo"]==null ? null : json["userId"]==null ? null :json["branchSrNo"],
    updatedBy: json["updatedBy"]==null ? null :json["updatedBy"],
    userList:json["userList"]==null ? null : List<UserList>.from(json["userList"].map((x) => UserList.fromJson(x))),
    menuList: json["menuList"]==null ? null :List<MenuList>.from(json["menuList"].map((x) => MenuList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "updatedBy": updatedBy,
    "userList": List<dynamic>.from(userList!.map((x) => x.toJson())),
    "menuList": List<dynamic>.from(menuList!.map((x) => x.toJson())),
  };
}

class MenuList {
  MenuList({
    this.menuId,
  });

  int ?menuId;

  factory MenuList.fromJson(Map<String, dynamic> json) => MenuList(
    menuId: json["menuId"]==null ? null :json["menuId"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
  };
}

class UserList {
  UserList({
    this.userId,
  });

  int? userId;

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
    userId: json["userId"]==null ? null : json["userId"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
  };
}


