// To parse this JSON data, do
//
//     final editDeviceResponse = editDeviceResponseFromJson(jsonString);

import 'dart:convert';

EditDeviceResponse editDeviceResponseFromJson(String str) => EditDeviceResponse.fromJson(json.decode(str));

String editDeviceResponseToJson(EditDeviceResponse data) => json.encode(data.toJson());

class EditDeviceResponse {
  EditDeviceResponse({
    this.succeeded,
    this.message,
  });

  bool? succeeded;
  String ?message;

  factory EditDeviceResponse.fromJson(Map<String, dynamic> json) => EditDeviceResponse(
    succeeded: json["succeeded"]==null ? null :json["succeeded"],
    message: json["message"]==null ? null :json["message"],
  );

  Map<String, dynamic> toJson() => {
    "succeeded": succeeded,
    "message": message,
  };
}
