// To parse this JSON data, do
//
//     final searchDriverMasterRpt = searchDriverMasterRptFromJson(jsonString);

import 'dart:convert';

SearchDriverMasterRpt searchDriverMasterRptFromJson(String str) => SearchDriverMasterRpt.fromJson(json.decode(str));

String searchDriverMasterRptToJson(SearchDriverMasterRpt data) => json.encode(data.toJson());

class SearchDriverMasterRpt {
    SearchDriverMasterRpt({
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
    List<FindDriverMasterData>? data;
    bool? succeeded;
    String? errors;
    String? message;

    factory SearchDriverMasterRpt.fromJson(Map<String, dynamic> json) => SearchDriverMasterRpt(
        pageNumber: json["pageNumber"]??0,
        pageSize: json["pageSize"]??0,
        firstPage: json["firstPage"]??"",
        lastPage: json["lastPage"]??"",
        totalPages: json["totalPages"]??0,
        totalRecords: json["totalRecords"]??0,
        nextPage: json["nextPage"]??"",
        previousPage: json["previousPage"]??"",
        data: json["data"] == null ? [] : List<FindDriverMasterData>.from(json["data"]!.map((x) => FindDriverMasterData.fromJson(x))),
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
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "succeeded": succeeded,
        "errors": errors,
        "message": message,
    };
}

class FindDriverMasterData {
    FindDriverMasterData({
        this.srNo,
        this.vendorSrNo,
        this.vendorName,
        this.branchSrNo,
        this.branchName,
        this.driverCode,
        this.driverName,
        this.licenceNo,
        this.city,
        this.mobileNo,
        this.doj,
        this.driverAddress,
        this.acUser,
        this.acStatus,
    });

    int? srNo;
    int? vendorSrNo;
    String? vendorName;
    int? branchSrNo;
    String? branchName;
    String? driverCode;
    String? driverName;
    String? licenceNo;
    String? city;
    String? mobileNo;
    DateTime? doj;
    String? driverAddress;
    String? acUser;
    String? acStatus;

    factory FindDriverMasterData.fromJson(Map<String, dynamic> json) => FindDriverMasterData(
        srNo: json["srNo"]??0,
        vendorSrNo: json["vendorSrNo"]??0,
        vendorName: json["vendorName"]??"",
        branchSrNo: json["branchSrNo"]??0,
        branchName: json["branchName"]??"",
        driverCode: json["driverCode"]??"",
        driverName: json["driverName"]??"",
        licenceNo: json["licenceNo"]??"",
        city: json["city"]??"",
        mobileNo: json["mobileNo"]??"",
        doj: json["doj"] == null ? null : DateTime.parse(json["doj"]),
        driverAddress: json["driverAddress"]??"",
        acUser: json["acUser"]??"",
        acStatus: json["acStatus"]??"",
    );

    Map<String, dynamic> toJson() => {
        "srNo": srNo,
        "vendorSrNo": vendorSrNo,
        "vendorName": vendorName,
        "branchSrNo": branchSrNo,
        "branchName": branchName,
        "driverCode": driverCode,
        "driverName": driverName,
        "licenceNo": licenceNo,
        "city": city,
        "mobileNo": mobileNo,
        "doj": doj?.toIso8601String(),
        "driverAddress": driverAddress,
        "acUser": acUser,
        "acStatus": acStatus,
    };
}
