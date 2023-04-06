// To parse this JSON data, do
//
//     final vendorNameResponse = vendorNameResponseFromJson(jsonString);

import 'dart:convert';

List<VendorNameResponse> vendorNameResponseFromJson(String str) =>
    List<VendorNameResponse>.from(
        json.decode(str).map((x) => VendorNameResponse.fromJson(x)));

String vendorNameResponseToJson(List<VendorNameResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VendorNameResponse {
  VendorNameResponse({
    this.vendorId,
    this.vendorName,
  });

  int? vendorId;
  String? vendorName;

  factory VendorNameResponse.fromJson(Map<String, dynamic> json) =>
      VendorNameResponse(
        vendorId: json["vendorId"] == null ? null : json["vendorId"],
        vendorName: json["vendorName"] == null ? null : json["vendorName"],
      );

  Map<String, dynamic> toJson() => {
        "vendorId": vendorId,
        "vendorName": vendorName,
      };
}
