// To parse this JSON data, do
//
//     final fillAlertNotificationVehicleResponse = fillAlertNotificationVehicleResponseFromJson(jsonString);

import 'dart:convert';

FillAlertNotificationVehicleResponse fillAlertNotificationVehicleResponseFromJson(String str) => FillAlertNotificationVehicleResponse.fromJson(json.decode(str));

String fillAlertNotificationVehicleResponseToJson(FillAlertNotificationVehicleResponse data) => json.encode(data.toJson());

class FillAlertNotificationVehicleResponse {
  FillAlertNotificationVehicleResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<VehicleDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory FillAlertNotificationVehicleResponse.fromJson(Map<String, dynamic> json) => FillAlertNotificationVehicleResponse(
    data: List<VehicleDatum>.from(json["data"].map((x) => VehicleDatum.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class VehicleDatum {
  VehicleDatum({
    this.vsrNo,
    this.vehicleRegNo,
  });

  int? vsrNo;
  String? vehicleRegNo;

  factory VehicleDatum.fromJson(Map<String, dynamic> json) => VehicleDatum(
    vsrNo: json["vsrNo"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vehicleRegNo": vehicleRegNo,
  };
}
