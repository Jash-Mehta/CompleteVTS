import 'dart:convert';



VehicleFillSrNoResponse vehicleFillSrNoResponseFromJson(String str) => VehicleFillSrNoResponse.fromJson(json.decode(str));

String vehicleFillSrNoResponseToJson(VehicleFillSrNoResponse data) => json.encode(data.toJson());

class VehicleFillSrNoResponse {
  VehicleFillSrNoResponse({
    this.data,
    this.succeeded,
    this.errors,
    this.message,
  });

  List<VehicleDatums>? data;
  bool ?succeeded;
  dynamic? errors;
  String ?message;

  factory VehicleFillSrNoResponse.fromJson(Map<String, dynamic> json) => VehicleFillSrNoResponse(
    data: List<VehicleDatums>.from(json["data"].map((x) => VehicleDatums.fromJson(x))),
    succeeded: json["succeeded"],
    errors: json["errors"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "succeeded": succeeded,
    "errors": errors,
    "message": message,
  };
}

class VehicleDatums {
  VehicleDatums({
    this.vsrNo,
    this.vehicleRegNo,
  });

  int? vsrNo;
  String? vehicleRegNo;

  factory VehicleDatums.fromJson(Map<String, dynamic> json) => VehicleDatums(
    vsrNo: json["vsrNo"],
    vehicleRegNo: json["vehicleRegNo"],
  );

  Map<String, dynamic> toJson() => {
    "vsrNo": vsrNo,
    "vehicleRegNo": vehicleRegNo,
  };
}
