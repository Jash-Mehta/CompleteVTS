// To parse this JSON data, do
//
//     final vehicleStatusResponse = vehicleStatusResponseFromJson(jsonString);

import 'dart:convert';

List<VehicleStatusResponse> vehicleStatusResponseFromJson(String str) => List<VehicleStatusResponse>.from(json.decode(str).map((x) => VehicleStatusResponse.fromJson(x)));

String vehicleStatusResponseToJson(List<VehicleStatusResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleStatusResponse {
  VehicleStatusResponse({
    this.statusId,
    this.status,
  });

  int ?statusId;
  String? status;

  factory VehicleStatusResponse.fromJson(Map<String, dynamic> json) => VehicleStatusResponse(
    statusId: json["statusID"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "statusID": statusId,
    "status": status,
  };
}
