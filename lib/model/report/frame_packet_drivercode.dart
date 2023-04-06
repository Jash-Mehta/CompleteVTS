class FramePacketRptDriverCodeModel {
  List<FramePktDriverData>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  FramePacketRptDriverCodeModel(
      {this.data, this.succeeded, this.errors, this.message});

  FramePacketRptDriverCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FramePktDriverData>[];
      json['data'].forEach((v) {
        data!.add(new FramePktDriverData.fromJson(v));
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

class FramePktDriverData {
  String? imeino;
  String? vehicleRegNo;
  String? imeiNo;

  FramePktDriverData({this.imeino, this.vehicleRegNo, this.imeiNo});

  FramePktDriverData.fromJson(Map<String, dynamic> json) {
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
