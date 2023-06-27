class VehicleMasterVSrModel {
  List<VehicleVSrData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  VehicleMasterVSrModel({this.data, this.succeeded, this.errors, this.message});

  VehicleMasterVSrModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <VehicleVSrData>[];
      json['data'].forEach((v) {
        data!.add(new VehicleVSrData.fromJson(v));
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

class VehicleVSrData {
  String? vsrNo;
  String? vehicleRegNo;

  VehicleVSrData({this.vsrNo, this.vehicleRegNo});

  VehicleVSrData.fromJson(Map<String, dynamic> json) {
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
