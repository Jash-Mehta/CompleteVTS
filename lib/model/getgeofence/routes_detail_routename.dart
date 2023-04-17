class RoutesDetailByRouteName {
  List<RoutesNameDetailList>? data;
  bool? succeeded;
  Null? errors;
  String? message;

  RoutesDetailByRouteName(
      {this.data, this.succeeded, this.errors, this.message});

  RoutesDetailByRouteName.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RoutesNameDetailList>[];
      json['data'].forEach((v) {
        data!.add(new RoutesNameDetailList.fromJson(v));
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

class RoutesNameDetailList {
  int? id;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? routeName;
  String? routeFrom;
  String? routeTo;
  String? latlang;

  RoutesNameDetailList(
      {this.id,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.routeName,
      this.routeFrom,
      this.routeTo,
      this.latlang});

  RoutesNameDetailList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vendorSrNo = json['vendorSrNo'];
    vendorName = json['vendorName'];
    branchSrNo = json['branchSrNo'];
    branchName = json['branchName'];
    routeName = json['routeName'];
    routeFrom = json['routeFrom'];
    routeTo = json['routeTo'];
    latlang = json['latlang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vendorSrNo'] = this.vendorSrNo;
    data['vendorName'] = this.vendorName;
    data['branchSrNo'] = this.branchSrNo;
    data['branchName'] = this.branchName;
    data['routeName'] = this.routeName;
    data['routeFrom'] = this.routeFrom;
    data['routeTo'] = this.routeTo;
    data['latlang'] = this.latlang;
    return data;
  }
}
