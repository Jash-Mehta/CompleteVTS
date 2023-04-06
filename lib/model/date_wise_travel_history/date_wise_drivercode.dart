class DateWiseDriverCodeModel {
  List<DateWiseDriverCodeData>? data;
  bool? succeeded;
  String? errors;
  String? message;

  DateWiseDriverCodeModel(
      {this.data, this.succeeded, this.errors, this.message});

  DateWiseDriverCodeModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DateWiseDriverCodeData>[];
      json['data'].forEach((v) {
        data!.add(new DateWiseDriverCodeData.fromJson(v));
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

class DateWiseDriverCodeData {
  var imeino;
  var vehicleRegNo;
  var imeiNo;

  DateWiseDriverCodeData({this.imeino, this.vehicleRegNo, this.imeiNo});

  DateWiseDriverCodeData.fromJson(Map<String, dynamic> json) {
    imeino = json['imeino'] ?? "";
    vehicleRegNo = json['vehicleRegNo']??"";
    imeiNo = json['imeiNo']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imeino'] = this.imeino;
    data['vehicleRegNo'] = this.vehicleRegNo;
    data['imeiNo'] = this.imeiNo;
    return data;
  }
}
