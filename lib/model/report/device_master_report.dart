class DeviceMasterModel {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<DeviceData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  DeviceMasterModel(
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

  DeviceMasterModel.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <DeviceData>[];
      json['data'].forEach((v) {
        data!.add(new DeviceData.fromJson(v));
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

class DeviceData {
  int? srNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? deviceNo;
  String? modelNo;
  String? simNo1;
  String? simNo2;
  String? deviceName;
  String? imeino;
  String? portNo;
  String? acUser;
  String? acStatus;

  DeviceData(
      {this.srNo,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.deviceNo,
      this.modelNo,
      this.simNo1,
      this.simNo2,
      this.deviceName,
      this.imeino,
      this.portNo,
      this.acUser,
      this.acStatus});

  DeviceData.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    deviceNo = json['deviceNo'];
    modelNo = json['modelNo'];
    simNo1 = json['simNo1'];
    simNo2 = json['simNo2'];
    deviceName = json['deviceName'];
    imeino = json['imeino'];
    portNo = json['portNo'];
    acUser = json['acUser'];
    acStatus = json['acStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['deviceNo'] = this.deviceNo;
    data['modelNo'] = this.modelNo;
    data['simNo1'] = this.simNo1;
    data['simNo2'] = this.simNo2;
    data['deviceName'] = this.deviceName;
    data['imeino'] = this.imeino;
    data['portNo'] = this.portNo;
    data['acUser'] = this.acUser;
    data['acStatus'] = this.acStatus;
    return data;
  }
}
