// class DateWiseSearch {
//   int? pageNumber;
//   int? pageSize;
//   String? firstPage;
//   String? lastPage;
//   int? totalPages;
//   int? totalRecords;
//   String? nextPage;
//   Null? previousPage;
//   List<Data>? data;
//   bool? succeeded;
//   Null? errors;
//   Null? message;

//   DateWiseSearch(
//       {this.pageNumber,
//       this.pageSize,
//       this.firstPage,
//       this.lastPage,
//       this.totalPages,
//       this.totalRecords,
//       this.nextPage,
//       this.previousPage,
//       this.data,
//       this.succeeded,
//       this.errors,
//       this.message});

//   DateWiseSearch.fromJson(Map<String, dynamic> json) {
//     pageNumber = json['pageNumber'];
//     pageSize = json['pageSize'];
//     firstPage = json['firstPage'];
//     lastPage = json['lastPage'];
//     totalPages = json['totalPages'];
//     totalRecords = json['totalRecords'];
//     nextPage = json['nextPage'];
//     previousPage = json['previousPage'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//     succeeded = json['succeeded'];
//     errors = json['errors'];
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['pageNumber'] = this.pageNumber;
//     data['pageSize'] = this.pageSize;
//     data['firstPage'] = this.firstPage;
//     data['lastPage'] = this.lastPage;
//     data['totalPages'] = this.totalPages;
//     data['totalRecords'] = this.totalRecords;
//     data['nextPage'] = this.nextPage;
//     data['previousPage'] = this.previousPage;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     data['succeeded'] = this.succeeded;
//     data['errors'] = this.errors;
//     data['message'] = this.message;
//     return data;
//   }
// }

// class Data {
//   String? fromDate;
//   String? toDate;
//   List<GroupByDateTotal>? groupByDateTotal;
//   double? totalDistanceTravel;
//   List<DatewiseTravelHistoryData>? datewiseTravelHistoryData;

//   Data(
//       {this.fromDate,
//       this.toDate,
//       this.groupByDateTotal,
//       this.totalDistanceTravel,
//       this.datewiseTravelHistoryData});

//   Data.fromJson(Map<String, dynamic> json) {
//     fromDate = json['fromDate'];
//     toDate = json['toDate'];
//     if (json['groupByDateTotal'] != null) {
//       groupByDateTotal = <GroupByDateTotal>[];
//       json['groupByDateTotal'].forEach((v) {
//         groupByDateTotal!.add(new GroupByDateTotal.fromJson(v));
//       });
//     }
//     totalDistanceTravel = json['totalDistanceTravel'];
//     if (json['datewiseTravelHistoryData'] != null) {
//       datewiseTravelHistoryData = <DatewiseTravelHistoryData>[];
//       json['datewiseTravelHistoryData'].forEach((v) {
//         datewiseTravelHistoryData!
//             .add(new DatewiseTravelHistoryData.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['fromDate'] = this.fromDate;
//     data['toDate'] = this.toDate;
//     if (this.groupByDateTotal != null) {
//       data['groupByDateTotal'] =
//           this.groupByDateTotal!.map((v) => v.toJson()).toList();
//     }
//     data['totalDistanceTravel'] = this.totalDistanceTravel;
//     if (this.datewiseTravelHistoryData != null) {
//       data['datewiseTravelHistoryData'] =
//           this.datewiseTravelHistoryData!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class GroupByDateTotal {
//   String? transDate;
//   double? distanceTravel;

//   GroupByDateTotal({this.transDate, this.distanceTravel});

//   GroupByDateTotal.fromJson(Map<String, dynamic> json) {
//     transDate = json['transDate'];
//     distanceTravel = json['distanceTravel'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['transDate'] = this.transDate;
//     data['distanceTravel'] = this.distanceTravel;
//     return data;
//   }
// }

// class DatewiseTravelHistoryData {
//   String? vehicleRegNo;
//   String? imeino;
//   String? transDate;
//   double? distanceTravel;

//   DatewiseTravelHistoryData(
//       {this.vehicleRegNo, this.imeino, this.transDate, this.distanceTravel});

//   DatewiseTravelHistoryData.fromJson(Map<String, dynamic> json) {
//     vehicleRegNo = json['vehicleRegNo'];
//     imeino = json['imeino'];
//     transDate = json['transDate'];
//     distanceTravel = json['distanceTravel'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['vehicleRegNo'] = this.vehicleRegNo;
//     data['imeino'] = this.imeino;
//     data['transDate'] = this.transDate;
//     data['distanceTravel'] = this.distanceTravel;
//     return data;
//   }
// }
