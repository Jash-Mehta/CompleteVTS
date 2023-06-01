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
  String currentimeiNUmber;
  int prevTransactionId;
  String prevDate;
  String prevTime;
  String prevIMEINo;
  NextLocationIMEIEvents({
    required this.token,
    required this.vendorId,
    required this.branchId,
    required this.araiNonarai,
    required this.currentimeiNUmber,
    required this.prevTransactionId,
    required this.prevDate,
    required this.prevTime,
    required this.prevIMEINo,
  });
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

class FramePacketEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  String fromDate;
  String formTime;
  String toDate;
  String toTime;
  int imeno;
  String framepacketoption;
  int pageNumber;
  int pageSize;

  FramePacketEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.fromDate,
      required this.formTime,
      required this.toDate,
      required this.toTime,
      required this.imeno,
      required this.framepacketoption,
      required this.pageNumber,
      required this.pageSize});
}

class FramePacketGridEvents extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  String fromDate;
  String formTime;
  String toDate;
  String toTime;
  String vehicleList;
  String framepacketoption;
  int pageNumber;
  int pageSize;

  FramePacketGridEvents(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.fromDate,
      required this.formTime,
      required this.toDate,
      required this.toTime,
      required this.vehicleList,
      required this.framepacketoption,
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
  int pagenumber;
  int pagesize;
 
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
    required this.pagenumber,
    required this.pagesize,
  });
}

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

class DistanceSummarySearchEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdate;
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
    required this.fromdate,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.searchtext,
    required this.pagesize,
    required this.pagenumber,
  });
}

class DriverWiseVehicleAssignEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pagesize;
  int pagenumber;
  DriverWiseVehicleAssignEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.pagesize,
    required this.pagenumber,
  });
}

class SearchDriverwiseVehAssignDetailsEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pageSize;
  int pageNumber;
  String searchText;

  SearchDriverwiseVehAssignDetailsEvent(
      {required this.token,
      required this.vendorid,
      required this.branchid,
      required this.pageSize,
      required this.pageNumber,
      required this.searchText});
}

//! Event for get vehicle reports-----

class GetVehReportDetailsEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pageSize;
  int pageNumber;

  GetVehReportDetailsEvent(
      {required this.token,
      required this.vendorid,
      required this.branchid,
      required this.pageSize,
      required this.pageNumber});
}

// Event for serach text for Vahicle Details..
class SearchVehReportDetailsEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String searchText;
  int pageNumber;
  int pageSize;

  SearchVehReportDetailsEvent(
      {required this.token,
      required this.vendorid,
      required this.branchid,
      required this.pageNumber,
      required this.pageSize,
      required this.searchText});
}

//
//Event for get device master report-----

class GetDeviceMasterReportDetailsEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pageSize;
  int pageNumber;

  GetDeviceMasterReportDetailsEvent(
      {required this.token,
      required this.vendorid,
      required this.branchid,
      required this.pageSize,
      required this.pageNumber});
}

//Event for searrch data in  device master report-----

class SearchDeviceMasterReportDetailsEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pageSize;
  int pageNumber;
  String searchText;

  SearchDeviceMasterReportDetailsEvent(
      {required this.token,
      required this.vendorid,
      required this.branchid,
      required this.pageSize,
      required this.pageNumber,
      required this.searchText});
}

class DateWiseTravelHistoryEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String fromdate;
  String todate;
  String imeino;
  int pageSize;
  int pageNumber;

  DateWiseTravelHistoryEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.fromdate,
    required this.todate,
    required this.imeino,
    required this.pageSize,
    required this.pageNumber,
  });
}

class DriverMasterEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pageSize;
  int pageNumber;

  DriverMasterEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.pageSize,
    required this.pageNumber,
  });
}

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

class DeviceMasterReportEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  int pagenumber;
  int pagesize;
  DeviceMasterReportEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.pagenumber,
    required this.pagesize,
  });
}

class OverSpeedEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arai;
  String fromDate;
  String toDate;
  int imeno;
  int pagenumber;
  int pagesize;
  OverSpeedEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arai,
    required this.fromDate,
    required this.toDate,
    required this.imeno,
    required this.pagenumber,
    required this.pagesize,
  });
}

class OverSpeedFilterEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arai;
  String fromDate;
  String toDate;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  OverSpeedFilterEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arai,
    required this.fromDate,
    required this.toDate,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleStatusGroupEvent extends MainEvent {
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
  VehicleStatusGroupEvent({
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

class vehicleStatusSummaryEvent extends MainEvent {
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
  vehicleStatusSummaryEvent({
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

class vehicleGroupFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  vehicleGroupFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

class vehicleSummaryFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  vehicleSummaryFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleReportFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String vsrno;
  int pagenumber;
  int pagesize;
  VehicleReportFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.vsrno,
    required this.pagenumber,
    required this.pagesize,
  });
}

class DriverMasterFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String drivercode;
  int pagenumber;
  int pagesize;
  DriverMasterFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.drivercode,
    required this.pagenumber,
    required this.pagesize,
  });
}

class DriverVehicleFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String vsrno;
  int pagenumber;
  int pagesize;
  DriverVehicleFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.vsrno,
    required this.pagenumber,
    required this.pagesize,
  });
}

class DateWiseTravelFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String arai;
  String fromdate;
  String todate;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  DateWiseTravelFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.arai,
    required this.fromdate,
    required this.todate,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

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

class FrameFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String arai;
  String fromdate;
  String fromtime;
  String todate;
  String totime;
  String vehiclelist;
  String framepacketoption;
  int pagenumber;
  int pagesize;
  FrameFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.arai,
    required this.fromdate,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.vehiclelist,
    required this.framepacketoption,
    required this.pagenumber,
    required this.pagesize,
  });
}

class FrameGridFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String arai;
  String fromdate;
  String fromtime;
  String todate;
  String totime;
  String vehiclelist;
  String framepacketoption;
  int pagenumber;
  int pagesize;
  FrameGridFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.arai,
    required this.fromdate,
    required this.fromtime,
    required this.todate,
    required this.totime,
    required this.vehiclelist,
    required this.framepacketoption,
    required this.pagenumber,
    required this.pagesize,
  });
}

// Device master filter driver code
class DeviceMasterDrivercode extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  DeviceMasterDrivercode({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

// date wise travel history driver code event
class DateWiseDriverCodeEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  DateWiseDriverCodeEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

// Driver wise driver code
class DriverWiseDriverCodeEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  DriverWiseDriverCodeEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class OverSpeedVehicleFilterEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  OverSpeedVehicleFilterEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class FramepacketDriverCodeEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  FramepacketDriverCodeEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class FramepacketGridDriverCodeEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  FramepacketGridDriverCodeEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class VehicleStsRptDriverCodeEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  VehicleStsRptDriverCodeEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class DriverMasterDriverCodeEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  DriverMasterDriverCodeEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class SearchDriverMasterReportEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String searchText;
  int pagenumber;
  int pagesize;
  SearchDriverMasterReportEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.searchText,
    required this.pagenumber,
    required this.pagesize,
  });
}

class SearchDatewiseTravelReportEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arai;
  String fromDate;
  String todate;
  String searchText;
  int pagenumber;
  int pagesize;
  SearchDatewiseTravelReportEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arai,
    required this.fromDate,
    required this.todate,
    required this.searchText,
    required this.pagenumber,
    required this.pagesize,
  });
}

//Search event for Search frame packet...

class SearchFramePacktReportEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  String fromDate;
  String formTime;
  String toDate;
  String toTime;
  String searchText;
  String framepacketoption;
  int pageNumber;
  int pageSize;

  SearchFramePacktReportEvent(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.fromDate,
      required this.formTime,
      required this.toDate,
      required this.toTime,
      required this.searchText,
      required this.framepacketoption,
      required this.pageNumber,
      required this.pageSize});
}

//Search event for Search frame packet grid...

class SearchFramePacktGridEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  String araiNonarai;
  String fromDate;
  String formTime;
  String toDate;
  String toTime;
  String searchText;
  String framepacketoption;
  int pageNumber;
  int pageSize;

  SearchFramePacktGridEvent(
      {required this.token,
      required this.vendorId,
      required this.branchId,
      required this.araiNonarai,
      required this.fromDate,
      required this.formTime,
      required this.toDate,
      required this.toTime,
      required this.searchText,
      required this.framepacketoption,
      required this.pageNumber,
      required this.pageSize});
}

class SearchVehicleStatusGroupEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String searchText;
  int pagenumber;
  int pagesize;
  SearchVehicleStatusGroupEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.searchText,
    required this.pagenumber,
    required this.pagesize,
  });
}

class SearchOverSpeedCreateEvents extends MainEvent {
  String token;
  int vendorId;
  int barnchId;
  String arainonarai;
  String fromDate;
  String toDate;
  String searchText;
  int pageNumber;
  int pageSize;

  SearchOverSpeedCreateEvents(
      {required this.token,
      required this.vendorId,
      required this.barnchId,
      required this.arainonarai,
      required this.fromDate,
      required this.toDate,
      required this.searchText,
      required this.pageNumber,
      required this.pageSize});
}

class SearchVehicleStatusEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String searchText;
  int pagenumber;
  int pagesize;
  SearchVehicleStatusEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.searchText,
    required this.pagenumber,
    required this.pagesize,
  });
}

class SearchvehicleStatusSummaryEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String searchText;
  int pagenumber;
  int pagesize;
  SearchvehicleStatusSummaryEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.searchText,
    required this.pagenumber,
    required this.pagesize,
  });
}

class DateAndTimeWiseTravelEvents extends MainEvent {
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
  DateAndTimeWiseTravelEvents({
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

class DateAndTimeWiseSearchEvents extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String searchtxt;
  int pagenumber;
  int pagesize;
  DateAndTimeWiseSearchEvents({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.searchtxt,
    required this.pagenumber,
    required this.pagesize,
  });
}

class DateAndTimeWiseFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  DateAndTimeWiseFilterEvents({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleWiseTravelEvents extends MainEvent {
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
  VehicleWiseTravelEvents({
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

class VehicleWiseFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  VehicleWiseFilterEvents({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleWiseSearchEvents extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String toDate;
  String searchtxt;
  int pagenumber;
  int pagesize;
  VehicleWiseSearchEvents({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.toDate,
    required this.searchtxt,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleWiseTimeWiseTravelEvents extends MainEvent {
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
  VehicleWiseTimeWiseTravelEvents({
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

class VehicleWiseTimeWiseFilterEvents extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String vehiclelist;
  int pagenumber;
  int pagesize;
  VehicleWiseTimeWiseFilterEvents({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.vehiclelist,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleWiseTimeWiseSearchEvents extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String searchtxt;
  int pagenumber;
  int pagesize;
  VehicleWiseTimeWiseSearchEvents({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.searchtxt,
    required this.pagenumber,
    required this.pagesize,
  });
}

class VehicleVSrNoEvent extends MainEvent {
  String token;
  int vendorId;
  int branchId;
  VehicleVSrNoEvent({
    required this.token,
    required this.vendorId,
    required this.branchId,
  });
}

class FramePacketOptionGridEvent extends MainEvent {
  String token;
  String arai;
  FramePacketOptionGridEvent({
    required this.token,
    required this.arai,
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

class DropdownPointOfInterestEvent extends MainEvent {
  String token;
  DropdownPointOfInterestEvent({
    required this.token,
  });
}

//! Route data---------------------(getVstGeofecnce)>
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

//! Route Define Post Data---------------------------->
class RouteDefinePostEvents extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String routefrom;
  String routeto;
  String routename;
  String midwaypoint;
  RouteDefinePostEvents({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.routefrom,
    required this.routeto,
    required this.routename,
    required this.midwaypoint,
  });
}
//Event

class GetVehSpeedDataEvent extends MainEvent {
  String token;
  int vendorId;
  int branchid;
  String araino;
  String fromdate;
  String fromTime;
  String toDate;
  String toTime;
  String vehicleStatusList;
  String vehicleList;
  int pagenumber;
  int pagesize;
  GetVehSpeedDataEvent({
    required this.token,
    required this.vendorId,
    required this.branchid,
    required this.araino,
    required this.fromdate,
    required this.fromTime,
    required this.toDate,
    required this.toTime,
    required this.vehicleStatusList,
    required this.vehicleList,
    required this.pagenumber,
    required this.pagesize,
  });
}

//! VTSLive Geofence circle event------------->
class VTSLiveGeofenceEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String vehicleregNo;
  VTSLiveGeofenceEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.vehicleregNo,
  });
}

class VTSHistorySpeedParameterEvent extends MainEvent {
  String token;
  int vendorid;
  int branchid;
  String arainonarai;
  String imei;
  String fromdate;
  String todate;
  String fromtime;
  String totime;
  int pagenumber;
  int pagesize;
  VTSHistorySpeedParameterEvent({
    required this.token,
    required this.vendorid,
    required this.branchid,
    required this.arainonarai,
    required this.imei,
    required this.fromdate,
    required this.todate,
    required this.fromtime,
    required this.totime,
    required this.pagenumber,
    required this.pagesize,
  });
}