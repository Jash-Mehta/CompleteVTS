class POIPost {
  List<AddPOIPostdata>? data;
  bool? succeeded;
  String? errors;
  String? message;

  POIPost({this.data, this.succeeded, this.errors, this.message});

  POIPost.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <AddPOIPostdata>[];
      json['data'].forEach((v) {
        data!.add(new AddPOIPostdata.fromJson(v));
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

class AddPOIPostdata {
  int? srNo;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? poiname;
  int? poiTypeId;
  String? poiTypeName;
  String? description;
  int? tolerance;
  int? vehicleSrNo;
  String? vehicleRegno;
  String? showPoi;

  AddPOIPostdata(
      {this.srNo,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.poiname,
      this.poiTypeId,
      this.poiTypeName,
      this.description,
      this.tolerance,
      this.vehicleSrNo,
      this.vehicleRegno,
      this.showPoi});

  AddPOIPostdata.fromJson(Map<String, dynamic> json) {
    srNo = json['srNo'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    poiname = json['poiname'];
    poiTypeId = json['poiTypeId'];
    poiTypeName = json['poiTypeName'];
    description = json['description'];
    tolerance = json['tolerance'];
    vehicleSrNo = json['vehicleSrNo'];
    vehicleRegno = json['vehicleRegno'];
    showPoi = json['showPoi'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['srNo'] = this.srNo;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['poiname'] = this.poiname;
    data['poiTypeId'] = this.poiTypeId;
    data['poiTypeName'] = this.poiTypeName;
    data['description'] = this.description;
    data['tolerance'] = this.tolerance;
    data['vehicleSrNo'] = this.vehicleSrNo;
    data['vehicleRegno'] = this.vehicleRegno;
    data['showPoi'] = this.showPoi;
    return data;
  }
}
