// To parse this JSON data, do
//
//     final getGeofenceCreateDetailsResponse = getGeofenceCreateDetailsResponseFromJson(jsonString);

import 'dart:convert';

GetGeofenceCreateDetailsResponse getGeofenceCreateDetailsResponseFromJson(String str) => GetGeofenceCreateDetailsResponse.fromJson(json.decode(str));

String getGeofenceCreateDetailsResponseToJson(GetGeofenceCreateDetailsResponse data) => json.encode(data.toJson());

class GetGeofenceCreateDetailsResponse {
  GetGeofenceCreateDetailsResponse({
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

  dynamic ?pageNumber;
  dynamic ?pageSize;
  String? firstPage;
  String? lastPage;
  dynamic ?totalPages;
  dynamic ?totalRecords;
  String? nextPage;
  dynamic? previousPage;
  List<GeofenceDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  dynamic ?message;

  factory GetGeofenceCreateDetailsResponse.fromJson(Map<String, dynamic> json) => GetGeofenceCreateDetailsResponse(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    firstPage: json["firstPage"],
    lastPage: json["lastPage"],
    totalPages: json["totalPages"],
    totalRecords: json["totalRecords"],
    nextPage: json["nextPage"],
    previousPage: json["previousPage"],
    data: List<GeofenceDatum>.from(json["data"].map((x) => GeofenceDatum.fromJson(x))),
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
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class GeofenceDatum {
  GeofenceDatum({
    this.srNo,
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.geofenceName,
    this.category,
    this.description,
    this.tolerance,
    this.vehicleSrNo,
    this.vehicleRegno,
    this.showGeofence,
  });

  dynamic ?srNo;
  dynamic ?vendorSrNo;
  String? vendorName;
  dynamic ?branchSrNo;
  String? branchName;
  String? geofenceName;
  String? category;
  String? description;
  dynamic ?tolerance;
  dynamic ?vehicleSrNo;
  String? vehicleRegno;
  String? showGeofence;

  factory GeofenceDatum.fromJson(Map<String, dynamic> json) => GeofenceDatum(
    srNo: json["srNo"],
    vendorSrNo: json["vendorSrNo"],
    vendorName: json["vendorName"],
    branchSrNo: json["branchSrNo"],
    branchName: json["branchName"],
    geofenceName: json["geofenceName"],
    category: json["category"],
    description: json["description"],
    tolerance: json["tolerance"],
    vehicleSrNo: json["vehicleSrNo"],
    vehicleRegno: json["vehicleRegno"],
    showGeofence: json["showGeofence"],
  );

  Map<String, dynamic> toJson() => {
    "srNo": srNo,
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "geofenceName": geofenceName,
    "category": category,
    "description": description,
    "tolerance": tolerance,
    "vehicleSrNo": vehicleSrNo,
    "vehicleRegno": vehicleRegno,
    "showGeofence": showGeofence,
  };
}

