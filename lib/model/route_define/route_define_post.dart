class RouteDefinePost {
  RoutePost? data;
  bool? succeeded;
  String? errors;
  String? message;

  RouteDefinePost({this.data, this.succeeded, this.errors, this.message});

  RouteDefinePost.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new RoutePost.fromJson(json['data']) : null;
    succeeded = json['succeeded'];
    errors = json['errors'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['succeeded'] = this.succeeded;
    data['errors'] = this.errors;
    data['message'] = this.message;
    return data;
  }
}

class RoutePost {
  int? id;
  int? vendorSrNo;
  String? vendorName;
  int? branchSrNo;
  String? branchName;
  String? routeName;
  String? routeFrom;
  String? routeTo;
  String? latlang;

  RoutePost(
      {this.id,
      this.vendorSrNo,
      this.vendorName,
      this.branchSrNo,
      this.branchName,
      this.routeName,
      this.routeFrom,
      this.routeTo,
      this.latlang});

  RoutePost.fromJson(Map<String, dynamic> json) {
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
