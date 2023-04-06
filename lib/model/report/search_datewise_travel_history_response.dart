// To parse this JSON data, do
//
//     final searchDatewiseTravelHistryRpt = searchDatewiseTravelHistryRptFromJson(jsonString);

import 'dart:convert';

SearchDatewiseTravelHistryRpt searchDatewiseTravelHistryRptFromJson(String str) => SearchDatewiseTravelHistryRpt.fromJson(json.decode(str));

String searchDatewiseTravelHistryRptToJson(SearchDatewiseTravelHistryRpt data) => json.encode(data.toJson());

class SearchDatewiseTravelHistryRpt {
  SearchDatewiseTravelHistryRpt({
    this.pageNumber,
    this.pageSize,
    this.firstPage,
    this.lastPage,
    this.totalPages,
    this.totalRecords,
    this.nextPage,
    this.previousPage,
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<SearchdatwisetravelDetail>? data;
  bool? succeeded;
  String? errors;
  String? message;

  factory SearchDatewiseTravelHistryRpt.fromJson(Map<String, dynamic> json) => SearchDatewiseTravelHistryRpt(
    pageNumber: json["pageNumber"]??0,
    pageSize: json["pageSize"]??0,
    firstPage: json["firstPage"]??"",
    lastPage: json["lastPage"]??"",
    totalPages: json["totalPages"]??0,
    totalRecords: json["totalRecords"]??0,
    nextPage: json["nextPage"]??"",
    previousPage: json["previousPage"]??"",
    data: json["data"] == null ? [] : List<SearchdatwisetravelDetail>.from(json["data"]!.map((x) => SearchdatwisetravelDetail.fromJson(x))),
    succeeded: json["succeeded"]??false,
    errors: json["errors"]??"",
    message: json["message"]??"",
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "firstPage": firstPage,
    "lastPage": lastPage,
    "totalPages": totalPages,
    "totalRecords": totalRecords,
    "nextPage": nextPage,
    "previousPage": previousPage,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class SearchdatwisetravelDetail {
  SearchdatwisetravelDetail({
    this.fromDate,
    this.toDate,
    this.groupByDateTotal,
    this.totalDistanceTravel,
    this.datewiseTravelHistoryData,
  });

  DateTime? fromDate;
  DateTime? toDate;
  List<GroupByDateTotal>? groupByDateTotal;
  double? totalDistanceTravel;
  List<DatewiseTravelHistoryDatum>? datewiseTravelHistoryData;

  factory SearchdatwisetravelDetail.fromJson(Map<String, dynamic> json) => SearchdatwisetravelDetail(
    fromDate: json["fromDate"] == null ? null : DateTime.parse(json["fromDate"]),
    toDate: json["toDate"] == null ? null : DateTime.parse(json["toDate"]),
    groupByDateTotal: json["groupByDateTotal"] == null ? [] : List<GroupByDateTotal>.from(json["groupByDateTotal"]!.map((x) => GroupByDateTotal.fromJson(x))),
    totalDistanceTravel: json["totalDistanceTravel"]?.toDouble()??0.0,
    datewiseTravelHistoryData: json["datewiseTravelHistoryData"] == null ? [] : List<DatewiseTravelHistoryDatum>.from(json["datewiseTravelHistoryData"]!.map((x) => DatewiseTravelHistoryDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "fromDate": fromDate?.toIso8601String(),
    "toDate": toDate?.toIso8601String(),
    "groupByDateTotal": groupByDateTotal == null ? [] : List<dynamic>.from(groupByDateTotal!.map((x) => x.toJson())),
    "totalDistanceTravel": totalDistanceTravel,
    "datewiseTravelHistoryData": datewiseTravelHistoryData == null ? [] : List<dynamic>.from(datewiseTravelHistoryData!.map((x) => x.toJson())),
  };
}

class DatewiseTravelHistoryDatum {
  DatewiseTravelHistoryDatum({
    this.vehicleRegNo,
    this.imeino,
    this.transDate,
    this.distanceTravel,
  });

  VehicleRegNo? vehicleRegNo;
  String? imeino;
  String? transDate;
  double? distanceTravel;

  factory DatewiseTravelHistoryDatum.fromJson(Map<String, dynamic> json) => DatewiseTravelHistoryDatum(
    vehicleRegNo: vehicleRegNoValues.map[json["vehicleRegNo"]]!,
    imeino: json["imeino"]??"",
    transDate: json["transDate"]??"",
    distanceTravel: json["distanceTravel"]?.toDouble()??0.0,
  );

  Map<String, dynamic> toJson() => {
    "vehicleRegNo": vehicleRegNoValues.reverse[vehicleRegNo],
    "imeino": imeino,
    "transDate": transDate,
    "distanceTravel": distanceTravel,
  };
}

enum VehicleRegNo { MH12_AA0011 }

final vehicleRegNoValues = EnumValues({
  "MH12AA0011": VehicleRegNo.MH12_AA0011
});

class GroupByDateTotal {
  GroupByDateTotal({
    this.transDate,
    this.distanceTravel,
  });

  String? transDate;
  double? distanceTravel;

  factory GroupByDateTotal.fromJson(Map<String, dynamic> json) => GroupByDateTotal(
    transDate: json["transDate"]??"",
    distanceTravel: json["distanceTravel"]?.toDouble()??0.0,
  );

  Map<String, dynamic> toJson() => {
    "transDate": transDate,
    "distanceTravel": distanceTravel,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
