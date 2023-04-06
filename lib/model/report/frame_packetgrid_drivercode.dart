class FramePacketGridRptDriverCodeModel {
  List<FramePktGrdDriverData>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  FramePacketGridRptDriverCodeModel(
      {this.data, this.succeeded, this.errors, this.message});

  FramePacketGridRptDriverCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <FramePktGrdDriverData>[];
      json['data'].forEach((v) {
        data!.add(new FramePktGrdDriverData.fromJson(v));
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

class FramePktGrdDriverData {
  String? imeino;
  String? vehicleRegNo;
  String? imeiNo;

  FramePktGrdDriverData({this.imeino, this.vehicleRegNo, this.imeiNo});

  FramePktGrdDriverData.fromJson(Map<String, dynamic> json) {
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
