// To parse this JSON data, do
//
//     final vehicleStatusWithCountResponse = vehicleStatusWithCountResponseFromJson(jsonString);

import 'dart:convert';

List<VehicleStatusWithCountResponse> vehicleStatusWithCountResponseFromJson(String str) => List<VehicleStatusWithCountResponse>.from(json.decode(str).map((x) => VehicleStatusWithCountResponse.fromJson(x)));

String vehicleStatusWithCountResponseToJson(List<VehicleStatusWithCountResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VehicleStatusWithCountResponse {
  VehicleStatusWithCountResponse({
    this.statusId,
    this.status,
    this.count,
  });

  String ?statusId;
  String ?status;
  int ?count;

  factory VehicleStatusWithCountResponse.fromJson(Map<String, dynamic> json) => VehicleStatusWithCountResponse(
    statusId:json["StatusId"]==null ? null : json["StatusId"],
    status: json["Status"]==null ? null : json["Status"],
    count:json["Count"]==null ? null : json["Count"],
  );

  Map<String, dynamic> toJson() => {
    "StatusId": statusId,
    "Status": status,
    "Count": count,
  };
}

//--------------------------------------------------------------------------------


