// To parse this JSON data, do
//
//     final searchPointOfInterest = searchPointOfInterestFromJson(jsonString);

import 'dart:convert';

SearchPointOfInterest searchPointOfInterestFromJson(String str) => SearchPointOfInterest.fromJson(json.decode(str));

String searchPointOfInterestToJson(SearchPointOfInterest data) => json.encode(data.toJson());

class SearchPointOfInterest {
  SearchPointOfInterest({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datum>? data;
  bool? succeeded;
  dynamic errors;
  String? message;

  factory SearchPointOfInterest.fromJson(Map<String, dynamic> json) => SearchPointOfInterest(
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    poiname: json["poiname"],
    poiTypeId: json["poiTypeId"],
    poiTypeName: json["poiTypeName"],
    description: json["description"],
    tolerance: json["tolerance"],
    vehicleSrNo: json["vehicleSrNo"],
    vehicleRegno: json["vehicleRegno"],
    showPoi: json["showPoi"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
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
