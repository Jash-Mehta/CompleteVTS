// To parse this JSON data, do
//
//     final searchDriverwiseVehRpt = searchDriverwiseVehRptFromJson(jsonString);

import 'dart:convert';

SearchDriverwiseVehRpt searchDriverwiseVehRptFromJson(String str) =>
    SearchDriverwiseVehRpt.fromJson(json.decode(str));

String searchDriverwiseVehRptToJson(SearchDriverwiseVehRpt data) =>
    json.encode(data.toJson());

class SearchDriverwiseVehRpt {
  SearchDriverwiseVehRpt({
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
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<Searchdetaildriverwise>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory SearchDriverwiseVehRpt.fromJson(Map<String, dynamic> json) =>
      SearchDriverwiseVehRpt(
        pageNumber: json["pageNumber"]??0,
        pageSize: json["pageSize"]??0,
        firstPage: json["firstPage"]??"",
        lastPage: json["lastPage"]??"",
        totalPages: json["totalPages"]??0,
        totalRecords: json["totalRecords"]??0,
        nextPage: json["nextPage"]??"",
        previousPage: json["previousPage"]??"",
        data: json["data"] == null
            ? []
            : List<Searchdetaildriverwise>.from(json["data"]!.map((x) {
              print("Search data of X-----------$x");

          return Searchdetaildriverwise.fromJson(x);

            })),
        succeeded: json["succeeded"]??false,
        errors: json["errors"]??"",
        message: json["message"]??"",
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
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "succeeded": succeeded,
        "errors": errors,
        "message": message,
      };
}

class Searchdetaildriverwise {
  Searchdetaildriverwise({
    this.vsrNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.vehicleRegNo,
    this.vehicleName,
    this.driverSrNo,
    this.driverCode,
    this.driverName,
    this.mobileNo,
    this.acUser,
    this.acStatus,
  });

  int? vsrNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? vehicleRegNo;
  String? vehicleName;
  int? driverSrNo;
  String? driverCode;
  String? driverName;
  String? mobileNo;
  String? acUser;
  String? acStatus;

  factory Searchdetaildriverwise.fromJson(Map<String, dynamic> json) => Searchdetaildriverwise(
        vsrNo: json["vsrNo"]??0,
        vendorSrNo: json["vendorSrNo"]??0,
        vendorName: json["vendorName"]??"",
        branchSrNo: json["branchSrNo"]??0,
        branchName: json["branchName"]??'',
        vehicleRegNo: json["vehicleRegNo"]??"",
        vehicleName: json["vehicleName"]??"",
        driverSrNo: json["driverSrNo"]??0,
        driverCode: json["driverCode"]??"",
        driverName: json["driverName"]??"",
        mobileNo: json["mobileNo"]??"",
        acUser: json["acUser"]??"",
        acStatus: json["acStatus"]??"",
      );

  Map<String, dynamic> toJson() => {
        "vsrNo": vsrNo,
        "vendorSrNo": vendorSrNo,
        "vendorName": vendorName,
        "branchSrNo": branchSrNo,
        "branchName": branchName,
        "vehicleRegNo": vehicleRegNo,
        "vehicleName": vehicleName,
        "driverSrNo": driverSrNo,
        "driverCode": driverCode,
        "driverName": driverName,
        "mobileNo": mobileNo,
        "acUser": acUser,
        "acStatus": acStatus,
      };
}
