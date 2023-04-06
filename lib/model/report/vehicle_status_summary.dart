class VehicleStatusSummaryModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  Null? previousPage;
  List<DatewiseStatusWiseTravelSummaryData>? data;
  bool? succeeded;
  Null? errors;
  Null? message;

  VehicleStatusSummaryModel(
      {this.pageNumber,
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
      this.message});

  VehicleStatusSummaryModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <DatewiseStatusWiseTravelSummaryData>[];
      json['data'].forEach((v) {
        var reportdata = v['datewiseTravelHoursData'] as List<dynamic>;
        reportdata.forEach((element) {
          data!.add(new DatewiseStatusWiseTravelSummaryData.fromJson(element));
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? fromDate;
  String? toDate;
  List<DateWiseTravelSummaryDataTotalHours>?
      dateWiseTravelSummaryDataTotalHours;
  String? totalTravelHoursSummary;
  List<DatewiseStatusWiseTravelSummaryData>?
      datewiseTravelHoursData;

  Data(
      {this.fromDate,
      this.toDate,
      this.dateWiseTravelSummaryDataTotalHours,
      this.totalTravelHoursSummary,
      this.datewiseTravelHoursData});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    if (json['dateWiseTravelSummaryDataTotalHours'] != null) {
      dateWiseTravelSummaryDataTotalHours =
          <DateWiseTravelSummaryDataTotalHours>[];
      json['dateWiseTravelSummaryDataTotalHours'].forEach((v) {
        dateWiseTravelSummaryDataTotalHours!
            .add(new DateWiseTravelSummaryDataTotalHours.fromJson(v));
      });
    }
    totalTravelHoursSummary = json['totalTravelHoursSummary'];
    if (json['datewiseTravelHoursData'] != null) {
      datewiseTravelHoursData =
          <DatewiseStatusWiseTravelSummaryData>[];
      json['datewiseTravelHoursData'].forEach((v) {
        datewiseTravelHoursData!
            .add(new DatewiseStatusWiseTravelSummaryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    if (this.dateWiseTravelSummaryDataTotalHours != null) {
      data['dateWiseTravelSummaryDataTotalHours'] = this
          .dateWiseTravelSummaryDataTotalHours!
          .map((v) => v.toJson())
          .toList();
    }
    data['totalTravelHoursSummary'] = this.totalTravelHoursSummary;
    if (this.datewiseTravelHoursData != null) {
      data['datewiseTravelHoursData'] = this
          .datewiseTravelHoursData!
          .map((v) => v.toJson())
          .toList();
    }
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
  int? srNo;
  String? tDate;
  String? imei;
  String? vehicleregNo;
  String? vehicleStatus;
  String? vehicleStatusTime;

  DatewiseStatusWiseTravelSummaryData(
      {this.srNo,
      this.tDate,
      this.imei,
      this.vehicleregNo,
      this.vehicleStatus,
      this.vehicleStatusTime});

  DatewiseStatusWiseTravelSummaryData.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    tDate = json['tDate'];
    imei = json['imei'];
    vehicleregNo = json['vehicleregNo'];
    vehicleStatus = json['vehicleStatus'];
    vehicleStatusTime = json['vehicleStatusTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['tDate'] = this.tDate;
    data['imei'] = this.imei;
    data['vehicleregNo'] = this.vehicleregNo;
    data['vehicleStatus'] = this.vehicleStatus;
    data['vehicleStatusTime'] = this.vehicleStatusTime;
    return data;
  }
}
