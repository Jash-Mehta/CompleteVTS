import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/model/vehicle_history/get_veh_speed_response.dart';
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
import 'package:flutter_vts/model/report/date_and_timewise_filter.dart';
import 'package:flutter_vts/model/report/vehicle_wise_timewise_search.dart';
import 'package:flutter_vts/model/serial_number/serial_number_response.dart';
import 'package:flutter_vts/model/subscription/subscription_master_response.dart';
import 'package:flutter_vts/model/travel_summary/travel_summary.dart';
import 'package:flutter_vts/model/user/create_user/add_created_user_response.dart';
import 'package:flutter_vts/model/user/create_user/get_all_create_user_response.dart';
import 'package:flutter_vts/model/user/create_user/search_created_user_response.dart';
import 'package:flutter_vts/model/vehicle/add_vehicle_request.dart';
import 'package:flutter_vts/model/vehicle/all_vehicle_detail_response.dart';
import 'package:flutter_vts/model/login/login_response.dart';
import 'package:flutter_vts/model/vehicle/search_vehicle_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/model/vendor/add_new_vendor_response.dart';
import 'package:flutter_vts/model/vendor/all_vendor_detail_response.dart';
import 'package:flutter_vts/model/vendor/edit_vendor_response.dart';
import 'package:flutter_vts/model/vendor/search_vendor_response.dart';
import 'package:flutter_vts/model/login/check_forget_password_user_response.dart';
import 'package:flutter_vts/screen/live_tracking_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_name_response.dart';
import 'package:flutter_vts/screen/profile/profile_detail/profile_detail_screen.dart';
import 'package:flutter_vts/model/report/frame_packet_report_response.dart';
import 'package:flutter_vts/model/report/frame_packet_report_response.dart';
import 'package:flutter_vts/model/report/over_speed_report_response.dart';
import 'package:flutter_vts/model/report/search_frame_packet_report_response.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';
import 'package:flutter_vts/model/report/search_overspeed_response.dart';

import '../model/Driver_Master/driver_master.dart';
import '../model/Driver_Master/driver_master_drivercode.dart';
import '../model/Driver_Master/search_driver_master_report_response.dart';
import '../model/date_wise_travel_history/date_wise_drivercode.dart';
import '../model/date_wise_travel_history/date_wise_travel_filter.dart';
import '../model/date_wise_travel_history/date_wise_travel_history.dart';
import '../model/date_wise_travel_history/search_datewise_travel_history_response.dart';
import '../model/device_master/get_device_master_report.dart';
import '../model/device_master/search_device_master_report.dart';
import '../model/distanceSummary/distance_summary_filter.dart';
import '../model/distanceSummary/distance_summary_search.dart';
import '../model/distanceSummary/distancesummary_entity.dart';
import '../model/driver_wise_vehicle_assign/driver_wise_drivercode.dart';
import '../model/driver_wise_vehicle_assign/driver_wise_vehicle_assign.dart';
import '../model/driver_wise_vehicle_assign/driver_wise_vehicle_filter.dart';
import '../model/driver_wise_vehicle_assign/search_driver_vehicle_assign.dart';
import '../model/getgeofence/getroute_name_list.dart';
import '../model/getgeofence/routes_detail_routename.dart';
import '../model/live/nextlocation_imei.dart';
import '../model/live/startlocation_imei.dart';
import '../model/live/vts_live_geo_response.dart';
import '../model/point_of_interest/create_point_of_interest.dart';
import '../model/point_of_interest/dropdown_point_of_interest.dart';
import '../model/point_of_interest/poi_post.dart';
import '../model/point_of_interest/poi_type.dart';
import '../model/point_of_interest/search_point_of_interest.dart';
import '../model/report/date_and_timewise_search.dart';
import '../model/report/date_and_timewise_travel.dart';
import '../model/report/device_master_filter.dart';
import '../model/report/device_master_filter_drivercode.dart';
import '../model/report/device_master_report.dart';
import '../model/Driver_Master/driver_master_filter.dart';
import '../model/report/driver_master_report_response.dart';
import '../model/report/frame_filter.dart';
import '../model/report/frame_grid_filter.dart';
import '../model/report/frame_packet_drivercode.dart';
import '../model/report/frame_packet_report_response.dart';
import '../model/report/frame_packet_report_response.dart';
import '../model/report/frame_packetgrid_drivercode.dart';
import '../model/report/frame_packetoption_grid.dart';
import '../model/report/framepacketgrid.dart';
import '../model/report/over_speed_report_response.dart';
import '../model/report/over_speed_report_response.dart';
import '../model/report/overspeed_filter.dart';
import '../model/report/overspeed_vehicle_filter.dart';
import '../model/report/search_driverwise_veh_rpt.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_pckt_grid_response.dart';
import '../model/report/search_frame_pckt_report.dart';
import '../model/report/search_overspeed_response.dart';
import '../model/report/search_overspeed_response.dart';
import '../model/report/search_vehicle_status_group_response.dart';
import '../model/report/search_vehicle_status_response.dart';
import '../model/report/search_vehicle_status_summary.dart';
import '../model/report/vehicle_group_filter.dart';
import '../model/report/vehicle_status_filter_report.dart';
import '../model/report/vehicle_status_group.dart';
import '../model/report/vehicle_status_report.dart';
import '../model/report/vehicle_status_report_drivercode.dart';
import '../model/report/vehicle_status_summary.dart';
import '../model/report/vehicle_summary_filter.dart';
import '../model/report/vehicle_vsrno.dart';
import '../model/report/vehicle_wise_search.dart';
import '../model/report/vehicle_wise_timewise_filter.dart';
import '../model/report/vehicle_wise_timewise_travel.dart';
import '../model/report/vehicle_wise_travel.dart';
import '../model/report/vehicle_wise_travel_filter.dart';
import '../model/route_define/route_define_post.dart';
import '../model/travel_summary/travel_summary_filter.dart';
import '../model/travel_summary/travel_summary_search.dart';
import '../model/vehicle_history/vts_history_speed_parameter.dart';
import '../model/vehicle_master/search_vehicle_report_data_response.dart';
import '../model/vehicle_master/vehicle_master_filter.dart';
import '../model/vehicle_master/vehicle_report_detail.dart';

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

//End
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

//!start location  using IMEI
class StartLocationIMEILoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class StartLocationIMEILoadedState extends MainState {
  List<StartLocationImei> startLocationResponse;
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
//!Next location imei

class NextLocationIMEILoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class NextLocationIMEILoadedState extends MainState {
  List<NextLocationImei> startLocationResponse;
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

//Overspeed
class OverSpeedLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OverSpeedLoadedState extends MainState {
  GetOverspeedReportResponse OverspeedReportResponse;
  OverSpeedLoadedState({required this.OverspeedReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OverSpeedErrorState extends MainState {
  String msg;
  OverSpeedErrorState({required this.msg});

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

class SearchOverSpeedCreateLoadingState extends MainState {
  SearchOverSpeedCreateLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchOverSpeedCreateLoadedState extends MainState {
  SearchVehOverSpeedRpt searchOverSpeedCreateResponse;

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

//driver_master_report-----------------------------------------------

class DriverMasterLoadingState extends MainState {
  DriverMasterLoadingState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterLoadedState extends MainState {
  DriverMasterReport drivermasterreportresponse;
  DriverMasterLoadedState({required this.drivermasterreportresponse});

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

class FramePacketLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FramePacketLoadedState extends MainState {
  FramePacketData FramePacketResponse;
  FramePacketLoadedState({required this.FramePacketResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketErrorState extends MainState {
  String msg;
  FramePacketErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Frame packet Grid ---------------------

class FramePacketGridLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FramePacketGridLoadedState extends MainState {
  FramePacketGridModel FramePacketGridResponse;
  FramePacketGridLoadedState({required this.FramePacketGridResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketGridErrorState extends MainState {
  String msg;
  FramePacketGridErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//vehicle status group

class VehicleStatusGroupLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusGroupLoadedState extends MainState {
  VehicleStatusGroupModel VehicleStatusGroupResponse;
  VehicleStatusGroupLoadedState({required this.VehicleStatusGroupResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusGroupErrorState extends MainState {
  String msg;
  VehicleStatusGroupErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDatewiseTravelReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDatewiseTravelReportLoadedState extends MainState {
  SearchDatewiseTravelHistryRpt searchResponse;
  SearchDatewiseTravelReportLoadedState({required this.searchResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDatewiseTravelReportErrorState extends MainState {
  String msg;
  SearchDatewiseTravelReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverMasterReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverMasterReportLoadedState extends MainState {
  SearchDriverMasterRpt searchResponse;
  SearchDriverMasterReportLoadedState({required this.searchResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverMasterReportErrorState extends MainState {
  String msg;
  SearchDriverMasterReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle Status Report

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

// Vehicle Status Summary
class VehicleStatusSummaryLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusSummaryLoadedState extends MainState {
  VehicleStatusSummaryModel VehicleStatusSummaryResponse;
  VehicleStatusSummaryLoadedState({required this.VehicleStatusSummaryResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStatusSummaryErrorState extends MainState {
  String msg;
  VehicleStatusSummaryErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle status report filter--------
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

//! Vehicle Summary Search------------------
class SearchVehicleStatusSummaryLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleStatusSummaryLoadedState extends MainState {
  SearchVehicleStatusSummaryRpt searchVehicleStatusGroupResponse;
  SearchVehicleStatusSummaryLoadedState(
      {required this.searchVehicleStatusGroupResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleStatusSummaryErrorState extends MainState {
  String msg;
  SearchVehicleStatusSummaryErrorState({required this.msg});

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

// Distance summary search
class DistanceSummarySearchLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummarySearchLoadedState extends MainState {
  DistanceSummarySearchModel distancesummarysearch;
  DistanceSummarySearchLoadedState({required this.distancesummarysearch});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DistanceSummarySearchErrorState extends MainState {
  String msg;
  DistanceSummarySearchErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle Report
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

class VTSHistorySpeedParameterLoadingState extends MainState{
   List<Object> get props => throw UnimplementedError();
}
class VTSHistorySpeedParameterLoadedState extends MainState{
  VTSHistorySpeedParameter vtsLiveGeo;
   VTSHistorySpeedParameterLoadedState({required this.vtsLiveGeo});
     @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class VTSHistorySpeedParameterErrorState extends MainState{
   String msg;
  VTSHistorySpeedParameterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}


// // Date and Time wise distance
// class DateAndTimeWiseDistanceLoadingState extends MainState {
//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }

// class DateAndTimeWiseDistanceLoadedState extends MainState {
//   GetOverspeedReportResponse DateAndTimeWiseDistanceResponse;
//   DateAndTimeWiseDistanceLoadedState(
//       {required this.DateAndTimeWiseDistanceResponse});

//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }

// class DateAndTimeWiseDistanceErrorState extends MainState {
//   String msg;
//   DateAndTimeWiseDistanceErrorState({required this.msg});

//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }

// Driver Wise Vehicle Assign
class DriverWiseVehicleAssignLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseVehicleAssignLoadedState extends MainState {
  DriverWiseVehicleAssign DriverWiseVehicleAssignResponse;
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

// Driver wise vehicle assign filter
class DriverWiseVehicleFilterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseVehicleFilterLoadedState extends MainState {
  DriverWiseVehicleFilter DriverWiseVehicleFilterResponse;
  DriverWiseVehicleFilterLoadedState(
      {required this.DriverWiseVehicleFilterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseVehicleFilterErrorState extends MainState {
  String msg;
  DriverWiseVehicleFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Date wise Travel history filter
class DateWiseTravelFilterLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseTravelFilterLoadedState extends MainState {
  DateWiseTravelFilterModel dateWiseTravelFilterResponse;
  DateWiseTravelFilterLoadedState({required this.dateWiseTravelFilterResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseTravelFilterErrorState extends MainState {
  String msg;
  DateWiseTravelFilterErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Driver wise Vehicle assign search
class SearchDriverVehAssignReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverVehAssignReportLoadedState extends MainState {
  SearchDriverwiseVehRpt searchvehassignResponse;
  SearchDriverVehAssignReportLoadedState(
      {required this.searchvehassignResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDriverVehAssignReportErrorState extends MainState {
  String msg;
  SearchDriverVehAssignReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle Report State
class GetVehicleReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetVehicleReportLoadedState extends MainState {
  VehicleReportDetails vehicleReportResponse;
  GetVehicleReportLoadedState({required this.vehicleReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetVehicleReportErrorState extends MainState {
  String msg;
  GetVehicleReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//End

//State for Search text for Vehicle Details...
// Vehicle Report State
class SearchVehicleReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleReportLoadedState extends MainState {
  SearchingVehicleDetailsReportData searchVehicleReportResponse;
  SearchVehicleReportLoadedState({required this.searchVehicleReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleReportErrorState extends MainState {
  String msg;
  SearchVehicleReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//Search Device Master Report Data State----
// Device Master Report State
class SearchDeviceMasterReportLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDeviceMasterReportLoadedState extends MainState {
  SearchDeviceMasterReport searchdmReportResponse;
  SearchDeviceMasterReportLoadedState({required this.searchdmReportResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchDeviceMasterReportErrorState extends MainState {
  String msg;
  SearchDeviceMasterReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//End

class DateWiseTravelHistoryLoadingState extends MainState {
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseTravelHistoryLoadedState extends MainState {
  DateWiseTravelHistory datedisetravelhistoryresponse;
  DateWiseTravelHistoryLoadedState(
      {required this.datedisetravelhistoryresponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseTravelHistoryErrorState extends MainState {
  String msg;
  DateWiseTravelHistoryErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// device master report
class DeviceMasterReportLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DeviceMasterReportLoadedState extends MainState {
  DeviceMasterModel deviceData;
  DeviceMasterReportLoadedState({
    required this.deviceData,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DeviceMasterReportErorrState extends MainState {
  String msg;
  DeviceMasterReportErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Date and time wise distance/travel
class DateAndTimeWiseTravelLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseTravelLoadedState extends MainState {
  DateAndTimeWiseTravel dateandtimewisetravelResponse;
  DateAndTimeWiseTravelLoadedState(
      {required this.dateandtimewisetravelResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseTravelErrorState extends MainState {
  String msg;
  DateAndTimeWiseTravelErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// date and time wise filter history
class DateAndTimeWiseFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseFilterLoadedState extends MainState {
  DateAndTimeWiseFilter dateandtimewisefilterResponse;
  DateAndTimeWiseFilterLoadedState(
      {required this.dateandtimewisefilterResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseFilterErrorState extends MainState {
  String msg;
  DateAndTimeWiseFilterErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// date and time wise search history
class DateAndTimeWiseSearchLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseSearchLoadedState extends MainState {
  DateAndTimeWiseSearchModel dateandtimewisesearchResponse;
  DateAndTimeWiseSearchLoadedState(
      {required this.dateandtimewisesearchResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateAndTimeWiseSearchErrorState extends MainState {
  String msg;
  DateAndTimeWiseSearchErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle Wise Travel History
class VehicleWiseTravelLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTravelLoadedState extends MainState {
  VehicleWiseTravelModel vehiclewisetravelResponse;
  VehicleWiseTravelLoadedState({required this.vehiclewisetravelResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTravelErrorState extends MainState {
  String msg;
  VehicleWiseTravelErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle wise time wise travel history
class VehicleWiseTimeWiseTravelLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTimeWiseTravelLoadedState extends MainState {
  VehicleWiseTimeWiseTravelModel vehiclewisewimewisetravelResponse;
  VehicleWiseTimeWiseTravelLoadedState(
      {required this.vehiclewisewimewisetravelResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTimeWiseTravelErrorState extends MainState {
  String msg;
  VehicleWiseTimeWiseTravelErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle wise filter history
class VehicleWiseFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseFilterLoadedState extends MainState {
  VehicleWiseFilterModel vehiclewisefilterResponse;
  VehicleWiseFilterLoadedState({required this.vehiclewisefilterResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseFilterErrorState extends MainState {
  String msg;
  VehicleWiseFilterErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle wise time wise filter history
class VehicleWiseTimeWiseFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTimeWiseFilterLoadedState extends MainState {
  VehicleWiseTimeWiseFilterModel vehiclewisetimewisefilterResponse;
  VehicleWiseTimeWiseFilterLoadedState(
      {required this.vehiclewisetimewisefilterResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTimeWiseFilterErrorState extends MainState {
  String msg;
  VehicleWiseTimeWiseFilterErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle Wise Search travel
class VehicleWiseSearchLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseSearchLoadedState extends MainState {
  VehicleWiseSearchModel vehiclewisesearchResponse;
  VehicleWiseSearchLoadedState({required this.vehiclewisesearchResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseSearchErrorState extends MainState {
  String msg;
  VehicleWiseSearchErrorState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle Wise time wise Search travel
class VehicleWiseTimeWiseSearchLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTimeWiseSearchLoadedState extends MainState {
  VehicleWiseTimeWiseSearchModel vehiclewisetimewisesearchResponse;
  VehicleWiseTimeWiseSearchLoadedState(
      {required this.vehiclewisetimewisesearchResponse});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleWiseTimeWiseSearchErrorState extends MainState {
  String msg;
  VehicleWiseTimeWiseSearchErrorState({required this.msg});
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

// Vehicle Report Filter
class VehicleReportFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleReportFilterLoadedState extends MainState {
  VehicleReportFilter vehicleReportFilter;
  VehicleReportFilterLoadedState({
    required this.vehicleReportFilter,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleReportFilterErorrState extends MainState {
  String msg;
  VehicleReportFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle status group Report Filter
class VehicleGroupFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleGroupFilterLoadedState extends MainState {
  VehicleGroupFilterModel vehiclegroupFilterresponse;
  VehicleGroupFilterLoadedState({
    required this.vehiclegroupFilterresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleGroupFilterErorrState extends MainState {
  String msg;
  VehicleGroupFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle status summary Report Filter
class VehicleSummaryFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleSummaryFilterLoadedState extends MainState {
  VehicleSummaryFilterModel vehiclesummaryFilterresponse;
  VehicleSummaryFilterLoadedState({
    required this.vehiclesummaryFilterresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleSummaryFilterErorrState extends MainState {
  String msg;
  VehicleSummaryFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Frame packet filter
class FrameFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FrameFilterLoadedState extends MainState {
  FramePacketFilterModel frameFilterresponse;
  FrameFilterLoadedState({
    required this.frameFilterresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FrameFilterErorrState extends MainState {
  String msg;
  FrameFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//State for search frame packet...

class SearchFramePacketLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class SearchFramePacketLoadedState extends MainState {
  SearchFramePcktRpt searchFramePacket;
  SearchFramePacketLoadedState({required this.searchFramePacket});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchFramePacketErrorState extends MainState {
  String msg;
  SearchFramePacketErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//State for search frame packet...

class SearchFramePacketGridLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class SearchFramePacketGridLoadedState extends MainState {
  SearchFramepacketgrid searchFramePacketgrid;
  SearchFramePacketGridLoadedState({required this.searchFramePacketgrid});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchFramePacketGridErrorState extends MainState {
  String msg;
  SearchFramePacketGridErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//State for search vehicle status group report...
class SearchVehicleStatusGroupLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleStatusGroupLoadedState extends MainState {
  SearchVehicleStatusGroupRpt searchVehicleStatusGroupResponse;
  SearchVehicleStatusGroupLoadedState(
      {required this.searchVehicleStatusGroupResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleStatusGroupErrorState extends MainState {
  String msg;
  SearchVehicleStatusGroupErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//!State for get vehicle status report...
class SearchVehicleStatusReportLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleStatusReportLoadedState extends MainState {
  SearchVehicleStatusRpt searchvehicleStatusGroupResponse;
  SearchVehicleStatusReportLoadedState(
      {required this.searchvehicleStatusGroupResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class SearchVehicleStatusReportErrorState extends MainState {
  String msg;
  SearchVehicleStatusReportErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Frame packet grid filter
class FrameGridFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FrameGridFilterLoadedState extends MainState {
  FrameGridFilterMode framegridFilterresponse;
  FrameGridFilterLoadedState({
    required this.framegridFilterresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FrameGridFilterErorrState extends MainState {
  String msg;
  FrameGridFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// device master filter driver code (DMFD)
class DMFDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DMFDriverCodeLoadedState extends MainState {
  DeviceDriverCode dmfdriverCoderesponse;
  DMFDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DMFDriverCodeErorrState extends MainState {
  String msg;
  DMFDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle VSrNo
class VehicleVSrNoLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleVSrNoLoadedState extends MainState {
  VehicleVSrNoModel vehiclevsrnoresponse;
  VehicleVSrNoLoadedState({
    required this.vehiclevsrnoresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleVSrNoErorrState extends MainState {
  String msg;
  VehicleVSrNoErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle VSrNo
class FramePacketOptiongridLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FramePacketOptiongridLoadedState extends MainState {
  FramePacketOptionGridModel vehiclevsrnoresponse;
  FramePacketOptiongridLoadedState({
    required this.vehiclevsrnoresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketOptiongridErorrState extends MainState {
  String msg;
  FramePacketOptiongridErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Date wise travel driver code
class DateWiseDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DateWiseDriverCodeLoadedState extends MainState {
  DateWiseDriverCodeModel dmfdriverCoderesponse;
  DateWiseDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DateWiseDriverCodeErorrState extends MainState {
  String msg;
  DateWiseDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Driver wise vehicle assign driver code
class DriverWiseDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseDriverCodeLoadedState extends MainState {
  DriverWiseDriverCodeModel dmfdriverCoderesponse;
  DriverWiseDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverWiseDriverCodeErorrState extends MainState {
  String msg;
  DriverWiseDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Frame packet driver code
class FramePacketDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FramePacketDriverCodeLoadedState extends MainState {
  FramePacketRptDriverCodeModel dmfdriverCoderesponse;
  FramePacketDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketDriverCodeErorrState extends MainState {
  String msg;
  FramePacketDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Frame packet grid driver code
class FramePacketGridDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class FramePacketGridDriverCodeLoadedState extends MainState {
  FramePacketGridRptDriverCodeModel dmfdriverCoderesponse;
  FramePacketGridDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FramePacketGridDriverCodeErorrState extends MainState {
  String msg;
  FramePacketGridDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Vehicle status report driver code
class VehicleStsRptDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class VehicleStsRptDriverCodeLoadedState extends MainState {
  VehicleStatusReportDriverCodeModel dmfdriverCoderesponse;
  VehicleStsRptDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class VehicleStsRptDriverCodeErorrState extends MainState {
  String msg;
  VehicleStsRptDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Driver master driver code
class DriverMasterDriverCodeLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterDriverCodeLoadedState extends MainState {
  DriverMasterDriverCodeModel dmfdriverCoderesponse;
  DriverMasterDriverCodeLoadedState({
    required this.dmfdriverCoderesponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterDriverCodeErorrState extends MainState {
  String msg;
  DriverMasterDriverCodeErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Over Speed Vehicle Filter
class OverSpeedVehicleFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class OverSpeedVehicleFilterLoadedState extends MainState {
  OverSpeedVehicleFilter overspeedvehiclefilterresponse;
  OverSpeedVehicleFilterLoadedState({
    required this.overspeedvehiclefilterresponse,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OverSpeedVehicleFilterErorrState extends MainState {
  String msg;
  OverSpeedVehicleFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// Driver master report filter
class DriverMasterFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterFilterLoadedState extends MainState {
  DriverMasterFilter driverMasterFilter;
  DriverMasterFilterLoadedState({
    required this.driverMasterFilter,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class DriverMasterFilterErorrState extends MainState {
  String msg;
  DriverMasterFilterErorrState({required this.msg});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

//Overspeed filter

class OverSpeedFilterLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class OverSpeedFilterLoadedState extends MainState {
  OverSpeedFilter overspeedFilter;
  OverSpeedFilterLoadedState({
    required this.overspeedFilter,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OverSpeedFilterErorrState extends MainState {
  String msg;
  OverSpeedFilterErorrState({required this.msg});
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
  POIPostErrorState({required this.msg});

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
  POIDeleteErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

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

//! Route Define Post Data-------------->
class RouteDefinePostLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class RouteDefinePostLoadedState extends MainState {
  RouteDefinePost routedefinepost;
  RouteDefinePostLoadedState({
    required this.routedefinepost,
  });
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class RouteDefinePostErrorState extends MainState {
  String msg;
  RouteDefinePostErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//State

//------------//get Vehicle Speed Data----------------------
class GetVehSpeedLoadingState extends MainState {
  List<Object> get props => throw UnimplementedError();
}

class GetVehSpeedLoadedState extends MainState {
  GetVehSpeedResponse getVehSpeedResponse;
  GetVehSpeedLoadedState({required this.getVehSpeedResponse});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GetVehSpeedErrorState extends MainState {
  String msg;
  GetVehSpeedErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
//! VTSLive Geofence--------------->
class VTSLiveGeofenceLoadingState extends MainState{
    List<Object> get props => throw UnimplementedError();
}
class VTSLiveGeofenceLoadedState extends MainState{
  List<VtsLiveGeo> vtsLiveGeo;
   VTSLiveGeofenceLoadedState({required this.vtsLiveGeo});
     @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class VTSLiveGeofenceErrorState extends MainState{
   String msg;
  VTSLiveGeofenceErrorState({required this.msg});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

// class DriverMasterLoadingState extends MainState {
//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }

// class DriverMasterLoadedState extends MainState {
//   DriverMaster DriverMasterresponse;
//   DriverMasterLoadedState(
//       {required this.DriverMasterresponse});

//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }

// class DriverMasterErrorState extends MainState {
//   String msg;
//   DriverMasterErrorState({required this.msg});

//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }

//Driver Master Report

// class DriverMasterReportLoadedState extends MainState{
//   getDriverMasterReportResponse  DriverMasterReportResponse;
//   DriverMasterReportLoadedState({required this.DriverMasterReportResponse});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => throw UnimplementedError();
// }
