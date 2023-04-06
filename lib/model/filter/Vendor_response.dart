// To parse this JSON data, do
//
//     final vendorResponse = vendorResponseFromJson(jsonString);

import 'dart:convert';

VendorResponse vendorResponseFromJson(String str) => VendorResponse.fromJson(json.decode(str));

String vendorResponseToJson(VendorResponse data) => json.encode(data.toJson());

class VendorResponse {
  VendorResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<VendorDatum> ?data;
  bool ?succeeded;
  dynamic ?errors;
  String ?message;

  factory VendorResponse.fromJson(Map<String, dynamic> json) => VendorResponse(
    data: json["data"]==null ? null : List<VendorDatum>.from(json["data"].map((x) => VendorDatum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null : json["succeeded"],
    errors:  json["errors"]==null ? null :json["errors"],
    message: json["message"]==null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class VendorDatum {
  VendorDatum({
    this.vendorId,
    this.vendorName,
  });

  dynamic ?vendorId;
  String? vendorName;

  factory VendorDatum.fromJson(Map<String, dynamic> json) => VendorDatum(
    vendorId: json["vendorId"]==null ? null :json["vendorId"],
    vendorName: json["vendorName"]==null ? null : json["vendorName"],
  );

  Map<String, dynamic> toJson() => {
    "vendorId": vendorId,
    "vendorName": vendorName,
  };
}
