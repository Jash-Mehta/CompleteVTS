class DriverWiseDriverCodeModel {
  List<DriverWiseDriverCodeData>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  DriverWiseDriverCodeModel(
      {this.data, this.succeeded, this.errors, this.message});

  DriverWiseDriverCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DriverWiseDriverCodeData>[];
      json['data'].forEach((v) {
        data!.add(new DriverWiseDriverCodeData.fromJson(v));
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

class DriverWiseDriverCodeData {
  var vsrNo;
  var vehicleRegNo;

  DriverWiseDriverCodeData({this.vsrNo, this.vehicleRegNo});

  DriverWiseDriverCodeData.fromJson(Map<String, dynamic> json) {
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
