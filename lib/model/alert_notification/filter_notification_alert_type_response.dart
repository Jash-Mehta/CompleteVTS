// To parse this JSON data, do
//
//     final filterNotificationAlertTypeResponse = filterNotificationAlertTypeResponseFromJson(jsonString);

import 'dart:convert';

FilterNotificationAlertTypeResponse filterNotificationAlertTypeResponseFromJson(String str) => FilterNotificationAlertTypeResponse.fromJson(json.decode(str));

String filterNotificationAlertTypeResponseToJson(FilterNotificationAlertTypeResponse data) => json.encode(data.toJson());

class FilterNotificationAlertTypeResponse {
  FilterNotificationAlertTypeResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<AlertTypeDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory FilterNotificationAlertTypeResponse.fromJson(Map<String, dynamic> json) => FilterNotificationAlertTypeResponse(
    data: List<AlertTypeDatum>.from(json["data"].map((x) => AlertTypeDatum.fromJson(x))),
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

class AlertTypeDatum {
  AlertTypeDatum({
    this.alertCode,
    this.alertIndication,
  });

  String ?alertCode;
  String ?alertIndication;

  factory AlertTypeDatum.fromJson(Map<String, dynamic> json) => AlertTypeDatum(
    alertCode: json["alertCode"],
    alertIndication: json["alertIndication"],
  );

  Map<String, dynamic> toJson() => {
    "alertCode": alertCode,
    "alertIndication": alertIndication,
  };
}
