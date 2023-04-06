class DeviceDriverCode {
  List<DMDFData>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  DeviceDriverCode({this.data, this.succeeded, this.errors, this.message});

  DeviceDriverCode.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DMDFData>[];
      json['data'].forEach((v) {
        data!.add(new DMDFData.fromJson(v));
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

class DMDFData {
  String? deviceNo;
  String? deviceName;

  DMDFData({this.deviceNo, this.deviceName});

  DMDFData.fromJson(Map<String, dynamic> json) {
    deviceNo = json['deviceNo'];
    deviceName = json['deviceName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceNo'] = this.deviceNo;
    data['deviceName'] = this.deviceName;
    return data;
  }
}
