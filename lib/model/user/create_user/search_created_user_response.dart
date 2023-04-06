// To parse this JSON data, do
//
//     final searchCreatedUserResponse = searchCreatedUserResponseFromJson(jsonString);

import 'dart:convert';

SearchCreatedUserResponse searchCreatedUserResponseFromJson(String str) => SearchCreatedUserResponse.fromJson(json.decode(str));

String searchCreatedUserResponseToJson(SearchCreatedUserResponse data) => json.encode(data.toJson());

class SearchCreatedUserResponse {
  SearchCreatedUserResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory SearchCreatedUserResponse.fromJson(Map<String, dynamic> json) => SearchCreatedUserResponse(
    data: json["data"]==null ?  null :List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    succeeded:  json["message"]==null ?  null :json["succeeded"],
    errors: json["message"]==null ?  null : json["message"],
    message:  json["message"]==null ?  null :json["message"],
  );

  Map<String, dynamic> toJson() => {
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

  int ?userId;
  String ?userName;
  int ?vendorSrNo;
  String ?vendorName;
  int? branchSrNo;
  String ?branchName;
  String ?userPwd;
  int? userTypeId;
  String ?userType;
  String ?emailId;
  String ?acUser;
  String ?acFlag;
  DateTime? validFrom;
  DateTime? validTill;
  List<VehicleSelectedList> ?vehicleList;
  List<MenuSelectedList> ?menuList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId:  json["userId"]==null ?  null :json["userId"],
    userName: json["userName"]==null ?  null : json["userName"],
    vendorSrNo:  json["vendorSrNo"]==null ?  null :json["vendorSrNo"],
    vendorName:  json["vendorName"]==null ?  null :json["vendorName"],
    branchSrNo:  json["branchSrNo"]==null ?  null :json["branchSrNo"],
    branchName: json["branchName"]==null ?  null : json["branchName"],
    userPwd:  json["userPwd"]==null ?  null :json["userPwd"],
    userTypeId:  json["userTypeId"]==null ?  null: json["userTypeId"],
    userType:  json["userType"]==null ?  null :json["userType"],
    emailId:  json["emailId"]==null ?  null :json["emailId"],
    acUser:  json["acUser"]==null ?  null :json["acUser"],
    acFlag:  json["acFlag"]==null ?  null :json["acFlag"],
    validFrom:  json["validFrom"]==null ?  null :DateTime.parse(json["validFrom"]),
    validTill:  json["validTill"]==null ?  null :DateTime.parse(json["validTill"]),
    vehicleList:  json["vehicleList"]==null ?  null :List<VehicleSelectedList>.from(json["vehicleList"].map((x) => VehicleSelectedList.fromJson(x))),
    menuList: json["menuList"]==null ?  null : List<MenuSelectedList>.from(json["menuList"].map((x) => MenuSelectedList.fromJson(x))),
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

class MenuSelectedList {
  MenuSelectedList({
    this.menuId,
    this.menuCaption,
  });

  int? menuId;
  String ?menuCaption;

  factory MenuSelectedList.fromJson(Map<String, dynamic> json) => MenuSelectedList(
    menuId:  json["menuId"]==null ?  null :json["menuId"],
    menuCaption:  json["menuCaption"]==null ?  null :json["menuCaption"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuCaption": menuCaption,
  };
}

class VehicleSelectedList {
  VehicleSelectedList({
    this.vehicleId,
    this.vehicleRegNo,
  });

  int ?vehicleId;
  String ?vehicleRegNo;

  factory VehicleSelectedList.fromJson(Map<String, dynamic> json) => VehicleSelectedList(
    vehicleId: json["vehicleId"]==null ?  null : json["vehicleId"],
    vehicleRegNo:  json["vehicleRegNo"]==null ?  null :json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vehicleId": vehicleId,
    "vehicleRegNo": vehicleRegNo,
  };
}










/*
class SearchCreatedUserResponse {
  List<Data>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  SearchCreatedUserResponse(
      {this.data, this.succeeded, this.errors, this.message});

  SearchCreatedUserResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    errors = json['errors'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  int? userId;
  String? userName;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? userPwd;
  String? userType;
  String? emailId;
  String? acUser;
  String? acFlag;
  String? validFrom;
  String? validTill;
  List<VehicleSelectedList>? vehicleList;
  List<MenuSelectedList>? menuList;

  Data(
      {this.userId,
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
        this.menuList});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    userPwd = json['userPwd'];
    userType = json['userType'];
    emailId = json['emailId'];
    acUser = json['acUser'];
    acFlag = json['acFlag'];
    // validFrom= json["validFrom"]==null ? null :DateTime.parse(json["validFrom"]);
    // validTill=json["validTill"]==null ? null : DateTime.parse(json["validTill"]);
    validFrom = json['validFrom'];
    validTill = json['validTill'];

    if (json['vehicleList'] != null) {
      vehicleList = <VehicleSelectedList>[];
      json['vehicleList'].forEach((v) {
        vehicleList!.add(new VehicleSelectedList.fromJson(v));
      });
    }
    if (json['menuList'] != null) {
      menuList = <MenuSelectedList>[];
      json['menuList'].forEach((v) {
        menuList!.add(new MenuSelectedList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['userPwd'] = this.userPwd;
    data['userType'] = this.userType;
    data['emailId'] = this.emailId;
    data['acUser'] = this.acUser;
    data['acFlag'] = this.acFlag;
    data['validFrom'] = this.validFrom!;
    data['validTill'] = this.validTill!;
    if (this.vehicleList != null) {
      data['vehicleList'] = this.vehicleList!.map((v) => v.toJson()).toList();
    }
    if (this.menuList != null) {
      data['menuList'] = this.menuList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleSelectedList {
  int? vehicleId;
  String? vehicleRegNo;

  VehicleSelectedList({this.vehicleId, this.vehicleRegNo});

  VehicleSelectedList.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicleId'];
    vehicleRegNo = json['vehicleRegNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleId'] = this.vehicleId;
    data['vehicleRegNo'] = this.vehicleRegNo;
    return data;
  }
}

class MenuSelectedList {
  int? menuId;
  String? menuCaption;

  MenuSelectedList({this.menuId, this.menuCaption});

  MenuSelectedList.fromJson(Map<String, dynamic> json) {
    menuId = json['menuId'];
    menuCaption = json['menuCaption'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuId'] = this.menuId;
    data['menuCaption'] = this.menuCaption;
    return data;
  }
}
*/
