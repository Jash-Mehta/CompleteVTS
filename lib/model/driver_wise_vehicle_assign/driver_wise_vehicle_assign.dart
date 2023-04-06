import 'dart:convert';

DriverWiseVehicleAssign driverWiseVehicleAssignFromJson(String str) => DriverWiseVehicleAssign.fromJson(json.decode(str));

String driverWiseVehicleAssignToJson(DriverWiseVehicleAssign data) => json.encode(data.toJson());

class DriverWiseVehicleAssign {
    DriverWiseVehicleAssign({
        required this.pageNumber,
        required this.pageSize,
        required this.firstPage,
        required this.lastPage,
        required this.totalPages,
        required this.totalRecords,
        required this.nextPage,
        this.previousPage,
        required this.data,
        required this.succeeded,
        this.errors,
        this.message,
    });

    int pageNumber;
    int pageSize;
    String firstPage;
    String lastPage;
    int totalPages;
    int totalRecords;
    String nextPage;
    dynamic previousPage;
    List<DriverWiseVehicle> data;
    bool succeeded;
    dynamic errors;
    dynamic message;

    factory DriverWiseVehicleAssign.fromJson(Map<String, dynamic> json) => DriverWiseVehicleAssign(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        firstPage: json["firstPage"],
        lastPage: json["lastPage"],
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
        nextPage: json["nextPage"],
        previousPage: json["previousPage"],
        data: List<DriverWiseVehicle>.from(json["data"].map((x) => DriverWiseVehicle.fromJson(x))),
        succeeded: json["succeeded"],
        errors: json["errors"],
        message: json["message"],
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
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "succeeded": succeeded,
        "errors": errors,
        "message": message,
    };
}

class DriverWiseVehicle {
    DriverWiseVehicle({
        required this.vsrNo,
        required this.vendorSrNo,
        required this.vendorName,
        required this.branchSrNo,
        required this.branchName,
        required this.vehicleRegNo,
        required this.vehicleName,
        required this.driverSrNo,
        required this.driverCode,
        required this.driverName,
        required this.mobileNo,
        required this.acUser,
        required this.acStatus,
    });

    int vsrNo;
    int vendorSrNo;
    VendorName vendorName;
    int branchSrNo;
    BranchName branchName;
    String vehicleRegNo;
    String vehicleName;
    int driverSrNo;
    String driverCode;
    String driverName;
    String mobileNo;
    AcUser acUser;
    AcStatus acStatus;

    factory DriverWiseVehicle.fromJson(Map<String, dynamic> json) => DriverWiseVehicle(
        vsrNo: json["vsrNo"],
        vendorSrNo: json["vendorSrNo"],
        vendorName: vendorNameValues.map[json["vendorName"]]!,
        branchSrNo: json["branchSrNo"],
        branchName: branchNameValues.map[json["branchName"]]!,
        vehicleRegNo: json["vehicleRegNo"],
        vehicleName: json["vehicleName"],
        driverSrNo: json["driverSrNo"],
        driverCode: json["driverCode"],
        driverName: json["driverName"],
        mobileNo: json["mobileNo"],
        acUser: acUserValues.map[json["acUser"]]!,
        acStatus: acStatusValues.map[json["acStatus"]]!,
    );

    Map<String, dynamic> toJson() => {
        "vsrNo": vsrNo,
        "vendorSrNo": vendorSrNo,
        "vendorName": vendorNameValues.reverse[vendorName],
        "branchSrNo": branchSrNo,
        "branchName": branchNameValues.reverse[branchName],
        "vehicleRegNo": vehicleRegNo,
        "vehicleName": vehicleName,
        "driverSrNo": driverSrNo,
        "driverCode": driverCode,
        "driverName": driverName,
        "mobileNo": mobileNo,
        "acUser": acUserValues.reverse[acUser],
        "acStatus": acStatusValues.reverse[acStatus],
    };
}

enum AcStatus { INACTIVE, ACTIVE }

final acStatusValues = EnumValues({
    "Active": AcStatus.ACTIVE,
    "Inactive": AcStatus.INACTIVE
});

enum AcUser { SATYAM, TECHNO }

final acUserValues = EnumValues({
    "Satyam": AcUser.SATYAM,
    "Techno": AcUser.TECHNO
});

enum BranchName { HINJEWADI }

final branchNameValues = EnumValues({
    "Hinjewadi": BranchName.HINJEWADI
});

enum VendorName { MTECH_COMPANY }

final vendorNameValues = EnumValues({
    "MTECH company": VendorName.MTECH_COMPANY
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
