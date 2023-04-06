// To parse this JSON data, do
//
//     final fillUsernameResponse = fillUsernameResponseFromJson(jsonString);

import 'dart:convert';

FillUsernameResponse fillUsernameResponseFromJson(String str) => FillUsernameResponse.fromJson(json.decode(str));

String fillUsernameResponseToJson(FillUsernameResponse data) => json.encode(data.toJson());

class FillUsernameResponse {
  FillUsernameResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datum> ?data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory FillUsernameResponse.fromJson(Map<String, dynamic> json) => FillUsernameResponse(
    data: json["data"]==null ? null :List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    errors: json["errors"]==null ? null :json["errors"],
    message: json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datum {
  Datum({
    this.userId,
    this.userName,
  });

  int ?userId;
  String? userName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId:json["userId"]==null ? null : json["userId"],
    userName: json["userName"]==null ? null :json["userName"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userName": userName,
  };
}
