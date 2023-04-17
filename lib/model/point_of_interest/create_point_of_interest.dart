// To parse this JSON data, do
//
//     final createPointOfInterest = createPointOfInterestFromJson(jsonString);

import 'dart:convert';

CreatePointOfInterest createPointOfInterestFromJson(String str) => CreatePointOfInterest.fromJson(json.decode(str));

String createPointOfInterestToJson(CreatePointOfInterest data) => json.encode(data.toJson());

class CreatePointOfInterest {
  CreatePointOfInterest({
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
  dynamic previousPage;
  List<PointInterstData>? data;
  bool? succeeded;
  dynamic errors;
  dynamic message;

  factory CreatePointOfInterest.fromJson(Map<String, dynamic> json) => CreatePointOfInterest(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    firstPage: json["firstPage"],
    lastPage: json["lastPage"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: json["data"] == null ? [] : List<PointInterstData>.from(json["data"]!.map((x) => PointInterstData.fromJson(x))),
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
    "pointOfIntrstData": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class PointInterstData {
  PointInterstData({
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.poiname,
    this.poiTypeId,
    this.poiTypeName,
    this.description,
    this.tolerance,
    this.vehicleSrNo,
    this.vehicleRegno,
    this.showPoi,
  });

  int? srNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? poiname;
  int? poiTypeId;
  String? poiTypeName;
  String? description;
  double? tolerance;
  int? vehicleSrNo;
  String? vehicleRegno;
  String? showPoi;

  factory PointInterstData.fromJson(Map<String, dynamic> json) {
    return PointInterstData(
      srNo: json["srNo"] ?? 0,
      vendorSrNo: json["vendorSrNo"] ?? 0,
      vendorName: json["vendorName"] == null ? json['vendorName'] : '',
      branchSrNo: json["branchSrNo"]??0,
      branchName: json["branchName"] ?? '',
      poiname: json["poiname"] ?? '',
      poiTypeId: json["poiTypeId"] ?? 0,
      poiTypeName: json["poiTypeName"] ?? '',
      description: json["description"] ?? '',
      tolerance: json["tolerance"] ?? 0.0,
      vehicleSrNo: json["vehicleSrNo"] ?? 0,
      vehicleRegno: json["vehicleRegno"] ?? '',
      showPoi: json["showPoi"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName ,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "poiname": poiname,
    "poiTypeId": poiTypeId,
    "poiTypeName": poiTypeName,
    "description": description,
    "tolerance": tolerance,
    "vehicleSrNo": vehicleSrNo,
    "vehicleRegno": vehicleRegno,
    "showPoi": showPoi,
  };
}
