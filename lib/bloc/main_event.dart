import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';
import 'package:flutter_vts/model/alert/all_alert_master_response.dart';
import 'package:flutter_vts/model/alert_notification/fill_alert_notification_vehicle_response.dart';
import 'package:flutter_vts/model/assign_menu_rights_request.dart';
import 'package:flutter_vts/model/branch/add_branch_request.dart';
import 'package:flutter_vts/model/branch/edit_branch_response.dart';
import 'package:flutter_vts/model/device/add_device_request.dart';
import 'package:flutter_vts/model/driver/add_driver_master_request.dart';
import 'package:flutter_vts/model/geofence/search_geofence_create_response.dart';
import 'package:flutter_vts/model/login/forget_password_request.dart';
import 'package:flutter_vts/model/subscription/add_subscription_request.dart';
import 'package:flutter_vts/model/subscription/edit_subscription_resquest.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';
import 'package:flutter_vts/model/vehicle/add_vehicle_request.dart';
import 'package:flutter_vts/model/vehicle/edit_vehicle_request.dart';
import 'package:flutter_vts/model/vendor/edit_vendor_response.dart';
import 'package:flutter_vts/model/vendor/request/add_new_vendor_request.dart';
import 'package:flutter_vts/screen/profile/profile_detail/profile_detail_screen.dart';

import '../model/vendor/request/edit_vendor_request.dart';

class MainEvent {}

class LoginEvents extends MainEvent {
  String username;
  String password;
  LoginEvents({required this.username, required this.password});
}

class UpdateLoginEvents extends MainEvent {
  String menuCaption;
  int vendorSrNo;
  int branchSrNo;
  int userId;
  String sessionId;
  String token;

  UpdateLoginEvents(
      {required this.menuCaption,
      required this.vendorSrNo,
      required this.branchSrNo,
      required this.userId,
      required this.sessionId,
      required this.token});
}

class UpdateLogoutEvents extends MainEvent {
  String menuCaption;
  int vendorSrNo;
  int branchSrNo;
  int userId;
  String sessionId;
  String token;

  UpdateLogoutEvents(
      {required this.menuCaption,
      required this.vendorSrNo,
      required this.branchSrNo,
      required this.userId,
      required this.sessionId,
      required this.token});
}

class CheckForgetPasswordUserEvents extends MainEvent {
  String token;
  String searchEmaitId;
  CheckForgetPasswordUserEvents(
      {required this.searchEmaitId, required this.token});
}

class ForgetPasswordEvents extends MainEvent {
  String token;
  ForgetPasswordRequest forgetPasswordRequest;

  ForgetPasswordEvents(
      {required this.token, required this.forgetPasswordRequest});
}

class ResetPasswordEvents extends MainEvent {
  String token;
  ResetPasswordRequest resetPasswordRequest;

  ResetPasswordEvents(
      {required this.token, required this.resetPasswordRequest});
}

class DashboradEvents extends MainEvent {
  int vendorId;
  int branchId;
  String optionClicked;
  String aRAI_NONARAI;
  String username;
  int pageNumber;
  int pageSize;
  String token;

  DashboradEvents(
      {required this.vendorId,
      required this.branchId,
      required this.optionClicked,
      required this.aRAI_NONARAI,
      required this.username,
      required this.pageNumber,
      required this.pageSize,
      required this.token});
}

class ProfileDetailsEvents extends MainEvent {
  int vendorId;
  int branchId;
  int profileid;
  String token;

  ProfileDetailsEvents(
      {required this.vendorId,
      required this.branchId,
      required this.profileid,
      required this.token});
}

class UpdateProfileEvents extends MainEvent {
  int userId;
  ProfileUpdateRequest profileUpdateRequest;
  String token;

  UpdateProfileEvents(
      {required this.userId,
      required this.profileUpdateRequest,
      required this.token});
}

class AllVendorDetailEvents extends MainEvent {
  int pageNumber;
  int pageSize;
  String token;
  AllVendorDetailEvents(
      {required this.pageNumber, required this.pageSize, required this.token});
}

class AllVehicleDetailEvents extends MainEvent {
  int vendorId;
  int branchId;
  int pageNumber;
  int pageSize;
  String token;

  AllVehicleDetailEvents(
      {required this.vendorId,
      required this.branchId,
      required this.pageNumber,
      required this.pageSize,
      required this.token});
}

class SearchVehicleEvents extends MainEvent {
  int vendorId;
  int branchId;
  String searchText;
  String token;

  SearchVehicleEvents(
      {required this.vendorId,
      required this.branchId,
      required this.searchText,
      required this.token});
}

class AddVehicleEvents extends MainEvent {
  AddVehicleRequest addVehicleRequest;
  String token;
  AddVehicleEvents({required this.addVehicleRequest, required this.token});
}

class EditVehicleEvents extends MainEvent {
  EditVehicleRequest editVehicleRequest;
  String token;
  int vehicleid;
  EditVehicleEvents(
      {required this.editVehicleRequest,
      required this.vehicleid,
      required this.token});
}

class SearchVendorEvents extends MainEvent {
  String searchText;
  String token;

  SearchVendorEvents({required this.searchText, required this.token});
}

class AddVendorEvents extends MainEvent {
  AddNewVendorRequest addNewVendorRequest;
  String token;
  AddVendorEvents({required this.addNewVendorRequest, required this.token});
}

class EditVendorEvents extends MainEvent {
  EditVendorRequest editVendorRequest;
  String token;
  int vendorid;
  EditVendorEvents(
      {required this.editVendorRequest,
      required this.vendorid,
      required this.token});
}

class AllVendorNamesEvents extends MainEvent {
  String token;
  AllVendorNamesEvents({required this.token});
}

class AllDriverEvents extends MainEvent {
  int vendorId;
  int branchId;
  int pageNumber;
  int pageSize;
  String token;

  AllDriverEvents(
      {required this.vendorId,
      required this.branchId,
      required this.pageNumber,
      required this.pageSize,
      required this.token});
}

class SearchDriverEvents extends MainEvent {
  int vendorId;
  int branchId;
  String searchText;
  String token;

  SearchDriverEvents(
      {required this.vendorId,
      required this.branchId,
      required this.searchText,
      required this.token});
}

class AddDriverEvents extends MainEvent {
  late AddDriverRequest addDriverRequest;
  late String token;
  AddDriverEvents({required this.addDriverRequest, required this.token});
}

class EditDriverEvents extends MainEvent {
  AddDriverRequest addDriverRequest;
  String token;
  int srno;
  EditDriverEvents(
      {required this.addDriverRequest,
      required this.srno,
      required this.token});
}

class AllBranchNamesEvents extends MainEvent {
  String token;
  String branchid;
  AllBranchNamesEvents({required this.token, required this.branchid});
}

class AllDeviceEvents extends MainEvent {
  int vendorId;
  int branchId;
  int pageNumber;
  int pageSize;
  String token;

  AllDeviceEvents(
      {required this.vendorId,
      required this.branchId,
      required this.pageNumber,
      required this.pageSize,
      required this.token});
}

class AddDeviceEvents extends MainEvent {
  AddDeviceRequest adddeviceRequest;
  String token;
  AddDeviceEvents({required this.adddeviceRequest, required this.token});
}

class EditDeviceEvents extends MainEvent {
  AddDeviceRequest adddeviceRequest;
  int deviceId;
  String token;
  EditDeviceEvents(
      {required this.adddeviceRequest,
      required this.deviceId,
      required this.token});
}

class SearchDeviceEvents extends MainEvent {
  int vendorId;
  int branchId;
  String searchText;
  String token;

  SearchDeviceEvents(
      {required this.vendorId,
      required this.branchId,
      required this.searchText,
      required this.token});
}

// subscription

class AllSubscriptionEvents extends MainEvent {
  String token;
  int branchid;
  int vendorid;
  int pagesize;
  int totalpage;
  AllSubscriptionEvents(
      {required this.token,
      required this.branchid,
      required this.vendorid,
      required this.pagesize,
      required this.totalpage});
}

class SearchSubscriptionEvents extends MainEvent {
  String token;
  int branchid;
  int vendorid;
  String searchtext;
  SearchSubscriptionEvents(
      {required this.token,
      required this.branchid,
      required this.vendorid,
      required this.searchtext});
}

class AddSubscriptionEvents extends MainEvent {
  AddSubscriptionRequest addSubscriptionRequest;
  String token;
  AddSubscriptionEvents(
      {required this.addSubscriptionRequest, required this.token});
}

class UpdateSubscriptionEvents extends MainEvent {
  EditSubscriptionRequest editSubscriptionRequest;
  int subid;
  String token;
  UpdateSubscriptionEvents(
      {required this.editSubscriptionRequest,
      required this.subid,
      required this.token});
}

class AllBranchMasterEvents extends MainEvent {
  int vendorId;
  int pagenumber;
  int pagesize;
  String token;

  AllBranchMasterEvents(
      {required this.token,
      required this.vendorId,
      required this.pagenumber,
      required this.pagesize});
}

class SearchBranchEvents extends MainEvent {
  int vendorId;
  String searchText;
  String token;

  SearchBranchEvents(
      {required this.vendorId, required this.searchText, required this.token});
}

class AddBranchEvents extends MainEvent {
  String token;
  AddBranchRequest addBranchRequest;

  AddBranchEvents({required this.addBranchRequest, required this.token});
}

class EditBranchEvents extends MainEvent {
  int srno;
  int vendorid;
  String token;
  EditBranchRequest editBranchRequest;

  EditBranchEvents(
      {required this.srno,
      required this.vendorid,
      required this.editBranchRequest,
      required this.token});
}
// alert

class AddAlertEvents extends MainEvent {
  String token;
  AddAlertMasterRequest addAlertMasterRequest;

  AddAlertEvents({required this.addAlertMasterRequest, required this.token});
}

class AllAlertMasterEvents extends MainEvent {
  int vendorId;
  int branchId;
  int pagenumber;
  int pagesize;
  String token;

  AllAlertMasterEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.pagenumber,
      required this.pagesize});
}

class SearchAlertEvents extends MainEvent {
  int vendorId;
  int branchId;
  String searchText;
  String token;

  SearchAlertEvents(
      {required this.vendorId,
      required this.branchId,
      required this.searchText,
      required this.token});
}

class EditAlertEvents extends MainEvent {
  AddAlertMasterRequest addAlertMasterRequest;
  String token;
  String alerttext;
  EditAlertEvents(
      {required this.addAlertMasterRequest,
      required this.alerttext,
      required this.token});
}

// user

class AllCreateUserEvents extends MainEvent {
  int vendorId;
  int branchId;
  int pagenumber;
  int pagesize;
  String token;

  AllCreateUserEvents(
      {required this.token,
      required this.branchId,
      required this.vendorId,
      required this.pagenumber,
      required this.pagesize});
}

class SearchCreateUserEvents extends MainEvent {
  int vendorId;
  int branchId;
  String searchText;
  String token;

  SearchCreateUserEvents({
    required this.vendorId,
    required this.branchId,
    required this.searchText,
    required this.token,
  });
}

class AddUserEvents extends MainEvent {
  String token;
  AddUserRequest addUserRequest;

  AddUserEvents({required this.addUserRequest, required this.token});
}

class EditUserEvents extends MainEvent {
  String token;
  String userId;
  AddUserRequest addUserRequest;

  EditUserEvents(
      {required this.addUserRequest,
      required this.userId,
      required this.token});
}

class SerialNumberEvents extends MainEvent {
  String token;
  String apiName;
  SerialNumberEvents({required this.token, required this.apiName});
}

class AlertNotificationEvents extends MainEvent {
  int vendorId;
  int branchId;
  String arai;
  int pagenumber;
  int pagesize;
  String username;
  String displayStatus;
  String token;
  AlertNotificationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.arai,
      required this.username,
      required this.displayStatus,
      required this.pagenumber,
      required this.pagesize});
}

class SearchAlertNotificationEvents extends MainEvent {
  int vendorId;
  int branchId;
  String arai;
  String username;
  String displayStatus;
  String token;
  String search;
  int pageNumber;
  int pageSize;

  SearchAlertNotificationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.arai,
      required this.username,
      required this.displayStatus,
      required this.search,
      required this.pageNumber,
      required this.pageSize});
}

class DateWiseSearchAlertNotificationEvents extends MainEvent {
  int vendorId;
  int branchId;
  String arai;
  String username;
  String displayStatus;
  String token;
  String fromDate;
  String toDate;
  String formTime;
  String toTime;
  int pageNumber;
  int pageSize;

  DateWiseSearchAlertNotificationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.arai,
      required this.username,
      required this.displayStatus,
      required this.fromDate,
      required this.formTime,
      required this.toDate,
      required this.toTime,
      required this.pageNumber,
      required this.pageSize});
}

class AnalyticsReportsStatusEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String openClick;
  String araiNoarai;
  String username;
  int pageNumber;
  int pageSize;

  AnalyticsReportsStatusEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.openClick,
      required this.araiNoarai,
      required this.username,
      required this.pageNumber,
      required this.pageSize});
}

class SearchAnalyticsReportsStatusEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String openClick;
  String araiNoarai;
  String username;
  String vehicleNo;

  SearchAnalyticsReportsStatusEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.openClick,
      required this.araiNoarai,
      required this.username,
      required this.vehicleNo});
}

class AnalyticsReportsDetailsEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String openClick;
  String araiNoarai;
  String username;
  int vehiclesrno;

  AnalyticsReportsDetailsEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.openClick,
      required this.araiNoarai,
      required this.username,
      required this.vehiclesrno});
}

class FilteralertNotificationEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String username;
  String displayStatus;
  List<int> vehiclesrNo;
  List<String> alertCode;
  int pageNumber;
  int pageSize;

  FilteralertNotificationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.username,
      required this.displayStatus,
      required this.vehiclesrNo,
      required this.alertCode,
      required this.pageNumber,
      required this.pageSize});
}

class SearchFilteralertNotificationEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String username;
  String displayStatus;
  List<int> vehiclesrNo;
  List<String> alertCode;
  String searchText;
  int pageNumber;
  int pageSize;

  SearchFilteralertNotificationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.username,
      required this.displayStatus,
      required this.vehiclesrNo,
      required this.alertCode,
      required this.searchText,
      required this.pageNumber,
      required this.pageSize});
}

class ClearAlertNotificationByIdEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String username;
  int alertNotificatioID;

  ClearAlertNotificationByIdEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.username,
      required this.alertNotificatioID});
}

class ClearAllAlertNotificationByIdEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String username;

  ClearAllAlertNotificationByIdEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.username});
}

class VehicleSatusEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String fromDate;
  String toDate;
  String formTime;
  String toTime;
  String vehicleRegno;
  int pageNumber;
  int pageSize;

  VehicleSatusEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.fromDate,
      required this.toDate,
      required this.formTime,
      required this.toTime,
      required this.vehicleRegno,
      required this.pageNumber,
      required this.pageSize});
}

class VehicleHistoryFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String fromDate;
  String toDate;
  String formTime;
  String toTime;
  List<String> vehicleStatusList;
  List<int> vehicleList;
  int pageNumber;
  int pageSize;

  VehicleHistoryFilterEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.fromDate,
      required this.toDate,
      required this.formTime,
      required this.toTime,
      required this.vehicleStatusList,
      required this.vehicleList,
      required this.pageNumber,
      required this.pageSize});
}

class VehicleHistorySearchFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String fromDate;
  String toDate;
  String formTime;
  String toTime;
  List<String> vehicleStatusList;
  List<int> vehicleList;
  String searchText;
  int pageNumber;
  int pageSize;

  VehicleHistorySearchFilterEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.fromDate,
      required this.toDate,
      required this.formTime,
      required this.toTime,
      required this.vehicleStatusList,
      required this.vehicleList,
      required this.searchText,
      required this.pageNumber,
      required this.pageSize});
}

class VehicleHistoryByIdDetailEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNoarai;
  String fromDate;
  String toDate;
  String formTime;
  String toTime;
  int vehicleHistoryId;

  VehicleHistoryByIdDetailEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNoarai,
      required this.fromDate,
      required this.toDate,
      required this.formTime,
      required this.toTime,
      required this.vehicleHistoryId});
}

class VehicleStatusWithCountEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;

  VehicleStatusWithCountEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai});
}

class LiveTrackingEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String TrackingStatus;
  String araiNonarai;

  LiveTrackingEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.TrackingStatus,
      required this.araiNonarai});
}

class LiveTrackingByIdEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  int transactionId;

  LiveTrackingByIdEvents({
    required this.token,
    required this.vendorId,
    required this.branchId,
    required this.araiNonarai,
    required this.transactionId,
  });
}

class StartLocationEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;

  StartLocationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai});
}

class StartLocationIMEIEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  String imeiNUmber;

  StartLocationIMEIEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.imeiNUmber});
}

class NextLocationEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;

  NextLocationEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai});
}

class NextLocationIMEIEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  String imeiNUmber;

  NextLocationIMEIEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.imeiNUmber});
}

class LiveTrackingFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  List<int> vehicleSrNolist = [];

  LiveTrackingFilterEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.vehicleSrNolist});
}

class SearchLiveTrackingFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  List<int> vehicleSrNolist = [];
  String searchText;

  SearchLiveTrackingFilterEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.vehicleSrNolist,
      required this.searchText});
}

class SearchLiveTrackingEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String trackingStatus;
  String araiNonarai;
  String searchText;

  SearchLiveTrackingEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.trackingStatus,
      required this.araiNonarai,
      required this.searchText});
}

class GetGeofenceCreateDetailEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  int pageNumber;
  int pageSize;

  GetGeofenceCreateDetailEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.pageNumber,
      required this.pageSize});
}

class DeleteGeofenceCreateEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  int geofenceId;

  DeleteGeofenceCreateEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.geofenceId});
}

class SearchGeofenceCreateEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String searchText;

  SearchGeofenceCreateEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.searchText});
}

class AddGeofenceEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String geofencename;
  String category;
  String description;
  int tolerance;
  String showgeofence;
  String latitude;
  String longitude;
  String overlaytype;
  String rectanglebond;
  String rectanglearea;
  String rectanglehectares;
  String rectanglekilometer;
  String rectanglemiles;
  String address;
  int vehicleid;

  AddGeofenceEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.geofencename,
    required this.category,
    required this.description,
    required this.tolerance,
    required this.showgeofence,
    required this.latitude,
    required this.longitude,
    required this.overlaytype,
    required this.rectanglebond,
    required this.rectanglearea,
    required this.rectanglehectares,
    required this.rectanglekilometer,
    required this.rectanglemiles,
    required this.address,
    required this.vehicleid,
  });
}

class CreateAssignMenuRightsEvents extends MainEvent {
  String token;
  AssignMenuRightsRequest assignMenuRightsRequest;

  CreateAssignMenuRightsEvents(
      {required this.token, required this.assignMenuRightsRequest});
}

class RemoveAssignMenuRightsEvents extends MainEvent {
  String token;
  AssignMenuRightsRequest assignMenuRightsRequest;

  RemoveAssignMenuRightsEvents(
      {required this.token, required this.assignMenuRightsRequest});
}

//! Overspeed Events------------
class getOverSpeedEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  int pagesize;
  int pagenumber;
  getOverSpeedEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.pagesize,
    required this.pagenumber,
  });
}

class SearchOverSpeedCreateEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  int pagesize;
  int pagenumber;
  String searchText;
  SearchOverSpeedCreateEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.pagesize,
    required this.pagenumber,
    required this.searchText,
  });
}

// class getDriverMasterReportEvents extends MainEvent {
//   int srNo;
//   int vendorSrNo;
//   String vendorName;
//   int branchSrNo;
//   String branchName;
//   String driverCode;
//   String driverName;
//   String licenceNo;
//   String city;
//   String mobileNo;
//   DateTime doj;
//   String driverAddress;
//   String acUser;
//   String acStatus;
//   getDriverMasterReportEvents({required this.srNo, required this.vendorSrNo, required this.vendorName, required this.branchSrNo, required this.branchName, required this.driverCode, required this.licenceNo, required this.city, required this.mobileNo, required this.doj, required this.driverAddress, required this.acUser, required this.acStatus});
// }

class FramePacketReportEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  int pageNumber;
  int pageSize;

  FramePacketReportEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.pageNumber,
      required this.pageSize});
}

// abstract class FramePacketReport extends MainEvent{
//
//    int pageNumber;
//    int pageSize;
//    String firstPage;
//    String lastPage;
//    int totalPages;
//    int totalRecords;
//    String nextPage;
//    dynamic previousPage;
//    bool succeeded;
//    dynamic errors;
//    dynamic message;
//
//   FramepacketReportEvents({required this.pageNumber,required this.pageSize,required this.firstPage,required this.lastPage,required this.username,required this.pageNumber,required this.pageSize,required this.token});
// }

// ! here we start-----------------
class TravelSummaryReportEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  String totime;
  int pagesize;
  int pagenumber;
  TravelSummaryReportEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.pagesize,
    required this.pagenumber,
  });
}

//! TravelSummary Search Event-------------------------
class TravelSummarySearchEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  String totime;
  String searchtext;
  int pagesize;
  int pagenumber;
  TravelSummarySearchEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.searchtext,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.pagesize,
    required this.pagenumber,
  });
}

//! TravelSummary Filter Event-------------------------
class TravelSummaryFilterEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  String totime;
  String vehiclelist;
  int pagesize;
  int pagenumber;
  TravelSummaryFilterEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.vehiclelist,
    required this.pagesize,
    required this.pagenumber,
  });
}

//! DistanceSummary Event-------------------------
class DistanceSummaryEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  String totime;
  String IMEINO;
  int pagesize;
  int pagenumber;

  DistanceSummaryEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.IMEINO,
    required this.pagesize,
    required this.pagenumber,
  });
}

//! DistanceSummary Filter Event-------------------------
class DistanceSummaryFilterEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String summaryrange;
  String vehiclelist;
  int pagesize;
  int pagenumber;
  DistanceSummaryFilterEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.summaryrange,
    required this.vehiclelist,
    required this.pagesize,
    required this.pagenumber,
  });
}

//! DistanceSummary Search Event-------------------------
class DistanceSummarySearchEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdata;
  String fromtime;
  String todate;
  String totime;
  String searchtext;
  int pagesize;
  int pagenumber;
  DistanceSummarySearchEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdata,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.searchtext,
    required this.pagesize,
    required this.pagenumber,
  });
}

//! PointOfInterest Get  Event-------------------------
class GetPointOfInterestEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pagesize;
  int pagenumber;

  GetPointOfInterestEvent(
      {required this.token,
      required this.vendorid,
      required this.branchid,
      required this.pagesize,
      required this.pagenumber});
}
//End of PointOfInterest get Event

//! PointOfInterest Search  Event-------------------------
class SearchPointOfInterestEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String searchStr;

  SearchPointOfInterestEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.searchStr,
  });
}
//!End of PointOfInterest search Event

class DropdownPointOfInterestEvent extends MainEvent {
  String token;
  DropdownPointOfInterestEvent({
    required this.token,
  });
}

//! DeviceMasterFilter-----------------------------
class DeviceMasterFilter extends MainEvent {
  String token;
  String vendorid;
  String branchid;
  String deviceno;
  int pagenumber;
  int pagesize;
  DeviceMasterFilter({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.deviceno,
    required this.pagenumber,
    required this.pagesize,
  });
}

//!------------------
class vehicleStatusReportEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  int imeno;
  int pagenumber;
  int pagesize;
  vehicleStatusReportEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.imeno,
    required this.pagenumber,
    required this.pagesize,
  });
}

//!------------Vehicle status report filter----------------------
class Vehiclestatusreportfilter extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String vehiclelist;
  String toDate;
  String toTime;
  int imeno;
  int pagenumber;
  int pagesize;
  Vehiclestatusreportfilter({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.vehiclelist,
    required this.toDate,
    required this.toTime,
    required this.imeno,
    required this.pagenumber,
    required this.pagesize,
  });
}

//! FillRoute Define(Getting Route for VTSgeofence) GGR(Get Geofence Route)-----------------------
class GettingRouteGGR extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  GettingRouteGGR({
    required this.token,
    required this.vendorid,
    required this.branchid,
  });
}

class RoutesDetailByRoutesNameEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String routename;
  RoutesDetailByRoutesNameEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.routename,
  });
}

//! POI type event------------------
class Poitype extends MainEvent {
  String token;
  Poitype({
    required this.token,
  });
}

//! POI post data to server event------------------------------
class PoiPostdata extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String poiname;
  int poitypeID;
  String description;
  int tolerance;
  String locationlatitude;
  String locationlongitude;
  String showpoi;
  String address;
  int vehicleid;
  PoiPostdata({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.poiname,
    required this.poitypeID,
    required this.description,
    required this.tolerance,
    required this.locationlatitude,
    required this.locationlongitude,
    required this.showpoi,
    required this.address,
    required this.vehicleid,
  });
}

//! POI for delete data-----------------
class POIDeletedata extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int srno;
  POIDeletedata({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.srno,
  });
}
