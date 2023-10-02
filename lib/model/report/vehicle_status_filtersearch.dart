class VehicleStatusRFilterSearchModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<VehStatusFilterSearchData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  VehicleStatusRFilterSearchModel(
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

  VehicleStatusRFilterSearchModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <VehStatusFilterSearchData>[];
      json['data'].forEach((v) {
         var searchdata = v['datewiseTravelHoursData'] as List<dynamic>;
        searchdata.forEach((element) {
          data!.add(new VehStatusFilterSearchData.fromJson(element));
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
  List<GroupByDateTotalHours>? groupByDateTotalHours;
  List<GroupByVehicleRegNoTotalHours>? groupByVehicleRegNoTotalHours;
  String? totalHours;
  List<VehStatusFilterSearchData>? datewiseTravelHoursData;

  Data(
      {this.fromDate,
      this.toDate,
      this.groupByDateTotalHours,
      this.groupByVehicleRegNoTotalHours,
      this.totalHours,
      this.datewiseTravelHoursData});

  Data.fromJson(Map<String, dynamic> json) {
    fromDate = json['fromDate'];
    toDate = json['toDate'];
    if (json['groupByDateTotalHours'] != null) {
      groupByDateTotalHours = <GroupByDateTotalHours>[];
      json['groupByDateTotalHours'].forEach((v) {
        groupByDateTotalHours!.add(new GroupByDateTotalHours.fromJson(v));
      });
    }
    if (json['groupByVehicleRegNoTotalHours'] != null) {
      groupByVehicleRegNoTotalHours = <GroupByVehicleRegNoTotalHours>[];
      json['groupByVehicleRegNoTotalHours'].forEach((v) {
        groupByVehicleRegNoTotalHours!
            .add(new GroupByVehicleRegNoTotalHours.fromJson(v));
      });
    }
    totalHours = json['totalHours'];
    if (json['datewiseTravelHoursData'] != null) {
      datewiseTravelHoursData = <VehStatusFilterSearchData>[];
      json['datewiseTravelHoursData'].forEach((v) {
        datewiseTravelHoursData!.add(new VehStatusFilterSearchData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    if (this.groupByDateTotalHours != null) {
      data['groupByDateTotalHours'] =
          this.groupByDateTotalHours!.map((v) => v.toJson()).toList();
    }
    if (this.groupByVehicleRegNoTotalHours != null) {
      data['groupByVehicleRegNoTotalHours'] =
          this.groupByVehicleRegNoTotalHours!.map((v) => v.toJson()).toList();
    }
    data['totalHours'] = this.totalHours;
    if (this.datewiseTravelHoursData != null) {
      data['datewiseTravelHoursData'] =
          this.datewiseTravelHoursData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GroupByDateTotalHours {
  String? tDate;
  String? groupByDateTimeDiff;

  GroupByDateTotalHours({this.tDate, this.groupByDateTimeDiff});

  GroupByDateTotalHours.fromJson(Map<String, dynamic> json) {
    tDate = json['tDate'];
    groupByDateTimeDiff = json['groupByDateTimeDiff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tDate'] = this.tDate;
    data['groupByDateTimeDiff'] = this.groupByDateTimeDiff;
    return data;
  }
}

class GroupByVehicleRegNoTotalHours {
  String? tDate;
  String? vehicleRegNo;
  String? imei;
  String? groupByDateByVehicleRegNoTimeDiff;

  GroupByVehicleRegNoTotalHours(
      {this.tDate,
      this.vehicleRegNo,
      this.imei,
      this.groupByDateByVehicleRegNoTimeDiff});

  GroupByVehicleRegNoTotalHours.fromJson(Map<String, dynamic> json) {
    tDate = json['tDate'];
    vehicleRegNo = json['vehicleRegNo'];
    imei = json['imei'];
    groupByDateByVehicleRegNoTimeDiff =
        json['groupByDateByVehicleRegNoTimeDiff'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tDate'] = this.tDate;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imei'] = this.imei;
    data['groupByDateByVehicleRegNoTimeDiff'] =
        this.groupByDateByVehicleRegNoTimeDiff;
    return data;
  }
}

class VehStatusFilterSearchData {
  int? srNo;
  String? vehicleregNo;
  String? imei;
  String? tDate;
  String? startTime;
  String? endTime;
  String? vehicleStatus;
  String? vehicleStatusTime;

  VehStatusFilterSearchData(
      {this.srNo,
      this.vehicleregNo,
      this.imei,
      this.tDate,
      this.startTime,
      this.endTime,
      this.vehicleStatus,
      this.vehicleStatusTime});

  VehStatusFilterSearchData.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    vehicleregNo = json['vehicleregNo'];
    imei = json['imei'];
    tDate = json['tDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    vehicleStatus = json['vehicleStatus'];
    vehicleStatusTime = json['vehicleStatusTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['vehicleregNo'] = this.vehicleregNo;
    data['imei'] = this.imei;
    data['tDate'] = this.tDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['vehicleStatus'] = this.vehicleStatus;
    data['vehicleStatusTime'] = this.vehicleStatusTime;
    return data;
  }
}
