import 'dart:convert';

AddAlertMasterRequest addAlertMasterRequestFromJson(String str) => AddAlertMasterRequest.fromJson(json.decode(str));

String addAlertMasterRequestToJson(AddAlertMasterRequest data) => json.encode(data.toJson());

class AddAlertMasterRequest {
  AddAlertMasterRequest({
    this.vendorSrNo,
    this.branchSrNo,
    this.alertGroupName,
    this.acUser,
    this.vehicleDetails,
    this.alertDetails,
  });

  int ?vendorSrNo;
  int ?branchSrNo;
  String ?alertGroupName;
  String ?acUser;
  List<VehiclesDetail> ?vehicleDetails;
  List<AlertsDetail> ?alertDetails;

  factory AddAlertMasterRequest.fromJson(Map<String, dynamic> json) => AddAlertMasterRequest(
    vendorSrNo: json["vendorSrNo"],
    branchSrNo: json["branchSrNo"],
    alertGroupName: json["alertGroupName"],
    acUser: json["acUser"],
    vehicleDetails: List<VehiclesDetail>.from(json["vehicleDetails"].map((x) => VehiclesDetail.fromJson(x))),
    alertDetails: List<AlertsDetail>.from(json["alertDetails"].map((x) => AlertsDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "vendorSrNo": vendorSrNo,
    "branchSrNo": branchSrNo,
    "alertGroupName": alertGroupName,
    "acUser": acUser,
    "vehicleDetails": List<dynamic>.from(vehicleDetails!.map((x) => x.toJson())),
    "alertDetails": List<dynamic>.from(alertDetails!.map((x) => x.toJson())),
  };
}

class AlertsDetail {
  AlertsDetail({
    this.alertCode,
    this.alertIndication,
  });

  String ?alertCode;
  String ?alertIndication;

  factory AlertsDetail.fromJson(Map<String, dynamic> json) => AlertsDetail(
    alertCode: json["alertCode"],
    alertIndication: json["alertIndication"],
  );

  Map<String, dynamic> toJson() => {
    "alertCode": alertCode,
    "alertIndication": alertIndication,
  };
}

class VehiclesDetail {
  VehiclesDetail({
    this.vsrNo,
    this.vehicleRegNo,
  });

  int? vsrNo;
  String? vehicleRegNo;

  factory VehiclesDetail.fromJson(Map<String, dynamic> json) => VehiclesDetail(
    vsrNo: json["vsrNo"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vehicleRegNo": vehicleRegNo,
  };
}