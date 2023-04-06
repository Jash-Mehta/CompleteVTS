// To parse this JSON data, do
//
//     final allSubscriptionResponse = allSubscriptionResponseFromJson(jsonString);

import 'dart:convert';

AllSubscriptionResponse allSubscriptionResponseFromJson(String str) => AllSubscriptionResponse.fromJson(json.decode(str));

String allSubscriptionResponseToJson(AllSubscriptionResponse data) => json.encode(data.toJson());

class AllSubscriptionResponse {
  AllSubscriptionResponse({
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
  int ?pageSize;
  String ?firstPage;
  String ?lastPage;
  int ?totalPages;
  int ?totalRecords;
  String ?nextPage;
  dynamic? previousPage;
  List<Datum> ?data;
  bool? succeeded;
  dynamic ?errors;
  dynamic? message;

  factory AllSubscriptionResponse.fromJson(Map<String, dynamic> json) => AllSubscriptionResponse(
    pageNumber: json["pageNumber"]==null ? null :json["pageNumber"],
    pageSize: json["pageSize"]==null ? null :json["pageSize"],
    firstPage:json["firstPage"]==null ? null : json["firstPage"],
    lastPage: json["lastPage"]==null ? null :json["lastPage"],
    totalPages:json["totalPages"]==null ? null : json["totalPages"],
    totalRecords: json["totalRecords"]==null ? null :json["totalRecords"],
    nextPage: json["nextPage"]==null ? null :json["nextPage"],
    previousPage:json["previousPage"]==null ? null : json["previousPage"],
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
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
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.userId,
    this.userName,
    this.validFrom,
    this.validTill,
    this.acUser,
    this.acStatus,
  });

  int? srNo;
  int ?vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String? branchName;
  int? userId;
  String ?userName;
  DateTime? validFrom;
  DateTime ?validTill;
  String? acUser;
  String ?acStatus;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["srNo"]==null ? null :json["srNo"],
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName:json["vendorName"]==null ? null : json["vendorName"],
    branchSrNo:json["branchSrNo"]==null ? null : json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    userId:json["userId"]==null ? null : json["userId"],
    userName: json["userName"]==null ? null :json["userName"],
    validFrom: json["validFrom"]==null ? null :DateTime.parse(json["validFrom"]),
    validTill: json["validTill"]==null ? null :DateTime.parse(json["validTill"]),
    acUser:json["acUser"]==null ? null : json["acUser"],
    acStatus: json["acStatus"]==null ? null :json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName":vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "userId": userId,
    "userName": userName,
    "validFrom": validFrom!.toIso8601String(),
    "validTill": validTill!.toIso8601String(),
    "acUser": acUser,
    "acStatus": acStatus,
  };
}

// ----------------------------------------------------

// To parse this JSON data, do
//
//     final searchSubscriptionResponse = searchSubscriptionResponseFromJson(jsonString);

// import 'dart:convert';

SearchSubscriptionResponse searchSubscriptionResponseFromJson(String str) => SearchSubscriptionResponse.fromJson(json.decode(str));

String searchSubscriptionResponseToJson(SearchSubscriptionResponse data) => json.encode(data.toJson());

class SearchSubscriptionResponse {
  SearchSubscriptionResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Data>? data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory SearchSubscriptionResponse.fromJson(Map<String, dynamic> json) => SearchSubscriptionResponse(
    data: List<Data>.from(json["data"].map((x) => Data.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
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
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.userId,
    this.userName,
    this.validFrom,
    this.validTill,
    this.acUser,
    this.acStatus,
  });

  int ?srNo;
  int ?vendorSrNo;
  String? vendorName;
  int ?branchSrNo;
  String? branchName;
  int ?userId;
  String? userName;
  DateTime? validFrom;
  DateTime ?validTill;
  String ?acUser;
  String ?acStatus;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    userId: json["userId"],
    userName: json["userName"],
    validFrom: DateTime.parse(json["validFrom"]),
    validTill: DateTime.parse(json["validTill"]),
    acUser: json["acUser"],
    acStatus: json["acStatus"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "userId": userId,
    "userName": userName,
    "validFrom": validFrom!.toIso8601String(),
    "validTill": validTill!.toIso8601String(),
    "acUser": acUser,
    "acStatus": acStatus,
  };
}
