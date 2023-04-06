// To parse this JSON data, do
//
//     final fillAlertResponse = fillAlertResponseFromJson(jsonString);

import 'dart:convert';


FillAlertResponse fillAlertResponseFromJson(String str) => FillAlertResponse.fromJson(json.decode(str));

String fillAlertResponseToJson(FillAlertResponse data) => json.encode(data.toJson());

class FillAlertResponse {
  FillAlertResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<AlertTypesDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory FillAlertResponse.fromJson(Map<String, dynamic> json) => FillAlertResponse(
    data: List<AlertTypesDatum>.from(json["data"].map((x) => AlertTypesDatum.fromJson(x))),
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

class AlertTypesDatum {
  AlertTypesDatum({
    this.alertCode,
    this.alertIndication,
  });

  String ?alertCode;
  String ?alertIndication;

  factory AlertTypesDatum.fromJson(Map<String, dynamic> json) => AlertTypesDatum(
    alertCode: json["alertCode"],
    alertIndication: json["alertIndication"],
  );

  Map<String, dynamic> toJson() => {
    "alertCode": alertCode,
    "alertIndication": alertIndication,
  };
}
