// To parse this JSON data, do
//
//     final editVendorResponse = editVendorResponseFromJson(jsonString);

import 'dart:convert';

EditVendorResponse editVendorResponseFromJson(String str) => EditVendorResponse.fromJson(json.decode(str));

String editVendorResponseToJson(EditVendorResponse data) => json.encode(data.toJson());

class EditVendorResponse {
  EditVendorResponse({
    this.message,
  });

  String? message;

  factory EditVendorResponse.fromJson(Map<String, dynamic> json) => EditVendorResponse(
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
  };
}
