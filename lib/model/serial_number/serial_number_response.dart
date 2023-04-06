// To parse this JSON data, do
//
//     final serialNumberResponse = serialNumberResponseFromJson(jsonString);

import 'dart:convert';

SerialNumberResponse serialNumberResponseFromJson(String str) => SerialNumberResponse.fromJson(json.decode(str));

String serialNumberResponseToJson(SerialNumberResponse data) => json.encode(data.toJson());

class SerialNumberResponse {
  SerialNumberResponse({
    this.value,
  });

  String ?value;

  factory SerialNumberResponse.fromJson(Map<String, dynamic> json) => SerialNumberResponse(
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
  };
}
