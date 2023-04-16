import 'dart:math';

import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/model/report/frame_packet_report_response.dart';
import 'package:flutter_vts/service/web_service.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  WebService webService;

  MainBloc({required this.webService}) : super(MainInitialState());

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    {
      if (event is LoginEvents) {
        try {
          yield LoginLoadingState();
          var loginresponse =
              await webService.userLogin(event.username, event.password);
          yield LoginLoadedState(loginResponse: loginresponse);
        } catch (e) {
          print(e.toString());
          yield LoginErrorState(msg: e.toString());
        }
      } else if (event is UpdateLoginEvents) {
        try {
          yield UpdateLoginLoadingState();
          var loginresponse = await webService.updateLogin(
              event.menuCaption,
              event.vendorSrNo,
              event.branchSrNo,
              event.userId,
              event.sessionId,
              event.token);
          yield UpdateLoginLoadedState(loginResponse: loginresponse);
        } catch (e) {
          print(e.toString());
          yield UpdateLoginErrorState(msg: e.toString());
        }
      } else if (event is CheckForgetPasswordUserEvents) {
        try {
          yield CheckForgetPasswordUserLoadingState();
          var checkForgetPasswordUserResponse =
              await webService.checkUser(event.searchEmaitId, event.token);
          yield CheckForgetPasswordUserLoadedState(
              checkForgetPasswordUserResponse: checkForgetPasswordUserResponse);
        } catch (e) {
          print(e.toString());
          yield CheckForgetPasswordUserErrorState(msg: e.toString());
        }
      } else if (event is ForgetPasswordEvents) {
        try {
          yield ForgetPasswordLoadingState();
          var editDeviceResponse = await webService.forgetPassword(
              event.forgetPasswordRequest, event.token);
          yield ForgetPasswordLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield ForgetPasswordErrorState(msg: e.toString());
        }
      } else if (event is ForgetPasswordEvents) {
        try {
          yield ForgetPasswordLoadingState();
          var editDeviceResponse = await webService.forgetPassword(
              event.forgetPasswordRequest, event.token);
          yield ForgetPasswordLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield ForgetPasswordErrorState(msg: e.toString());
        }
      } else if (event is DashboradEvents) {
        try {
          yield DashbordLoadingState();
          var dashbordResponse = await webService.getdashboard(
              event.vendorId,
              event.branchId,
              event.optionClicked,
              event.aRAI_NONARAI,
              event.username,
              event.pageNumber,
              event.pageSize,
              event.token);
          yield DashbordLoadedState(dashbordResponse: dashbordResponse);
        } catch (e) {
          print(e.toString());
          yield DashbordErrorState(msg: e.toString());
        }
      } else if (event is ResetPasswordEvents) {
        try {
          yield ResetPasswordLoadingState();
          var editDeviceResponse = await webService.resetPassword(
              event.resetPasswordRequest, event.token);
          yield ResetPasswordLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield ResetPasswordErrorState(msg: e.toString());
        }
      } else if (event is ProfileDetailsEvents) {
        try {
          yield GetProfileDetailsLoadingState();
          var getProfileResponse = await webService.getProfileDetails(
              event.vendorId, event.branchId, event.profileid, event.token);
          yield GetProfileDetailsLoadedState(
              getProfileResponse: getProfileResponse);
        } catch (e) {
          print(e.toString());
          yield GetProfileDetailsErrorState(msg: e.toString());
        }
      } else if (event is UpdateProfileEvents) {
        try {
          yield UpdateProfileLoadingState();
          var editDeviceResponse = await webService.updateProfile(
              event.userId, event.profileUpdateRequest, event.token);
          yield UpdateProfileLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield UpdateProfileErrorState(msg: e.toString());
        }
      } else if (event is AllVehicleDetailEvents) {
        try {
          yield AllVehicleDetailLoadingState();
          var allVehicleDetailResponse = await webService.getallvehicledetail(
              event.vendorId,
              event.branchId,
              event.pageNumber,
              event.pageSize,
              event.token);
          yield AllVehicleDetailLoadedState(
              allVehicleDetailResponse: allVehicleDetailResponse);
        } catch (e) {
          print(e.toString());
          yield AllVehicleDetailErrorState(msg: e.toString());
        }
      } else if (event is SearchVehicleEvents) {
        try {
          yield SearchVehicleDetailLoadingState();
          var searchVehicleResponse = await webService.searchvehicle(
              event.vendorId, event.branchId, event.searchText, event.token);
          yield SearchVehicleDetailLoadedState(
              searchVehicleResponse: searchVehicleResponse);
        } catch (e) {
          print(e.toString());
          yield SearchVehicleDetailErrorState(msg: e.toString());
        }
      } else if (event is AddVehicleEvents) {
        try {
          yield AddVehicleLoadingState();
          var addVehicleResponse = await webService.addnewvehicle(
              event.addVehicleRequest, event.token);
          yield AddVehicleLoadedState(addVehicleResponse: addVehicleResponse);
        } catch (e) {
          print(e.toString());
          yield AddVehicleErrorState(msg: e.toString());
        }
      } else if (event is EditVehicleEvents) {
        try {
          yield EditVehicleLoadingState();
          var editDeviceResponse = await webService.editvehicle(
              event.editVehicleRequest, event.vehicleid, event.token);
          yield EditVehicleLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield EditVehicleErrorState(msg: e.toString());
        }
      } else if (event is AllVendorDetailEvents) {
        try {
          yield AllVendorDetailLoadingState();
          var allVendorDetailResponse = await webService.getallvendor(
              event.pageNumber, event.pageSize, event.token);
          yield AllVendorDetailLoadedState(
              allVendorDetailResponse: allVendorDetailResponse);
        } catch (e) {
          print(e.toString());
          yield AllVendorDetailErrorState(msg: e.toString());
        }
      } else if (event is SearchVendorEvents) {
        try {
          yield SearchVendorLoadingState();
          var searchVendorResponse =
              await webService.searchVendor(event.searchText, event.token);
          yield SearchVendorLoadedState(
              searchVendorResponse: searchVendorResponse);
        } catch (e) {
          print(e.toString());
          yield SearchVendorErrorState(msg: e.toString());
        }
      } else if (event is AddVendorEvents) {
        try {
          yield AddVendorLoadingState();
          var addNewVendorResponse = await webService.addnewvendor(
              event.addNewVendorRequest, event.token);
          yield AddVendorLoadedState(
              addNewVendorResponse: addNewVendorResponse);
        } catch (e) {
          print(e.toString());
          yield AddVendorErrorState(msg: e.toString());
        }
      } else if (event is EditVendorEvents) {
        try {
          yield EditVendorLoadingState();
          var editVendorResponse = await webService.editvendor(
              event.editVendorRequest, event.vendorid, event.token);
          yield EditVendorLoadedState(editVendorResponse: editVendorResponse);
        } catch (e) {
          print(e.toString());
          yield EditVendorErrorState(msg: e.toString());
        }
      } else if (event is AllDeviceEvents) {
        try {
          yield AllDeviceLoadingState();
          var allDeviceResponse = await webService.getalldevice(event.vendorId,
              event.branchId, event.pageNumber, event.pageSize, event.token);
          yield AllDeviceLoadedState(allDeviceResponse: allDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield AllDeviceErrorState(msg: e.toString());
        }
      } else if (event is AddDeviceEvents) {
        try {
          yield AddDeviceLoadingState();
          var addDeviceResponse = await webService.addnewdevice(
              event.adddeviceRequest, event.token);
          yield AddDeviceLoadedState(addDeviceResponse: addDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield AddDeviceErrorState(msg: e.toString());
        }
      } else if (event is SearchDeviceEvents) {
        try {
          yield SearchDeviceLoadingState();
          var searchDeviceResponse = await webService.searchdevice(
              event.vendorId, event.branchId, event.searchText, event.token);
          yield SearchDeviceLoadedState(
              searchDeviceResponse: searchDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield SearchDeviceErrorState(msg: e.toString());
        }
      } else if (event is EditDeviceEvents) {
        try {
          yield EditDeviceLoadingState();
          var editDeviceResponse = await webService.editDevice(
              event.adddeviceRequest, event.deviceId, event.token);
          yield EditDeviceLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield EditDeviceErrorState(msg: e.toString());
        }
      } else if (event is AllVendorNamesEvents) {
        try {
          yield AllVendorNamesLoadingState();
          var vendorNameResponse = await webService.getvendorname(event.token);
          yield AllVendorNamesLoadedState(
              vendorNameResponse: vendorNameResponse);
        } catch (e) {
          print(e.toString());
          yield AllVendorNamesErrorState(msg: e.toString());
        }
      } else if (event is AllBranchNamesEvents) {
        try {
          yield AllBranchNamesLoadingState();
          var branchnameresponse =
              await webService.getbranchname(event.token, event.branchid);
          yield AllBranchNamesLoadedState(
              branchnameresponse: branchnameresponse);
        } catch (e) {
          print(e.toString());
          yield AllBranchNamesErrorState(msg: e.toString());
        }
      } else if (event is EditVendorEvents) {
        try {
          yield EditVendorLoadingState();
          var editVendorResponse = await webService.editvendor(
              event.editVendorRequest, event.vendorid, event.token);
          yield EditVendorLoadedState(editVendorResponse: editVendorResponse);
        } catch (e) {
          print(e.toString());
          yield EditVendorErrorState(msg: e.toString());
        }
      } else if (event is AllDriverEvents) {
        try {
          yield AllDriverLoadingState();
          var allDriverResponse = await webService.getalldriver(event.vendorId,
              event.branchId, event.pageNumber, event.pageSize, event.token);
          yield AllDriverLoadedState(allDriverResponse: allDriverResponse);
        } catch (e) {
          print(e.toString());
          yield AllDriverErrorState(msg: e.toString());
        }
      } else if (event is SearchDriverEvents) {
        try {
          yield SearchDriverLoadingState();
          var searchDriverResponse = await webService.searchdriver(
              event.vendorId, event.branchId, event.searchText, event.token);
          yield SearchDriverLoadedState(
              searchDriverResponse: searchDriverResponse);
        } catch (e) {
          print(e.toString());
          yield SearchDriverErrorState(msg: e.toString());
        }
      } else if (event is AddDriverEvents) {
        try {
          yield AddDriverLoadingState();
          var addDriverResponse = await webService.addnewdriver(
              event.addDriverRequest, event.token);
          yield AddDriverLoadedState(addDriverResponse: addDriverResponse);
        } catch (e) {
          print(e.toString());
          yield AddDriverErrorState(msg: e.toString());
        }
      } else if (event is EditDriverEvents) {
        try {
          yield EditDriverLoadingState();
          var editDeviceResponse = await webService.editdriver(
              event.addDriverRequest, event.srno, event.token);
          yield EditDriverLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield EditDriverErrorState(msg: e.toString());
        }
      } else if (event is AllSubscriptionEvents) {
        try {
          yield AllSubscriptionLoadingState();
          var subscriptionMasterRespose = await webService.getallsubscription(
              event.vendorid,
              event.branchid,
              event.pagesize,
              event.totalpage,
              event.token);
          yield AllSubscriptionLoadedState(
              subscriptionMasterRespose: subscriptionMasterRespose);
        } catch (e) {
          print(e.toString());
          yield AllSubscriptionErrorState(msg: e.toString());
        }
      } else if (event is SearchSubscriptionEvents) {
        try {
          yield SearchSubscriptionLoadingState();
          var searchSubscriptionResponse = await webService.searchsubscription(
              event.token, event.branchid, event.vendorid, event.searchtext);
          yield SearchSubscriptionLoadedState(
              searchSubscriptionResponse: searchSubscriptionResponse);
        } catch (e) {
          print(e.toString());
          yield SearchSubscriptionErrorState(msg: e.toString());
        }
      } else if (event is AddSubscriptionEvents) {
        try {
          yield AddSubscriptionLoadingState();
          var editDeviceResponse = await webService.addsubscription(
              event.addSubscriptionRequest, event.token);
          yield AddSubscriptionLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield AddSubscriptionErrorState(msg: e.toString());
        }
      } else if (event is UpdateSubscriptionEvents) {
        try {
          yield UpdateSubscriptionLoadingState();
          var editDeviceResponse = await webService.editSubscription(
              event.editSubscriptionRequest, event.subid, event.token);
          yield UpdateSubscriptionLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield UpdateSubscriptionErrorState(msg: e.toString());
        }
      } else if (event is AllBranchMasterEvents) {
        try {
          yield AllBranchMasterLoadingState();
          var allBranchMasterResponse = await webService.getallbranch(
              event.token, event.vendorId, event.pagenumber, event.pagesize);
          yield AllBranchMasterLoadedState(
              allBranchMasterResponse: allBranchMasterResponse);
        } catch (e) {
          print(e.toString());
          yield AllBranchMasterErrorState(msg: e.toString());
        }
      } else if (event is EditBranchEvents) {
        try {
          yield EditBranchLoadingState();
          var editDeviceResponse = await webService.editbranch(
              event.srno, event.vendorid, event.editBranchRequest, event.token);
          yield EditBranchLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield EditBranchErrorState(msg: e.toString());
        }
      } else if (event is SearchBranchEvents) {
        try {
          yield SearchBranchLoadingState();
          var searchDeviceResponse = await webService.searchBranch(
              event.vendorId, event.searchText, event.token);
          yield SearchBranchLoadedState(
              searchBranchResponse: searchDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield SearchBranchErrorState(msg: e.toString());
        }
      } else if (event is AddBranchEvents) {
        try {
          yield AddBranchLoadingState();
          var addBranchResponse = await webService.addnewbranch(
              event.addBranchRequest, event.token);
          yield AddBranchLoadedState(addBranchResponse: addBranchResponse);
        } catch (e) {
          print(e.toString());
          yield AddBranchErrorState(msg: e.toString());
        }
      } else if (event is AllAlertMasterEvents) {
        try {
          yield AllAlertLoadingState();
          var alertMasterResponse = await webService.getallalert(event.token,
              event.vendorId, event.branchId, event.pagenumber, event.pagesize);
          yield AllAlertLoadedState(alertMasterResponse: alertMasterResponse);
        } catch (e) {
          print(e.toString());
          yield AllAlertErrorState(msg: e.toString());
        }
      } else if (event is SearchAlertEvents) {
        try {
          yield SearchAlertLoadingState();
          var searchAlertMasterResponse = await webService.searchalert(
              event.vendorId, event.branchId, event.searchText, event.token);
          yield SearchAlertLoadedState(
              searchAlertMasterResponse: searchAlertMasterResponse);
        } catch (e) {
          print(e.toString());
          yield SearchAlertErrorState(msg: e.toString());
        }
      } else if (event is AddAlertEvents) {
        try {
          yield AddAlertLoadingState();
          var addAlertMasterResponse = await webService.addalert(
              event.addAlertMasterRequest, event.token);
          yield AddAlertLoadedState(
              addAlertMasterResponse: addAlertMasterResponse);
        } catch (e) {
          print(e.toString());
          yield AddAlertErrorState(msg: e.toString());
        }
      } else if (event is EditAlertEvents) {
        try {
          yield EditAlertLoadingState();
          var editDeviceResponse = await webService.editAlert(
              event.addAlertMasterRequest, event.alerttext, event.token);
          yield EditAlertLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield EditAlertErrorState(msg: e.toString());
        }
      } else if (event is AllCreateUserEvents) {
        try {
          yield AllCreatedUserLoadingState();
          var editDeviceResponse = await webService.getAllUser(event.vendorId,
              event.branchId, event.pagenumber, event.pagesize, event.token);
          yield AllCreatedUserLoadedState(
              getAllCreateUserResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield AllCreatedUserErrorState(msg: e.toString());
        }
      } else if (event is SearchCreateUserEvents) {
        try {
          yield SearchCreatedUserLoadingState();
          var searchCreatedUserResponse = await webService.searchAllUser(
              event.vendorId, event.branchId, event.searchText, event.token);
          yield SearchCreatedUserLoadedState(
              searchCreatedUserResponse: searchCreatedUserResponse);
        } catch (e) {
          print(e.toString());
          yield SearchCreatedUserErrorState(msg: e.toString());
        }
      } else if (event is AddUserEvents) {
        try {
          yield AddUserLoadingState();
          var addCreatedUserResponse =
              await webService.addUser(event.addUserRequest, event.token);
          yield AddUserLoadedState(
              addCreatedUserResponse: addCreatedUserResponse);
        } catch (e) {
          print(e.toString());
          yield AddUserErrorState(msg: e.toString());
        }
      } else if (event is EditUserEvents) {
        try {
          yield EditUserLoadingState();
          var editDeviceResponse = await webService.editUser(
              event.addUserRequest, event.userId, event.token);
          yield EditUserLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield EditUserErrorState(msg: e.toString());
        }
      } else if (event is SerialNumberEvents) {
        try {
          yield SerialNumberLoadingState();
          var serialNumberResponse =
              await webService.getserialnumber(event.token, event.apiName);
          yield SerialNumberLoadedState(
              serialNumberResponse: serialNumberResponse);
        } catch (e) {
          print(e.toString());
          yield SerialNumberErrorState(msg: e.toString());
        }
      } else if (event is AlertNotificationEvents) {
        try {
          yield AlertNotificationLoadingState();
          var alertNotificationResponse = await webService.getalertNotification(
              event.token,
              event.vendorId,
              event.branchId,
              event.arai,
              event.username,
              event.displayStatus,
              event.pagenumber,
              event.pagesize);
          yield AlertNotificationLoadedState(
              alertNotificationResponse: alertNotificationResponse);
        } catch (e) {
          print(e.toString());
          yield AlertNotificationErrorState(msg: e.toString());
        }
      } else if (event is SearchAlertNotificationEvents) {
        try {
          yield SearchAlertNotificationLoadingState();
          var searchAlertNotificationResponse =
              await webService.searchalertNotification(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.arai,
                  event.username,
                  event.displayStatus,
                  event.search,
                  event.pageNumber,
                  event.pageSize);
          yield SearchNotificationLoadedState(
              searchAlertNotificationResponse: searchAlertNotificationResponse);
        } catch (e) {
          print(e.toString());
          yield SearchNotificationErrorState(msg: e.toString());
        }
      } else if (event is DateWiseSearchAlertNotificationEvents) {
        try {
          yield DateWiseSearchAlertNotificationLoadingState();
          var dateWiseSearchAlertNotificationResponse =
              await webService.getdateWiseSearchalertNotification(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.arai,
                  event.username,
                  event.displayStatus,
                  event.fromDate,
                  event.formTime,
                  event.toDate,
                  event.toTime,
                  event.pageNumber,
                  event.pageSize);
          yield DateWiseSearchNotificationLoadedState(
              dateWiseSearchAlertNotificationResponse:
                  dateWiseSearchAlertNotificationResponse);
        } catch (e) {
          print(e.toString());
          yield DateWiseSearchNotificationErrorState(msg: e.toString());
        }
      } else if (event is AnalyticsReportsStatusEvents) {
        try {
          yield AnalyticsReportsStatusLoadingState();
          var analyticReportStatusClickResponse =
              await webService.getanalyticreportstatus(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.openClick,
                  event.araiNoarai,
                  event.username,
                  event.pageNumber,
                  event.pageSize);
          yield AnalyticsReportsStatusLoadedState(
              analyticReportStatusClickResponse:
                  analyticReportStatusClickResponse);
        } catch (e) {
          print(e.toString());
          yield AnalyticsReportsStatusErrorState(msg: e.toString());
        }
      } else if (event is SearchAnalyticsReportsStatusEvents) {
        try {
          yield SearchAnalyticsReportsStatusLoadingState();
          var searchAnalyticReportStatusClickResponse =
              await webService.searchanalyticreportstatus(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.openClick,
                  event.araiNoarai,
                  event.username,
                  event.vehicleNo);
          yield SearchAnalyticsReportsStatusLoadedState(
              searchAnalyticReportStatusClickResponse:
                  searchAnalyticReportStatusClickResponse);
        } catch (e) {
          print(e.toString());
          yield SearchAnalyticsReportsStatusErrorState(msg: e.toString());
        }
      } else if (event is AnalyticsReportsDetailsEvents) {
        try {
          yield AnalyticsReportsDetailsLoadingState();
          var analyticReportDetailsResponse =
              await webService.getanalyticreportdetails(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.openClick,
                  event.araiNoarai,
                  event.username,
                  event.vehiclesrno);
          yield AnalyticsReportsDetailsLoadedState(
              analyticReportDetailsResponse: analyticReportDetailsResponse);
        } catch (e) {
          print(e.toString());
          yield AnalyticsReportsDetailsErrorState(msg: e.toString());
        }
      } else if (event is FilteralertNotificationEvents) {
        try {
          yield FilteralertNotificationLoadingState();
          var filterAlertNotificationResponse =
              await webService.filteralertNotification(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNoarai,
                  event.username,
                  event.displayStatus,
                  event.vehiclesrNo,
                  event.alertCode,
                  event.pageNumber,
                  event.pageSize);
          yield FilteralertNotificationLoadedState(
              filterAlertNotificationResponse: filterAlertNotificationResponse);
        } catch (e) {
          print(e.toString());
          yield FilteralertNotificationErrorState(msg: e.toString());
        }
      } else if (event is SearchFilteralertNotificationEvents) {
        try {
          yield SearchFilteralertNotificationLoadingState();
          var filterAlertNotificationResponse =
              await webService.searchFilterAlertNotification(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNoarai,
                  event.username,
                  event.displayStatus,
                  event.vehiclesrNo,
                  event.alertCode,
                  event.searchText,
                  event.pageNumber,
                  event.pageSize);
          yield SearchFilteralertNotificationLoadedState(
              filterAlertNotificationResponse: filterAlertNotificationResponse);
        } catch (e) {
          print(e.toString());
          yield SearchFilteralertNotificationErrorState(msg: e.toString());
        }
      } else if (event is ClearAlertNotificationByIdEvents) {
        try {
          yield ClearAlertNotificationByIdLoadingState();
          var editDeviceResponse = await webService.clearAlertNotificationById(
              event.vendorId,
              event.branchId,
              event.araiNoarai,
              event.username,
              event.alertNotificatioID,
              event.token);
          yield ClearAlertNotificationByIdLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield ClearAlertNotificationByIdErrorState(msg: e.toString());
        }
      } else if (event is ClearAllAlertNotificationByIdEvents) {
        try {
          yield ClearAllAlertNotificationByIdLoadingState();
          var editDeviceResponse =
              await webService.clearallAlertNotificationById(
                  event.vendorId,
                  event.branchId,
                  event.araiNoarai,
                  event.username,
                  event.token);
          yield ClearAllAlertNotificationByIdLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield ClearAllAlertNotificationByIdErrorState(msg: e.toString());
        }
      } else if (event is VehicleSatusEvents) {
        try {
          yield VehicleStatusLoadingState();
          var vehicleStatusResponse = await webService.getVehicleStatus(
              event.token,
              event.vendorId,
              event.branchId,
              event.araiNoarai,
              event.fromDate,
              event.toDate,
              event.formTime,
              event.toTime,
              event.vehicleRegno,
              event.pageNumber,
              event.pageSize);
          yield VehicleStatusLoadedState(
              vehicleStatusResponse: vehicleStatusResponse);
        } catch (e) {
          print(e.toString());
          yield VehicleStatusErrorState(msg: e.toString());
        }
      } else if (event is VehicleHistoryFilterEvents) {
        try {
          yield VehicleHistoryFilterLoadingState();
          var vehicleHistoryFilterResponse =
              await webService.getVehicleHistoryFilter(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNoarai,
                  event.fromDate,
                  event.toDate,
                  event.formTime,
                  event.toTime,
                  event.vehicleStatusList,
                  event.vehicleList,
                  event.pageNumber,
                  event.pageSize);
          yield VehicleHistoryFilterLoadedState(
              vehicleHistoryFilterResponse: vehicleHistoryFilterResponse);
        } catch (e) {
          print(e.toString());
          yield VehicleHistoryFilterErrorState(msg: e.toString());
        }
      } else if (event is VehicleHistorySearchFilterEvents) {
        try {
          yield VehicleHistorySearchFilterLoadingState();
          var vehicleHistoryFilterResponse =
              await webService.getVehicleHistorysearchFilter(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNoarai,
                  event.fromDate,
                  event.toDate,
                  event.formTime,
                  event.toTime,
                  event.vehicleStatusList,
                  event.vehicleList,
                  event.searchText,
                  event.pageNumber,
                  event.pageSize);
          yield VehicleHistorySearchFilterLoadedState(
              vehicleHistoryFilterResponse: vehicleHistoryFilterResponse);
        } catch (e) {
          print(e.toString());
          yield VehicleHistorySearchFilterErrorState(msg: e.toString());
        }
      } else if (event is VehicleHistoryByIdDetailEvents) {
        try {
          yield VehicleHistoryByIdDetailLoadingState();
          var vehicleHistoryByIdDetailResponse =
              await webService.getVehiclehistroyById(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNoarai,
                  event.fromDate,
                  event.toDate,
                  event.formTime,
                  event.toTime,
                  event.vehicleHistoryId);
          yield VehicleHistoryByIdDetailLoadedState(
              vehicleHistoryByIdDetailResponse:
                  vehicleHistoryByIdDetailResponse);
        } catch (e) {
          print(e.toString());
          yield VehicleHistoryByIdDetailErrorState(msg: e.toString());
        }
      } else if (event is VehicleStatusWithCountEvents) {
        try {
          yield VehicleStatusWithCountLoadingState();
          var vehicleStatusWithCountResponse =
              await webService.getvehiclestatuswithcount(event.token,
                  event.vendorId, event.branchId, event.araiNonarai);
          yield VehicleStatusWithCountLoadedState(
              vehicleStatusWithCountResponse: vehicleStatusWithCountResponse);
        } catch (e) {
          print(e.toString());
          yield VehicleStatusWithCountErrorState(msg: e.toString());
        }
      } else if (event is LiveTrackingEvents) {
        try {
          yield LiveTrackingLoadingState();
          var liveTrackingResponse = await webService.getlivetracking(
              event.token,
              event.vendorId,
              event.branchId,
              event.TrackingStatus,
              event.araiNonarai);
          yield LiveTrackingLoadedState(
              liveTrackingResponse: liveTrackingResponse);
        } catch (e) {
          print(e.toString());
          yield LiveTrackingErrorState(msg: e.toString());
        }
      } else if (event is LiveTrackingByIdEvents) {
        try {
          yield LiveTrackingByIdLoadingState();
          var liveTrackingResponse = await webService.getlivetrackingById(
              event.token,
              event.vendorId,
              event.branchId,
              event.araiNonarai,
              event.transactionId);
          yield LiveTrackingByIdLoadedState(
              liveTrackingByIdResponse: liveTrackingResponse);
        } catch (e) {
          print(e.toString());
          yield LiveTrackingByIdErrorState(msg: e.toString());
        }
      } else if (event is StartLocationEvents) {
        try {
          yield StartLocationLoadingState();
          var startLocationResponse = await webService.getStartLocation(
              event.token, event.vendorId, event.branchId, event.araiNonarai);
          yield StartLocationLoadedState(
              startLocationResponse: startLocationResponse);
        } catch (e) {
          print(e.toString());
          yield StartLocationErrorState(msg: e.toString());
        }
      } else if (event is StartLocationIMEIEvents) {
        try {
          yield StartLocationIMEILoadingState();
          var startLocationResponse = await webService.getStartLocationImei(
              event.token,
              event.vendorId,
              event.branchId,
              event.araiNonarai,
              event.imeiNUmber);
          yield StartLocationIMEILoadedState(
              startLocationResponse: startLocationResponse);
        } catch (e) {
          print(e.toString());
          yield StartLocationIMEIErrorState(msg: e.toString());
        }
      } else if (event is NextLocationEvents) {
        try {
          yield NextLocationLoadingState();
          var startLocationResponse = await webService.getNextLocation(
              event.token, event.vendorId, event.branchId, event.araiNonarai);
          yield NextLocationLoadedState(
              startLocationResponse: startLocationResponse);
        } catch (e) {
          print(e.toString());
          yield NextLocationErrorState(msg: e.toString());
        }
      } else if (event is NextLocationIMEIEvents) {
        try {
          yield NextLocationIMEILoadingState();
          var startLocationResponse = await webService.getnextLocationImei(
              event.token,
              event.vendorId,
              event.branchId,
              event.araiNonarai,
              event.imeiNUmber);
          yield NextLocationIMEILoadedState(
              startLocationResponse: startLocationResponse);
        } catch (e) {
          print(e.toString());
          yield NextLocationIMEIErrorState(msg: e.toString());
        }
      } else if (event is LiveTrackingFilterEvents) {
        try {
          yield LiveTrackingFilterLoadingState();
          var liveTrackingFilterResponse =
              await webService.getLiveTrackingFilter(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNonarai,
                  event.vehicleSrNolist);
          yield LiveTrackingFilterLoadedState(
              liveTrackingFilterResponse: liveTrackingFilterResponse);
        } catch (e) {
          print(e.toString());
          yield LiveTrackingFilterErrorState(msg: e.toString());
        }
      } else if (event is SearchLiveTrackingFilterEvents) {
        try {
          yield SearchLiveTrackingFilterLoadingState();
          var liveTrackingFilterResponse =
              await webService.getSearchLiveTrackingFilter(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNonarai,
                  event.vehicleSrNolist,
                  event.searchText);
          yield SearchLiveTrackingFilterLoadedState(
              liveTrackingFilterResponse: liveTrackingFilterResponse);
        } catch (e) {
          print(e.toString());
          yield SearchLiveTrackingFilterErrorState(msg: e.toString());
        }
      } else if (event is SearchLiveTrackingEvents) {
        try {
          yield SearchLiveTrackingLoadingState();
          var searchliveTrackingResponse =
              await webService.getSearchLiveTracking(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.araiNonarai,
                  event.trackingStatus,
                  event.searchText);
          yield SearchLiveTrackingLoadedState(
              searchliveTrackingResponse: searchliveTrackingResponse);
        } catch (e) {
          print(e.toString());
          yield SearchLiveTrackingErrorState(msg: e.toString());
        }
      } else if (event is GetGeofenceCreateDetailEvents) {
        try {
          yield GetGeofenceCreateDetailLoadingState();
          var geofenceCreateDetailsResponse =
              await webService.getGeofenceCreateDetails(
                  event.token,
                  event.vendorId,
                  event.branchId,
                  event.pageNumber,
                  event.pageSize);
          yield GetGeofenceCreateDetailLoadedState(
              geofenceCreateDetailsResponse: geofenceCreateDetailsResponse);
        } catch (e) {
          print(e.toString());
          yield GetGeofenceCreateDetailErrorState(msg: e.toString());
        }
      } else if (event is SearchGeofenceCreateEvents) {
        try {
          yield SearchGeofenceCreateLoadingState();
          var searchGeofenceCreateResponse =
              await webService.searchGeofenceCreateDetails(event.token,
                  event.vendorId, event.branchId, event.searchText);
          yield SearchGeofenceCreateLoadedState(
              searchGeofenceCreateResponse: searchGeofenceCreateResponse);
        } catch (e) {
          print(e.toString());
          yield SearchGeofenceCreateErrorState(msg: e.toString());
        }
      } else if (event is DeleteGeofenceCreateEvents) {
        try {
          yield DeleteGeofenceCreateLoadingState();
          var editDeviceResponse = await webService.deleteGeofenceCreateById(
              event.token, event.vendorId, event.branchId, event.geofenceId);
          yield DelectGeofenceCreateLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield DeleteGeofenceCreateErrorState(msg: e.toString());
        }
      } else if (event is AddGeofenceEvents) {
        try {
          yield AddGeofenceLoadingState();
          var addGeofenceResponse = await webService.addGeofence(
              event.token,
              event.vendorid,
              event.branchid,
              event.geofencename,
              event.category,
              event.description,
              event.tolerance,
              event.showgeofence,
              event.latitude,
              event.longitude,
              event.overlaytype,
              event.rectanglebond,
              event.rectanglearea,
              event.rectanglehectares,
              event.rectanglekilometer,
              event.rectanglemiles,
              event.address,
              event.vehicleid);
          yield AddGeofenceLoadedState(
              addGeofenceResponse: addGeofenceResponse);
        } catch (e) {
          print(e.toString());
          yield AddGeofenceErrorState(msg: e.toString());
        }
      } else if (event is CreateAssignMenuRightsEvents) {
        try {
          yield CreateAssignMenuRightsLoadingState();
          var editDeviceResponse = await webService.createAssignMenuRights(
              event.assignMenuRightsRequest, event.token);
          yield CreateAssignMenuRightsLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield CreateAssignMenuRightsErrorState(msg: e.toString());
        }
      } else if (event is RemoveAssignMenuRightsEvents) {
        try {
          yield RemoveAssignMenuRightsLoadingState();
          var editDeviceResponse = await webService.removeAssignMenuRights(
              event.assignMenuRightsRequest, event.token);
          yield RemoveAssignMenuRightsLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield RemoveAssignMenuRightsErrorState(msg: e.toString());
        }
      }
      //! Overspeed Report---------------------------------------
      else if (event is getOverSpeedEvents) {
        try {
          yield GetOverSpeedCreateDetailLoadingState();
          var getOverspeedREportResponse = await webService.getOverSpeedReport(
              event.token,
              event.vendorid,
              event.branchid,
              event.arainonarai,
              event.fromdata,
              event.fromtime,
              event.todate,
              event.pagesize,
              event.pagenumber);
          yield GetOverSpeedCreateDetailLoadedState(
              getOverspeedREportResponse: getOverspeedREportResponse);
        } catch (e) {
          print(e.toString());
          yield GetOverSpeedCreateDetailErrorState(msg: e.toString());
        }
      }
      //! Search OverSpeed Report--------------------------------
      else if (event is SearchOverSpeedCreateEvents) {
        try {
          yield SearchOverSpeedCreateLoadingState();
          var search_overspeed_response =
              await webService.searchOverSpeedCreateDetails(
                  event.token,
                  event.vendorid,
                  event.branchid,
                  event.arainonarai,
                  event.fromdata,
                  event.fromtime,
                  event.todate,
                  event.pagesize,
                  event.pagenumber,
                  event.searchText);
          yield SearchOverSpeedCreateLoadedState(
              searchOverSpeedCreateResponse: search_overspeed_response);
        } catch (e) {
          print(e.toString());
          //   yield SearchOverSpeedCreateErrorState(msg: e.toString());
          // }
        }
//! Travel Summary All Data Event-------------------------
      } else if (event is TravelSummaryReportEvent) {
        try {
          yield TravelSummaryReportLoadingState();
          var travelsummaryresponse = await webService.travelsummarydetail(
              event.token,
              event.vendorid,
              event.branchid,
              event.pagenumber,
              event.pagesize,
              event.arainonarai,
              event.fromdata,
              event.fromtime,
              event.totime,
              event.todate);
          yield TravelSummaryReportLoadedState(
              TravelSummaryResponse: travelsummaryresponse);
        } catch (e) {
          print(e.toString());
        }
        //! Travel Summary Search Event-------------------------
      } else if (event is TravelSummarySearchEvent) {
        try {
          yield TravelSummarySearchLoadingState();
          var travelsummarysearch = await webService.travelsearch_web(
              event.token,
              event.vendorid,
              event.branchid,
              event.pagenumber,
              event.pagesize,
              event.arainonarai,
              event.fromdata,
              event.fromtime,
              event.searchtext,
              event.totime,
              event.todate);
          yield TravelSummarySearchLoadedState(
              travelSummaryResponse: travelsummarysearch);
        } catch (e) {
          print(e.toString());
        }
//! Travel Summary Filter Event-------------------------
      } else if (event is TravelSummaryFilterEvent) {
        try {
          yield TravelSummaryFilterLoadingState();
          var travelsummaryfilter = await webService.travelfilter_web(
              event.token,
              event.vendorid,
              event.branchid,
              event.pagenumber,
              event.pagesize,
              event.arainonarai,
              event.fromdata,
              event.fromtime,
              event.vehiclelist,
              event.totime,
              event.todate);
          yield TravelSummaryFilterLoadedState(
              travelSummaryFilterResponse: travelsummaryfilter);
        } catch (e) {
          print(e.toString());
        }
        //! Distance Summary Alldata Event-------------------------
      } else if (event is DistanceSummaryEvent) {
        try {
          yield DistanceSummaryLoadingState();
          var distancesummaryresponse = await webService.distancesummarydetail(
              event.token,
              event.vendorid,
              event.branchid,
              event.pagenumber,
              event.pagesize,
              event.arainonarai,
              event.fromdata,
              event.fromtime,
              event.totime,
              event.todate,
              event.IMEINO);
          yield DistanceSummaryLoadedState(
              DistanceSummaryResponse: distancesummaryresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //! Distance Summary Filter Event-------------------------
      else if (event is DistanceSummaryFilterEvent) {
        try {
          yield DistanceSummaryFilterLoadingState();
          var distancesummaryfilterresponse =
              await webService.distancesummaryfilter(
            event.token,
            event.vendorid,
            event.branchid,
            event.pagenumber,
            event.pagesize,
            event.arainonarai,
            event.summaryrange,
            event.vehiclelist,
          );
          yield DistanceSummaryFilterLoadedState(
              DistanceSummaryFilterResponse: distancesummaryfilterresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //! DistanceSummary Search Bloc----------
      else if (event is DistanceSummarySearchEvent) {
        try {
          yield DistanceSummaryFilterLoadingState();
          var distancesummarysearchresponse =
              await webService.distancesummarysearch(
                  event.token,
                  event.vendorid,
                  event.branchid,
                  event.pagenumber,
                  event.pagesize,
                  event.arainonarai,
                  event.fromdata,
                  event.fromtime,
                  event.searchtext,
                  event.totime,
                  event.todate);
          yield DistanceSummarySearchLoadedState(
              distanceSummarySearch: distancesummarysearchresponse);
        } catch (e) {
          print(e.toString());
        }
      } //! Get Point Of Interest Bloc
      else if (event is GetPointOfInterestEvent) {
        try {
          yield PointOfInterestCreateLoadingState();
          var pointOfInterestCreateDetailsResponse =
              await webService.createPointOfInterestGetApi(
                  event.token,
                  event.vendorid,
                  event.branchid,
                  event.pagenumber,
                  event.pagesize);
          yield PointOfInterestCreateLoadedState(
              createPointOfInterest: pointOfInterestCreateDetailsResponse);
        } catch (e) {
          print(e.toString());
          yield PointOfInterestCreateErrorState(msg: e.toString());
        }
      }
      // //End of bloc

      //! Search Point Of Interest Bloc
      else if (event is SearchPointOfInterestEvent) {
        try {
          yield SearchPointOfInterestLoadingState();
          var searchPointOfInterestDetailsResponse =
              await webService.fetchSearchPointInterestDetails(
            event.token,
            event.vendorid,
            event.branchid,
            event.searchStr,
          );
          yield SearchPointOfInterestLoadedState(
              searchPointOfInterest: searchPointOfInterestDetailsResponse);
        } catch (e) {
          print(e.toString());
          yield PointOfInterestCreateErrorState(msg: e.toString());
        }
        //! Dropdown Point Of Interest Bloc----------------
      } else if (event is DropdownPointOfInterestEvent) {
        try {
          yield PointofInterestDropdownLoadingState();
          var dropdownpointofinterest =
              await webService.dropdownpointofinterest(event.token);
          yield PointofInterestDropdownLoadedState(
              dropdownPointOfInterest: dropdownpointofinterest);
        } catch (e) {
          print(e.toString());
          yield PointofInterestDropdownErrorState(msg: e.toString());
        }
      } else if (event is DeviceMasterFilter) {
        try {
          yield DeviceMasterFilterLoadingState();
          var devicemasterfilterbloc = await webService.devicemasterwebfilter(
              event.token,
              event.vendorid,
              event.branchid,
              event.deviceno,
              event.pagenumber,
              event.pagesize);
          yield DeviceMasterFilterLoadedState(
              deviceMasterFilter: devicemasterfilterbloc);
        } catch (e) {
          yield DeviceMasterFilterErorrState(msg: e.toString());
        }
        //!--------------
      } else if (event is vehicleStatusReportEvent) {
        try {
          yield VehicleStatusReportLoadingState();
          var vehiclestatusreportresponse =
              await webService.vehicleStatusReport(
            event.token,
            event.vendorId,
            event.branchid,
            event.araino,
            event.fromdate,
            event.fromTime,
            event.toDate,
            event.toTime,
            event.imeno,
            event.pagenumber,
            event.pagesize,
          );
          yield VehicleStatusReportLoadedState(
              VehicleStatusReportResponse: vehiclestatusreportresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //!-------------------
      else if (event is Vehiclestatusreportfilter) {
        try {
          yield VehicleStatusFilterLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclestatusreportfilter(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.fromTime,
                  event.vehiclelist,
                  event.toDate,
                  event.toTime,
                  event.imeno,
                  event.pagenumber,
                  event.pagesize);
          yield VehicleStatusFilterLoadedState(
              VehicleStatusReportResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      } else if (event is GettingRouteGGR) {
        try {
          yield RouteNameListLoadingState();
          var routenamelist = await webService.routedefinelist(
              event.token, event.vendorid, event.branchid);
          yield RouteNameListLoadedState(routenamelist: routenamelist);
        } catch (e) {
          print(e.toString());
        }
      }
      //! Routes Detail By RoutesName---------------------------
      else if (event is RoutesDetailByRoutesNameEvents) {
        try {
          yield GetRoutesDetailLoadingState();
          var routenamedetail = await webService.routesdetailbyname(
              event.token, event.vendorid, event.branchid, event.routename);
          yield GetRoutesDetailLoadedState(routenamelist: routenamedetail);
        } catch (e) {
          print(e.toString());
        }
      }
      //! POI type code------------
      else if (event is Poitype) {
        try {
          yield POITypeLoadingState();
          var poitypecode = await webService.poitypecode(event.token);
          yield POITypeLoadedState(poitypelist: poitypecode);
        } catch (e) {
          print(e.toString());
        }
      }
      //! POI post data mainbloc----------------
      else if (event is PoiPostdata) {
        try {
          yield POIPostLoadingState();
          var addpoidata = await webService.poiaddeddata(
              event.token,
              event.vendorid,
              event.branchid,
              event.poiname,
              event.poitypeID,
              event.description,
              event.tolerance,
              event.locationlatitude,
              event.locationlongitude,
              event.showpoi,
              event.address,
              event.vehicleid);
          yield POIPostLoadedState(poipost: addpoidata);
        } catch (e) {
          yield POIPostErrorState(msg: e.toString());
        }
      }
      //! POI delete data----------------
      else if (event is POIDeletedata) {
        try {
          yield POIDeleteLoadingState();
          var editDeviceResponse = await webService.poideletewebservice(
              event.token, event.vendorid, event.branchid, event.srno);
          yield POIDeleteLoadedState(
              editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield POIDeleteErrorState(msg: e.toString());
        }
      }
    }
  }
  // else if (event is FramePacketReportEvents) {
  // try {
  // yield FramePacketReportLoadingState();
  // var frame_packet_response = await webService.getframepacketreport(
  // event.vendorId, event.branchId, event.pageNumber, event.pageSize,);
  // yield FramePacketReportLoadedState(
  // frame_packet_response: frame_packet_response);
  // } catch (e) {
  // print(e.toString());
  // yield FramePacketReportErrorState(msg: e.toString());
  // }
  // }
}
