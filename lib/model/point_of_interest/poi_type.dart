import 'package:flutter/material.dart';

List poitypelist = [];
List poicodeforpost = [];

class POITypeCode {
  int? poiTypeCode;
  String? poiTypeName;

  POITypeCode({this.poiTypeCode, this.poiTypeName});

  POITypeCode.fromJson(List<dynamic> json) {
    json.forEach((element) {
      poiTypeCode = element['poiTypeCode'];
      poiTypeName = element['poiTypeName'];
      poitypelist.add(poiTypeName);
      poicodeforpost.add(poiTypeCode);
     
    });
    // poiTypeCode = json['poiTypeCode'];
    // poiTypeName = json['poiTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poiTypeCode'] = this.poiTypeCode;
    data['poiTypeName'] = this.poiTypeName;
    return data;
  }
}
