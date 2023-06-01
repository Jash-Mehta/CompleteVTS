import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/model/alert/add_alert_master_requesy.dart';
import 'package:flutter_vts/model/alert/add_alert_master_response.dart';
import 'package:flutter_vts/model/alert/all_alert_master_response.dart';

import 'package:flutter_vts/model/alert/search_alert_master_screen.dart';
import 'package:flutter_vts/model/alert_notification/alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/date_wise_search_alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/fill_alert_notification_vehicle_response.dart';
import 'package:flutter_vts/model/alert_notification/filter_alert_notification_response.dart';
import 'package:flutter_vts/model/alert_notification/search_alert_notification_response.dart';
import 'package:flutter_vts/model/analytic_report/analytic_report_by_id_detail_response.dart';
import 'package:flutter_vts/model/analytic_report/analytic_report_click_response.dart';
import 'package:flutter_vts/model/analytic_report/search_analytic_report_status_click_response.dart';
import 'package:flutter_vts/model/assign_menu_rights_request.dart';
import 'package:flutter_vts/model/branch/add_branch_request.dart';
import 'package:flutter_vts/model/branch/add_branch_response.dart';
import 'package:flutter_vts/model/branch/all_branch_master_response.dart';
import 'package:flutter_vts/model/branch/branch_name_response.dart';
import 'package:flutter_vts/model/branch/edit_branch_response.dart';
import 'package:flutter_vts/model/branch/search_branch_response.dart';
import 'package:flutter_vts/model/dashbord/dashboard_response.dart';
import 'package:flutter_vts/model/date_wise_travel_history/date_wise_drivercode.dart';
import 'package:flutter_vts/model/device/add_device_request.dart';
import 'package:flutter_vts/model/device/add_device_response.dart';
import 'package:flutter_vts/model/device/device_master_response.dart';
import 'package:flutter_vts/model/device/edit_device_response.dart';
import 'package:flutter_vts/model/device/search_device_response.dart';
import 'package:flutter_vts/model/distanceSummary/distance_summary_filter.dart';
import 'package:flutter_vts/model/driver/add_driver_master_request.dart';
import 'package:flutter_vts/model/driver/add_driver_master_response.dart';
import 'package:flutter_vts/model/driver/all_driver_master_response.dart';
import 'package:flutter_vts/model/driver/search_driver_master_response.dart';
import 'package:flutter_vts/model/geofence/get_geofence_create_details_response.dart';
import 'package:flutter_vts/model/geofence/search_geofence_create_response.dart';
import 'package:flutter_vts/model/live/live_tracking_filter_response.dart';
import 'package:flutter_vts/model/live/live_tracking_response.dart';
import 'package:flutter_vts/model/live/start_location_response.dart';
import 'package:flutter_vts/model/live/vehicle_status_with_count_response.dart';
import 'package:flutter_vts/model/live/vts_live_geo_response.dart';
import 'package:flutter_vts/model/login/check_forget_password_user_response.dart';
import 'package:flutter_vts/model/login/forget_password_request.dart';
import 'package:flutter_vts/model/report/date_and_timewise_travel.dart';
import 'package:flutter_vts/model/report/frame_filter.dart';
import 'package:flutter_vts/model/report/vehicle_status_group.dart';
import 'package:flutter_vts/model/report/vehicle_summary_filter.dart';
import 'package:flutter_vts/model/serial_number/serial_number_response.dart';
import 'package:flutter_vts/model/subscription/add_subscription_request.dart';
import 'package:flutter_vts/model/subscription/edit_subscription_resquest.dart';
import 'package:flutter_vts/model/subscription/subscription_master_response.dart';
import 'package:flutter_vts/model/travel_summary/travel_summary_filter.dart';
import 'package:flutter_vts/model/travel_summary/travel_summary_search.dart';
import 'package:flutter_vts/model/user/create_user/add_created_user_response.dart';
import 'package:flutter_vts/model/user/create_user/add_user_request.dart';
import 'package:flutter_vts/model/user/create_user/get_all_create_user_response.dart';
import 'package:flutter_vts/model/user/create_user/search_created_user_response.dart';
import 'package:flutter_vts/model/vehicle/add_vehicle_request.dart';
import 'package:flutter_vts/model/vehicle/all_vehicle_detail_response.dart';
import 'package:flutter_vts/model/login/login_response.dart';
import 'package:flutter_vts/model/vehicle/edit_vehicle_request.dart';
import 'package:flutter_vts/model/vehicle/search_vehicle_response.dart';
import 'package:flutter_vts/model/vehicle/vehicle_fill_response.dart';
import 'package:flutter_vts/model/vehicle_history/vehicle_history_filter_response.dart';
import 'package:flutter_vts/model/vendor/add_new_vendor_response.dart';
import 'package:flutter_vts/model/vendor/all_vendor_detail_response.dart';
import 'package:flutter_vts/model/vendor/edit_vendor_response.dart';
import 'package:flutter_vts/model/vendor/request/add_new_vendor_request.dart';
import 'package:flutter_vts/model/vendor/request/edit_vendor_request.dart';
import 'package:flutter_vts/model/vendor/search_vendor_response.dart';
import 'package:flutter_vts/screen/live_tracking_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_name_response.dart';
import 'package:flutter_vts/screen/profile/profile_detail/profile_detail_screen.dart';
import 'package:flutter_vts/screen/report/driver_wise_vehicle_assign.dart';
import 'package:flutter_vts/screen/travel_summary/travel_summary_screen.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:http/http.dart' as http;
import '../model/Driver_Master/driver_master.dart';
import '../model/Driver_Master/driver_master_drivercode.dart';
import '../model/Driver_Master/search_driver_master_report_response.dart';
import '../model/date_wise_travel_history/date_wise_travel_filter.dart';
import '../model/date_wise_travel_history/date_wise_travel_history.dart';
import '../model/date_wise_travel_history/search_datewise_travel_history_response.dart';
import '../model/device_master/get_device_master_report.dart';
import '../model/device_master/search_device_master_report.dart';
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
import '../model/point_of_interest/create_point_of_interest.dart';
import '../model/point_of_interest/dropdown_point_of_interest.dart';
import '../model/point_of_interest/poi_post.dart';
import '../model/point_of_interest/poi_type.dart';
import '../model/point_of_interest/search_point_of_interest.dart';
import '../model/report/date_and_timewise_filter.dart';
import '../model/report/date_and_timewise_search.dart';
import '../model/report/device_master_filter.dart';
import '../model/report/device_master_filter_drivercode.dart';
import '../model/report/device_master_report.dart';
import '../model/Driver_Master/driver_master_filter.dart';
import '../model/report/frame_grid_filter.dart';
import '../model/report/frame_packet_drivercode.dart';
import '../model/report/frame_packet_report_response.dart';
import '../model/report/frame_packetgrid_drivercode.dart';
import '../model/report/frame_packetoption_grid.dart';
import '../model/report/framepacketgrid.dart';
import '../model/report/over_speed_report_response.dart';
import '../model/report/overspeed_filter.dart';
import '../model/report/overspeed_vehicle_filter.dart';
import '../model/report/search_driverwise_veh_rpt.dart';
import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_frame_pckt_grid_response.dart';
import '../model/report/search_frame_pckt_report.dart';
import '../model/report/search_overspeed_response.dart';
import '../model/report/search_vehicle_status_group_response.dart';
import '../model/report/search_vehicle_status_response.dart';
import '../model/report/search_vehicle_status_summary.dart';
import '../model/report/vehicle_group_filter.dart';
import '../model/report/vehicle_status_filter_report.dart';
import '../model/report/vehicle_status_report.dart';
import '../model/report/vehicle_status_report_drivercode.dart';
import '../model/report/vehicle_status_summary.dart';
import '../model/report/vehicle_vsrno.dart';
import '../model/report/vehicle_wise_search.dart';
import '../model/report/vehicle_wise_timewise_filter.dart';
import '../model/report/vehicle_wise_timewise_search.dart';
import '../model/report/vehicle_wise_timewise_travel.dart';
import '../model/report/vehicle_wise_travel.dart';
import '../model/report/vehicle_wise_travel_filter.dart';
import '../model/route_define/route_define_post.dart';
import '../model/searchString.dart';
import '../model/travel_summary/travel_summary.dart';
import '../model/vehicle_history/get_veh_speed_response.dart';
import '../model/vehicle_history/vts_history_speed_parameter.dart';
import '../model/vehicle_master/search_vehicle_report_data_response.dart';
import '../model/vehicle_master/vehicle_master_filter.dart';
import '../model/vehicle_master/vehicle_report_detail.dart';
import '../screen/report/frame_packet_grid.dart';

class WebService {
  SearchStringClass searchStrClass = SearchStringClass(searchStr: '');
  Future<LoginResponse> userLogin(String username, String password) async {
    print(Constant.loginUrl);
    final response = await http.post(
      Uri.parse(Constant.loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    print(response.body);
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponse> updateLogin(String menuCaption, int vendorSrNo,
      int branchsrno, int userId, String sessionId, String token) async {
    print(Constant.updateloginUrl);
    final response = await http.post(
      Uri.parse(Constant.updateloginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'menuCaption': menuCaption,
        'vendorSrNo': vendorSrNo.toString(),
        'branchSrNo': branchsrno.toString(),
        'userId': userId.toString(),
        'sessionId': sessionId.toString(),
      }),
    );
    print(response.body);
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponse> updateLogout(String menuCaption, int vendorSrNo,
      int branchsrno, int userId, String sessionId, String token) async {
    print(Constant.updateloginUrl);
    final response = await http.post(
      Uri.parse(Constant.updateloginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'menuCaption': menuCaption,
        'vendorSrNo': vendorSrNo.toString(),
        'branchSrNo': branchsrno.toString(),
        'userId': userId.toString(),
        'sessionId': sessionId.toString(),
      }),
    );
    print(response.body);
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<CheckForgetPasswordUserResponse> checkUser(
      String searchEmail, String token) async {
    print(Constant.checkuserUrl + "" + searchEmail);

    final response = await http.post(
      Uri.parse(Constant.checkuserUrl + "" + searchEmail),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return CheckForgetPasswordUserResponse.fromJson(jsonDecode(response.body));
  }

  // optionClicked - Divtotal_count(all), Running_count(running)...etc
  // aRAI_NONARAI(App run Device setting ) - ARAI or NONARAI

  Future<DashbordResponse> getdashboard(
      int vendorId,
      int branchid,
      String optionClicked,
      String aRAI_NONARAI,
      String username,
      int PageNumber,
      int PageSize,
      String token) async {
    // print(Constant.dashboardUrl +
    //     "" +
    //     vendorId.toString() +
    //     "&BranchId=" +
    //     branchid.toString() +
    //     "&OptionClicked=" +
    //     optionClicked +
    //     "&ARAI_NONARAI=" +
    //     aRAI_NONARAI +
    //     "&UserName=" +
    //     username +
    //     "&PageNumber=" +
    //     PageNumber.toString() +
    //     "&PageSize=" +
    //     PageSize.toString());

    final response = await http.get(
      Uri.parse(Constant.dashboardUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchid.toString() +
          "&OptionClicked=" +
          optionClicked +
          "&ARAI_NONARAI=" +
          aRAI_NONARAI +
          "&UserName=" +
          username +
          "&PageNumber=" +
          PageNumber.toString() +
          "&PageSize=" +
          PageSize.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    return DashbordResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> forgetPassword(
      ForgetPasswordRequest forgetPasswordRequest, String token) async {
    print(Constant.forgetPasswordUrl);

    final response = await http.post(
      Uri.parse(Constant.forgetPasswordUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Authorization': 'Bearer eyJhbGciOiJodHRwOi8vd3d3LnczLm9yZy8yMDAxLzA0L3htbGRzaWctbW9yZSNobWFjLXNoYTI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJWVFNTRVJWSUNFQUNDRVNTVE9LRU4iLCJqdGkiOiIyZGRhNDM5MS1iNTZjLTQ4MGItODI1YS02ZWZmNDQwOWZlZmUiLCJpYXQiOiIwOS8wNS8yMDIyIDQ6NTc6MzUgQU0iLCJVc2VyTmFtZSI6IjE2IiwiRmlyc3ROYW1lIjoiVGVjaG5vIiwiTGFzdE5hbWUiOiJNb3dvdklIbEhRbTdTLzFlelRNc0tRPT0iLCJTdXBlclVzZXIiOiJOIiwiRW1haWwiOiJUZWNobm9AZ21haWwuY29tIiwiZXhwIjoxNjUyMTU4NjU1LCJpc3MiOiJNVEVDSElOTk9WQVRJT05MVEQiLCJhdWQiOiJBTllDTElFTlQifQ.DhL10DHFbNWot7tSXmnlsHLN9S3FgpDMoNt-fnnbOxk',
      },
      body: jsonEncode(forgetPasswordRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> resetPassword(
      ResetPasswordRequest resetPasswordRequest, String token) async {
    print(Constant.resetPasswordUrl);

    final response = await http.post(
      Uri.parse(Constant.resetPasswordUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(resetPasswordRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<GetProfileResponse> getProfileDetails(
      int vendorId, int branchId, int profileId, String token) async {
    String allprofiledetailurl = Constant.getprofileDetailsUrl +
        vendorId.toString() +
        "/" +
        branchId.toString() +
        "/" +
        profileId.toString();
    print(allprofiledetailurl);

    final response = await http.get(
      Uri.parse(allprofiledetailurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    print(response.body);
    return GetProfileResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> updateProfile(int userId,
      ProfileUpdateRequest profileUpdateRequest, String token) async {
    String updateprofileurl =
        Constant.updateprofileUrl + "" + userId.toString();
    print(updateprofileurl);

    final response = await http.put(
      Uri.parse(updateprofileurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
      body: jsonEncode(profileUpdateRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AllVehicleDetailResponse> getallvehicledetail(int vendorId,
      int branchId, int pageNumber, int pageSize, String token) async {
    String allvehicledetailurl = Constant.getAllVehicleDetailUrl +
        vendorId.toString() +
        "&Branchid=" +
        branchId.toString() +
        "&pageNumber=" +
        pageNumber.toString() +
        "&pageSize=" +
        pageSize.toString();
    print(allvehicledetailurl);

    final response = await http.get(
      Uri.parse(allvehicledetailurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    print(response.body);
    return AllVehicleDetailResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchVehicleResponse> searchvehicle(
      int vendorid, int branchid, String searchText, String token) async {
    String searchvehicleurl = Constant.getSearchVehicleUrl +
        vendorid.toString() +
        "/" +
        branchid.toString() +
        "/" +
        searchText;
    print(searchvehicleurl);

    final response = await http.get(
      Uri.parse(searchvehicleurl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return SearchVehicleResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddVehicleResponse> addnewvehicle(
      AddVehicleRequest addVehicleRequest, String token) async {
    print(Constant.addNewVehicleUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addNewVehicleUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addVehicleRequest),
    );

    print(response.body);
    return AddVehicleResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editvehicle(EditVehicleRequest editVehicleRequest,
      int vehicleid, String token) async {
    print(Constant.editVehicleUrl + vehicleid.toString());

    final response = await http.put(
      Uri.parse(Constant.editVehicleUrl + vehicleid.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(editVehicleRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AllVendorDetailResponse> getallvendor(
      int pageNumber, int pagesize, String token) async {
    String vendorurl = Constant.getAllVendorDetailUrl +
        pageNumber.toString() +
        "&pageSize=" +
        pagesize.toString();
    print(vendorurl);

    final response = await http.get(
      Uri.parse(vendorurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return AllVendorDetailResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchVendorResponse> searchVendor(
      String searchText, String token) async {
    String searchVendorurl =
        Constant.getSearchVendorUrl + searchText.toString();
    print(searchVendorurl);

    final response = await http.get(
      Uri.parse(searchVendorurl),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return SearchVendorResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddNewVendorResponse> addnewvendor(
      AddNewVendorRequest addNewVendorRequest, String token) async {
    print(Constant.addNewVendorUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addNewVendorUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addNewVendorRequest),
    );

    print(response.body);
    return AddNewVendorResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditVendorResponse> editvendor(
      EditVendorRequest editVendorRequest, int vendorid, String token) async {
    print(Constant.editVendorUrl + vendorid.toString());

    final response = await http.put(
      Uri.parse(Constant.editVendorUrl + vendorid.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(editVendorRequest),
    );

    print(response.body);
    return EditVendorResponse.fromJson(jsonDecode(response.body));
  }

  Future<List<VendorNameResponse>> getvendorname(String token) async {
    String getvendornameUrl = Constant.vendorNameUrl;
    print(getvendornameUrl);

    final response = await http.get(
      Uri.parse(getvendornameUrl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return vendorNameResponseFromJson(response.body);
  }

  Future<List<BranchNameResponse>> getbranchname(
      String token, String branchid) async {
    String getbranchnameUrl = Constant.branchNameUrl + branchid;
    print(getbranchnameUrl);

    final response = await http.get(
      Uri.parse(getbranchnameUrl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return BranchNameResponseFromJson(response.body);
  }

  Future<AllDeviceResponse> getalldevice(int vendorId, int branchId,
      int pageNumber, int pageSize, String token) async {
    String alldevicedetailurl = Constant.getAllDeviceDetailUrl +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();
    print(alldevicedetailurl);

    final response = await http.get(
      Uri.parse(alldevicedetailurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);
    return AllDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddDeviceResponse> addnewdevice(
      AddDeviceRequest addDeviceRequest, String token) async {
    print(Constant.addNewDeviceUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addNewDeviceUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addDeviceRequest),
    );
    print(response.body);
    return AddDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editDevice(
      AddDeviceRequest addDeviceRequest, int deviceid, String token) async {
    print(Constant.editdeviceUrl + deviceid.toString());

    final response = await http.put(
      Uri.parse(Constant.editdeviceUrl + deviceid.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addDeviceRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchDeviceResponse> searchdevice(
      int vendorid, int branchid, String searchText, String token) async {
    String searchdeviceurl = Constant.getSearchDeviceUrl +
        vendorid.toString() +
        "/" +
        branchid.toString() +
        "/" +
        searchText;
    print(searchdeviceurl);

    final response = await http.get(
      Uri.parse(searchdeviceurl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return SearchDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AllBranchMasterResponse> getallbranch(
      String token, int vendorid, int pagenumber, int pagesized) async {
    String getbranchUrl = Constant.getAllBranchDetailUrl +
        vendorid.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesized.toString();
    print(getbranchUrl);

    final response = await http.get(
      Uri.parse(getbranchUrl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return allBranchMasterResponseFromJson(response.body);
  }

  Future<SearchBranchResponse> searchBranch(
      int vendorid, String searchText, String token) async {
    String searchbranchurl =
        Constant.getSearchBranchUrl + vendorid.toString() + "/" + searchText;
    print(searchbranchurl);

    final response = await http.get(
      Uri.parse(searchbranchurl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return SearchBranchResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddBranchResponse> addnewbranch(
      AddBranchRequest addBranchRequest, String token) async {
    print(Constant.addNewBranchUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addNewBranchUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addBranchRequest),
    );
    print(response.body);
    return AddBranchResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editbranch(int srno, int vendorid,
      EditBranchRequest editBranchRequest, String token) async {
    print(Constant.editBranchUrl + vendorid.toString() + "/" + srno.toString());

    final response = await http.put(
      Uri.parse(
          Constant.editBranchUrl + vendorid.toString() + "/" + srno.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(editBranchRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AllSubscriptionResponse> getallsubscription(int verdorid, int branchid,
      int pageNumber, int total, String token) async {
    String allsubscriptionurl = Constant.getAllSubscriptionUrl +
        "" +
        verdorid.toString() +
        "&BranchID=" +
        branchid.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        total.toString();

    print(allsubscriptionurl);

    final response = await http.get(
      Uri.parse(allsubscriptionurl),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return AllSubscriptionResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchSubscriptionResponse> searchsubscription(
      String token, int branchid, int verdorid, String searchtext) async {
    String searchsubscriptionurl = Constant.searchSubscriptionUrl +
        "" +
        verdorid.toString() +
        "/" +
        branchid.toString() +
        "/" +
        searchtext;

    print(searchsubscriptionurl);

    final response = await http.get(
      Uri.parse(searchsubscriptionurl),
      headers: <String, String>{
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return SearchSubscriptionResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> addsubscription(
      AddSubscriptionRequest addSubscriptionRequest, String token) async {
    print(Constant.addSubscriptionUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addSubscriptionUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addSubscriptionRequest),
    );
    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editSubscription(
      EditSubscriptionRequest editSubscriptionRequest,
      int subsid,
      String token) async {
    print(Constant.editSubscriptionUrl + "" + subsid.toString());

    final response = await http.put(
      Uri.parse(Constant.editSubscriptionUrl + "" + subsid.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(editSubscriptionRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AllDriverResponse> getalldriver(int verdorid, int branchid,
      int pageNumber, int pagesize, String token) async {
    String driverurl = Constant.getAllDriverUrl +
        verdorid.toString() +
        "&BranchID=" +
        branchid.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&pageSize=" +
        pagesize.toString();
    print(driverurl);

    final response = await http.get(
      Uri.parse(driverurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return AllDriverResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchDriverResponse> searchdriver(
      int vendorid, int branchid, String searchText, String token) async {
    String searchdriverurl = Constant.getSearchDriverUrl +
        vendorid.toString() +
        "/" +
        branchid.toString() +
        "/" +
        searchText;
    print(searchdriverurl);

    final response = await http.get(
      Uri.parse(searchdriverurl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return SearchDriverResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddDriverResponse> addnewdriver(
      AddDriverRequest addDriverRequest, String token) async {
    print(Constant.addNewDriverUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addNewDriverUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addDriverRequest),
    );
    print(response.body);
    return AddDriverResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editdriver(
      AddDriverRequest addDriverRequest, int srno, String token) async {
    print(Constant.editDriverUrl + "" + srno.toString());

    final response = await http.put(
      Uri.parse(Constant.editDriverUrl + "" + srno.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addDriverRequest),
    );
    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddAlertMasterResponse> addalert(
      AddAlertMasterRequest addAlertMasterRequest, String token) async {
    print(Constant.addAlertUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addAlertUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addAlertMasterRequest),
    );
    print(response.body);
    return AddAlertMasterResponse.fromJson(jsonDecode(response.body));
  }

  Future<AllAlertMasterResponse> getallalert(String token, int vendorid,
      int branchid, int pagenumber, int pagesized) async {
    String getalertUrl = Constant.getAllAlertDetailUrl +
        vendorid.toString() +
        "&BranchID=" +
        branchid.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesized.toString();
    print(getalertUrl);

    final response = await http.get(
      Uri.parse(getalertUrl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return allAlertMasterResponseFromJson(response.body);
  }

  Future<SearchAlertMasterResponse> searchalert(
      int vendorid, int branchid, String searchText, String token) async {
    String searchalertrurl = Constant.getSearchAlertUrl +
        vendorid.toString() +
        "/" +
        branchid.toString() +
        "/" +
        searchText;
    print(searchalertrurl);

    final response = await http.get(
      Uri.parse(searchalertrurl),
      headers: <String, String>{
        'Authorization': "Bearer $token",
      },
    );
    print(response.body);
    return SearchAlertMasterResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editAlert(
      AddAlertMasterRequest addAlertMasterRequest,
      String alertText,
      String token) async {
    print(Constant.editAlertUrl + "" + alertText);

    final response = await http.put(
      Uri.parse(Constant.editAlertUrl + alertText.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addAlertMasterRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<GetAllCreateUserResponse> getAllUser(int verdorid, int branchid,
      int pageNumber, int pagesize, String token) async {
    String userurl = Constant.getAllUserUrl +
        verdorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&pageSize=" +
        pagesize.toString();
    print(userurl);

    final response = await http.get(
      Uri.parse(userurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return GetAllCreateUserResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchCreatedUserResponse> searchAllUser(
      int verdorid, int branchid, String searchText, String token) async {
    String searchuserurl = Constant.getsearchUserUrl +
        "" +
        verdorid.toString() +
        "/" +
        branchid.toString() +
        "/" +
        searchText.toString();
    print(searchuserurl);

    final response = await http.get(
      Uri.parse(searchuserurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print(response.body);
    return SearchCreatedUserResponse.fromJson(jsonDecode(response.body));
  }

  Future<AddCreatedUserResponse> addUser(
      AddUserRequest addUserRequest, String token) async {
    print(Constant.addUserUrl);

    // String addNewVendorRequest=addNewVendorRequestToJson(addNewVendorRequest);
    final response = await http.post(
      Uri.parse(Constant.addUserUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addUserRequest),
    );
    print(response.body);
    return AddCreatedUserResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> editUser(
      AddUserRequest addUserRequest, String userid, String token) async {
    print(Constant.editUserUrl + "" + userid);

    final response = await http.put(
      Uri.parse(Constant.editUserUrl + userid.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(addUserRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<SerialNumberResponse> getserialnumber(
    String token,
    String api,
  ) async {
    print(Constant.baseUrl + "" + api);

    final response = await http.get(
      Uri.parse(Constant.baseUrl + "" + api),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return SerialNumberResponse.fromJson(jsonDecode(response.body));
  }

  Future<AlertNotificationResponse> getalertNotification(
      String token,
      int vendorId,
      int branchId,
      String Arai,
      String username,
      String displayStatus,
      int pageNumber,
      int pageSize) async {
    print(Constant.alertNotificationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&Arai_Nonarai=" +
        Arai +
        "&UserName=" +
        username +
        "&DisplayStatus=" +
        displayStatus +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString());

    final response = await http.get(
      Uri.parse(Constant.alertNotificationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&Arai_Nonarai=" +
          Arai +
          "&UserName=" +
          username +
          "&DisplayStatus=" +
          displayStatus +
          "&PageNumber=" +
          pageNumber.toString() +
          "&PageSize=" +
          pageSize.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return AlertNotificationResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchAlertNotificationResponse> searchalertNotification(
      String token,
      int vendorId,
      int branchId,
      String Arai,
      String username,
      String displayStatus,
      String search,
      int pageNumber,
      int pageSize) async {
    print(Constant.searchAlertNotificationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&Arai_Nonarai=" +
        Arai +
        "&UserName=" +
        username +
        "&DisplayStatus=" +
        displayStatus +
        "&Search=" +
        search +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString());

    final response = await http.get(
      Uri.parse(Constant.searchAlertNotificationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&Arai_Nonarai=" +
          Arai +
          "&UserName=" +
          username +
          "&DisplayStatus=" +
          displayStatus +
          "&Search=" +
          search +
          "&PageNumber=" +
          pageNumber.toString() +
          "&PageSize=" +
          pageSize.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return SearchAlertNotificationResponse.fromJson(jsonDecode(response.body));
  }

  Future<DateWiseSearchAlertNotificationResponse>
      getdateWiseSearchalertNotification(
          String token,
          int vendorId,
          int branchId,
          String Arai,
          String username,
          String displayStatus,
          String fromDate,
          String fromTime,
          String toDate,
          String toTime,
          int pagenumber,
          int pagesize) async {
    print(Constant.dateWiseSearchAlertNotificationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&Arai_Nonarai=" +
        Arai +
        "&UserName=" +
        username +
        "&DisplayStatus=" +
        displayStatus +
        "&FromDate=" +
        fromDate +
        "&FromTime=" +
        fromTime +
        "&ToDate=" +
        toDate +
        "&ToTime=" +
        toTime +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString());

    final response = await http.get(
      Uri.parse(Constant.dateWiseSearchAlertNotificationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&Arai_Nonarai=" +
          Arai +
          "&UserName=" +
          username +
          "&DisplayStatus=" +
          displayStatus +
          "&FromDate=" +
          fromDate +
          "&FromTime=" +
          fromTime +
          "&ToDate=" +
          toDate +
          "&ToTime=" +
          toTime +
          "&PageNumber=" +
          pagenumber.toString() +
          "&PageSize=" +
          pagesize.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return DateWiseSearchAlertNotificationResponse.fromJson(
        jsonDecode(response.body));
  }

  Future<EditDeviceResponse> clearAlertNotificationById(
      int vendorId,
      int branchid,
      String aRAI_NONARAI,
      String username,
      int alertNotificatioID,
      String token) async {
    print(Constant.clearAlertNotificationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&Arai_Nonarai=" +
        aRAI_NONARAI +
        "&UserName=" +
        username +
        "&AlertNotificationId=" +
        alertNotificatioID.toString());

    final response = await http.delete(
      Uri.parse(Constant.clearAlertNotificationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchid.toString() +
          "&Arai_Nonarai=" +
          aRAI_NONARAI +
          "&UserName=" +
          username +
          "&AlertNotificationId=" +
          alertNotificatioID.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> clearallAlertNotificationById(int vendorId,
      int branchid, String aRAI_NONARAI, String username, String token) async {
    print(Constant.clearAllNotificationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&Arai_Nonarai=" +
        aRAI_NONARAI +
        "&UserName=" +
        username);

    final response = await http.delete(
      Uri.parse(Constant.clearAllNotificationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchid.toString() +
          "&Arai_Nonarai=" +
          aRAI_NONARAI +
          "&UserName=" +
          username),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<AnalyticReportStatusClickResponse> getanalyticreportstatus(
      String token,
      int vendorId,
      int branchId,
      String openClick,
      String araiNoarai,
      String username,
      int pagenumber,
      int pagesize) async {
    print(Constant.getAnalyticReportStatusClick +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&OptionClicked=" +
        openClick +
        "&ARAI_NONARAI=" +
        araiNoarai +
        "&UserName=" +
        username +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString());

    final response = await http.get(
      Uri.parse(Constant.getAnalyticReportStatusClick +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&OptionClicked=" +
          openClick +
          "&ARAI_NONARAI=" +
          araiNoarai +
          "&UserName=" +
          username +
          "&PageNumber=" +
          pagenumber.toString() +
          "&PageSize=" +
          pagesize.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return AnalyticReportStatusClickResponse.fromJson(
        jsonDecode(response.body));
  }

  Future<SearchAnalyticReportStatusClickResponse> searchanalyticreportstatus(
      String token,
      int vendorId,
      int branchId,
      String openClick,
      String araiNoarai,
      String username,
      String vehicleno) async {
    print(Constant.getSearchAnalyticReportStatusClick +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&OptionClicked=" +
        openClick +
        "&ARAI_NONARAI=" +
        araiNoarai +
        "&UserName=" +
        username +
        "&VehicleRegNo=" +
        vehicleno.toString());

    final response = await http.get(
      Uri.parse(Constant.getSearchAnalyticReportStatusClick +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&OptionClicked=" +
          openClick +
          "&ARAI_NONARAI=" +
          araiNoarai +
          "&UserName=" +
          username +
          "&VehicleRegNo=" +
          vehicleno.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return SearchAnalyticReportStatusClickResponse.fromJson(
        jsonDecode(response.body));
  }

  Future<AnalyticReportDetailsResponse> getanalyticreportdetails(
      String token,
      int vendorId,
      int branchId,
      String openClick,
      String araiNoarai,
      String username,
      int vehiclesrno) async {
    print(Constant.getAnalyticReportDetails +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&OptionClicked=" +
        openClick +
        "&ARAI_NONARAI=" +
        araiNoarai +
        "&UserName=" +
        username +
        "&VehicleSrNo=" +
        vehiclesrno.toString());

    final response = await http.get(
      Uri.parse(Constant.getAnalyticReportDetails +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&OptionClicked=" +
          openClick +
          "&ARAI_NONARAI=" +
          araiNoarai +
          "&UserName=" +
          username +
          "&VehicleSrNo=" +
          vehiclesrno.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return AnalyticReportDetailsResponse.fromJson(jsonDecode(response.body));
  }

  Future<FilterAlertNotificationResponse> filteralertNotification(
      String token,
      int vendorId,
      int branchId,
      String araiNoarai,
      String username,
      String displaystatus,
      List<int> vehicleno,
      List<String> alertcode,
      int pageNumber,
      int pagesize) async {
    // [0].toString()

    String vehiclelistnumbers = "";
    String alertCodelist = "";
    var response;

    for (int i = 0; i < vehicleno.length; i++) {
      vehiclelistnumbers = vehiclelistnumbers + vehicleno[i].toString() + ",";
    }

    for (int i = 0; i < alertcode.length; i++) {
      alertCodelist = alertCodelist + alertcode[i].toString() + ",";
    }

    if (vehiclelistnumbers != "" && alertCodelist != "") {
      print("-------------------------------${vehiclelistnumbers}");
      print(Constant.getFilteralertNotificationClick +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNoarai +
          "&UserName=" +
          username +
          "&DisplayStatus=" +
          displaystatus +
          "&VehicleList=" +
          vehiclelistnumbers +
          "&AlertCodeList=" +
          alertCodelist.toString() +
          "&PageNumber=" +
          pageNumber.toString() +
          "&PageSize=" +
          pagesize.toString());
      // print("https://vtsgpsapi.m-techinnovations.com/api/AlertNotification/AlertFilter?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&UserName=satyam&DisplayStatus=n&VehicleList=8&VehicleList=55&AlertCodeList=geo&AlertCodeList=RT15&AlertCodeList=NR01");
      // print("https://vtsgpsapi.m-techinnovations.com/api/AlertNotification/AlertFilter?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&UserName=Techno&DisplayStatus=n&VehicleList=8,55,39,86,&AlertCodeList=RT15,poi,geo,stop&PageNumber=1&PageSize=10");
      response = await http.get(
        Uri.parse(Constant.getFilteralertNotificationClick +
            "" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&ARAI_NONARAI=" +
            araiNoarai +
            "&UserName=" +
            username +
            "&DisplayStatus=" +
            displaystatus +
            "&VehicleList=" +
            vehiclelistnumbers +
            "&AlertCodeList=" +
            alertCodelist.toString() +
            "&PageNumber=" +
            pageNumber.toString() +
            "&PageSize=" +
            pagesize.toString()),

        // Uri.parse("https://vtsgpsapi.m-techinnovations.com/api/AlertNotification/AlertFilter?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&UserName=satyam&DisplayStatus=n&VehicleList=8&VehicleList=55&AlertCodeList=geo&AlertCodeList=RT15&AlertCodeList=NR01"),
        // Uri.parse(Constant.getFilteralertNotificationClick+""+vendorId.toString()+"&BranchId=1&ARAI_NONARAI=nonarai&UserName=Techno&DisplayStatus=n&VehicleList=8,55,39,86,&AlertCodeList=RT15,poi,geo,stop&PageNumber=1&PageSize=10"),

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
    }
    return FilterAlertNotificationResponse.fromJson(jsonDecode(response.body));
  }

  Future<FilterAlertNotificationResponse> searchFilterAlertNotification(
      String token,
      int vendorId,
      int branchId,
      String araiNoarai,
      String username,
      String displaystatus,
      List<int> vehicleno,
      List<String> alertcode,
      String searchText,
      int pageNumber,
      int pagesize) async {
    String vehiclelistnumbers = "";
    String alertCodelist = "";
    var response;

    for (int i = 0; i < vehicleno.length; i++) {
      vehiclelistnumbers = vehiclelistnumbers + vehicleno[i].toString() + ",";
    }

    for (int i = 0; i < alertcode.length; i++) {
      alertCodelist = alertCodelist + alertcode[i].toString() + ",";
    }
    if (vehiclelistnumbers != "" && alertCodelist != "") {
      print(Constant.getSearchFilteralertNotification +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNoarai +
          "&UserName=" +
          username +
          "&DisplayStatus=" +
          displaystatus +
          "&VehicleList=" +
          vehiclelistnumbers +
          "&AlertCodeList=" +
          alertCodelist +
          "&Search=" +
          searchText +
          "&PageNumber=" +
          pageNumber.toString() +
          "&PageSize=" +
          pagesize.toString());

      // print("https://vtsgpsapi.m-techinnovations.com/api/AlertNotification/SearchAlertFilter?VendorId=1&BranchId=1&Arai_Nonarai=nonarai&UserName=satyam&DisplayStatus=n&VehicleList=8&VehicleList=55&AlertCodeList=poi&AlertCodeList=rt15&Search=vehicl");
      response = await http.get(
        // Uri.parse("https://vtsgpsapi.m-techinnovations.com/api/AlertNotification/SearchAlertFilter?VendorId=1&BranchId=1&Arai_Nonarai=nonarai&UserName=satyam&DisplayStatus=n&VehicleList=8&VehicleList=55&AlertCodeList=poi&AlertCodeList=rt15&Search=vehicl"),

        Uri.parse(Constant.getSearchFilteralertNotification +
            "" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&ARAI_NONARAI=" +
            araiNoarai +
            "&UserName=" +
            username +
            "&DisplayStatus=" +
            displaystatus +
            "&VehicleList=" +
            vehiclelistnumbers +
            "&AlertCodeList=" +
            alertCodelist +
            "&Search=" +
            searchText +
            "&PageNumber=" +
            pageNumber.toString() +
            "&PageSize=" +
            pagesize.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
    }
    return FilterAlertNotificationResponse.fromJson(jsonDecode(response.body));
  }

  Future<VehicleStatusResponse> getVehicleStatus(
      String token,
      int vendorId,
      int branchId,
      String araiNoarai,
      String fromDate,
      String toDate,
      String formTime,
      String toTime,
      String vehicleRegNo,
      int pageNUmber,
      int pageSize) async {
    var vehiclestatusurl = Constant.getVehicleHistoryDetail +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&Arai_Nonarai=" +
        araiNoarai +
        "&FromDate=" +
        fromDate +
        "&FromTime=" +
        formTime +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime +
        "&VehicleRegNo=" +
        vehicleRegNo +
        "&PageNumber=" +
        pageNUmber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is vehicle status url " + vehiclestatusurl);

    final response = await http.get(
      Uri.parse(vehiclestatusurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return VehicleStatusResponse.fromJson(jsonDecode(response.body));
  }

  Future<List<VehicleHistoryByIdDetailResponse>> getVehiclehistroyById(
      String token,
      int vendorId,
      int branchId,
      String araiNoarai,
      String fromDate,
      String toDate,
      String formTime,
      String toTime,
      int vehicleHistoryId) async {
    print(Constant.getVehicleHistoryById +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNoarai +
        "&FromDate=" +
        fromDate +
        "&FromTime=" +
        formTime +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime +
        "&vehicleHistoryId=" +
        vehicleHistoryId.toString());

    final response = await http.get(
      Uri.parse(Constant.getVehicleHistoryById +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&Arai_Nonarai=" +
          araiNoarai +
          "&FromDate=" +
          fromDate +
          "&FromTime=" +
          formTime +
          "&ToDate=" +
          toDate.toString() +
          "&ToTime=" +
          toTime +
          "&vehicleHistoryId=" +
          vehicleHistoryId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return vehicleHistoryByIdDetailResponseFromJson(response
        .body) /*VehicleHistoryByIdDetailResponse.fromJson(jsonDecode(response.body))*/;
  }

  Future<VehicleHistoryFilterResponse> getVehicleHistoryFilter(
      String token,
      int vendorId,
      int branchId,
      String araiNoarai,
      String fromDate,
      String toDate,
      String formTime,
      String toTime,
      List<String> vehicleStatusList,
      List<int> vehicleList,
      int pageNUmber,
      int pageSize) async {
    String vehiclestatusList = "";
    String vehiclelistnumbers = "";

    var response;

    for (int i = 0; i < vehicleStatusList.length; i++) {
      vehiclestatusList =
          vehiclestatusList + vehicleStatusList[i].toString() + ",";
    }
    if (vehiclestatusList != null && vehiclestatusList.length > 0) {
      vehiclestatusList =
          vehiclestatusList.substring(0, vehiclestatusList.length - 1);
    }
    print(vehiclestatusList);
    for (int i = 0; i < vehicleList.length; i++) {
      vehiclelistnumbers = vehiclelistnumbers + vehicleList[i].toString() + ",";
    }
    if (vehiclelistnumbers != null && vehiclelistnumbers.length > 0) {
      vehiclelistnumbers =
          vehiclelistnumbers.substring(0, vehiclelistnumbers.length - 1);
    }
    print(vehiclelistnumbers);

    if (vehiclestatusList != "") {
      print(Constant.getVehicleHistoryFilterDetail +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&Arai_Nonarai=" +
          araiNoarai +
          "&FromDate=" +
          fromDate +
          "&FromTime=" +
          formTime +
          "&ToDate=" +
          toDate.toString() +
          "&ToTime=" +
          toTime +
          "&VehicleStatusList=" +
          vehiclestatusList +
          "&VehicleList=" +
          vehiclelistnumbers +
          "&PageNumber=" +
          pageNUmber.toString() +
          "&PageSize=" +
          pageSize.toString());

      response = await http.get(
        Uri.parse(Constant.getVehicleHistoryFilterDetail +
            "" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&Arai_Nonarai=" +
            araiNoarai +
            "&FromDate=" +
            fromDate +
            "&FromTime=" +
            formTime +
            "&ToDate=" +
            toDate.toString() +
            "&ToTime=" +
            toTime +
            "&VehicleStatusList=" +
            vehiclestatusList +
            "&VehicleList=" +
            vehiclelistnumbers +
            "&PageNumber=" +
            pageNUmber.toString() +
            "&PageSize=" +
            pageSize.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
    }
    return VehicleHistoryFilterResponse.fromJson(jsonDecode(response.body));
  }

  Future<VehicleHistoryFilterResponse> getVehicleHistorysearchFilter(
      String token,
      int vendorId,
      int branchId,
      String araiNoarai,
      String fromDate,
      String toDate,
      String formTime,
      String toTime,
      List<String> vehicleStatusList,
      List<int> vehicleList,
      String searchText,
      int pageNUmber,
      int pageSize) async {
    String vehiclestatusList = "";
    String vehiclelistnumbers = "";

    var response;

    for (int i = 0; i < vehicleStatusList.length; i++) {
      vehiclestatusList =
          vehiclestatusList + vehicleStatusList[i].toString() + ",";
    }
    if (vehiclestatusList != null && vehiclestatusList.length > 0) {
      vehiclestatusList =
          vehiclestatusList.substring(0, vehiclestatusList.length - 1);
    }
    print(vehiclestatusList);
    for (int i = 0; i < vehicleList.length; i++) {
      vehiclelistnumbers = vehiclelistnumbers + vehicleList[i].toString() + ",";
    }
    print(vehiclelistnumbers);

    if (vehiclestatusList != "") {
      print(Constant.getVehicleHistorySearchFilterDetail +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&Arai_Nonarai=" +
          araiNoarai +
          "&FromDate=" +
          fromDate +
          "&FromTime=" +
          formTime +
          "&ToDate=" +
          toDate.toString() +
          "&ToTime=" +
          toTime +
          "&VehicleStatusList=" +
          vehiclestatusList +
          "&VehicleList=" +
          vehiclelistnumbers +
          "&SearchText_VehicleRegNo=" +
          searchText +
          "&PageNumber=" +
          pageNUmber.toString() +
          "&PageSize=" +
          pageSize.toString());

      response = await http.get(
        Uri.parse(Constant.getVehicleHistorySearchFilterDetail +
            "" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&Arai_Nonarai=" +
            araiNoarai +
            "&FromDate=" +
            fromDate +
            "&FromTime=" +
            formTime +
            "&ToDate=" +
            toDate.toString() +
            "&ToTime=" +
            toTime +
            "&VehicleStatusList=" +
            vehiclestatusList +
            "&VehicleList=" +
            vehiclelistnumbers +
            "&SearchText_VehicleRegNo=" +
            searchText +
            "&PageNumber=" +
            pageNUmber.toString() +
            "&PageSize=" +
            pageSize.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
    }
    return VehicleHistoryFilterResponse.fromJson(jsonDecode(response.body));
  }

  Future<List<VehicleStatusWithCountResponse>> getvehiclestatuswithcount(
      String token, int vendorId, int branchId, String araiNonarai) async {
    print(Constant.getVehilcStatusWithCountUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString());

    final response = await http.get(
      Uri.parse(Constant.getVehilcStatusWithCountUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return vehicleStatusWithCountResponseFromJson(response.body);
  }

  Future<LiveTrackingResponse> getlivetracking(String token, int vendorId,
      int branchId, String trackingStatus, String araiNonarai) async {
    print(Constant.getLiveTrackingUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&TrackingStatus=" +
        trackingStatus.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString());

    final response = await http.get(
      Uri.parse(Constant.getLiveTrackingUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&TrackingStatus=" +
          trackingStatus.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return LiveTrackingResponse.fromJson(jsonDecode(response.body));
  }

  Future<List<LiveTrackingByIdResponse>> getlivetrackingById(String token,
      int vendorId, int branchId, String araiNonarai, int transId) async {
    print(Constant.getLiveTrackingByIdUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString() +
        "&TransID=" +
        transId.toString());

    final response = await http.get(
      Uri.parse(Constant.getLiveTrackingByIdUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString() +
          "&TransID=" +
          transId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return liveTrackingByIdResponseFromJson(response.body);
  }

  Future<List<StartLocationResponse>> getStartLocation(
      String token, int vendorId, int branchId, String araiNonarai) async {
    print(Constant.getStartLocationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString());

    final response = await http.get(
      Uri.parse(Constant.getStartLocationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return startLocationResponseFromJson(response.body);
  }

  Future<List<StartLocationImei>> getStartLocationImei(String token,
      int vendorId, int branchId, String araiNonarai, String imeino) async {
    print(Constant.getStartLocationImeiUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString() +
        "&IMEINO=" +
        imeino.toString());

    final response = await http.get(
      Uri.parse(Constant.getStartLocationImeiUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString() +
          "&IMEINO=" +
          imeino.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {}

    return startLocationImeiFromJson(response.body);
  }

  Future<List<StartLocationResponse>> getNextLocation(
      String token, int vendorId, int branchId, String araiNonarai) async {
    print(Constant.getNextLocationUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString());

    final response = await http.get(
      Uri.parse(Constant.getNextLocationUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return startLocationResponseFromJson(response.body);
  }

  //! VTSLive Geofence------------->
  Future<List<VtsLiveGeo>> getvtslivegeo(
    String token,
    int vendorid,
    int branchid,
    String vehicleno,
  ) async {
    final response = await http.get(
      Uri.parse(Constant.vtslivegeo +
          "" +
          vendorid.toString() +
          "&BranchId=" +
          branchid.toString() +
          "&VehicleRegNo=" +
          vehicleno.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      print("Sucessfully geeting your data");
    } else {
      print(response.body);
    }
    return vtsLiveGeoFromJson(response.body);
  }

//! nextlocation ime---------------->
  Future<List<NextLocationImei>> getnextLocationImei(
      String token,
      int vendorId,
      int branchId,
      String araiNonarai,
      String currentimeino,
      int prevTransactionId,
      String prevDate,
      String prevTime,
      String prevIMEINo) async {
    final response = await http.get(
      Uri.parse(Constant.getNextLocationImeiUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&ARAI_NONARAI=" +
          araiNonarai.toString() +
          "&CurrentIMEINO=" +
          currentimeino.toString() +
          "&PreviousTransactionId=" +
          prevTransactionId.toString() +
          "&PreviousDate=" +
          prevDate.toString() +
          "&PreviousTime=" +
          prevTime.toString() +
          "&PreviousIMEINo=" +
          prevIMEINo.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print("Enter in the nextlocation Live----------->" + response.body);
    } else {
      print(response.body);
    }
    return nextLocationImeiFromJson(response.body);
  }

  Future<LiveTrackingFilterResponse> getLiveTrackingFilter(
      String token,
      int vendorId,
      int branchId,
      String araiNonarai,
      List<int> vehicleSrNolist) async {
    String vehiclelistnumbers = "";
    var response;

    for (int i = 0; i < vehicleSrNolist.length; i++) {
      vehiclelistnumbers =
          vehiclelistnumbers + vehicleSrNolist[i].toString() + ",";
    }
    print(Constant.getLiveTrackingFilterUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString() +
        "&VehicleList=" +
        vehiclelistnumbers.toString());

    if (vehiclelistnumbers != "") {
      response = await http.get(
        Uri.parse(Constant.getLiveTrackingFilterUrl +
            "" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&ARAI_NONARAI=" +
            araiNonarai.toString() +
            "&VehicleList=" +
            vehiclelistnumbers.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    }

    print(response.body);
    return liveTrackingFilterResponseFromJson(response.body);
  }

  Future<LiveTrackingFilterResponse> getSearchLiveTrackingFilter(
      String token,
      int vendorId,
      int branchId,
      String araiNonarai,
      List<int> vehicleSrNolist,
      String searchText) async {
    String vehiclelistnumbers = "";
    var response;

    for (int i = 0; i < vehicleSrNolist.length; i++) {
      vehiclelistnumbers =
          vehiclelistnumbers + vehicleSrNolist[i].toString() + ",";
    }

    print(Constant.getSearchLiveTrackingFilterUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString() +
        "&VehicleList=" +
        vehiclelistnumbers.toString() +
        "&SearchText_VehicleRegNo=" +
        searchText);

    if (vehiclelistnumbers != "") {
      response = await http.get(
        Uri.parse(Constant.getSearchLiveTrackingFilterUrl +
            "" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&ARAI_NONARAI=" +
            araiNonarai.toString() +
            "&VehicleList=" +
            vehiclelistnumbers.toString() +
            "&SearchText_VehicleRegNo=" +
            searchText),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );
    }

    print(response.body);
    return liveTrackingFilterResponseFromJson(response.body);
  }

  Future<List<SearchLiveTrackingResponse>> getSearchLiveTracking(
      String token,
      int vendorId,
      int branchId,
      String araiNonarai,
      String trakingStatus,
      String searchText) async {
    // print(Constant.getSearchLiveTrackingUrl+""+vendorId.toString()+"&BranchId="+branchId.toString()+"&TrackingStatus="+trakingStatus+"&ARAI_NONARAI="+araiNonarai.toString()+"&SearchText_VehicleRegNo="+searchText);

    String url =
        "https://vtsgpsapi.m-techinnovations.com/api/VTSLive/SearchLiveVehicle?VendorId=" +
            vendorId.toString() +
            "&BranchId=" +
            branchId.toString() +
            "&TrackingStatus=" +
            trakingStatus +
            "&ARAI_NONARAI=" +
            araiNonarai +
            "&SearchText_VehicleRegNo=" +
            searchText;
    print(url);
    print("-----------------------${searchText}");
    final response = await http.get(
      Uri.parse(
        url,
        // Constant.getSearchLiveTrackingUrl+""+vendorId.toString()+"&BranchId="+branchId.toString()+"&TrackingStatus="+trakingStatus+"&ARAI_NONARAI="+araiNonarai.toString()+"&SearchText_VehicleRegNo="+searchText
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    print(response.body);
    return searchLiveTrackingResponseFromJson(response.body);
  }

  Future<GetGeofenceCreateDetailsResponse> getGeofenceCreateDetails(
      String token,
      int vendorId,
      int branchId,
      int pageNUmber,
      int pageSize) async {
    print(Constant.getGeofenceCreateDetailsUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "PageNumber=" +
        pageNUmber.toString() +
        "&PageSize=" +
        pageSize.toString());

    final response = await http.get(
      Uri.parse(Constant.getGeofenceCreateDetailsUrl +
          "" +
          vendorId.toString() +
          "&BranchId=" +
          branchId.toString() +
          "&PageNumber=" +
          pageNUmber.toString() +
          "&PageSize=" +
          pageSize.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return GetGeofenceCreateDetailsResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> deleteGeofenceCreateById(
      String token, int vendorId, int branchId, int geofenceId) async {
    print(Constant.deleteGeofenceCreateByIdUrl +
        "" +
        vendorId.toString() +
        "/" +
        branchId.toString() +
        "/" +
        geofenceId.toString());

    final response = await http.delete(
      Uri.parse(Constant.deleteGeofenceCreateByIdUrl +
          "" +
          vendorId.toString() +
          "/" +
          branchId.toString() +
          "/" +
          geofenceId.toString()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<SearchGeofenceCreateResponse> searchGeofenceCreateDetails(
      String token, int vendorId, int branchId, String searchText) async {
    print(Constant.searchGeofenceCreateByIdUrl +
        "" +
        vendorId.toString() +
        "/" +
        branchId.toString() +
        "/" +
        searchText);

    final response = await http.get(
      Uri.parse(Constant.searchGeofenceCreateByIdUrl +
          "" +
          vendorId.toString() +
          "/" +
          branchId.toString() +
          "/" +
          searchText),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return SearchGeofenceCreateResponse.fromJson(jsonDecode(response.body));
  }

//! AddGeofence is created-------------------------------------------------
  Future<AddGeofenceResponse> addGeofence(
    String token,
    int vendorid,
    int branchid,
    String geofencename,
    String category,
    String description,
    int tolerance,
    String showgeofence,
    String latitude,
    String longitude,
    String overlaytype,
    String rectanglebond,
    String rectanglearea,
    String rectanglehectares,
    String rectanglekilometer,
    String rectanglemiles,
    String address,
    int vehicleid,
  ) async {
    final body = {
      "vendorSrNo": 1,
      "branchSrNo": 1,
      "geofenceName": geofencename,
      "category": category,
      "description": description,
      "tolerance": tolerance,
      "showGeofence": showgeofence,
      "locationLatitude": latitude,
      "locationLongitude": longitude,
      "overlayType": "Rectangle",
      "circleBounds": "",
      "circleRadius": "",
      "circleArea": "",
      "circlehectares": "",
      "circleKilometer": "",
      "circleMiles": "",
      "circleCenterLat": "",
      "circleCenterLng": "",
      "rectangleBounds": "12.56",
      "rectangleArea": "12.56",
      "rectanglehectares": "3.6",
      "rectangleKilometer": "4",
      "rectangleMiles": "2.3",
      "polygonPath": "",
      "polygonArea": "",
      "polygonhectares": "",
      "polygonKilometer": "",
      "polygonMiles": "",
      "address": address.toString(),
      "vehicleList": [
        {"vehicleId": vehicleid},
      ]
    };
    final response = await http.post(
      Uri.parse(Constant.addGeofenceUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(body),
    );
    print("your token of geoFence------------" + token);
    if (response.statusCode == 201) {
      print("Your data was addedd sucessfully");
      return AddGeofenceResponse.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to loaded Geofence");
    }
  }

  Future<EditDeviceResponse> createAssignMenuRights(
      AssignMenuRightsRequest assignMenuRightsRequest, String token) async {
    print(Constant.createAssignMenuRightsUrl);

    final response = await http.post(
      Uri.parse(Constant.createAssignMenuRightsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(assignMenuRightsRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  Future<EditDeviceResponse> removeAssignMenuRights(
      AssignMenuRightsRequest assignMenuRightsRequest, String token) async {
    print(Constant.removeAssignMenuRightsUrl);

    final response = await http.post(
      Uri.parse(Constant.removeAssignMenuRightsUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(assignMenuRightsRequest),
    );

    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

// ! here we start--------------
  Future<travel_summary_response> travelsummarydetail(
    String token,
    int vendorid,
    int branchid,
    int pagenumber,
    int pagesize,
    String arinonarai,
    String fromdate,
    String fromtime,
    String totime,
    String todate,
  ) async {
    var travelurl = Constant.travelSummaryReportfillvendor +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&IMEINO=867322033819244&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is travel data url " + travelurl);

    final response =
        await http.get(Uri.parse(travelurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var travelsummaryjson = travel_summary_response.fromJson(jsonbody);
      print("Json decoded body_" + travelsummaryjson.toString());
      return travelsummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

//! TravelSummary Search web service-------------------------
  Future<TravelSummarySearch> travelsearch_web(
  String token,
  int vendorid,
  int branchid,
  String arainonarai,
  String fromdata,
  String fromtime,
  String todate,
  String totime,
  String searchtext,
  int pagenumber,
  int pagesize,
  ) async {
    var travelsearchurl = Constant.travelSummarySearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdata.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&SearchText=" +
        searchtext.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    // var travelsearchurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/TravelSummaryReport/SearchTravelSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=10:30&ToDate=30-sep-2022&ToTime=15:30&SearchText=MH12&PageNumber=1&PageSize=10";
    print("This is travel summary search " + travelsearchurl);
    final response =
        await http.get(Uri.parse(travelsearchurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
      print("Successfully getting your data 2");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var travelsummaryjson = TravelSummarySearch.fromJson(jsonbody);
      print("Json decoded body2_" + jsonbody.toString());
      return travelsummaryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  //! TravelSummary Filter web service-----------------
  Future<TravelSummaryFilter> travelfilter_web(
    String token,
    int vendorid,
    int branchid,
    int pagenumber,
    int pagesize,
    String arinonarai,
    String fromdate,
    String fromtime,
    String vehiclelist,
    String totime,
    String todate,
  ) async {
    var travelfilterurl = Constant.travelSummaryFilter +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is travel filter" + travelfilterurl);

    // var travelfilterurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/TravelSummaryReport/FilterTravelSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=02-sep-2022&FromTime=13:30&ToDate=30-sep-2022&ToTime=19:30&VehicleList=86,76&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(travelfilterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    print("Successfully getting your data 3");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var travelsummaryjson = TravelSummaryFilter.fromJson(jsonbody);

    return travelsummaryjson;
  }

  //! Route Define Post----------------
  Future<RouteDefinePost> routedefinepost(
    String token,
    int vendorid,
    int branchid,
    String routefrom,
    String routeto,
    String routename,
    String midway,
  ) async {
    final body = {
      "vendorSrNo": 1,
      "branchSrNo": 1,
      "routeName": routename.toString(),
      "routeFrom": routefrom.toString(),
      "routeTo": routeto.toString(),
      "latlang": midway.toString()
    };
    final response = await http.post(
      Uri.parse("https://vtsgpsapi.m-techinnovations.com/api/RouteDefine"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(body),
    );
    print("your token of geoFence------------" + token);
    if (response.statusCode == 201) {
      print("Your RouteDefine data was addedd sucessfully");
      return RouteDefinePost.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to loaded poidata");
    }
  }

  //! All Data Distance Summary Screen---------------------------
  Future<DistancesummaryEntity> distancesummarydetail(
    String token,
    int vendorid,
    int branchid,
    int pagenumber,
    int pagesize,
    String arinonarai,
    String fromdate,
    String fromtime,
    String totime,
    String todate,
    String IMEINO,
  ) async {
    var distanceurl = Constant.DistanceSummaryReport +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&IMEINO=867322033819244&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    /*
    var distanceurl ="https://vtsgpsapi.m-techinnovations.com/api/DistanceTravelSummary/GetDistanceTravelSummaryReport?"
        "VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=06:30&ToDate=30-sep-2022&ToTime=18:00&IMEINO"
        "=867322033819244&PageNumber=1&PageSize=10";

     */
    final response =
        await http.get(Uri.parse(distanceurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var distancesummaryjson = DistancesummaryEntity.fromJson(jsonbody);
      print("Json decoded body_" + distancesummaryjson.toString());
      return distancesummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<DistanceSummaryFilter> distancesummaryfilter(
    String token,
    int vendorid,
    int branchid,
    int pagenumber,
    int pagesize,
    String arinonarai,
    String summaryrange,
    String vehiclelist,
  ) async {
    var distanceurl = Constant.distancesummaryfilter +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&" +
        "&SummaryRange=" +
        summaryrange.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    // var distanceurl =
    //   "https://vtsgpsapi.m-techinnovations.com/api/DistanceTravelSummary/FilterDistanceTravelSummaryReport_SummaryRange?VendorId=1&BranchId=1&ARAI_NONARAI=arai&SummaryRange=months&VehicleList=86,76&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(distanceurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var distancesummaryjson = DistanceSummaryFilter.fromJson(jsonbody);
      print("Json decoded body_" + distancesummaryjson.toString());
      return distancesummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // distance summary search
  Future<DistanceSummarySearchModel> distancesummarysearch(
    String token,
    int vendorid,
    int branchid,
    int pagenumber,
    int pagesize,
    String arinonarai,
    String fromdate,
    String fromtime,
    String searchtext,
    String totime,
    String todate,
  ) async {
    var distanceurl = Constant.distancesummarysearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=$arinonarai" +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&SearchText=$searchtext" +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    final response =
        await http.get(Uri.parse(distanceurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
    var distancesummaryjson = DistanceSummarySearchModel.fromJson(jsonbody);
    return distancesummaryjson;
  }

  // Driver wise vehicle assign
  Future<DriverWiseVehicleAssign> driverwisevehicleassign(
    String token,
    int vendorid,
    int branchid,
    int pagenumber,
    int pagesize,
  ) async {
    var driverwisevehicleassignurl = Constant.driverwisevehicleassign +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is driver wise url " + driverwisevehicleassignurl);
    /*
    var driverwisevehicleassign ="https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/GetDriverVehicleAssign?VendorId=1&BranchId=1&PageNumber=1&PageSize=10";

     */
    final response = await http
        .get(Uri.parse(driverwisevehicleassignurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var driverwisevehiclejson = DriverWiseVehicleAssign.fromJson(jsonbody);
      print("Json decoded body_" + driverwisevehiclejson.toString());
      return driverwisevehiclejson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Driver wise vehicle filter
  Future<DriverWiseVehicleFilter> driverwisevehiclefilter(
    String token,
    int vendorid,
    int branchid,
    String vsrno,
    int pagenumber,
    int pagesize,
  ) async {
    var driverwisevehiclefilternurl = Constant.driverwisevehiclefilter +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&VSrNo=" +
        vsrno.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is driver wise url " + driverwisevehiclefilternurl);
    /*
    var driverwisevehicleassign ="https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/GetDriverVehicleAssign?VendorId=1&BranchId=1&PageNumber=1&PageSize=10";

     */
    final response = await http
        .get(Uri.parse(driverwisevehiclefilternurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var driverwisevehiclejson = DriverWiseVehicleFilter.fromJson(jsonbody);
    print("Json decoded body_" + driverwisevehiclejson.toString());
    return driverwisevehiclejson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Date wise travel history filter
  Future<DateWiseTravelFilterModel> datewisetravelfilter(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String todate,
    String vehiclelist,
    int pagenumber,
    int pagesize,
  ) async {
    // https://vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/ApplyFilterDatewiseTravelHistory?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&VehicleList=86,76&PageNumber=1&PageSize=10
    var datewisetravelfilterurl = Constant.datewisetravelfilter +
        "?VendorId=" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&ToDate=" +
        todate.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var datewisetravelfilterurl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/ApplyFilterDatewiseTravelHistory?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&VehicleList=86,76&PageNumber=1&PageSize=10';

    print("This is date wise travel filter url " + datewisetravelfilterurl);
    /*
    var driverwisevehicleassign ="https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/GetDriverVehicleAssign?VendorId=1&BranchId=1&PageNumber=1&PageSize=10";

     */
    final response = await http
        .get(Uri.parse(datewisetravelfilterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var driverwisevehiclejson = DateWiseTravelFilterModel.fromJson(jsonbody);
    print("Json decoded body_" + datewisetravelfilterurl.toString());
    return driverwisevehiclejson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Frame packet grid filter
  Future<FrameGridFilterMode> framepacketgridfilter(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String vehiclelist,
    String framepacketoption,
    int pagenumber,
    int pagesize,
  ) async {
    // https://vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/ApplyFilterDatewiseTravelHistory?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&VehicleList=86,76&PageNumber=1&PageSize=10
    var framegridreportfilterurl = Constant.framegridfilterurl +
        "?VendorId=" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&FramePacketOption=" +
        framepacketoption.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var datewisetravelfilterurl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/ApplyFilterDatewiseTravelHistory?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&VehicleList=86,76&PageNumber=1&PageSize=10';

    print("This is frame packet grid filter url " + framegridreportfilterurl);
    /*
    var driverwisevehicleassign ="https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/GetDriverVehicleAssign?VendorId=1&BranchId=1&PageNumber=1&PageSize=10";

     */
    final response = await http
        .get(Uri.parse(framegridreportfilterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var driverwisevehiclejson = FrameGridFilterMode.fromJson(jsonbody);
    print("Json decoded body_" + framegridreportfilterurl.toString());
    print("this is packet frame grid filter data" +
        driverwisevehiclejson.toString());
    return driverwisevehiclejson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Frame packet filter
  Future<FramePacketFilterModel> frampacketfilter(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String vehiclelist,
    String framepacketoption,
    int pagenumber,
    int pagesize,
  ) async {
    // https://vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/ApplyFilterDatewiseTravelHistory?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&VehicleList=86,76&PageNumber=1&PageSize=10
    var framepacketfilterurl = Constant.framefilterurl +
        "?VendorId=" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&FramePacketOption=" +
        framepacketoption.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var datewisetravelfilterurl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/FramePacketReport/FilterFramepacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=09:30&ToDate=30-sep-2022&ToTime=20:30&VehicleList=86,76&FramePacketOption=loginpacket&PageNumber=1&PageSize=10';

    print("This is Frame packet filter url " + framepacketfilterurl);
    /*
    var driverwisevehicleassign ="https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/GetDriverVehicleAssign?VendorId=1&BranchId=1&PageNumber=1&PageSize=10";

     */
    final response = await http
        .get(Uri.parse(framepacketfilterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var driverwisevehiclejson = FramePacketFilterModel.fromJson(jsonbody);
    print("Json decoded body_" + framepacketfilterurl.toString());
    return driverwisevehiclejson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // vehicle status report filter
  Future<VehicleStatusReportFilter> vehiclestatusreportfilter(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String vehiclelist,
    String toDate,
    String toTime,
    int imeno,
    int pagenumber,
    int pagesize,
  ) async {
    var travelurl = Constant.vehiclestatusfilter +
        "?VendorId=" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is Vehicle status filter url " + travelurl);
    final response =
        await http.get(Uri.parse(travelurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
    var searchtextresponce = VehicleStatusReportFilter.fromJson(jsonbody);
    print("Json decoded body_" + searchtextresponce.toString());
    return searchtextresponce;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  Future<DriverWiseVehicleAssignSearch> driverwisevehicleassignsearch(
    String token,
    int vendorid,
    int branchid,
    String searchtext,
    int pagenumber,
    int pagesize,
  ) async {
    var drivervehicleassigsearchnurl = Constant.driverwisevehicleassignsearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&SearchText=" +
        searchtext.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // print("This is driver wise url "+drivervehicleassigsearchnurl);
    /*
    var driverwisevehicleassignsearch ="https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/SearchDriverVehicleAssign?VendorId=1&BranchId=1&SearchText=sandhya&PageNumber=1&PageSize=10";

     */
    final response = await http
        .get(Uri.parse(drivervehicleassigsearchnurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var driverwisevehiclesearchjson =
          DriverWiseVehicleAssignSearch.fromJson(jsonbody);
      print("Json decoded body_" + driverwisevehiclesearchjson.toString());
      return driverwisevehiclesearchjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<DateWiseTravelHistory> datewisetravelhistory(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String todate,
    String imeino,
    int pageSize,
    int pageNumber,
  ) async {
    var datewisetravelhistoryurl = Constant.datewisetravelhistory +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&ToDate=" +
        todate.toString() +
        "&IMEINO=867322033819244" +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is date wise travel history url " + datewisetravelhistoryurl);

    print("This is date wise travel history url " + datewisetravelhistoryurl);

    final response = await http
        .get(Uri.parse(datewisetravelhistoryurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var datewisetravelhistoryjson = DateWiseTravelHistory.fromJson(jsonbody);
      print("Json decoded body_" + datewisetravelhistoryjson.toString());
      return datewisetravelhistoryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Vehicle wise travel history

  Future<VehicleWiseTravelModel> vehiclewisetravelhistory(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    int imeino,
    int pageNumber,
    int pageSize,
  ) async {
    var vehiclewisetravelhistory = Constant.vehiclewisetravelhistory +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&IMEINO=" +
        imeino.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print(
        "This is Vehicle wise travel history url " + vehiclewisetravelhistory);

    final response = await http
        .get(Uri.parse(vehiclewisetravelhistory), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var datewisetravelhistoryjson = VehicleWiseTravelModel.fromJson(jsonbody);
      print("Json decoded body_" + datewisetravelhistoryjson.toString());
      return datewisetravelhistoryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Vehicle wise Time wise travel history

  Future<VehicleWiseTimeWiseTravelModel> vehiclewisetimewisetravelhistory(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    int imeino,
    int pageNumber,
    int pageSize,
  ) async {
    var vehiclewisetimewisetravelhistory =
        Constant.vehicletimewisetravelhistory +
            "?VendorId=" +
            vendorid.toString() +
            "&BranchId=" +
            branchid.toString() +
            "&ARAI_NONARAI=arai&FromDate=" +
            fromdate.toString() +
            "&FromTime=" +
            fromtime.toString() +
            "&ToDate=" +
            todate.toString() +
            "&ToTime=" +
            totime.toString() +
            "&IMEINO=" +
            imeino.toString() +
            "&PageNumber=" +
            pageNumber.toString() +
            "&PageSize=" +
            pageSize.toString();

    print("This is vehicle wise Time wise travel history url " +
        vehiclewisetimewisetravelhistory);

    final response = await http.get(Uri.parse(vehiclewisetimewisetravelhistory),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var vehiclewisetravelhistoryjson =
          VehicleWiseTimeWiseTravelModel.fromJson(jsonbody);
      return vehiclewisetravelhistoryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Vehicle wise FIlter
  Future<VehicleWiseFilterModel> vehiclewisefilter(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String vehiclelist,
    int pageNumber,
    int pageSize,
  ) async {
    var vehiclewisefilter = Constant.vehiclewisefilter +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&Vehiclelist=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is vehicle wise Time wise travel filter url " +
        vehiclewisefilter);

    final response =
        await http.get(Uri.parse(vehiclewisefilter), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var vehiclewisetravelhistoryjson =
        VehicleWiseFilterModel.fromJson(jsonbody);
    return vehiclewisetravelhistoryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Vehicle wise Time wise FIlter
  Future<VehicleWiseTimeWiseFilterModel> vehiclewisetimewisefilter(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String vehiclelist,
    int pageNumber,
    int pageSize,
  ) async {
    var vehiclewisetimewisefilter = Constant.vehicletimewisefilter +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&Vehiclelist=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is vehicle wise Time wise travel filter url " +
        vehiclewisetimewisefilter);

    final response = await http
        .get(Uri.parse(vehiclewisetimewisefilter), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var vehiclewisetravelhistoryjson =
        VehicleWiseTimeWiseFilterModel.fromJson(jsonbody);
    return vehiclewisetravelhistoryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Vehicle wise  search
  Future<VehicleWiseSearchModel> vehiclewisesearch(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String todate,
    String searchtxt,
    int pageNumber,
    int pageSize,
  ) async {
    var vehiclewisetimewisefilter = Constant.vehiclewisesearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&ToDate=" +
        todate.toString() +
        "&SearchText=" +
        searchtxt.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print(
        "This is vehicle wise travel search url " + vehiclewisetimewisefilter);

    final response = await http
        .get(Uri.parse(vehiclewisetimewisefilter), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var vehiclewisetravelhistoryjson =
        VehicleWiseSearchModel.fromJson(jsonbody);
    return vehiclewisetravelhistoryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Vehicle wise Time wise search
  Future<VehicleWiseTimeWiseSearchModel> vehiclewisetimewisesearch(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String searchtxt,
    int pageNumber,
    int pageSize,
  ) async {
    var vehiclewisetimewisefilter = Constant.vehicletimewisesearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&SearchText=" +
        searchtxt.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is vehicle wise Time wise travel search url " +
        vehiclewisetimewisefilter);

    final response = await http
        .get(Uri.parse(vehiclewisetimewisefilter), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var vehiclewisetravelhistoryjson =
        VehicleWiseTimeWiseSearchModel.fromJson(jsonbody);
    return vehiclewisetravelhistoryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Date and time wise travel
  Future<DateAndTimeWiseTravel> dateandtimewisetravelhistory(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    int imeino,
    int pageNumber,
    int pageSize,
  ) async {
    var dateandtimewisetravelhistory = Constant.dateandtimewisedistance +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&IMEINO=" +
        imeino.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is date and Time wise travel history url " +
        dateandtimewisetravelhistory);

    final response = await http
        .get(Uri.parse(dateandtimewisetravelhistory), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var vehiclewisetravelhistoryjson =
          DateAndTimeWiseTravel.fromJson(jsonbody);
      return vehiclewisetravelhistoryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Date and time wise filter
  Future<DateAndTimeWiseFilter> dateandtimewisefilter(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String vehiclelist,
    int pageNumber,
    int pageSize,
  ) async {
    var dateandtimewisefilter = Constant.dateandtimewisefilter +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&Vehiclelist=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is date and Time wise filter url " + dateandtimewisefilter);

    final response = await http
        .get(Uri.parse(dateandtimewisefilter), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var vehiclewisetravelhistoryjson = DateAndTimeWiseFilter.fromJson(jsonbody);
    return vehiclewisetravelhistoryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Date and time wise search
  Future<DateAndTimeWiseSearchModel> dateandtimewisesearch(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String fromtime,
    String todate,
    String totime,
    String searchtxt,
    int pageNumber,
    int pageSize,
  ) async {
    var dateandtimewisesearch = Constant.dateandtimewisesearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&SearchText=" +
        searchtxt.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is date and Time wise filter url " + dateandtimewisesearch);

    final response = await http
        .get(Uri.parse(dateandtimewisesearch), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var vehiclewisetravelhistoryjson =
        DateAndTimeWiseSearchModel.fromJson(jsonbody);
    return vehiclewisetravelhistoryjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  Future<GetOverspeedReportResponse> overspeedreport(
      String token,
      int vendorid,
      int branchid,
      String arai,
      String fromDate,
      String toDate,
      int imeno,
      int pagenumber,
      int pagesize) async {
    var overspeedurl = Constant.getOverSpeedReportUrl +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromDate.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&IMEINO=" +
        imeno.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is overspeed url " + overspeedurl);
    // var overspeedurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleWiseOverSpeedReport/GetOverSpeedReport?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&FromDate=01-sep-2022&ToDate=30-sep-2022&IMEINO=862430050555255&PageNumber=1&PageSize=10";

    final response =
        await http.get(Uri.parse(overspeedurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var overspeedurljson = GetOverspeedReportResponse.fromJson(jsonbody);
      print("Json decoded body_" + overspeedurl.toString());
      return overspeedurljson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<OverSpeedFilter> overspeedfilter(
      String token,
      int vendorid,
      int branchid,
      String arai,
      String fromDate,
      String toDate,
      String vehiclelist,
      int pagenumber,
      int pagesize) async {
    var overspeedurl = Constant.filterOverSpeedUrl +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromDate.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("Over speed filter url " + overspeedurl);

    // var overspeedurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleWiseOverSpeedReport/FilterOverSpeed?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&FromDate=01-sep-2022&ToDate=30-sep-2022&VehicleList=8,46&PageNumber=1&PageSize=10";

    final response =
        await http.get(Uri.parse(overspeedurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    print("This is overspeed filter -------- " + response.body);
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var overspeedurljson = OverSpeedFilter.fromJson(jsonbody);
    print("Json decoded body_" + overspeedurl.toString());
    return overspeedurljson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // ----------------------------------
  Future<DateWiseTravelHistory> datewisesearch(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdate,
    String todate,
    String imeino,
    int pageSize,
    int pageNumber,
  ) async {
    var datewisesearchurl = Constant.datewisesearch +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=arai&FromDate=" +
        fromdate.toString() +
        "&ToDate=" +
        todate.toString() +
        "&IMEINO=867322033819244" +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is date wise travel history url " + datewisesearchurl);

    print("This is date wise travel history url " + datewisesearchurl);

    final response =
        await http.get(Uri.parse(datewisesearchurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var datewisesearchjson = DateWiseTravelHistory.fromJson(jsonbody);
      print("Json decoded body_" + datewisesearchurl.toString());
      return datewisesearchjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  //Start Search Element in Vehicle Report- API----
  // Future<SearchDatewiseTravelHistryRpt> searchTxtDateWiseTravelHistoryRpt(
  //     String token,
  //     int vendorId,
  //     String fromDate,
  //     String toDate,
  //     String searchText,
  //     int branchId,
  //     int pageNumber,
  //     int pageSize) async {
  //   String searchdmdataurl = Constant.searchDatewiseTravelrurl +
  //       vendorId.toString() +
  //       "&BranchId=1" +
  //       // branchId.toString() +
  //       "&ARAI_NONARAI=arai" +
  //       "&FromDate=01-sep-2022" +
  //       "&ToDate=30-sep-2022" +
  //       "&SearchText=" +
  //       searchText +
  //       "&PageNumber=1" +
  //       // pageNumber.toString() +
  //       "&PageSize=10";
  //   // pageSize.toString();
  //   // String searchdmdataurl ='https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/SearchDeviceMasterReport?
  //   // VendorId=1&BranchId=1&SearchText=AIS&PageNumber=1&PageSize=8';
  //   https: //vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/SearchDatewiseTravelHistory?
  //   // VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&SearchText=MH12&PageNumber=1&PageSize=10
  //   final response = await http.get(
  //     Uri.parse(searchdmdataurl),
  //     headers: <String, String>{
  //       // 'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': "Bearer ${token}",
  //     },
  //   );

  //   var jsonBody =
  //       SearchDatewiseTravelHistryRpt.fromJson(json.decode(response.body));
  //   print("JSon  assign body are:-------------$jsonBody");
  //   return jsonBody;
  // }
//End

// Pritis code ----------------------------------------------------------------
  Future<SearchVehOverSpeedRpt> searchoverspeedRpt(
      String token,
      int vendorId,
      int branchId,
      String arainonarai,
      String fromDate,
      String toDate,
      String searchText,
      int pageNumber,
      int pageSize) async {
    String searchurl = Constant.searchOverSpeedReportUrl +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=nonarai" +
        "&FromDate=$fromDate" +
        "&ToDate=$toDate" +
        "&SearchText=" +
        searchText +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();
    // String searchurl ='https://vtsgpsapi.m-techinnovations.com/api/VehicleWiseOverSpeedReport/SearchOverSpeedReport?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&FromDate=01-sep-2022&ToDate=30-sep-2022&SearchText=MH&PageNumber=1&PageSize=10';

    print("URi of search overspeed is ----------$searchurl");
    final response = await http.get(
      Uri.parse(searchurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    // if (response.statusCode == 200) {
    //   print("Response body is:-------->>${response.statusCode}");
    //   print("Response body is:-------->>${response.body}");
    var jsonBody = SearchVehOverSpeedRpt.fromJson(json.decode(response.body));
    print("JSon  overspeed search body are:-------------$jsonBody");
    return jsonBody;
    // } else {
    //   throw Exception(e);
    // }
  }

//
  ///Start Search Element in driver veh Assign Report- API----
  Future<SearchDriverwiseVehRpt> searchStrDriverwiseVehicleAssignRpt(
      String token,
      int vendorId,
      String searchText,
      int branchId,
      int pageNumber,
      int pageSize) async {
    String searchdmdataurl = Constant.searchDriverwiseAssignReportUrl +
        "&BranchId=$branchId" +
        // branchId.toString() +
        "&SearchText=" +
        searchText +
        "&PageNumber=$pageNumber" +
        // pageNumber.toString() +
        "&PageSize=$pageSize";

    print("URL of driver wise veh------${searchdmdataurl}");
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody = SearchDriverwiseVehRpt.fromJson(json.decode(response.body));
    print("JSon  assign body are:-------------$jsonBody");
    return jsonBody;
  }

  /// Search api fpr date wise travel history
  Future<SearchDatewiseTravelHistryRpt> searchTxtDateWiseTravelHistoryRpt(
      String token,
      int vendorId,
      int branchId,
      String arai,
      String fromDate,
      String toDate,
      String searchText,
      int pageNumber,
      int pageSize) async {
    String searchdmdataurl = Constant.searchDatewiseTravelrurl +
        vendorId.toString() +
        "&BranchId=$branchId" +
        // branchId.toString() +
        "&ARAI_NONARAI=$arai" +
        "&FromDate=$fromDate" +
        "&ToDate=$toDate" +
        "&SearchText=" +
        searchText +
        "&PageNumber=$pageNumber" +
        // pageNumber.toString() +
        "&PageSize=$pageSize";
    // pageSize.toString();
    // String searchdmdataurl ='https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/SearchDeviceMasterReport?
    // VendorId=1&BranchId=1&SearchText=AIS&PageNumber=1&PageSize=8';
    // https: //vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/SearchDatewiseTravelHistory?
    // VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&ToDate=30-sep-2022&SearchText=MH12&PageNumber=1&PageSize=10
    print("URL datewise travel histry----$searchdmdataurl");
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody =
        SearchDatewiseTravelHistryRpt.fromJson(json.decode(response.body));
    print("JSon  assign body are:-------------$jsonBody");
    return jsonBody;
  }

  /// Search api for frame packet
//  Future<SearchFramePcktRpt> searchTextFramePckt(
//     String token,
//     int vendorId,
//     int branchid,
//     String araino,
//     String fromdate,
//     String fromTime,
//     String toDate,
//     String toTime,
//     String searchText,
//     String frampacketoption,
//     int pagenumber,
//     int pagesize,
//   ) async {
//     // print(
//     //     "${searchStrClass.searchStr}-----Enter in SEARCH assign future api ----$searchText");
//     String searchdmdataurl = Constant.searchFramePacketrurl +
//         vendorId.toString() +
//         "&BranchId=" +
//         branchid.toString() +
//         "&ARAI_NONARAI=$araino" +
//         "&FromDate=$fromdate" +
//         "&FromTime=$fromTime" +
//         "&ToDate=$toDate" +
//         "&ToTime=$toTime" +
//         "&SearchText=$searchText" +
//         "&FramePacketOption=$frampacketoption" +
//         "&PageNumber=" +
//         pagenumber.toString() +
//         "&PageSize=" +
//         pagesize.toString();
//     // String searchdmdataurl =
//     //     "  https://vtsgpsapi.m-techinnovations.com/api/FramePacketReport/SearchFramePacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=07:00&ToDate=30-sep-2022&ToTime=18:00&SearchText=MH12&FramePacketOption=loginpacket&PageNumber=1&PageSize=10";
//     https: //vtsgpsapi.m-techinnovations.com/api/FramePacketReport/
//     // SearchFramepacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai
//     // &FromDate=01-sep-2022&FromTime=07:00&ToDate=30-sep-2022&ToTime=18:00
//     // &SearchText=MH12&FramePacketOption=loginpacket&PageNumber=1&PageSize=10

//     print("Search frame url is:----$searchdmdataurl");
//     final response = await http.get(
//       Uri.parse(searchdmdataurl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': "Bearer ${token}",
//       },
//     );
//     // if (response.statusCode == 200) {
//       print("Response body is:-------->>${response.statusCode}");
//       print("Response body is:-------->>${response.body}");
//       var jsonBody = SearchFramePcktRpt.fromJson(json.decode(response.body));
//       print("JSon  assign body are:-------------${jsonBody.data!}");
//       return jsonBody;
//     // } else {
//     //   throw Exception(e);
//     // }
//   }

  /// Search api for frame packet grid
//  Future<SearchFramepacketgrid> searchTextFramePcktgrid(
//     String token,
//     int vendorId,
//     int branchid,
//     String araino,
//     String fromdate,
//     String fromTime,
//     String toDate,
//     String toTime,
//     String searchText,
//     String frampacketoption,
//     int pagenumber,
//     int pagesize,
//   ) async {
//      String searchdmdataurl = Constant.searchFramePacketgridurl +
//         "$vendorId" +
//         "&BranchId=$branchid" +
//         "&ARAI_NONARAI=$araino" +
//         "&FromDate=$fromdate" +
//         "&FromTime=$fromTime" +
//         "&ToDate=$toDate" +
//         "&ToTime=$toTime" +
//         "&SearchText=$searchText" +
//         "&FramePacketOption=$frampacketoption" +
//         "&PageNumber=$pagenumber" +
//         "&PageSize=$pagesize";
//      print("Search frame url is:----$searchdmdataurl");
//     final response = await http.get(
//       Uri.parse(searchdmdataurl),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': "Bearer ${token}",
//       },
//     );
//     // if (response.statusCode == 200) {
//       print("Response body is:-------->>${response.statusCode}");
//       print("Response body is:-------->>${response.body}");
//       var jsonBody = SearchFramepacketgrid.fromJson(json.decode(response.body));
//       print("JSon  assign body are:-------------$jsonBody");
//       return jsonBody;
//     // } else {
//     //   print("Exception found from frame pkt grid search..");
//     //   throw Exception("e");
//     // }
//   }

//Future method for search vehicle status report------------
  Future<SearchVehicleStatusRpt> searchvehstatusrpt(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String searchText,
    int pagenumber,
    int pagesize,
  ) async {
    // print(
    //     "${searchStrClass.searchStr}-----Enter in SEARCH assign future api ----$searchText");
    String searchdmdataurl = Constant.searchvehiclestatusreporturl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&SearchText=" +
        searchText +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    // String searchdmdataurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/SearchVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12%3A30&ToDate=30-sep-2022&ToTime=18%3A30&SearchText=MH12&PageNumber=1&PageSize=10 ";
    print("Search frame url is:----$searchdmdataurl");
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody = SearchVehicleStatusRpt.fromJson(json.decode(response.body));
    print("JSon  assign body are:-------------$jsonBody");
    return jsonBody;
  }

  /// Search api for Vehicle status group by
  // Future<SearchVehicleStatusGroupRpt> searchvehstatusgrouprpt(
  //   String token,
  //   int vendorId,
  //   int branchid,
  //   String arai,
  //   String fromdate,
  //   String fromTime,
  //   String toDate,
  //   String toTime,
  //   String searchText,
  //   int pagenumber,
  //   int pagesize,
  // ) async {
  // print(
  //     "${searchStrClass.searchStr}-----Enter in SEARCH assign future api ----$searchText");
  //   String searchdmdataurl = Constant.searchvehiclestatusgroupurl +
  //       vendorId.toString() +
  //       "&BranchId=" +
  //       branchid.toString() +
  //       "&ARAI_NONARAI=" +
  //       arai.toString() +
  //       "&FromDate=" +
  //       fromdate.toString() +
  //       "&FromTime=" +
  //       fromTime.toString() +
  //       "&ToDate=" +
  //       toDate.toString() +
  //       "&ToTime=" +
  //       toTime.toString() +
  //       "&SearchText=" +
  //       searchText +
  //       "&PageNumber=" +
  //       pagenumber.toString() +
  //       "&PageSize=" +
  //       pagesize.toString();
  //   // String searchdmdataurl =
  //   //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/SearchVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12%3A30&ToDate=30-sep-2022&ToTime=18%3A30&SearchText=MH12&PageNumber=1&PageSize=10 ";
  //   print("Search frame url is:----$searchdmdataurl");
  //   final response = await http.get(
  //     Uri.parse(searchdmdataurl),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       'Authorization': "Bearer ${token}",
  //     },
  //   );
  //   // if (response.statusCode == 200) {
  //     print("Response body is:-------->>${response.statusCode}");
  //     print("Response body is:-------->>${response.body}");
  //     var jsonBody =
  //         SearchVehicleStatusGroupRpt.fromJson(json.decode(response.body));
  //     print("JSon  assign body are:-------------$jsonBody");
  //     return jsonBody;
  //   // } else {
  //   //   throw Exception(e);
  //   // }
  // }

// search Vehicle status summary
  Future<SearchVehicleStatusSummaryRpt> searchvehicleStatusSummary(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String searchText,
    int pagenumber,
    int pagesize,
  ) async {
    String vehiclestatussummaryurl = Constant.searchvehiclestatussummaryurl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&SearchText=" +
        ((searchText == null) ? "" : searchText) +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("search url of veh status summary----$vehiclestatussummaryurl");
    final response = await http.get(
      Uri.parse(vehiclestatussummaryurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    // if (response.statusCode == 200) {

    var jsonBody =
        SearchVehicleStatusSummaryRpt.fromJson(json.decode(response.body));

    return jsonBody;
    // }
    // else {
    //   throw Exception(e);
    // }
  }
// ----------------------------------------------------------------

// search device master
  Future<SearchDeviceMasterReport> findStringInDMReport(
      String token,
      int vendorId,
      String searchText,
      int branchId,
      int pageNumber,
      int pageSize) async {
    print(
        "${searchStrClass.searchStr}-----Enter in SEARCH dm future api ----$searchText");
    String searchdmdataurl = Constant.searchDeviceMasterReportUrl +
        vendorId.toString() +
        "&BranchId=1" +
        // branchId.toString() +
        "&SearchText=" +
        searchText +
        "&PageNumber=1" +
        // pageNumber.toString() +
        "&PageSize=8";
    // pageSize.toString();

    // String searchdmdataurl ='https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/SearchDeviceMasterReport?
    // VendorId=1&BranchId=1&SearchText=AIS&PageNumber=1&PageSize=8';
    print("URi is DM Report---------$searchdmdataurl");
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody =
        SearchDeviceMasterReport.fromJson(json.decode(response.body));
    print("JSon  dm body are:-------------$jsonBody");
    return jsonBody;
  }

  // device master filter
  Future<DeviceMasterFilterModel> devicemasterwebfilter(
    String token,
    String vendorid,
    String branchid,
    String deviceno,
    int pageSize,
    int pageNumber,
  ) async {
    var devicemasterurl = Constant.devicemasterfilterurl +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&DeviceNo=" +
        deviceno.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    // var devicemasterurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/FilterApplyDeviceReport?VendorId=1&BranchId=1&DeviceNo=DC00001&PageNumber=1&PageSize=10";

    print("This is device master filter url " + devicemasterurl);

    final response =
        await http.get(Uri.parse(devicemasterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var ddevicemasterjson = DeviceMasterFilterModel.fromJson(jsonbody);
    print("Json decoded body_" + devicemasterurl.toString());
    return ddevicemasterjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Vehicle Status Driver code
  Future<VehicleStatusReportDriverCodeModel> vsrdcdrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusReport/FillVehicleListIMEINo/1/1";

    print("This is vehicle status report filter driver code url " +
        dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson =
          VehicleStatusReportDriverCodeModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Vehicle VSrNo
  Future<VehicleVSrNoModel> vehiclevsrno(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/Vehicles/FillVehicleVSrNo/1/1";

    print("This is vehicle vsrno url " + dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = VehicleVSrNoModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Frame packet option
  Future<FramePacketOptionGridModel> framepacketoptiongrid(
    String token,
    String arai,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/FramePacketGridviewReport/FillFramePacket?ARAI_NONARAI=arai";

    print("This is vehicle vsrno url " + dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = FramePacketOptionGridModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Driver Master Driver code
  Future<DriverMasterDriverCodeModel> drivermasterdrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/DriverMasterReports/FillDriver/1/1";

    print("This is vehicle status report filter driver code url " +
        dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = DriverMasterDriverCodeModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // device master filter driver code (dmfdrivercode)
  Future<DeviceDriverCode> dmfdrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/FillDevice/1/1";

    print("This is device master filter driver code url " + dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = DeviceDriverCode.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Date wise Driver code
  Future<DateWiseDriverCodeModel> datewisedrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/DateWiseTravelHistoryReport/FillVehicleList_IMEINo/1/1";

    print("This is date wise vehicle assign filter driver code url " +
        dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = DateWiseDriverCodeModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Driver wise Driver code
  Future<DriverWiseDriverCodeModel> driverwisedrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/FillVehicleVSrNo/1/1";

    print("This is driver wise vehicle assign filter driver code url " +
        dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = DriverWiseDriverCodeModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Frame packet driver code
  Future<FramePacketRptDriverCodeModel> framepacketdrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/FramePacketReport/FillVehicleListIMEINo/1/1";

    print("This is frame packet filter driver code url " + dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = FramePacketRptDriverCodeModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Frame packet grid driver code
  Future<FramePacketGridRptDriverCodeModel> framepacketgriddrivercode(
    String token,
    int vendorid,
    int branchid,
  ) async {
    var dmfdrivercodeurl =
        "https://vtsgpsapi.m-techinnovations.com/api/FramePacketGridviewReport/FillVehicleListIMEINo/1/1";

    print(
        "This is frame packet grid filter driver code url " + dmfdrivercodeurl);

    final response =
        await http.get(Uri.parse(dmfdrivercodeurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson =
          FramePacketGridRptDriverCodeModel.fromJson(jsonbody);
      print("Json decoded body_" + dmfdrivercodeurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Overspeed vehicle filter
  Future<OverSpeedVehicleFilter> overspeedvehiclefilter(
    String token,
    int vendorId,
    int branchId,
  ) async {
    var overspeedvehiclefilterurl =
        "https://vtsgpsapi.m-techinnovations.com/api/VehicleWiseOverSpeedReport/FillVehicleList_IMEINo/1/1";

    print("This is overspeed vehicle filter  url " + overspeedvehiclefilterurl);

    final response = await http
        .get(Uri.parse(overspeedvehiclefilterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your driver code data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var ddevicemasterjson = OverSpeedVehicleFilter.fromJson(jsonbody);
      print("Json decoded body_" + overspeedvehiclefilterurl.toString());
      return ddevicemasterjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data ovrespeed');
    }
  }

  // Vehicle Report Filter
  Future<VehicleReportFilter> vehiclereportfilter(
    String token,
    int vendorId,
    int branchid,
    String vsrno,
    int pagenumber,
    int pagesize,
  ) async {
    var vehiclereporturl = Constant.filterVehicleReporturl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&VSrNo=" +
        vsrno.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var vehiclereporturl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleMasterReports/ApplyFilterVehicleMaster?VendorId=1&BranchId=1&VSrNo=8&PageNumber=1&PageSize=10";

    print("This is vehicle report filter url " + vehiclereporturl);

    final response =
        await http.get(Uri.parse(vehiclereporturl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data" + response.body);
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var ddevicemasterjson = VehicleReportFilter.fromJson(jsonbody);
    print("Json decoded body_" + vehiclereporturl.toString());
    return ddevicemasterjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Vehicle Summary Report Filter
  Future<VehicleSummaryFilterModel> vehiclersummaryfilter(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String vehiclelist,
    int pagenumber,
    int pagesize,
  ) async {
    var vehiclereporturl = Constant.vehiclesummaryfilter +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var vehiclereporturl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusSummaryReport/FilterVehicleStatusSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=08:30&ToDate=30-sep-2022&ToTime=19:30&VehicleList=86,76&PageNumber=1&PageSize=10";

    print(
        "This is vehicle status summary report filter url " + vehiclereporturl);

    final response =
        await http.get(Uri.parse(vehiclereporturl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data" + response.body);
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var ddevicemasterjson = VehicleSummaryFilterModel.fromJson(jsonbody);
    print("Json decoded body_" + vehiclereporturl.toString());
    return ddevicemasterjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  // Vehicle group Report Filter
  Future<VehicleGroupFilterModel> vehiclergroupfilter(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String vehiclelist,
    int pagenumber,
    int pagesize,
  ) async {
    var vehiclereporturl = Constant.vehiclegroupfilter +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&VehicleList=" +
        vehiclelist.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var vehiclereporturl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/FilterVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=08:30&ToDate=30-sep-2022&ToTime=19:30&VehicleList=86,76&PageNumber=1&PageSize=10";

    print("This is vehicle status group report filter url " + vehiclereporturl);

    final response =
        await http.get(Uri.parse(vehiclereporturl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data" + response.body);
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var ddevicemasterjson = VehicleGroupFilterModel.fromJson(jsonbody);
    print("Json decoded body_" + vehiclereporturl.toString());
    return ddevicemasterjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  Future<SearchFramePcktRpt> searchTextFramePckt(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String searchText,
    String frampacketoption,
    int pagenumber,
    int pagesize,
  ) async {
    // print(
    //     "${searchStrClass.searchStr}-----Enter in SEARCH assign future api ----$searchText");
    String searchdmdataurl = Constant.searchFramePacketrurl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=$araino" +
        "&FromDate=$fromdate" +
        "&FromTime=$fromTime" +
        "&ToDate=$toDate" +
        "&ToTime=$toTime" +
        "&SearchText=$searchText" +
        "&FramePacketOption=$frampacketoption" +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    // pageSize.toString();
    // String searchdmdataurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/FramePacketReport/SearchFramepacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12%3A30&ToDate=30-sep-2022&ToTime=18%3A30&SearchText=MH12&FramePacketOption=loginpacket&PageNumber=1&PageSize=10";
    // https: //vtsgpsapi.m-techinnovations.com/api/FramePacketReport/SearchFramepacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=07:00&ToDate=30-sep-2022&ToTime=18:00&SearchText=MH12&FramePacketOption=loginpacket&PageNumber=1&PageSize=10

    print("Search frame url is:----$searchdmdataurl");
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody = SearchFramePcktRpt.fromJson(json.decode(response.body));

    return jsonBody;
  }

//! SearchFramePacket GridAPI------------------------------
  Future<SearchFramepacketgrid> searchTextFramePcktgrid(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String searchText,
    String frampacketoption,
    int pagenumber,
    int pagesize,
  ) async {
    String searchdmdataurl = Constant.searchFramePacketgridurl +
        "$vendorId" +
        "&BranchId=$branchid" +
        "&ARAI_NONARAI=$araino" +
        "&FromDate=$fromdate" +
        "&FromTime=$fromTime" +
        "&ToDate=$toDate" +
        "&ToTime=$toTime" +
        "&SearchText=$searchText" +
        "&FramePacketOption=$frampacketoption" +
        "&PageNumber=$pagenumber" +
        "&PageSize=$pagesize";
    print("Search Grid URl-------------------" + searchdmdataurl);
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    var jsonBody = SearchFramepacketgrid.fromJson(json.decode(response.body));
    return jsonBody;
  }

  Future<SearchVehicleStatusGroupRpt> searchvehstatusgrouprpt(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String searchText,
    int pagenumber,
    int pagesize,
  ) async {
    // print(
    //     "${searchStrClass.searchStr}-----Enter in SEARCH assign future api ----$searchText");
    String searchdmdataurl = Constant.searchvehiclestatusgroupurl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&SearchText=" +
        searchText +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    // String searchdmdataurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/SearchVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12%3A30&ToDate=30-sep-2022&ToTime=18%3A30&SearchText=MH12&PageNumber=1&PageSize=10 ";
    print("Search frame url is:----$searchdmdataurl");
    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    if (response.statusCode == 200) {
      print("Response body is:-------->>${response.statusCode}");
      print("Response body is:-------->>${response.body}");
      var jsonBody =
          SearchVehicleStatusGroupRpt.fromJson(json.decode(response.body));
      print("JSon  assign body are:-------------$jsonBody");
      return jsonBody;
    } else {
      throw Exception('Failed to load data');
    }
  }
  //! POI API Start from here--------------------------------->

  Future<CreatePointOfInterest> createPointOfInterestGetApi(String token,
      int vendorId, int branchId, int pageNumber, int pageSize) async {
    // print("Api uri is-------" +
    // "${Constant.getPointOfInterstCreateUrl}VendorId=${vendorId}&BranchId=${branchId}&PageNumber=${pageNumber}&PageSize=${pageSize}" );

    var uriString = Constant.getPointOfInterstCreateUrl +
        "?VendorId=" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    //  var uriString =
    //    'https://vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate/GetPointofInterestDetails?VendorId=1&BranchId=1&PageNumber=1&PageSize=10';

    // var uriString ='${Constant.getPointOfInterstCreateUrl}?VendorId=${vendorId}&BranchId=${branchId}&PageNumber=${pageNumber}&PageSize=${pageSize}';

    print("New Uri of Point of interset is------------*********${uriString}");

    final response = await http.get(
      // Uri.parse(Constant.getPointOfInterstCreateUrl +
      //         "?VendorId=" +
      //         vendorId.toString() +
      //         "&BranchId=" +
      //         branchId.toString() +
      //         "&IMEINO=867322033819244&PageNumber=" +
      //         pageNumber.toString() +
      //         "&PageSize=" +
      //         pageSize.toString()),

      // Uri.parse('${Constant.getPointOfInterstCreateUrl}VendorId=${vendorId}&BranchId=${branchId}&PageNumber=${pageNumber}&PageSize=${pageSize}'),

      // Uri.parse('https://vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate/GetPointofInterestDetails?VendorId=1&BranchId=1PageNumber=1&PageSize=10'),

      Uri.parse(uriString),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      var createResponce =
          CreatePointOfInterest.fromJson(jsonDecode(response.body));

      return createResponce;
    } else {
      print("Data loading failed....");
      return throw Exception();
    }
  }
  //!--------------End API---------------------------

//!------------- API for Search Point of Interest -----------------//
  Future<SearchPointOfInterest> fetchSearchPointInterestDetails(
    String token,
    int vendorid,
    int branchid,
    String searchtext,
  ) async {
    print("Enter in main  web service api block");
    var searchurl =
        '${Constant.searchStrPointOfInterstCreateUrl}/${vendorid}/${branchid}/${searchtext}';
    // Constant.searchStrPointOfInterstCreateUrl +
    //  "?VendorId=" +
    //  vendorid.toString() +
    //  "&BranchId=" +
    //  branchid.toString() +
    //  "&IMEINO=867322033819244&searchString=" +
    //  searchtext.toString();

    // var searchurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate/1/1/air";
    https: //vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate?VendorId=1&BranchId=1&IMEINO=867322033819244&searchString=c
    print("Uri is-----------${searchurl}");

    final response =
        await http.get(Uri.parse(searchurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
    var searchtextresponce = SearchPointOfInterest.fromJson(jsonbody);
    print("Json decoded body_" + searchtextresponce.toString());
    return searchtextresponce;
  }

  //! Dropdown point of Interest---------------------------------
  Future<DropdownPointofInterest> dropdownpointofinterest(String token) async {
    final response = await http
        .get(Uri.parse(Constant.getPOITypeUrl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var searchtextresponce = DropdownPointofInterest.fromJson(jsonbody);
      print("Json decoded body_" + searchtextresponce.toString());
      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  //! POI type code--------------------------
  Future<POITypeCode> poitypecode(
    String token,
  ) async {
    var routenamelist =
        "https://vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate/GETPOITypeDetails";
    final response =
        await http.get(Uri.parse(routenamelist), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print("Successfully getting your data POI detail data");
      var jsonbody = jsonDecode(response.body) as List<dynamic>;
      var searchtextresponce = POITypeCode.fromJson(jsonbody);

      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

//! POI Post data added------------------
  Future<POIPost> poiaddeddata(
    String token,
    int vendorid,
    int branchid,
    String poiname,
    int poitypeID,
    String description,
    int tolerance,
    String locationlatitude,
    String locationlongitude,
    String showpoi,
    String address,
    int vehicleid,
  ) async {
    final body = {
      "vendorSrNo": 1,
      "branchSrNo": 1,
      "poiname": poiname.toString(),
      "poiTypeID": poitypeID,
      "description": description.toString(),
      "tolerance": tolerance,
      "locationLatitude": locationlatitude.toString(),
      "locationLongitude": locationlongitude.toString(),
      "showPoi": showpoi.toString(),
      "address": address.toString(),
      "vehicleList": [
        {"vehicleId": vehicleid}
      ]
    };
    final response = await http.post(
      Uri.parse(
          "https://vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode(body),
    );
    print("your token of geoFence------------" + token);
    if (response.statusCode == 201) {
      print("Your POI data was addedd sucessfully");
      return POIPost.fromJson(jsonDecode(response.body));
    } else {
      print(response.body);
      throw Exception("Failed to loaded poidata");
    }
  }

  //!  Delete poi data--------------------------
  Future<EditDeviceResponse> poideletewebservice(
    String token,
    int vendorid,
    int branchid,
    int srno,
  ) async {
    var deleteresponse =
        "https://vtsgpsapi.m-techinnovations.com/api/PointOfInterestCreate/${vendorid}/${branchid}/${srno}";
    final response = await http.delete(
      Uri.parse(deleteresponse),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return EditDeviceResponse.fromJson(jsonDecode(response.body));
  }

  //! RouteDefine by Geofence----------------
  Future<RouteNameList> routedefinelist(
    String token,
    int vendorId,
    int branchid,
  ) async {
    var routenamelist =
        "https://vtsgpsapi.m-techinnovations.com/api/RouteDefine/FillRoute?VendorId=1&BranchId=1";
    final response =
        await http.get(Uri.parse(routenamelist), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print("Successfully getting your data route data");
      var jsonbody = jsonDecode(response.body) as List<dynamic>;
      var searchtextresponce = RouteNameList.fromJson(jsonbody);

      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  //! vehicle history---------------->
  Future<GetVehSpeedResponse> getvehspeedDetail(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String vehicleStatusList,
    String vehicleList,
    int pagenumber,
    int pagesize,
  ) async {
    String speedurl = Constant.speedurl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&VehicleStatusList=" +
        "$vehicleStatusList" +
        "&VehicleList=" +
        "$vehicleList" +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    print("Speed URL is---------------$speedurl");
    final response = await http.get(
      Uri.parse(speedurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print("Respnse body of speed details is----------${response.body}");
    var jsonBody = GetVehSpeedResponse.fromJson(json.decode(response.body));
    print(
        "json responce body of speed details is----------${jsonBody.data!.length}");
    return jsonBody;
  }

  //!Get Geofence------------------------->
  Future<RoutesDetailByRouteName> routesdetailbyname(
    String token,
    int vendorId,
    int branchid,
    String routename,
  ) async {
    print(Constant.routesdetailbyname +
        "/" +
        vendorId.toString() +
        "/" +
        branchid.toString() +
        "/" +
        routename.toString());
    var routenamelist = Constant.routesdetailbyname +
        "/" +
        vendorId.toString() +
        "/" +
        branchid.toString() +
        "/" +
        routename.toString();

    // var routenamelist =
    //     "https://vtsgpsapi.m-techinnovations.com/api/RouteDefine/GetRoutesDetailsByRouteName/1/1/h";
    final response =
        await http.get(Uri.parse(routenamelist), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      print("Successfully getting your data route detail data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var searchtextresponce = RoutesDetailByRouteName.fromJson(jsonbody);

      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  // Driver master report filter
  Future<DriverMasterFilter> drivermasterfilter(
    String token,
    int vendorId,
    int branchid,
    String drivercode,
    int pagenumber,
    int pagesize,
  ) async {
    var drivermasterurl = Constant.drivermasterfilterurl +
        "?VendorId=" +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&DriverCode=" +
        drivercode.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var drivermasterurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/DriverMasterReports/FilterApplyDriverReport?VendorId=1&BranchId=1&DriverCode=DC0214&PageNumber=1&PageSize=10";

    print("This is drivermaster filter url " + drivermasterurl);

    final response =
        await http.get(Uri.parse(drivermasterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
    print("Successfully getting your data");
    var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

    var ddevicemasterjson = DriverMasterFilter.fromJson(jsonbody);
    print("Json decoded body_" + drivermasterurl.toString());
    return ddevicemasterjson;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

//
  //Start Search Element in Vehicle Report- API----
  Future<SearchDriverMasterRpt> searchtextdriverRpt(String token, int vendorId,
      String searchText, int branchId, int pageNumber, int pageSize) async {
    String searchdmdataurl = Constant.searchdrivermasterurl +
        vendorId.toString() +
        "&BranchId=1" +
        // branchId.toString() +
        "&SearchText=" +
        searchText +
        "&PageNumber=1" +
        // pageNumber.toString() +
        "&PageSize=10";
    // pageSize.toString();
    // String searchdmdataurl ='https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/SearchDeviceMasterReport?
    // VendorId=1&BranchId=1&SearchText=AIS&PageNumber=1&PageSize=8';
    //vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/
    // SearchDriverVehicleAssign?VendorId=1&BranchId=1&SearchText=as&PageNumber=1&PageSize=10

    final response = await http.get(
      Uri.parse(searchdmdataurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody = SearchDriverMasterRpt.fromJson(json.decode(response.body));
    print("JSon  assign body are:-------------$jsonBody");
    return jsonBody;
  }
  //End..

  //Frame packet

  Future<FramePacketData> getframepacketreport(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    int imeno,
    String frampacketoption,
    int pagenumber,
    int pagesize,
  ) async {
    var framepacketurl = Constant.FramePacketReportUrl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&IMEINO=" +
        imeno.toString() +
        "&FramePacketOption=" +
        frampacketoption.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var framepacketurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/FramePacketReport/GetFramepacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12:30&ToDate=30-sep-2022&ToTime=18:30&IMEINO=867322033819244&FramePacketOption=datapacket&PageNumber=1&PageSize=10";

    print("this is frame paket url " + framepacketurl);

    final response =
        await http.get(Uri.parse(framepacketurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var framepacketurljson = FramePacketData.fromJson(jsonbody);
      print("Json decoded body_" + framepacketurl.toString());
      return framepacketurljson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

// Frame packet grid ------------------------
  Future<FramePacketGridModel> framepacketgrid(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    String vehicleList,
    String frampacketoption,
    int pagenumber,
    int pagesize,
  ) async {
    var framepacketgridurl = Constant.FramePacketGridUrl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&VehicleList=" +
        vehicleList.toString() +
        "&FramePacketOption=" +
        frampacketoption.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // var framepacketgridurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/FramePacketGridviewReport/FilterFramePacketGridViewReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=10:20&ToDate=30-sep-2022&ToTime=19:30&VehicleList=86,76&FramePacketOption=healthpacket&PageNumber=1&PageSize=10";

    print("this is frame paket grid url " + framepacketgridurl);

    final response =
        await http.get(Uri.parse(framepacketgridurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var framepacketgridurl = FramePacketGridModel.fromJson(jsonbody);
      print("Json decoded body_" + framepacketgridurl.toString());
      return framepacketgridurl;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

// Driver Master Report API ------

  Future<DriverMasterReport> drivermaster(
    String token,
    int vendorid,
    int branchid,
    int pageSize,
    int pageNumber,
  ) async {
    var drivermasterreportyurl = Constant.drivermasterurl +
        "?VendorId=" +
        vendorid.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&PageNumber=" +
        pageNumber.toString() +
        "&PageSize=" +
        pageSize.toString();

    print("This is driver master report url " + drivermasterreportyurl);

    // var drivermasterreportyurl =
    //     "https://vtsgpsapi.m-techinnovations.com/api/DriverMasterReports/DriverMasterReport?VendorId=1&BranchId=1&PageNumber=1&PageSize=10";

    print("This is date wise travel history url " + drivermasterreportyurl);

    final response = await http
        .get(Uri.parse(drivermasterreportyurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    // if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var drivermasterreporturl = DriverMasterReport.fromJson(jsonbody);
      print("Json decoded body_" + drivermasterreporturl.toString());
      return drivermasterreporturl;
    // } else {
    //   print(response.body);
    //   throw Exception('Failed to load data');
    // }
  }

  Future<VTSHistorySpeedParameter> getvehhistoryspeed(
    String token,
    int vendorId,
    int branchid,
    String arai,
    String imei,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
  
    int pagenumber,
    int pagesize,
  ) async {
    String speedurl = Constant.vtshistoryspeedparameter +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        arai.toString() +
        "&IMEINO="+
        imei.toString()+
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    print("Speed URL is---------------$speedurl");
    final response = await http.get(
      Uri.parse(speedurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );
    print("Respnse body of speed details is----------${response.body}");
    var jsonBody = VTSHistorySpeedParameter.fromJson(json.decode(response.body));
    print(
        "json responce body of speed details is----------${jsonBody.details!.data!.length}");
    return jsonBody;
  }
  

//Start Get Vehicle Report API----
  Future<VehicleReportDetails> getvehicledetailReport(String token,
      int vendorId, int branchId, int pageNumber, int pageSize) async {
    print("Enter in api----");
    String allvehicledetailurl = Constant.getVehcleReportUrl +
        vendorId.toString() +
        "&Branchid=" +
        branchId.toString() +
        "&pageNumber=" +
        pageNumber.toString() +
        "&pageSize=" +
        pageSize.toString();

    // String allvehicledetailurl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/VehicleMasterReports/GetVehicleReport?VendorId=1&BranchId=1&PageNumber=1&PageSize=5';
    print("uri is------------" + allvehicledetailurl);
    final response = await http.get(
      Uri.parse(allvehicledetailurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    print(response.body);
    var jsonBody = VehicleReportDetails.fromJson(json.decode(response.body));

    return jsonBody;
  }

//End of API

//
//Start Search Element in Vehicle Report- API----
  Future<SearchingVehicleDetailsReportData> findStringInvehicledetailReport(
      String token,
      int vendorId,
      String searchText,
      int branchId,
      int pageNumber,
      int pageSize) async {
    print("Enter in future api----");
    String searchvehicledetailurl = Constant.searchVehicleReporturl +
        // vendorId.toString() +
        "1&Branchid=1" +
        // branchId.toString() +
        "&SearchText=" +
        searchText +
        "&pageNumber=1" +
        // pageNumber.toString() +
        "&pageSize=10";
    // pageSize.toString();

    // String searchvehicledetailurl = 'https://vtsgpsapi.m-techinnovations.com/api/VehicleMasterReports/SearchVehicleReport?VendorId=1&BranchId=1&SearchText=MH12&PageNumber=1&PageSize=10';
    print("uri is------------" + searchvehicledetailurl);
    final response = await http.get(
      Uri.parse(searchvehicledetailurl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    print(response.body);
    var jsonBody =
        SearchingVehicleDetailsReportData.fromJson(json.decode(response.body));
    print("JSon body are:-------------$jsonBody");
    return jsonBody;
  }

//End API

  ///Start fetch Element in Device master Report- API----
  Future<DeviceMasterModel> devicemasterreport(String token, int vendorId,
      int branchId, int pageNumber, int pageSize) async {
    print("Enter in future api----");
    String devicemasterurl = Constant.devicemasterreporturl +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&pageNumber=" +
        pageNumber.toString() +
        "&pageSize=" +
        pageSize.toString();

    // String urlString =
    //     'https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/DeviceMasterReport?VendorId=1&BranchId=1&PageNumber=1&PageSize=4';
    print("device master report url is------------" + devicemasterurl);
    final response = await http.get(
      Uri.parse(devicemasterurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    print(response.body);
    var jsonBody = DeviceMasterModel.fromJson(json.decode(response.body));
    print("JSon body are:-------------$jsonBody");
    return jsonBody;
  }

//End API

//End API

  Future<VehicleStatusGroupModel> vehicleStatusGroup(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    int imeno,
    int pagenumber,
    int pagesize,
  ) async {
    String vehiclestatusurl = Constant.vehiclestatusgroupurl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&IMEINO=" +
        imeno.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is vehicle status report url " + vehiclestatusurl);
    // String vehiclestatusurl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/GetVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=08:30&ToDate=30-sep-2022&ToTime=18:30&IMEINO=867322033819244&PageNumber=1&PageSize=10';

    final response = await http.get(
      Uri.parse(vehiclestatusurl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody = VehicleStatusGroupModel.fromJson(json.decode(response.body));
    print("JSon  dm body are:-------------$jsonBody");
    return jsonBody;
  }

  //Vehicle Status Report

  Future<VehicleStatusReportModel> vehicleStatusReport(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    int imeno,
    int pagenumber,
    int pagesize,
  ) async {
    String vehiclestatusreporturl = Constant.vehiclestatusreporturl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&IMEINO=" +
        imeno.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    print("This is vehicle status report url " + vehiclestatusreporturl);

    // String vehiclestatusreporturl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/GetVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=08:30&ToDate=30-sep-2022&ToTime=18:30&IMEINO=867322033819244&PageNumber=1&PageSize=10';

    final response = await http
        .get(Uri.parse(vehiclestatusreporturl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var travelsummaryjson = VehicleStatusReportModel.fromJson(jsonbody);
      print("Json decoded body_" + travelsummaryjson.toString());
      return travelsummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

//  Vehicle status summary
  Future<VehicleStatusSummaryModel> vehicleStatusSummary(
    String token,
    int vendorId,
    int branchid,
    String araino,
    String fromdate,
    String fromTime,
    String toDate,
    String toTime,
    int imeno,
    int pagenumber,
    int pagesize,
  ) async {
    String vehiclestatussummaryurl = Constant.vehiclestatussummaryurl +
        vendorId.toString() +
        "&BranchId=" +
        branchid.toString() +
        "&ARAI_NONARAI=" +
        araino.toString() +
        "&FromDate=" +
        fromdate.toString() +
        "&FromTime" +
        fromTime.toString() +
        "&ToDate=" +
        toDate.toString() +
        "&ToTime=" +
        toTime.toString() +
        "&IMEINO=" +
        imeno.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();

    // String vehiclestatussummaryurl =
    //     'https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusSummaryReport/GetVehicleStatusSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12:30&ToDate=30-sep-2022&ToTime=19:30&IMEINO=867322033819244&PageNumber=1&PageSize=10';

    print("This is vehicle status summary url " + vehiclestatussummaryurl);
    final response = await http
        .get(Uri.parse(vehiclestatussummaryurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var travelsummaryjson = VehicleStatusSummaryModel.fromJson(jsonbody);
      print("Json decoded body_" + travelsummaryjson.toString());
      return travelsummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  Future<SearchVehOverSpeedRpt> searchOverSpeedCreateDetails(
      String token,
      String vehicleRegNo,
      int imeino,
      int latitude,
      int longitude,
      String address,
      int transDate,
      int transTime,
      int speed,
      int overSpeed,
      int updatedOn,
      int distancetravel,
      int speedLimit,
      String searchText) async {
    print(Constant.searchOverSpeedReportUrl +
        "" +
        vehicleRegNo.toString() +
        "/" +
        imeino.toString() +
        "/" +
        latitude.toString() +
        "/" +
        longitude.toString() +
        "/" +
        address.toString() +
        "/" +
        transDate.toString() +
        "/" +
        transTime.toString() +
        "/" +
        speed.toString() +
        "/" +
        overSpeed.toString() +
        "/" +
        updatedOn.toString() +
        "/" +
        distancetravel.toString() +
        "/" +
        speedLimit.toString() +
        "/" +
        searchText);

    //required this.vehicleRegNo,required this.imeino,required this.latitude,required this.longitude,required this.address,required this.transDate,
    //     required this.transTime,required this.speed,required this.overSpeed,required this.updatedOn,required this.distancetravel,required this.speedLimit,required this.searchText
    final response = await http.get(
      Uri.parse(Constant.searchOverSpeedReportUrl +
          "" +
          vehicleRegNo.toString() +
          "/" +
          imeino.toString() +
          "/" +
          latitude.toString() +
          "/" +
          longitude.toString() +
          "/" +
          address.toString() +
          "/" +
          transDate.toString() +
          "/" +
          transTime.toString() +
          "/" +
          speed.toString() +
          "/" +
          overSpeed.toString() +
          "/" +
          updatedOn.toString() +
          "/" +
          distancetravel.toString() +
          "/" +
          speedLimit.toString() +
          "/" +
          searchText),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    return SearchVehOverSpeedRpt.fromJson(jsonDecode(response.body));
  }
}
