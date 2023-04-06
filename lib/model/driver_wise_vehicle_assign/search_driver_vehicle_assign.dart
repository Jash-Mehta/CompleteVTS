// To parse this JSON data, do
//
//     final driverWiseVehicleAssignSearch = driverWiseVehicleAssignSearchFromJson(jsonString);

import 'dart:convert';

DriverWiseVehicleAssignSearch driverWiseVehicleAssignSearchFromJson(String str) => DriverWiseVehicleAssignSearch.fromJson(json.decode(str));

String driverWiseVehicleAssignSearchToJson(DriverWiseVehicleAssignSearch data) => json.encode(data.toJson());

class DriverWiseVehicleAssignSearch {
    DriverWiseVehicleAssignSearch({
        required this.pageNumber,
        required this.pageSize,
        required this.firstPage,
        required this.lastPage,
        required this.totalPages,
        required this.totalRecords,
        this.nextPage,
        this.previousPage,
        required this.data,
        required this.succeeded,
        this.errors,
        this.message,
    });

    int pageNumber;
    int pageSize;
    String firstPage;
    String lastPage;
    int totalPages;
    int totalRecords;
    dynamic nextPage;
    dynamic previousPage;
    List<SearchData> data;
    bool succeeded;
    dynamic errors;
    dynamic message;

    factory DriverWiseVehicleAssignSearch.fromJson(Map<String, dynamic> json) => DriverWiseVehicleAssignSearch(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        firstPage: json["firstPage"],
        lastPage: json["lastPage"],
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        data: List<SearchData>.from(json["data"].map((x) => SearchData.fromJson(x))),
        succeeded: json["succeeded"],
        errors: json["errors"],
        message: json["message"],
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
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "succeeded": succeeded,
        "errors": errors,
        "message": message,
    };
}

class SearchData {
    SearchData({
        required this.vsrNo,
        required this.vendorSrNo,
        required this.vendorName,
        required this.branchSrNo,
        required this.branchName,
        required this.vehicleRegNo,
        required this.vehicleName,
        required this.driverSrNo,
        required this.driverCode,
        required this.driverName,
        required this.mobileNo,
        required this.acUser,
        required this.acStatus,
    });

    int vsrNo;
    int vendorSrNo;
    String vendorName;
    int branchSrNo;
    String branchName;
    String vehicleRegNo;
    String vehicleName;
    int driverSrNo;
    String driverCode;
    String driverName;
    String mobileNo;
    String acUser;
    String acStatus;

    factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        vsrNo: json["vsrNo"],
        vendorSrNo: json["vendorSrNo"],
        vendorName: json["vendorName"],
        branchSrNo: json["branchSrNo"],
        branchName: json["branchName"],
        vehicleRegNo: json["vehicleRegNo"],
        vehicleName: json["vehicleName"],
        driverSrNo: json["driverSrNo"],
        driverCode: json["driverCode"],
        driverName: json["driverName"],
        mobileNo: json["mobileNo"],
        acUser: json["acUser"],
        acStatus: json["acStatus"],
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
