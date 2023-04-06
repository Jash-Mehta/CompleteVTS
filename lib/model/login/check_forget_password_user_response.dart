// To parse this JSON data, do
//
//     final checkForgetPasswordUserResponse = checkForgetPasswordUserResponseFromJson(jsonString);

import 'dart:convert';

CheckForgetPasswordUserResponse checkForgetPasswordUserResponseFromJson(String str) => CheckForgetPasswordUserResponse.fromJson(json.decode(str));

String checkForgetPasswordUserResponseToJson(CheckForgetPasswordUserResponse data) => json.encode(data.toJson());

class CheckForgetPasswordUserResponse {
  CheckForgetPasswordUserResponse({
    this.succeeded,
    this.value,
    this.message,
  });

  bool ?succeeded;
  String? value;
  String ?message;

  factory CheckForgetPasswordUserResponse.fromJson(Map<String, dynamic> json) => CheckForgetPasswordUserResponse(
    succeeded:  json["succeeded"]==null  ? null :json["succeeded"],
    value: json["value"]==null  ? null :json["value"],
    message: json["message"]==null  ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "value": value,
    "message": message,
  };
}
