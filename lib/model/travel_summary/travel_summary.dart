import 'dart:convert';

travel_summary_response getDriverMasterReportResponseFromJson(String str) =>
    travel_summary_response.fromJson(json.decode(str));

String getDriverMasterReportResponseToJson(travel_summary_response data) =>
    json.encode(data.toJson());

class travel_summary_response {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<TravelData>? traveldata;
  List<DatewiseStatusWiseTravelSummaryData>? datewise;
  bool? succeeded;
  String? errors;
  String? message;

  travel_summary_response(
      {this.pageNumber,
      this.pageSize,
      this.firstPage,
      this.lastPage,
      this.totalPages,
      this.totalRecords,
      this.nextPage,
      this.previousPage,
      this.traveldata,
      this.datewise,
      this.succeeded,
      this.errors,
      this.message});

  travel_summary_response.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      traveldata = <TravelData>[];
      json['data'].forEach((v) {
        print(v);
        traveldata!.add(new TravelData.fromJson(v));
      });
    }
    if (json['data'] != null) {
      datewise = <DatewiseStatusWiseTravelSummaryData>[];
      json['data'].forEach((v) {
        var datewisetraveldata =
            v['datewiseStatusWiseTravelSummaryData'] as List<dynamic>;
        datewisetraveldata.forEach((element) {
          datewise!.add(DatewiseStatusWiseTravelSummaryData.fromJson(element));
        });
      });
    }
    succeeded = json['succeeded'];
    errors = json['errors'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['firstPage'] = this.firstPage;
    data['lastPage'] = this.lastPage;
    data['totalPages'] = this.totalPages;
    data['totalRecords'] = this.totalRecords;
    data['nextPage'] = this.nextPage;
    data['previousPage'] = this.previousPage;
    if (this.traveldata != null) {
      data['data'] = this.traveldata!.map((v) => v.toJson()).toList();
    }

    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class TravelData {
  String? fromDate;
  String? toDate;
  String? totalTravelHoursSummary;

  TravelData({
    this.fromDate,
    this.toDate,
    this.totalTravelHoursSummary,
  });

  TravelData.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];

    totalTravelHoursSummary = json['totalTravelHoursSummary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['totalTravelHoursSummary'] = this.totalTravelHoursSummary;
    return data;
  }
}

class DateWiseTravelSummaryDataTotalHours {
  String? tDate;
  String? summaryDateWise;

  DateWiseTravelSummaryDataTotalHours({this.tDate, this.summaryDateWise});

  DateWiseTravelSummaryDataTotalHours.fromJson(Map<String, dynamic> json) {
    tDate = json['tDate'];
    summaryDateWise = json['summaryDateWise'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tDate'] = this.tDate;
    data['summaryDateWise'] = this.summaryDateWise;
    return data;
  }
}

class DatewiseStatusWiseTravelSummaryData {
  var srNo;
  String? tDate;
  String? imei;
  String? vehicleregNo;
  String? vehicleStatus;
  String? vehicleStatusTime;
  double? avgSpeed;
  var maxSpeed;
  var distanceTravel;
  var alertCount;

  DatewiseStatusWiseTravelSummaryData(
      {this.srNo,
      this.tDate,
      this.imei,
      this.vehicleregNo,
      this.vehicleStatus,
      this.vehicleStatusTime,
      this.avgSpeed,
      this.maxSpeed,
      this.distanceTravel,
      this.alertCount});

  DatewiseStatusWiseTravelSummaryData.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    tDate = json['tDate'];
    imei = json['imei'];
    vehicleregNo = json['vehicleregNo'];
    vehicleStatus = json['vehicleStatus'];
    vehicleStatusTime = json['vehicleStatusTime'];
    avgSpeed = json['avgSpeed'];
    maxSpeed = json['maxSpeed'];
    distanceTravel = json['distanceTravel'];
    alertCount = json['alertCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['tDate'] = this.tDate;
    data['imei'] = this.imei;
    data['vehicleregNo'] = this.vehicleregNo;
    data['vehicleStatus'] = this.vehicleStatus;
    data['vehicleStatusTime'] = this.vehicleStatusTime;
    data['avgSpeed'] = this.avgSpeed;
    data['maxSpeed'] = this.maxSpeed;
    data['distanceTravel'] = this.distanceTravel;
    data['alertCount'] = this.alertCount;
    return data;
  }
}
