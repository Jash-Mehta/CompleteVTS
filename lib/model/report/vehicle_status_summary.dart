class VehicleStatusSummaryModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<StatusSummaryData>? data;
  bool? succeeded;
  String? errors;
  String? message;

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
      data = <StatusSummaryData>[];
      json['data'].forEach((v) {
        var summarydata =
            v['datewiseStatusWiseTravelSummaryData'] as List<dynamic>;
        summarydata.forEach((element) {
          data!.add(new StatusSummaryData.fromJson(element));
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
  List<StatusSummaryData>? datewiseStatusWiseTravelSummaryData;

  Data(
      {this.fromDate,
      this.toDate,
      this.dateWiseTravelSummaryDataTotalHours,
      this.totalTravelHoursSummary,
      this.datewiseStatusWiseTravelSummaryData});

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
    if (json['datewiseStatusWiseTravelSummaryData'] != null) {
      datewiseStatusWiseTravelSummaryData = <StatusSummaryData>[];
      json['datewiseStatusWiseTravelSummaryData'].forEach((v) {
        datewiseStatusWiseTravelSummaryData!
            .add(new StatusSummaryData.fromJson(v));
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
    if (this.datewiseStatusWiseTravelSummaryData != null) {
      data['datewiseStatusWiseTravelSummaryData'] = this
          .datewiseStatusWiseTravelSummaryData!
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

class StatusSummaryData {
  int? srNo;
  String? tDate;
  String? imei;
  String? vehicleregNo;
  String? vehicleStatus;
  String? vehicleStatusTime;

  StatusSummaryData(
      {this.srNo,
      this.tDate,
      this.imei,
      this.vehicleregNo,
      this.vehicleStatus,
      this.vehicleStatusTime});

  StatusSummaryData.fromJson(Map<String, dynamic> json) {
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
