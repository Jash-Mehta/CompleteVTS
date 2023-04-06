import 'dart:convert';

AddAlertMasterResponse addAlertMasterResponseFromJson(String str) => AddAlertMasterResponse.fromJson(json.decode(str));

String addAlertMasterResponseToJson(AddAlertMasterResponse data) => json.encode(data.toJson());

class AddAlertMasterResponse {
  AddAlertMasterResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<Datas>? data;
  bool? succeeded;
  dynamic ?errors;
  String? message;

  factory AddAlertMasterResponse.fromJson(Map<String, dynamic> json) => AddAlertMasterResponse(
    // data: json["data"]==null ? null :Datas.fromJson(json["data"]),
    data: json["data"]==null ? null : List<Datas>.from(json["data"].map((x) => Datas.fromJson(x))),
    succeeded:json["succeeded"]==null ? null : json["succeeded"],
    errors: json["errors"]==null ? null : json["errors"],
    message:json["message"]==null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    // "data": data!.toJson(),
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class Datas {
  Datas({
    this.vendorSrNo,
    this.vendorName,
    this.branchSrNo,
    this.branchName,
    this.alertGroupName,
    this.acUser,
    this.vehicleDetails,
    this.alertDetails,
  });

  int ?vendorSrNo;
  String ?vendorName;
  int ?branchSrNo;
  String ?branchName;
  String ?alertGroupName;
  String? acUser;
  List<VehicleDetails>? vehicleDetails;
  List<AlertDetails> ?alertDetails;

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
    vendorSrNo:json["vendorSrNo"]==null ? null : json["vendorSrNo"],
    vendorName: json["vendorName"]==null ? null :json["vendorName"],
    branchSrNo: json["branchSrNo"]==null ? null :json["branchSrNo"],
    branchName: json["branchName"]==null ? null :json["branchName"],
    alertGroupName:json["alertGroupName"]==null ? null : json["alertGroupName"],
    acUser:json["acUser"]==null ? null : json["acUser"],
    vehicleDetails: json["vehicleDetails"]==null ? null :List<VehicleDetails>.from(json["vehicleDetails"].map((x) => VehicleDetails.fromJson(x))),
    alertDetails:json["alertDetails"]==null ? null : List<AlertDetails>.from(json["alertDetails"].map((x) => AlertDetails.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorSrNo": vendorSrNo,
    "vendorName": vendorName,
    "branchSrNo": branchSrNo,
    "branchName": branchName,
    "alertGroupName": alertGroupName,
    "acUser": acUser,
    "vehicleDetails": List<dynamic>.from(vehicleDetails!.map((x) => x.toJson())),
    "alertDetails": List<dynamic>.from(alertDetails!.map((x) => x.toJson())),
  };
}

class AlertDetails {
  AlertDetails({
    this.alertCode,
    this.alertIndication,
  });

  String ?alertCode;
  String ?alertIndication;

  factory AlertDetails.fromJson(Map<String, dynamic> json) => AlertDetails(
    alertCode:json["alertCode"]==null ? null :  json["alertCode"],
    alertIndication: json["alertIndication"]==null ? null : json["alertIndication"],
  );

  Map<String, dynamic> toJson() => {
    "alertCode": alertCode,
    "alertIndication": alertIndication,
  };
}

class VehicleDetails {
  VehicleDetails({
    this.vsrNo,
    this.vehicleRegNo,
  });

  int ?vsrNo;
  String? vehicleRegNo;

  factory VehicleDetails.fromJson(Map<String, dynamic> json) => VehicleDetails(
    vsrNo: json["vsrNo"]==null ? null : json["vsrNo"],
    vehicleRegNo:json["vehicleRegNo"]==null ? null :  json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vehicleRegNo": vehicleRegNo,
  };
}


