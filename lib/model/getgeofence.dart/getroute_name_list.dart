import 'package:flutter/material.dart';

List routename = [];

class RouteNameList {
  var id;
  var routeName;

  RouteNameList({this.id, this.routeName});

  RouteNameList.fromJson(List<dynamic> json) {
    json.forEach((element) {
      id = element['id'];
      routeName = element['routeName'];
      routename.add(routeName.toString());
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['id'] = this.id;
    data['routeName'] = this.routeName;
    return data;
  }
}
