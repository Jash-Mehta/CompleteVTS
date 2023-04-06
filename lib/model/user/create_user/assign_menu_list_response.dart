// To parse this JSON data, do
//
//     final assignMenuListResponse = assignMenuListResponseFromJson(jsonString);

import 'dart:convert';

AssignMenuListResponse assignMenuListResponseFromJson(String str) => AssignMenuListResponse.fromJson(json.decode(str));

String assignMenuListResponseToJson(AssignMenuListResponse data) => json.encode(data.toJson());

class AssignMenuListResponse {
  AssignMenuListResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<AssignMenuDatum>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory AssignMenuListResponse.fromJson(Map<String, dynamic> json) => AssignMenuListResponse(
    data: List<AssignMenuDatum>.from(json["data"].map((x) => AssignMenuDatum.fromJson(x))),
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

class AssignMenuDatum {
  AssignMenuDatum({
    this.menuId,
    this.menuCaption,
  });

  int? menuId;
  String ?menuCaption;

  factory AssignMenuDatum.fromJson(Map<String, dynamic> json) => AssignMenuDatum(
    menuId: json["menuId"],
    menuCaption: json["menuCaption"],
  );

  Map<String, dynamic> toJson() => {
    "menuId": menuId,
    "menuCaption": menuCaption,
  };
}
