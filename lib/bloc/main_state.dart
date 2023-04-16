import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/model/alert/add_alert_master_response.dart';
import 'package:flutter_vts/model/alert/all_alert_master_response.dart';
import 'package:flutter_vts/model/alert/search_alert_master_screen.dart';
import 'package:flutter_vts/model/alert_notification/alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/date_wise_search_alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/filter_alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/search_alert_notification_response.dart';
import 'package:flutter_vts/model/analytic_report/analytic_report_by_id_detail_response.dart';
import 'package:flutter_vts/model/analytic_report/analytic_report_click_response.dart';
import 'package:flutter_vts/model/analytic_report/search_analytic_report_status_click_response.dart';
import 'package:flutter_vts/model/branch/add_branch_response.dart';
import 'package:flutter_vts/model/branch/all_branch_master_response.dart';
import 'package:flutter_vts/model/branch/branch_name_response.dart';
import 'package:flutter_vts/model/branch/search_branch_response.dart';
import 'package:flutter_vts/model/dashbord/dashboard_response.dart';
import 'package:flutter_vts/model/device/add_device_response.dart';
import 'package:flutter_vts/model/device/device_master_response.dart';
import 'package:flutter_vts/model/device/edit_device_response.dart';
import 'package:flutter_vts/model/device/search_device_response.dart';
import 'package:flutter_vts/model/driver/add_driver_master_response.dart';
import 'package:flutter_vts/model/driver/all_driver_master_response.dart';
import 'package:flutter_vts/model/driver/search_driver_master_response.dart';
import 'package:flutter_vts/model/geofence/get_geofence_create_details_response.dart';
import 'package:flutter_vts/model/geofence/search_geofence_create_response.dart';
import 'package:flutter_vts/model/live/live_tracking_filter_response.dart';
import 'package:flutter_vts/model/live/live_tracking_response.dart';
import 'package:flutter_vts/model/live/start_location_response.dart';
import 'package:flutter_vts/model/live/vehicle_status_with_count_response.dart';
import 'package:flutter_vts/model/login/check_forget_password_user_response.dart';
import 'package:flutter_vts/model/login/login_response.dart';
import 'package:flutter_vts/model/report/frame_packet_report_response.dart';
import 'package:flutter_vts/model/report/frame_packet_report_response.dart';
import 'package:flutter_vts/model/report/over_speed_report_response.dart';
import 'package:flutter_vts/model/report/search_frame_packet_report_response.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import 'package:flutter_vts/model/serial_number/serial_number_response.dart';
import 'package:flutter_vts/model/subscription/subscription_master_response.dart';
import 'package:flutter_vts/model/travel_summary/travel_summary.dart';
import 'package:flutter_vts/model/user/create_user/add_created_user_response.dart';
import 'package:flutter_vts/model/user/create_user/get_all_create_user_response.dart';
import 'package:flutter_vts/model/user/create_user/search_created_user_response.dart';
import 'package:flutter_vts/model/vehicle/add_vehicle_request.dart';
import 'package:flutter_vts/model/vehicle/all_vehicle_detail_response.dart';
import 'package:flutter_vts/model/vehicle/search_vehicle_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/model/vendor/add_new_vendor_response.dart';
import 'package:flutter_vts/model/vendor/all_vendor_detail_response.dart';
import 'package:flutter_vts/model/vendor/edit_vendor_response.dart';
import 'package:flutter_vts/model/vendor/search_vendor_response.dart';
import 'package:flutter_vts/screen/live_tracking_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_name_response.dart';
import 'package:flutter_vts/screen/profile/profile_detail/profile_detail_screen.dart';

import '../model/distanceSummary/distance_summary_filter.dart';
import '../model/distanceSummary/distance_summary_search.dart';
import '../model/distanceSummary/distancesummary_entity.dart';
import '../model/getgeofence.dart/getroute_name_list.dart';
import '../model/getgeofence.dart/routes_detail_routename.dart';
import '../model/point_of_interest/create_point_of_interest.dart';
import '../model/point_of_interest/dropdown_point_of_interest.dart';
import '../model/point_of_interest/poi_post.dart';
import '../model/point_of_interest/poi_type.dart';
import '../model/point_of_interest/search_point_of_interest.dart';
import '../model/report/device_master_filter.dart';
import '../model/report/driver_master_report_response.dart';
import '../model/report/frame_packet_report_response.dart';
import '../model/report/frame_packet_report_response.dart';
import '../model/report/over_speed_report_response.dart';
import '../model/report/over_speed_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_overspeed_response.dart';
import '../model/report/search_overspeed_response.dart';
import '../model/report/vehicle_status_filter_report.dart';
import '../model/report/vehicle_status_report.dart';
import '../model/travel_summary/travel_summary_filter.dart';
import '../model/travel_summary/travel_summary_search.dart';
import '../screen/distance_summary/distance_summary_screen.dart';

class MainState {
  @override
  String toString() {
    // TODO: implement toString
    return super.toString();
  }
}

class MainInitialState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//login

class LoginLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LoginLoadedState extends MainState {
  LoginResponse loginResponse;
  LoginLoadedState({required this.loginResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LoginErrorState extends MainState {
  String msg;
  LoginErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//update login

class UpdateLoginLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateLoginLoadedState extends MainState {
  LoginResponse loginResponse;
  UpdateLoginLoadedState({required this.loginResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateLoginErrorState extends MainState {
  String msg;
  UpdateLoginErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//update logout

class UpdateLogoutLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateLogoutLoadedState extends MainState {
  LoginResponse loginResponse;
  UpdateLogoutLoadedState({required this.loginResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateLogoutErrorState extends MainState {
  String msg;
  UpdateLogoutErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//check user email-id forget password

class CheckForgetPasswordUserLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CheckForgetPasswordUserLoadedState extends MainState {
  CheckForgetPasswordUserResponse checkForgetPasswordUserResponse;
  CheckForgetPasswordUserLoadedState(
      {required this.checkForgetPasswordUserResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CheckForgetPasswordUserErrorState extends MainState {
  String msg;
  CheckForgetPasswordUserErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//forget password

class ForgetPasswordLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgetPasswordLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  ForgetPasswordLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ForgetPasswordErrorState extends MainState {
  String msg;
  ForgetPasswordErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//reset password

class ResetPasswordLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ResetPasswordLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  ResetPasswordLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ResetPasswordErrorState extends MainState {
  String msg;
  ResetPasswordErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//get profile

class GetProfileDetailsLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetProfileDetailsLoadedState extends MainState {
  GetProfileResponse getProfileResponse;
  GetProfileDetailsLoadedState({required this.getProfileResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetProfileDetailsErrorState extends MainState {
  String msg;
  GetProfileDetailsErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//update profile

class UpdateProfileLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateProfileLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  UpdateProfileLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateProfileErrorState extends MainState {
  String msg;
  UpdateProfileErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//dashbord

class DashbordLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DashbordLoadedState extends MainState {
  DashbordResponse dashbordResponse;
  DashbordLoadedState({required this.dashbordResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DashbordErrorState extends MainState {
  String msg;
  DashbordErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//get all vendor

class AllVendorDetailLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllVendorDetailLoadedState extends MainState {
  AllVendorDetailResponse allVendorDetailResponse;
  AllVendorDetailLoadedState({required this.allVendorDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllVendorDetailErrorState extends MainState {
  String msg;
  AllVendorDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search vendor

class SearchVendorLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVendorLoadedState extends MainState {
  SearchVendorResponse searchVendorResponse;
  SearchVendorLoadedState({required this.searchVendorResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVendorErrorState extends MainState {
  String msg;
  SearchVendorErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//add new vendor

class AddVendorLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddVendorLoadedState extends MainState {
  AddNewVendorResponse addNewVendorResponse;
  AddVendorLoadedState({required this.addNewVendorResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddVendorErrorState extends MainState {
  String msg;
  AddVendorErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//edit new vendor

class EditVendorLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditVendorLoadedState extends MainState {
  EditVendorResponse editVendorResponse;
  EditVendorLoadedState({required this.editVendorResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditVendorErrorState extends MainState {
  String msg;
  EditVendorErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//get all vehicle detail

class AllVehicleDetailLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllVehicleDetailLoadedState extends MainState {
  AllVehicleDetailResponse allVehicleDetailResponse;
  AllVehicleDetailLoadedState({required this.allVehicleDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllVehicleDetailErrorState extends MainState {
  String msg;
  AllVehicleDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//search vehicle

class SearchVehicleDetailLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleDetailLoadedState extends MainState {
  SearchVehicleResponse searchVehicleResponse;
  SearchVehicleDetailLoadedState({required this.searchVehicleResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleDetailErrorState extends MainState {
  String msg;
  SearchVehicleDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//add vehicle

class AddVehicleLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddVehicleLoadedState extends MainState {
  AddVehicleResponse addVehicleResponse;
  AddVehicleLoadedState({required this.addVehicleResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddVehicleErrorState extends MainState {
  String msg;
  AddVehicleErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//edit vehicle

class EditVehicleLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditVehicleLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  EditVehicleLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditVehicleErrorState extends MainState {
  String msg;
  EditVehicleErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//device master

class AllDeviceLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllDeviceLoadedState extends MainState {
  AllDeviceResponse allDeviceResponse;
  AllDeviceLoadedState({required this.allDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllDeviceErrorState extends MainState {
  String msg;
  AllDeviceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//add device master

class AddDeviceLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddDeviceLoadedState extends MainState {
  AddDeviceResponse addDeviceResponse;
  AddDeviceLoadedState({required this.addDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddDeviceErrorState extends MainState {
  String msg;
  AddDeviceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//edit device master

class EditDeviceLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditDeviceLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  EditDeviceLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditDeviceErrorState extends MainState {
  String msg;
  EditDeviceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//all vendor name

class AllVendorNamesLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllVendorNamesLoadedState extends MainState {
  List<VendorNameResponse> vendorNameResponse;
  AllVendorNamesLoadedState({required this.vendorNameResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllVendorNamesErrorState extends MainState {
  String msg;
  AllVendorNamesErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//add branch master

class AllBranchNamesLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllBranchNamesLoadedState extends MainState {
  List<BranchNameResponse> branchnameresponse;
  AllBranchNamesLoadedState({required this.branchnameresponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllBranchNamesErrorState extends MainState {
  String msg;
  AllBranchNamesErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//search device

class SearchDeviceLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDeviceLoadedState extends MainState {
  SearchDeviceResponse searchDeviceResponse;
  SearchDeviceLoadedState({required this.searchDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDeviceErrorState extends MainState {
  String msg;
  SearchDeviceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// branch master
class AllBranchMasterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllBranchMasterLoadedState extends MainState {
  AllBranchMasterResponse allBranchMasterResponse;
  AllBranchMasterLoadedState({required this.allBranchMasterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllBranchMasterErrorState extends MainState {
  String msg;
  AllBranchMasterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
// all driver

class AllDriverLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllDriverLoadedState extends MainState {
  AllDriverResponse allDriverResponse;
  AllDriverLoadedState({required this.allDriverResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllDriverErrorState extends MainState {
  String msg;
  AllDriverErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//search driver

class SearchDriverLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverLoadedState extends MainState {
  SearchDriverResponse searchDriverResponse;
  SearchDriverLoadedState({required this.searchDriverResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverErrorState extends MainState {
  String msg;
  SearchDriverErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//add driver

class AddDriverLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddDriverLoadedState extends MainState {
  AddDriverResponse addDriverResponse;
  AddDriverLoadedState({required this.addDriverResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddDriverErrorState extends MainState {
  String msg;
  AddDriverErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//edit driver

class EditDriverLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditDriverLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  EditDriverLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditDriverErrorState extends MainState {
  String msg;
  EditDriverErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//Subscription

class AllSubscriptionLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllSubscriptionLoadedState extends MainState {
  AllSubscriptionResponse subscriptionMasterRespose;
  AllSubscriptionLoadedState({required this.subscriptionMasterRespose});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllSubscriptionErrorState extends MainState {
  String msg;
  AllSubscriptionErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
// search subscription

class SearchSubscriptionLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchSubscriptionLoadedState extends MainState {
  SearchSubscriptionResponse searchSubscriptionResponse;
  SearchSubscriptionLoadedState({required this.searchSubscriptionResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchSubscriptionErrorState extends MainState {
  String msg;
  SearchSubscriptionErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// add subscription
class AddSubscriptionLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddSubscriptionLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  AddSubscriptionLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddSubscriptionErrorState extends MainState {
  String msg;
  AddSubscriptionErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//Update subscription
class UpdateSubscriptionLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateSubscriptionLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  UpdateSubscriptionLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateSubscriptionErrorState extends MainState {
  String msg;
  UpdateSubscriptionErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search branch

class SearchBranchLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchBranchLoadedState extends MainState {
  SearchBranchResponse searchBranchResponse;
  SearchBranchLoadedState({required this.searchBranchResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchBranchErrorState extends MainState {
  String msg;
  SearchBranchErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//add branch

class AddBranchLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddBranchLoadedState extends MainState {
  AddBranchResponse addBranchResponse;
  AddBranchLoadedState({required this.addBranchResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddBranchErrorState extends MainState {
  String msg;
  AddBranchErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//edit branch
class EditBranchLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditBranchLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  EditBranchLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditBranchErrorState extends MainState {
  String msg;
  EditBranchErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// alert master

class AddAlertLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddAlertLoadedState extends MainState {
  AddAlertMasterResponse addAlertMasterResponse;
  AddAlertLoadedState({required this.addAlertMasterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddAlertErrorState extends MainState {
  String msg;
  AddAlertErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllAlertLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllAlertLoadedState extends MainState {
  AllAlertMasterResponse alertMasterResponse;
  AllAlertLoadedState({required this.alertMasterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllAlertErrorState extends MainState {
  String msg;
  AllAlertErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchAlertLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchAlertLoadedState extends MainState {
  SearchAlertMasterResponse searchAlertMasterResponse;
  SearchAlertLoadedState({required this.searchAlertMasterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchAlertErrorState extends MainState {
  String msg;
  SearchAlertErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditAlertLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditAlertLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  EditAlertLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditAlertErrorState extends MainState {
  String msg;
  EditAlertErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//create user

class AllCreatedUserLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllCreatedUserLoadedState extends MainState {
  GetAllCreateUserResponse getAllCreateUserResponse;
  AllCreatedUserLoadedState({required this.getAllCreateUserResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AllCreatedUserErrorState extends MainState {
  String msg;
  AllCreatedUserErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search user

class SearchCreatedUserLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchCreatedUserLoadedState extends MainState {
  SearchCreatedUserResponse searchCreatedUserResponse;
  SearchCreatedUserLoadedState({required this.searchCreatedUserResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchCreatedUserErrorState extends MainState {
  String msg;
  SearchCreatedUserErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//add user
class AddUserLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddUserLoadedState extends MainState {
  AddCreatedUserResponse addCreatedUserResponse;
  AddUserLoadedState({required this.addCreatedUserResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddUserErrorState extends MainState {
  String msg;
  AddUserErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//edit user
class EditUserLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditUserLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  EditUserLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class EditUserErrorState extends MainState {
  String msg;
  EditUserErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//serial no api

class SerialNumberLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SerialNumberLoadedState extends MainState {
  SerialNumberResponse serialNumberResponse;
  SerialNumberLoadedState({required this.serialNumberResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SerialNumberErrorState extends MainState {
  String msg;
  SerialNumberErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//alert notification
class AlertNotificationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AlertNotificationLoadedState extends MainState {
  AlertNotificationResponse alertNotificationResponse;
  AlertNotificationLoadedState({required this.alertNotificationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AlertNotificationErrorState extends MainState {
  String msg;
  AlertNotificationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search alert notification
class SearchAlertNotificationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchNotificationLoadedState extends MainState {
  SearchAlertNotificationResponse searchAlertNotificationResponse;
  SearchNotificationLoadedState(
      {required this.searchAlertNotificationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchNotificationErrorState extends MainState {
  String msg;
  SearchNotificationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//datewise alert notification search
class DateWiseSearchAlertNotificationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseSearchNotificationLoadedState extends MainState {
  DateWiseSearchAlertNotificationResponse
      dateWiseSearchAlertNotificationResponse;
  DateWiseSearchNotificationLoadedState(
      {required this.dateWiseSearchAlertNotificationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseSearchNotificationErrorState extends MainState {
  String msg;
  DateWiseSearchNotificationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//Analytics Reports Status click
class AnalyticsReportsStatusLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AnalyticsReportsStatusLoadedState extends MainState {
  AnalyticReportStatusClickResponse analyticReportStatusClickResponse;
  AnalyticsReportsStatusLoadedState(
      {required this.analyticReportStatusClickResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AnalyticsReportsStatusErrorState extends MainState {
  String msg;
  AnalyticsReportsStatusErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search Analytics Reports Status click
class SearchAnalyticsReportsStatusLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchAnalyticsReportsStatusLoadedState extends MainState {
  SearchAnalyticReportStatusClickResponse
      searchAnalyticReportStatusClickResponse;
  SearchAnalyticsReportsStatusLoadedState(
      {required this.searchAnalyticReportStatusClickResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchAnalyticsReportsStatusErrorState extends MainState {
  String msg;
  SearchAnalyticsReportsStatusErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AnalyticsReportsDetailsLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AnalyticsReportsDetailsLoadedState extends MainState {
  AnalyticReportDetailsResponse analyticReportDetailsResponse;
  AnalyticsReportsDetailsLoadedState(
      {required this.analyticReportDetailsResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AnalyticsReportsDetailsErrorState extends MainState {
  String msg;
  AnalyticsReportsDetailsErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Analytics Reports  filter
class FilteralertNotificationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FilteralertNotificationLoadedState extends MainState {
  FilterAlertNotificationResponse filterAlertNotificationResponse;
  FilteralertNotificationLoadedState(
      {required this.filterAlertNotificationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FilteralertNotificationErrorState extends MainState {
  String msg;
  FilteralertNotificationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search
class SearchFilteralertNotificationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchFilteralertNotificationLoadedState extends MainState {
  FilterAlertNotificationResponse filterAlertNotificationResponse;
  SearchFilteralertNotificationLoadedState(
      {required this.filterAlertNotificationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchFilteralertNotificationErrorState extends MainState {
  String msg;
  SearchFilteralertNotificationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// clear alert notification
class ClearAlertNotificationByIdLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ClearAlertNotificationByIdLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  ClearAlertNotificationByIdLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ClearAlertNotificationByIdErrorState extends MainState {
  String msg;
  ClearAlertNotificationByIdErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// clear all alert notification
class ClearAllAlertNotificationByIdLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ClearAllAlertNotificationByIdLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  ClearAllAlertNotificationByIdLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ClearAllAlertNotificationByIdErrorState extends MainState {
  String msg;
  ClearAllAlertNotificationByIdErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//vehicle status
class VehicleStatusLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusLoadedState extends MainState {
  VehicleStatusResponse vehicleStatusResponse;
  VehicleStatusLoadedState({required this.vehicleStatusResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusErrorState extends MainState {
  String msg;
  VehicleStatusErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//vehicle status filter
class VehicleHistoryFilterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleHistoryFilterLoadedState extends MainState {
  VehicleHistoryFilterResponse vehicleHistoryFilterResponse;
  VehicleHistoryFilterLoadedState({required this.vehicleHistoryFilterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleHistoryFilterErrorState extends MainState {
  String msg;
  VehicleHistoryFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//vehicle status search filter
class VehicleHistorySearchFilterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleHistorySearchFilterLoadedState extends MainState {
  VehicleHistoryFilterResponse vehicleHistoryFilterResponse;
  VehicleHistorySearchFilterLoadedState(
      {required this.vehicleHistoryFilterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleHistorySearchFilterErrorState extends MainState {
  String msg;
  VehicleHistorySearchFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// vehicle histroy by id detail
class VehicleHistoryByIdDetailLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleHistoryByIdDetailLoadedState extends MainState {
  List<VehicleHistoryByIdDetailResponse> vehicleHistoryByIdDetailResponse;
  VehicleHistoryByIdDetailLoadedState(
      {required this.vehicleHistoryByIdDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleHistoryByIdDetailErrorState extends MainState {
  String msg;
  VehicleHistoryByIdDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//vehicle status with count
class VehicleStatusWithCountLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusWithCountLoadedState extends MainState {
  List<VehicleStatusWithCountResponse> vehicleStatusWithCountResponse;
  VehicleStatusWithCountLoadedState(
      {required this.vehicleStatusWithCountResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusWithCountErrorState extends MainState {
  String msg;
  VehicleStatusWithCountErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//Live tracking
class LiveTrackingLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LiveTrackingLoadedState extends MainState {
  LiveTrackingResponse liveTrackingResponse;
  LiveTrackingLoadedState({required this.liveTrackingResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LiveTrackingErrorState extends MainState {
  String msg;
  LiveTrackingErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//Live tracking by id
class LiveTrackingByIdLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LiveTrackingByIdLoadedState extends MainState {
  List<LiveTrackingByIdResponse> liveTrackingByIdResponse;
  LiveTrackingByIdLoadedState({required this.liveTrackingByIdResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LiveTrackingByIdErrorState extends MainState {
  String msg;
  LiveTrackingByIdErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search Live tracking
class SearchLiveTrackingLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchLiveTrackingLoadedState extends MainState {
  List<SearchLiveTrackingResponse> searchliveTrackingResponse;
  SearchLiveTrackingLoadedState({required this.searchliveTrackingResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchLiveTrackingErrorState extends MainState {
  String msg;
  SearchLiveTrackingErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//start location
class StartLocationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StartLocationLoadedState extends MainState {
  List<StartLocationResponse> startLocationResponse;
  StartLocationLoadedState({required this.startLocationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StartLocationErrorState extends MainState {
  String msg;
  StartLocationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//start location  using IMEI
class StartLocationIMEILoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StartLocationIMEILoadedState extends MainState {
  List<StartLocationResponse> startLocationResponse;
  StartLocationIMEILoadedState({required this.startLocationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StartLocationIMEIErrorState extends MainState {
  String msg;
  StartLocationIMEIErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//Next location

class NextLocationLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class NextLocationLoadedState extends MainState {
  List<StartLocationResponse> startLocationResponse;
  NextLocationLoadedState({required this.startLocationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class NextLocationErrorState extends MainState {
  String msg;
  NextLocationErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//Next location imei

class NextLocationIMEILoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class NextLocationIMEILoadedState extends MainState {
  List<StartLocationResponse> startLocationResponse;
  NextLocationIMEILoadedState({required this.startLocationResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class NextLocationIMEIErrorState extends MainState {
  String msg;
  NextLocationIMEIErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//live tracking filter

class LiveTrackingFilterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LiveTrackingFilterLoadedState extends MainState {
  LiveTrackingFilterResponse liveTrackingFilterResponse;
  LiveTrackingFilterLoadedState({required this.liveTrackingFilterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class LiveTrackingFilterErrorState extends MainState {
  String msg;
  LiveTrackingFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//search live tracking filtre

class SearchLiveTrackingFilterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchLiveTrackingFilterLoadedState extends MainState {
  LiveTrackingFilterResponse liveTrackingFilterResponse;
  SearchLiveTrackingFilterLoadedState(
      {required this.liveTrackingFilterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchLiveTrackingFilterErrorState extends MainState {
  String msg;
  SearchLiveTrackingFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//geofence create
class GetGeofenceCreateDetailLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetGeofenceCreateDetailLoadedState extends MainState {
  GetGeofenceCreateDetailsResponse geofenceCreateDetailsResponse;
  GetGeofenceCreateDetailLoadedState(
      {required this.geofenceCreateDetailsResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetGeofenceCreateDetailErrorState extends MainState {
  String msg;
  GetGeofenceCreateDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//delete geofence create

class DeleteGeofenceCreateLoadingState extends MainState {
  DeleteGeofenceCreateLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DelectGeofenceCreateLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  DelectGeofenceCreateLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeleteGeofenceCreateErrorState extends MainState {
  String msg;
  DeleteGeofenceCreateErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//search geofence create

//delete geofence create

class SearchGeofenceCreateLoadingState extends MainState {
  SearchGeofenceCreateLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchGeofenceCreateLoadedState extends MainState {
  SearchGeofenceCreateResponse searchGeofenceCreateResponse;
  SearchGeofenceCreateLoadedState({required this.searchGeofenceCreateResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchGeofenceCreateErrorState extends MainState {
  String msg;
  SearchGeofenceCreateErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//!add geofence-----------------------------------------------

class AddGeofenceLoadingState extends MainState {
  AddGeofenceLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddGeofenceLoadedState extends MainState {
  AddGeofenceResponse addGeofenceResponse;
  AddGeofenceLoadedState({required this.addGeofenceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class AddGeofenceErrorState extends MainState {
  String msg;
  AddGeofenceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//create assign menu rights

class CreateAssignMenuRightsLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreateAssignMenuRightsLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  CreateAssignMenuRightsLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class CreateAssignMenuRightsErrorState extends MainState {
  String msg;
  CreateAssignMenuRightsErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//remove assign menu rights

class RemoveAssignMenuRightsLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RemoveAssignMenuRightsLoadedState extends MainState {
  EditDeviceResponse editDeviceResponse;
  RemoveAssignMenuRightsLoadedState({required this.editDeviceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! Overspeed report----------------------
class GetOverSpeedCreateDetailLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetOverSpeedCreateDetailLoadedState extends MainState {
  GetOverspeedReportResponse getOverspeedREportResponse;
  GetOverSpeedCreateDetailLoadedState(
      {required this.getOverspeedREportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetOverSpeedCreateDetailErrorState extends MainState {
  String msg;
  GetOverSpeedCreateDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RemoveAssignMenuRightsErrorState extends MainState {
  String msg;
  RemoveAssignMenuRightsErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! Search OverspeedData---------------------------------------
class SearchOverSpeedCreateLoadingState extends MainState {
  SearchOverSpeedCreateLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchOverSpeedCreateLoadedState extends MainState {
  search_overspeed_response searchOverSpeedCreateResponse;

  SearchOverSpeedCreateLoadedState(
      {required this.searchOverSpeedCreateResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchOverSpeedCreateErrorState extends MainState {
  String msg;
  SearchOverSpeedCreateErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//!  driver_master_report-----------------------------------------------

class DriverMasterLoadingState extends MainState {
  DriverMasterLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterLoadedState extends MainState {
  getDriverMasterReportResponse DriverMasterReportResponse;
  DriverMasterLoadedState({required this.DriverMasterReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterErrorState extends MainState {
  String msg;
  DriverMasterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Frame Packet Report

class FramePacketReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketReportLoadedState extends MainState {
  frame_packet_response FramePacketReportResponse;
  FramePacketReportLoadedState({required this.FramePacketReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketReportErrorState extends MainState {
  String msg;
  FramePacketReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// ! here we start--------------
//! TravelSummary ------All Data State------------
class TravelSummaryReportLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class TravelSummaryReportLoadedState extends MainState {
  travel_summary_response TravelSummaryResponse;
  TravelSummaryReportLoadedState({required this.TravelSummaryResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class TravelSummaryErrorState extends MainState {
  String msg;
  TravelSummaryErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! TravelSummary ------OnlySearch State------------
class TravelSummarySearchLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class TravelSummarySearchLoadedState extends MainState {
  TravelSummarySearch travelSummaryResponse;
  TravelSummarySearchLoadedState({required this.travelSummaryResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class TravelSummarySearchErrorState extends MainState {
  String msg;
  TravelSummarySearchErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! TravelSummary ------Only FilterState------------
class TravelSummaryFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class TravelSummaryFilterLoadedState extends MainState {
  TravelSummaryFilter travelSummaryFilterResponse;
  TravelSummaryFilterLoadedState({required this.travelSummaryFilterResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class TravelSummaryFilterErrorState extends MainState {
  String msg;
  TravelSummaryFilterErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! DistanceSummary ------Only Alldata State------------
class DistanceSummaryLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummaryLoadedState extends MainState {
  DistancesummaryEntity DistanceSummaryResponse;
  DistanceSummaryLoadedState({required this.DistanceSummaryResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummaryErrorState extends MainState {
  String msg;
  DistanceSummaryErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! DistanceSummary ------Only Filter State------------
class DistanceSummaryFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummaryFilterLoadedState extends MainState {
  DistanceSummaryFilter DistanceSummaryFilterResponse;
  DistanceSummaryFilterLoadedState(
      {required this.DistanceSummaryFilterResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummaryFilterErrorState extends MainState {
  String msg;
  DistanceSummaryFilterErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// ! Distance summary search loaded state-----------------
class DistanceSummarySearchLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummarySearchLoadedState extends MainState {
  DistanceSummarySearch distanceSummarySearch;
  DistanceSummarySearchLoadedState({required this.distanceSummarySearch});
}

//! Vehicle Report
class VehicleReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleReportLoadedState extends MainState {
  GetOverspeedReportResponse VehicleReportResponse;
  VehicleReportLoadedState({required this.VehicleReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleReportErrorState extends MainState {
  String msg;
  VehicleReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Date and Time wise distance
class DateAndTimeWiseDistanceLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseDistanceLoadedState extends MainState {
  GetOverspeedReportResponse DateAndTimeWiseDistanceResponse;
  DateAndTimeWiseDistanceLoadedState(
      {required this.DateAndTimeWiseDistanceResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseDistanceErrorState extends MainState {
  String msg;
  DateAndTimeWiseDistanceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Device Master Report

class DeviceMasterReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeviceMasterReportLoadedState extends MainState {
  GetOverspeedReportResponse DeviceMasterReportResponse;
  DeviceMasterReportLoadedState({required this.DeviceMasterReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeviceMasterReportErrorState extends MainState {
  String msg;
  DeviceMasterReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Driver Wise Vehicle Assign
class DriverWiseVehicleAssignLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseVehicleAssignLoadedState extends MainState {
  GetOverspeedReportResponse DriverWiseVehicleAssignResponse;
  DriverWiseVehicleAssignLoadedState(
      {required this.DriverWiseVehicleAssignResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseVehicleAssignErrorState extends MainState {
  String msg;
  DriverWiseVehicleAssignErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! PointOfInterest ------Only create State------------
class PointOfInterestCreateLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class PointOfInterestCreateLoadedState extends MainState {
  CreatePointOfInterest createPointOfInterest;

  PointOfInterestCreateLoadedState({required this.createPointOfInterest});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PointOfInterestCreateErrorState extends MainState {
  String msg;
  PointOfInterestCreateErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! PointOfInterest ------Only All State------------
class PointOfInterestFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class PointOfInterestFilterLoadedState extends MainState {
  DistanceSummaryFilter DistanceSummaryFilterResponse;
  PointOfInterestFilterLoadedState(
      {required this.DistanceSummaryFilterResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PointOfInterestFilterErrorState extends MainState {
  String msg;
  PointOfInterestFilterErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! Point of Interest ------Only Search State------------
class SearchPointOfInterestLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class SearchPointOfInterestLoadedState extends MainState {
  SearchPointOfInterest searchPointOfInterest;
  SearchPointOfInterestLoadedState({required this.searchPointOfInterest});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchPointOfInterestErrorState extends MainState {
  String msg;
  SearchPointOfInterestErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//end of searching of Point of Interest
//! PointOfInterest DropdownDetail-------------------
class PointofInterestDropdownLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class PointofInterestDropdownLoadedState extends MainState {
  DropdownPointofInterest dropdownPointOfInterest;
  PointofInterestDropdownLoadedState({required this.dropdownPointOfInterest});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class PointofInterestDropdownErrorState extends MainState {
  String msg;
  PointofInterestDropdownErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! DeviceMaster Filter-----------------------------------
class DeviceMasterFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DeviceMasterFilterLoadedState extends MainState {
  DeviceMasterFilterModel deviceMasterFilter;
  DeviceMasterFilterLoadedState({
    required this.deviceMasterFilter,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeviceMasterFilterErorrState extends MainState {
  String msg;
  DeviceMasterFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//!-----------------------
class VehicleStatusReportLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusReportLoadedState extends MainState {
  VehicleStatusReportModel VehicleStatusReportResponse;
  VehicleStatusReportLoadedState({required this.VehicleStatusReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusReportErrorState extends MainState {
  String msg;
  VehicleStatusReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! filter of vehicle status---------------------------
class VehicleStatusFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusFilterLoadedState extends MainState {
  VehicleStatusReportFilter VehicleStatusReportResponse;
  VehicleStatusFilterLoadedState({required this.VehicleStatusReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatuFilterErrorState extends MainState {
  String msg;
  VehicleStatuFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! RouteName List(Geofence)-----------------------
class RouteNameListLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class RouteNameListLoadedState extends MainState {
  RouteNameList routenamelist;
  RouteNameListLoadedState({
    required this.routenamelist,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RouteNameListErorrState extends MainState {
  String msg;
  RouteNameListErorrState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! GetRoutesDetailByRoutesname-------------
class GetRoutesDetailLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class GetRoutesDetailLoadedState extends MainState {
  RoutesDetailByRouteName routenamelist;
  GetRoutesDetailLoadedState({
    required this.routenamelist,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetRoutesDetailErrorState extends MainState {
  String msg;
  GetRoutesDetailErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! POI type code--------------------
class POITypeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class POITypeLoadedState extends MainState {
  POITypeCode poitypelist;
  POITypeLoadedState({
    required this.poitypelist,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class POITypeErrorState extends MainState {
  String msg;
  POITypeErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//! POI post states-------------------
class POIPostLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class POIPostLoadedState extends MainState {
  POIPost poipost;
  POIPostLoadedState({
    required this.poipost,
  });
    @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class POIPostErrorState extends MainState {
  String msg;
  POIPostErrorState ({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//! POI Delete data --------------------------
class POIDeleteLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class POIDeleteLoadedState extends MainState {
 EditDeviceResponse editDeviceResponse;
  POIDeleteLoadedState({required this.editDeviceResponse});
    @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class POIDeleteErrorState extends MainState {
  String msg;
  POIDeleteErrorState ({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//   getDriverMasterReportResponse  DriverMasterReportResponse;
//   DriverMasterReportLoadedState({required this.DriverMasterReportResponse});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }
