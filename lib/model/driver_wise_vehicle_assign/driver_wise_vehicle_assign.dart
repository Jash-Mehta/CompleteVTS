// import 'dart:convert';

// DriverWiseVehicleAssign driverWiseVehicleAssignFromJson(String str) => DriverWiseVehicleAssign.fromJson(json.decode(str));

// String driverWiseVehicleAssignToJson(DriverWiseVehicleAssign data) => json.encode(data.toJson());

// class DriverWiseVehicleAssign {
//     DriverWiseVehicleAssign({
//         required this.pageNumber,
//         required this.pageSize,
//         required this.firstPage,
//         required this.lastPage,
//         required this.totalPages,
//         required this.totalRecords,
//         required this.nextPage,
//         this.previousPage,
//         required this.data,
//         required this.succeeded,
//         this.errors,
//         this.message,
//     });

//     int pageNumber;
//     int pageSize;
//     String firstPage;
//     String lastPage;
//     int totalPages;
//     int totalRecords;
//     String nextPage;
//     dynamic previousPage;
//     List<DriverWiseVehicle> data;
//     bool succeeded;
//     dynamic errors;
//     dynamic message;

//     factory DriverWiseVehicleAssign.fromJson(Map<String, dynamic> json) => DriverWiseVehicleAssign(
//         pageNumber: json["pageNumber"],
//         pageSize: json["pageSize"],
//         firstPage: json["firstPage"],
//         lastPage: json["lastPage"],
//         totalPages: json["totalPages"],
//         totalRecords: json["totalRecords"],
//         nextPage: json["nextPage"],
//         previousPage: json["previousPage"],
//         data: List<DriverWiseVehicle>.from(json["data"].map((x) => DriverWiseVehicle.fromJson(x))),
//         succeeded: json["succeeded"],
//         errors: json["errors"],
//         message: json["message"],
//     );

//     Map<String, dynamic> toJson() => {
//         "pageNumber": pageNumber,
//         "pageSize": pageSize,
//         "firstPage": firstPage,
//         "lastPage": lastPage,
//         "totalPages": totalPages,
//         "totalRecords": totalRecords,
//         "nextPage": nextPage,
//         "previousPage": previousPage,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//         "succeeded": succeeded,
//         "errors": errors,
//         "message": message,
//     };
// }

// class DriverWiseVehicle {
//     DriverWiseVehicle({
//         required this.vsrNo,
//         required this.vendorSrNo,
//         required this.vendorName,
//         required this.branchSrNo,
//         required this.branchName,
//         required this.vehicleRegNo,
//         required this.vehicleName,
//         required this.driverSrNo,
//         required this.driverCode,
//         required this.driverName,
//         required this.mobileNo,
//         required this.acUser,
//         required this.acStatus,
//     });

//     int vsrNo;
//     int vendorSrNo;
//     VendorName vendorName;
//     int branchSrNo;
//     BranchName branchName;
//     String vehicleRegNo;
//     String vehicleName;
//     int driverSrNo;
//     String driverCode;
//     String driverName;
//     String mobileNo;
//     AcUser acUser;
//     AcStatus acStatus;

//     factory DriverWiseVehicle.fromJson(Map<String, dynamic> json) => DriverWiseVehicle(
//         vsrNo: json["vsrNo"],
//         vendorSrNo: json["vendorSrNo"],
//         vendorName: vendorNameValues.map[json["vendorName"]]!,
//         branchSrNo: json["branchSrNo"],
//         branchName: branchNameValues.map[json["branchName"]]!,
//         vehicleRegNo: json["vehicleRegNo"],
//         vehicleName: json["vehicleName"],
//         driverSrNo: json["driverSrNo"],
//         driverCode: json["driverCode"],
//         driverName: json["driverName"],
//         mobileNo: json["mobileNo"],
//         acUser: acUserValues.map[json["acUser"]]!,
//         acStatus: acStatusValues.map[json["acStatus"]]!,
//     );

//     Map<String, dynamic> toJson() => {
//         "vsrNo": vsrNo,
//         "vendorSrNo": vendorSrNo,
//         "vendorName": vendorNameValues.reverse[vendorName],
//         "branchSrNo": branchSrNo,
//         "branchName": branchNameValues.reverse[branchName],
//         "vehicleRegNo": vehicleRegNo,
//         "vehicleName": vehicleName,
//         "driverSrNo": driverSrNo,
//         "driverCode": driverCode,
//         "driverName": driverName,
//         "mobileNo": mobileNo,
//         "acUser": acUserValues.reverse[acUser],
//         "acStatus": acStatusValues.reverse[acStatus],
//     };
// }

// enum AcStatus { INACTIVE, ACTIVE }

// final acStatusValues = EnumValues({
//     "Active": AcStatus.ACTIVE,
//     "Inactive": AcStatus.INACTIVE
// });

// enum AcUser { SATYAM, TECHNO }

// final acUserValues = EnumValues({
//     "Satyam": AcUser.SATYAM,
//     "Techno": AcUser.TECHNO
// });

// enum BranchName { HINJEWADI }

// final branchNameValues = EnumValues({
//     "Hinjewadi": BranchName.HINJEWADI
// });

// enum VendorName { MTECH_COMPANY }

// final vendorNameValues = EnumValues({
//     "MTECH company": VendorName.MTECH_COMPANY
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap = map.map((k, v) => MapEntry(v, k));
//         return reverseMap;
//     }
// }
//  ------------------------------------------------

class DriverWiseVehicleAssign {
  int? pageNumber;
  int? pageSize;
  String? firstPage;
  String? lastPage;
  int? totalPages;
  int? totalRecords;
  String? nextPage;
  String? previousPage;
  List<DriverWiseVehicle>? data;
  bool? succeeded;
  String? errors;
  String? message;

  DriverWiseVehicleAssign(
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

  DriverWiseVehicleAssign.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    firstPage = json['firstPage'];
    lastPage = json['lastPage'];
    totalPages = json['totalPages'];
    totalRecords = json['totalRecords'];
    nextPage = json['nextPage'];
    previousPage = json['previousPage'];
    if (json['data'] != null) {
      data = <DriverWiseVehicle>[];
      json['data'].forEach((v) {
        data!.add(new DriverWiseVehicle.fromJson(v));
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

class DriverWiseVehicle {
  int? vsrNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? vehicleRegNo;
  String? vehicleName;
  int? driverSrNo;
  String? driverCode;
  String? driverName;
  String? mobileNo;
  String? acUser;
  String? acStatus;

  DriverWiseVehicle(
      {this.vsrNo,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.vehicleRegNo,
      this.vehicleName,
      this.driverSrNo,
      this.driverCode,
      this.driverName,
      this.mobileNo,
      this.acUser,
      this.acStatus});

  DriverWiseVehicle.fromJson(Map<String, dynamic> json) {
    vsrNo = json['vsrNo'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    vehicleRegNo = json['vehicleRegNo'];
    vehicleName = json['vehicleName'];
    driverSrNo = json['driverSrNo'];
    driverCode = json['driverCode'];
    driverName = json['driverName'];
    mobileNo = json['mobileNo'];
    acUser = json['acUser'];
    acStatus = json['acStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vsrNo'] = this.vsrNo;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['vehicleName'] = this.vehicleName;
    data['driverSrNo'] = this.driverSrNo;
    data['driverCode'] = this.driverCode;
    data['driverName'] = this.driverName;
    data['mobileNo'] = this.mobileNo;
    data['acUser'] = this.acUser;
    data['acStatus'] = this.acStatus;
    return data;
  }
}
