// To parse this JSON data, do
//
//     final dropdownPointofInterest = dropdownPointofInterestFromJson(jsonString);

import 'dart:convert';

List<DropdownPointofInterest> dropdownPointofInterestFromJson(String str) => List<DropdownPointofInterest>.from(json.decode(str).map((x) => DropdownPointofInterest.fromJson(x)));

String dropdownPointofInterestToJson(List<DropdownPointofInterest> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DropdownPointofInterest {
    DropdownPointofInterest({
        required this.poiTypeCode,
        required this.poiTypeName,
    });

    int poiTypeCode;
    String poiTypeName;

    factory DropdownPointofInterest.fromJson(Map<String, dynamic> json) => DropdownPointofInterest(
        poiTypeCode: json["poiTypeCode"],
        poiTypeName: json["poiTypeName"],
    );

    Map<String, dynamic> toJson() => {
        "poiTypeCode": poiTypeCode,
        "poiTypeName": poiTypeName,
    };
}
