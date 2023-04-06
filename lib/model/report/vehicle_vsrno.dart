class VehicleVSrNoModel {
  List<VehicleVSrNoData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  VehicleVSrNoModel({this.data, this.succeeded, this.errors, this.message});

  VehicleVSrNoModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VehicleVSrNoData>[];
      json['data'].forEach((v) {
        data!.add(new VehicleVSrNoData.fromJson(v));
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

class VehicleVSrNoData {
  int? vsrNo;
  String? vehicleRegNo;

  VehicleVSrNoData({this.vsrNo, this.vehicleRegNo});

  VehicleVSrNoData.fromJson(Map<String, dynamic> json) {
    vsrNo = json['vsrNo'];
    vehicleRegNo = json['vehicleRegNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vsrNo'] = this.vsrNo;
    data['vehicleRegNo'] = this.vehicleRegNo;
    return data;
  }
}
