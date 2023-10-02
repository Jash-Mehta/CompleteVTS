class VehicleWiseDriverCodeModel {
  List<VehicleDistanceVsr>? data;
  bool? succeeded;
  String? errors;
  String? message;

  VehicleWiseDriverCodeModel(
      {this.data, this.succeeded, this.errors, this.message});

  VehicleWiseDriverCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VehicleDistanceVsr>[];
      json['data'].forEach((v) {
        data!.add(new VehicleDistanceVsr.fromJson(v));
      });
    }
    succeeded = json['succeeded'];
    errors = json['errors'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class VehicleDistanceVsr {
  String? imeino;
  String? vehicleRegNo;
  String? imeiNo;

  VehicleDistanceVsr({this.imeino, this.vehicleRegNo, this.imeiNo});

  VehicleDistanceVsr.fromJson(Map<String, dynamic> json) {
    imeino = json['imeino'];
    vehicleRegNo = json['vehicleRegNo'];
    imeiNo = json['imeiNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imeino'] = this.imeino;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imeiNo'] = this.imeiNo;
    return data;
  }
}
