import 'dart:convert';
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
import 'package:flutter_vts/model/login/check_forget_password_user_response.dart';
import 'package:flutter_vts/model/login/forget_password_request.dart';
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
import 'package:flutter_vts/screen/distance_summary/distance_summary_screen.dart';
import 'package:flutter_vts/screen/live_tracking_screen.dart';
import 'package:flutter_vts/screen/master/vendor_master/vendor_name_response.dart';
import 'package:flutter_vts/screen/profile/profile_detail/profile_detail_screen.dart';
import 'package:flutter_vts/screen/travel_summary/travel_summary_screen.dart';
import 'package:flutter_vts/util/constant.dart';
import 'package:http/http.dart' as http;
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
import '../model/report/frame_packet_report_response.dart';
import '../model/report/over_speed_report_response.dart';

import '../model/report/search_frame_packet_report_response.dart';
import '../model/report/search_overspeed_response.dart';
import '../model/report/vehicle_status_filter_report.dart';
import '../model/report/vehicle_status_report.dart';
import '../model/travel_summary/travel_summary.dart';

class WebService {
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
    print(Constant.dashboardUrl +
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
        PageSize.toString());

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
    print(response.body);
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
    print(Constant.getVehicleHistoryDetail +
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
        pageSize.toString());

    final response = await http.get(
      Uri.parse(Constant.getVehicleHistoryDetail +
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
          pageSize.toString()),
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
          "arai"),
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
    var getlivetracking = Constant.getLiveTrackingUrl +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&TrackingStatus=" +
        trackingStatus.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString();
    print("Webservice Url is here-------------->" + getlivetracking.toString());
    final response = await http.get(
      Uri.parse(getlivetracking),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
   
      
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var livetrackingresponse = LiveTrackingResponse.fromJson(jsonbody);
      print("Json decoded body_ MAP-------" + response.body.toString());
      return livetrackingresponse;
  
  }

  Future<List<LiveTrackingByIdResponse>> getlivetrackingById(String token,
      int vendorId, int branchId, String araiNonarai, int transId) async {
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
    print("Your Google map data is printed");
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

  Future<List<StartLocationResponse>> getStartLocationImei(String token,
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
    print(response.body);
    return startLocationResponseFromJson(response.body);
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

  Future<List<StartLocationResponse>> getnextLocationImei(String token,
      int vendorId, int branchId, String araiNonarai, String imeino) async {
    print(Constant.getNextLocationImeiUrl +
        "" +
        vendorId.toString() +
        "&BranchId=" +
        branchId.toString() +
        "&ARAI_NONARAI=" +
        araiNonarai.toString() +
        "&IMEINO=" +
        imeino.toString());

    final response = await http.get(
      Uri.parse(Constant.getNextLocationImeiUrl +
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
    print(response.body);
    return startLocationResponseFromJson(response.body);
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
    //var travelurl =
    //  "https://vtsgpsapi.m-techinnovations.com/api/TravelSummaryReport/GetTravelSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=06:30&ToDate=30-sep-2022&ToTime=18:00&IMEINO=867322033819244&PageNumber=1&PageSize=10";
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
    int pagenumber,
    int pagesize,
    String arinonarai,
    String fromdate,
    String fromtime,
    String searchtext,
    String totime,
    String todate,
  ) async {
    var travelsearchurl = Constant.travelSummarySearch +
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
        searchtext.toString() +
        "&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    //var travelsearchurl =
    //  "https://vtsgpsapi.m-techinnovations.com/api/TravelSummaryReport/SearchTravelSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=10:30&ToDate=30-sep-2022&ToTime=15:30&SearchText=MH12&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(travelsearchurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });

    return TravelSummarySearch.fromJson(jsonDecode(response.body));
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
    print(Constant.travelSummaryFilter +
        "?VendorID=1&BranchId=1&ARAI_NONARAI=arai&" +
        "FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&VehicleList=86,76&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=10");
    var travelfilterurl = Constant.travelSummaryFilter +
        "?VendorID=1&BranchId=1&ARAI_NONARAI=arai&" +
        "FromDate=" +
        fromdate.toString() +
        "&FromTime=" +
        fromtime.toString() +
        "&ToDate=" +
        todate.toString() +
        "&ToTime=" +
        totime.toString() +
        "&VehicleList=86,76&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=10";
    // var travelfilterurl =
    //   "https://vtsgpsapi.m-techinnovations.com/api/TravelSummaryReport/FilterTravelSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=02-sep-2022&FromTime=13:30&ToDate=30-sep-2022&ToTime=19:30&VehicleList=86,76&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(travelfilterurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data 3" + response.body);
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var travelsummaryjson = TravelSummaryFilter.fromJson(jsonbody);
      print("Json decoded body3_" + travelsummaryjson.toString());
      return travelsummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
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

  //! Filter(Weeks,Months,today..........) Distance Summary Screen---------------------------
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

  //! Search Distance Summary Screen---------------------------
  Future<DistanceSummarySearch> distancesummarysearch(
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
    //  var distanceurl = Constant.DistanceSummaryReport +
    //       "?VendorId=" +
    //       vendorid.toString() +
    //       "&BranchId=" +
    //       branchid.toString() +
    //       "&ARAI_NONARAI=arai&FromDate=" +
    //       fromdate.toString() +
    //       "&FromTime=" +
    //       fromtime.toString() +
    //       "&ToDate=" +
    //       todate.toString() +
    //       "&ToTime=" +
    //       totime.toString() +
    //       "&IMEINO=867322033819244&PageNumber=" +
    //       pagenumber.toString() +
    //       "&PageSize=" +
    //       pagesize.toString();
    var distanceurl =
        "https://vtsgpsapi.m-techinnovations.com/api/DistanceTravelSummary/SearchDistanceTravelSummaryReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12:30&ToDate=30-sep-2022&ToTime=15:30&SearchText=MH12&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(distanceurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;

      var distancesummaryjson = DistanceSummarySearch.fromJson(jsonbody);
      print("Json decoded body_" + distancesummaryjson.toString());
      return distancesummaryjson;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }
  // !-------------  API for Create Point of variable  ----------//

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

//! Overspeed Data Fetching-----------------------------------
  Future<GetOverspeedReportResponse> getOverSpeedReport(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdata,
    String fromtime,
    String todate,
    int pagesize,
    int pagenumber,
  ) async {
    var getreporturi =
        "https://vtsgpsapi.m-techinnovations.com/api/VehicleWiseOverSpeedReport/GetOverSpeedReport?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&FromDate=01-sep-2022&ToDate=30-sep-2022&IMEINO=862430050555255&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(getreporturi), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var searchtextresponce = GetOverspeedReportResponse.fromJson(jsonbody);
      print("Json decoded body_" + searchtextresponce.toString());
      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  //! Overspeed Search Data Fetching-----------------------------------
  Future<search_overspeed_response> searchOverSpeedCreateDetails(
    String token,
    int vendorid,
    int branchid,
    String arainonarai,
    String fromdata,
    String fromtime,
    String todate,
    int pagesize,
    int pagenumber,
    String searchText,
  ) async {
    var overspeedsearch =
        "https://vtsgpsapi.m-techinnovations.com/api/VehicleWiseOverSpeedReport/SearchOverSpeedReport?VendorId=1&BranchId=1&ARAI_NONARAI=nonarai&FromDate=01-sep-2022&ToDate=30-sep-2022&SearchText=MH12AB0015&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(overspeedsearch), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var searchtextresponce = search_overspeed_response.fromJson(jsonbody);
      print("Json decoded body_" + searchtextresponce.toString());
      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

//! Device Master Filter---------------------------------
  Future<DeviceMasterFilterModel> devicemasterwebfilter(
    String token,
    String vendorid,
    String branchid,
    String deviceno,
    int pagenumber,
    int pagesize,
  ) async {
    var overspeedsearch =
        "https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/FilterApplyDeviceReport?VendorId=1&BranchId=1&DeviceNo=DC00001&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(overspeedsearch), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var searchtextresponce = DeviceMasterFilterModel.fromJson(jsonbody);
      print("Json decoded body_" + searchtextresponce.toString());
      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  //!---------------------------------------
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
    // print(
    //     "${searchStrClass.searchStr}-----Enter in SEARCH dm future api ----$searchText");
    // String vehiclestatusurl = Constant.vehiclestatusgroupurl +
    //     vendorId.toString() +
    //     "&BranchId=1" +
    //     branchId.toString() +
    //     "&SearchText=" +
    //     searchText +
    //     "&PageNumber=1" +
    //     // pageNumber.toString() +
    //     "&PageSize=10";
    // // pageSize.toString();

    String vehiclestatusreporturl =
        'https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusGroupByReport/GetVehicleStatusGroupByReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=08:30&ToDate=30-sep-2022&ToTime=18:30&IMEINO=867322033819244&PageNumber=1&PageSize=10';

    final response = await http.get(
      Uri.parse(vehiclestatusreporturl),
      headers: <String, String>{
        // 'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': "Bearer ${token}",
      },
    );

    var jsonBody =
        VehicleStatusReportModel.fromJson(json.decode(response.body));
    print("JSon  dm body are:-------------$jsonBody");
    return jsonBody;
  }

  //!--------------------------------
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
        "&VehicleList=86,76&PageNumber=" +
        pagenumber.toString() +
        "&PageSize=" +
        pagesize.toString();
    // var overspeedsearch =
    //     "https://vtsgpsapi.m-techinnovations.com/api/VehicleStatusReport/FilterVehicleStatusReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=10:30&ToDate=20-sep-2022&ToTime=18:30&VehicleList=86,76&PageNumber=1&PageSize=10";
    final response =
        await http.get(Uri.parse(travelurl), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      print("Successfully getting your data");
      var jsonbody = jsonDecode(response.body) as Map<String, dynamic>;
      var searchtextresponce = VehicleStatusReportFilter.fromJson(jsonbody);
      print("Json decoded body_" + searchtextresponce.toString());
      return searchtextresponce;
    } else {
      print(response.body);
      throw Exception('Failed to load data');
    }
  }

  //! RouteDefine----------------
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

  //!-------------------------
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
}

Future<frame_packet_response> getframepacketreport(
    int vendorId,
    int branchid,
    String optionClicked,
    String aRAI_NONARAI,
    String username,
    int PageNumber,
    int PageSize,
    String token) async {
  print(Constant.getFramePacketReportVendorUrl +
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
      PageSize.toString());

  final response = await http.get(
    Uri.parse(Constant.getFramePacketReportVendorUrl +
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
  print(response.body);
  return frame_packet_response.fromJson(jsonDecode(response.body));
}

Future<search_frame_packet_report_response> searchFramePacketDetails(
    String token, int vendorId, int branchId, String searchText) async {
  print(Constant.getFramePacketReportSearchUrl +
      "" +
      vendorId.toString() +
      "/" +
      branchId.toString() +
      "/" +
      searchText);

  final response = await http.get(
    Uri.parse(Constant.getFramePacketReportSearchUrl +
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
  return search_frame_packet_report_response
      .fromJson(jsonDecode(response.body));
}
