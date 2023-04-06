class DriverMasterDriverCodeModel {
  List<DMDCData>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  DriverMasterDriverCodeModel(
      {this.data, this.succeeded, this.errors, this.message});

  DriverMasterDriverCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DMDCData>[];
      json['data'].forEach((v) {
        data!.add(new DMDCData.fromJson(v));
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

class DMDCData {
  String? driverCode;
  String? driverName;

  DMDCData({this.driverCode, this.driverName});

  DMDCData.fromJson(Map<String, dynamic> json) {
    driverCode = json['driverCode'];
    driverName = json['driverName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['driverCode'] = this.driverCode;
    data['driverName'] = this.driverName;
    return data;
  }
}
