import 'dart:math';

import 'package:flutter_vts/bloc/main_event.dart';
import 'package:flutter_vts/bloc/main_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vts/model/report/frame_packet_report_response.dart';
import 'package:flutter_vts/service/web_service.dart';

import '../model/report/framepacketgrid.dart';

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
      } else if (event is SearchDriverMasterReportEvent) {
        try {
          yield SearchDriverMasterReportLoadingState();
          var driverMasterReportresponse = await webService.searchtextdriverRpt(
              event.token,
              event.vendorid,
              event.searchText,
              event.branchid,
              event.pagesize,
              event.pagenumber);
          yield SearchDriverMasterReportLoadedState(
              searchResponse: driverMasterReportresponse);
        } catch (e) {
          print(e.toString());
          yield SearchDriverMasterReportErrorState(msg: e.toString());
        }
      } else if (event is SearchDatewiseTravelReportEvent) {
        try {
          yield SearchDatewiseTravelReportLoadingState();
          var driverMasterReportresponse =
              await webService.searchTxtDateWiseTravelHistoryRpt(
                  event.token,
                  event.vendorid,
                  event.branchid,
                  event.arai,
                  event.fromDate,
                  event.todate,
                  event.searchText,
                  event.pagenumber,
                  event.pagesize);
          yield SearchDatewiseTravelReportLoadedState(
              searchResponse: driverMasterReportresponse);
        } catch (e) {
          print(e.toString());
          yield SearchDatewiseTravelReportErrorState(msg: e.toString());
        }
      }
      // -----------------------------------------------------
      else if (event is SearchOverSpeedCreateEvents) {
        try {
          yield SearchOverSpeedCreateLoadingState();
          var search_overspeed_response = await webService.searchoverspeedRpt(
              event.token,
              event.vendorId,
              event.barnchId,
              event.arainonarai,
              event.fromDate,
              event.toDate,
              event.searchText,
              event.pageNumber,
              event.pageSize);
          yield SearchOverSpeedCreateLoadedState(
              searchOverSpeedCreateResponse: search_overspeed_response);
        } catch (e) {
          // print(e.toString());
          yield SearchOverSpeedCreateErrorState(msg: e.toString());
        }
      }

      // ----------------------------------------------------

      // else if (event is SearchDriverMasterReportEvent) {
      //   try {
      //     yield SearchDriverMasterReportLoadingState();
      //     var driverMasterReportresponse = await webService.searchtextdriverRpt(
      //       event.token,
      //       event.vendorid,
      //      event.searchText,
      //       event.branchid,
      //       event.pagesize,
      //       event.pagenumber
      //     );
      //     yield SearchDriverMasterReportLoadedState(
      //         searchResponse: driverMasterReportresponse  );

      //   } catch (e) {
      //     print(e.toString());
      //     yield SearchDriverMasterReportErrorState(msg: e.toString());
      //   }
      // }
      //End
      //  else if (event is SearchDatewiseTravelReportEvent) {
      //   try {
      //     yield SearchDatewiseTravelReportLoadingState();
      //     var driverMasterReportresponse = await webService.searchTxtDateWise(
      //         event.token,
      //         event.vendorid,
      //         event.fromDate,
      //         event.todate,
      //         event.searchText,
      //         event.branchid,
      //         event.pagesize,
      //         event.pagenumber
      //     );
      //     yield SearchDatewiseTravelReportLoadedState(
      //         searchResponse: driverMasterReportresponse  );

      //   } catch (e) {
      //     print(e.toString());
      //     yield SearchDatewiseTravelReportErrorState(msg: e.toString());
      //   }
      // }

      else if (event is SearchBranchEvents) {
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
              event.currentimeiNUmber,
              event.prevTransactionId,
              event.prevDate,
              event.prevTime,
              event.prevIMEINo);
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
      }

      // else if (event is AddGeofenceEvents) {
      //   try {
      //     yield AddGeofenceLoadingState();
      //     var addGeofenceResponse = await webService.addGeofence(
      //         event.token,
      //         event.vendorid,
      //         event.branchid,
      //         event.geofencename,
      //         event.category,
      //         event.description,
      //         event.tolerance,
      //         event.showgeofence,
      //         event.latitude,
      //         event.longitude,
      //         event.overlaytype,
      //         event.rectanglebond,
      //         event.rectanglearea,
      //         event.rectanglehectares,
      //         event.rectanglekilometer,
      //         event.rectanglemiles,
      //         event.address,
      //         event.vehicleid);
      //     yield AddGeofenceLoadedState(
      //         addGeofenceResponse: addGeofenceResponse);
      //   } catch (e) {
      //     print(e.toString());
      //     yield AddGeofenceErrorState(msg: e.toString());
      //   }
      // }
      else if (event is CreateAssignMenuRightsEvents) {
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
      } else if (event is OverSpeedEvents) {
        try {
          yield OverSpeedLoadingState();
          var getOverspeedREportResponse = await webService.overspeedreport(
              event.token,
              event.vendorid,
              event.branchid,
              event.arai,
              event.fromDate,
              event.toDate,
              event.imeno,
              event.pagenumber,
              event.pagesize);
          yield OverSpeedLoadedState(
              OverspeedReportResponse: getOverspeedREportResponse);
        } catch (e) {
          print(e.toString());
          yield OverSpeedErrorState(msg: e.toString());
        }
      } else if (event is SearchOverSpeedCreateEvents) {
        try {
          yield SearchOverSpeedCreateLoadingState();
          var search_overspeed_response = await webService.searchoverspeedRpt(
              event.token,
              event.vendorId,
              event.barnchId,
              event.arainonarai,
              event.fromDate,
              event.toDate,
              event.searchText,
              event.pageNumber,
              event.pageSize);
          yield SearchOverSpeedCreateLoadedState(
              searchOverSpeedCreateResponse: search_overspeed_response);
        } catch (e) {
          print(e.toString());
          //   yield SearchOverSpeedCreateErrorState(msg: e.toString());
          // }
        }

        //------------
      } // search frame packet grid report ----------
      else if (event is SearchFramePacktGridEvent) {
        try {
          yield SearchFramePacketGridLoadingState();
          var frame_packet_grid_response =
              await webService.searchTextFramePcktgrid(
            event.token,
            event.vendorId,
            event.branchId,
            event.araiNonarai,
            event.fromDate,
            event.formTime,
            event.toDate,
            event.toTime,
            event.searchText,
            event.framepacketoption,
            event.pageNumber,
            event.pageSize,
          );
          yield SearchFramePacketGridLoadedState(
              searchFramePacketgrid: frame_packet_grid_response);
          print("Serch pkt res------$frame_packet_grid_response");
        } catch (e) {
          print(e.toString());
          yield SearchFramePacketGridErrorState(msg: e.toString());
        }
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
              event.arainonarai,
              event.fromdata,
              event.fromtime,
              event.todate,
              event.totime,
              event.searchtext,
              event.pagenumber,
              event.pagesize,);
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
      } else if (event is DistanceSummarySearchEvent) {
        try {
          yield DistanceSummarySearchLoadingState();
          var distancesummarysearchresponse =
              await webService.distancesummarysearch(
                  event.token,
                  event.vendorid,
                  event.branchid,
                  event.pagenumber,
                  event.pagesize,
                  event.arainonarai,
                  event.fromdate,
                  event.fromtime,
                  event.searchtext,
                  event.totime,
                  event.todate);
          yield DistanceSummarySearchLoadedState(
              distancesummarysearch: distancesummarysearchresponse);
        } catch (e) {
          print(e.toString());
          yield DistanceSummaryErrorState(msg: e.toString());
        }
      } else if (event is DriverWiseVehicleAssignEvent) {
        try {
          yield DriverWiseVehicleAssignLoadingState();
          var driverwisevehicleassignresponse =
              await webService.driverwisevehicleassign(
            event.token,
            event.vendorid,
            event.branchid,
            event.pagenumber,
            event.pagesize,
          );
          yield DriverWiseVehicleAssignLoadedState(
              DriverWiseVehicleAssignResponse: driverwisevehicleassignresponse);
        } catch (e) {
          print(e.toString());
        }
      } else if (event is DriverVehicleFilterEvent) {
        try {
          yield DriverWiseVehicleFilterLoadingState();
          var driverwisevehicleassignresponse =
              await webService.driverwisevehiclefilter(
            event.token,
            event.vendorId,
            event.branchid,
            event.vsrno,
            event.pagenumber,
            event.pagesize,
          );
          yield DriverWiseVehicleFilterLoadedState(
              DriverWiseVehicleFilterResponse: driverwisevehicleassignresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //! Main bloc for search element of driver wise Assign  Master report
      else if (event is SearchDriverwiseVehAssignDetailsEvent) {
        print("Enter in main bloc event.......${event.searchText}");
        try {
          yield SearchDriverVehAssignReportLoadingState();
          var findstrDetailResp =
              await webService.searchStrDriverwiseVehicleAssignRpt(
            event.token,
            event.branchid,
            event.searchText,
            event.pageNumber,
            event.vendorid,
            event.pageSize,
          );
          print("Api response in event is--------${findstrDetailResp}");
          yield SearchDriverVehAssignReportLoadedState(
              searchvehassignResponse: findstrDetailResp);
        } catch (e) {
          print(e.toString());
          yield SearchDriverVehAssignReportErrorState(msg: e.toString());
        }
      }
      //End.
      else if (event is DateWiseTravelHistoryEvent) {
        try {
          yield DateWiseTravelHistoryLoadingState();
          var datewisetravelhistoryresponse =
              await webService.datewisetravelhistory(
            event.token,
            event.vendorid,
            event.branchid,
            event.arainonarai,
            event.fromdate,
            event.todate,
            event.imeino,
            event.pageSize,
            event.pageNumber,
          );
          yield DateWiseTravelHistoryLoadedState(
              datedisetravelhistoryresponse: datewisetravelhistoryresponse);
        } catch (e) {
          print(e.toString());
        }
      } else if (event is DriverMasterEvent) {
        try {
          yield DriverMasterLoadingState();
          var DriverMasterReportresponse = await webService.drivermaster(
            event.token,
            event.vendorid,
            event.branchid,
            event.pageSize,
            event.pageNumber,
          );
          yield DriverMasterLoadedState(
              drivermasterreportresponse: DriverMasterReportresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //Main bloc for get vehicle reports event-----
      else if (event is GetVehReportDetailsEvent) {
        try {
          yield GetVehicleReportLoadingState();
          var vehDetailResp = await webService.getvehicledetailReport(
              event.token,
              event.vendorid,
              event.branchid,
              event.pageSize,
              event.pageNumber);
          print("Api response in event is--------${vehDetailResp}");
          yield GetVehicleReportLoadedState(
              vehicleReportResponse: vehDetailResp);
        } catch (e) {
          print(e.toString());
          yield GetVehicleReportErrorState(msg: e.toString());
        }
      }
      //End

      //Main bloc for searching element in vehicle Details report
      else if (event is SearchVehReportDetailsEvent) {
        print("Enter in main bloc event.......");
        try {
          yield SearchVehicleReportLoadingState();
          var vehDetailResp = await webService.findStringInvehicledetailReport(
            event.token,
            event.vendorid,
            event.searchText,
            event.branchid,
            event.pageNumber,
            event.pageSize,
          );
          print("Api response in event is--------${vehDetailResp}");
          yield SearchVehicleReportLoadedState(
              searchVehicleReportResponse: vehDetailResp);
        } catch (e) {
          print(e.toString());
          yield SearchVehicleReportErrorState(msg: e.toString());
        }
      }
      //End.
      //

      //Main bloc for fetch element of Device Master report
      else if (event is DeviceMasterReportEvent) {
        print("Enter in main bloc event.......");
        try {
          yield DeviceMasterFilterLoadingState();
          var deviceMaster = await webService.devicemasterreport(event.token,
              event.branchid, event.vendorid, event.pagenumber, event.pagesize);
          print("Api response in event is--------${deviceMaster}");
          yield DeviceMasterReportLoadedState(deviceData: deviceMaster);
        } catch (e) {
          print(e.toString());
          yield DeviceMasterReportErorrState(msg: e.toString());
        }
      }
      // overspeed filter
      else if (event is OverSpeedFilterEvents) {
        print("Enter in main bloc event.......");
        try {
          yield OverSpeedFilterLoadingState();
          var overspeed = await webService.overspeedfilter(
              event.token,
              event.branchid,
              event.vendorid,
              event.arai,
              event.fromDate,
              event.toDate,
              event.vehiclelist,
              event.pagenumber,
              event.pagesize);
          print("Api response in event is--------${overspeed}");
          yield OverSpeedFilterLoadedState(overspeedFilter: overspeed);
        } catch (e) {
          print(e.toString());
          yield OverSpeedFilterErorrState(msg: e.toString());
        }
      }
      //End.
      else if (event is FramePacketEvents) {
        try {
          yield FramePacketLoadingState();
          var frame_packet_response = await webService.getframepacketreport(
            event.token,
            event.vendorId,
            event.branchId,
            event.araiNonarai,
            event.fromDate,
            event.formTime,
            event.toDate,
            event.toTime,
            event.imeno,
            event.framepacketoption,
            event.pageNumber,
            event.pageSize,
          );
          yield FramePacketLoadedState(
              FramePacketResponse: frame_packet_response);
        } catch (e) {
          print(e.toString());
        }
      }

      // frame packet grid ----------
      else if (event is FramePacketGridEvents) {
        try {
          yield FramePacketGridLoadingState();
          var framepacketgridresponse = await webService.framepacketgrid(
            event.token,
            event.vendorId,
            event.branchId,
            event.araiNonarai,
            event.fromDate,
            event.formTime,
            event.toDate,
            event.toTime,
            event.vehicleList,
            event.framepacketoption,
            event.pageNumber,
            event.pageSize,
          );
          yield FramePacketGridLoadedState(
              FramePacketGridResponse: framepacketgridresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //vehicle Status group
      else if (event is VehicleStatusGroupEvent) {
        try {
          yield VehicleStatusGroupLoadingState();
          var vehiclestatusgroupresponse = await webService.vehicleStatusGroup(
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
          yield VehicleStatusGroupLoadedState(
              VehicleStatusGroupResponse: vehiclestatusgroupresponse);
        } catch (e) {
          print(e.toString());
        }
      } else if (event is SearchDeviceMasterReportDetailsEvent) {
        print(
            "Enter in main bloc event of serach vehicle rept.......${event.searchText}");
        try {
          yield SearchDeviceMasterReportLoadingState();
          var finddmDetailResp = await webService.findStringInDMReport(
            event.token,
            event.branchid,
            event.searchText,
            event.pageNumber,
            event.vendorid,
            event.pageSize,
          );
          print("Api response in event is--------${finddmDetailResp}");
          yield SearchDeviceMasterReportLoadedState(
              searchdmReportResponse: finddmDetailResp);
        } catch (e) {
          print(e.toString());

          yield SearchDeviceMasterReportErrorState(msg: e.toString());
          print("error msg--------${e.toString()}");
        }
      }

      // Vehicle Status Report
      else if (event is vehicleStatusReportEvent) {
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

      // Vehicle Status Summary
      else if (event is vehicleStatusSummaryEvent) {
        try {
          yield VehicleStatusSummaryLoadingState();
          var vehiclestatussummaryresponse =
              await webService.vehicleStatusSummary(
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
          yield VehicleStatusSummaryLoadedState(
              VehicleStatusSummaryResponse: vehiclestatussummaryresponse);
        } catch (e) {
          print(e.toString());
        }
      }
      //Main bloc for search element of Device Master report
      else if (event is SearchDeviceMasterReportDetailsEvent) {
        print("Enter in main bloc event.......");
        try {
          yield SearchDeviceMasterReportLoadingState();
          var finddmDetailResp = await webService.findStringInDMReport(
            event.token,
            event.branchid,
            event.searchText,
            event.pageNumber,
            event.vendorid,
            event.pageSize,
          );
          print("Api response in event is--------${finddmDetailResp}");
          yield SearchDeviceMasterReportLoadedState(
              searchdmReportResponse: finddmDetailResp);
        } catch (e) {
          print(e.toString());
          yield SearchDeviceMasterReportErrorState(msg: e.toString());
        }
      }
      //End.
      else if (event is DeviceMasterFilter) {
        try {
          yield DeviceMasterFilterLoadingState();
          var devicemasterfilterbloc = await webService.devicemasterwebfilter(
            event.token,
            event.vendorid,
            event.branchid,
            event.deviceno,
            event.pagesize,
            event.pagenumber,
          );
          yield DeviceMasterFilterLoadedState(
              deviceMasterFilter: devicemasterfilterbloc);
        } catch (e) {
          yield DeviceMasterFilterErorrState(msg: e.toString());
        }
      }
      // vehicle report filter
      else if (event is VehicleReportFilterEvent) {
        try {
          yield VehicleReportFilterLoadingState();
          var vehiclereportfilterbloc = await webService.vehiclereportfilter(
              event.token,
              event.vendorId,
              event.branchid,
              event.vsrno,
              event.pagenumber,
              event.pagesize);
          yield VehicleReportFilterLoadedState(
              vehicleReportFilter: vehiclereportfilterbloc);
        } catch (e) {
          print("vehicle report went wrong in main bloc");
          yield VehicleReportFilterErorrState(msg: e.toString());
        }
      }
      // Vehicle Status Group Filter
      else if (event is vehicleGroupFilterEvent) {
        try {
          yield VehicleGroupFilterLoadingState();
          var vehiclereportfilterbloc = await webService.vehiclergroupfilter(
              event.token,
              event.vendorId,
              event.branchid,
              event.araino,
              event.fromdate,
              event.fromTime,
              event.toDate,
              event.toTime,
              event.vehiclelist,
              event.pagenumber,
              event.pagesize);
          yield VehicleGroupFilterLoadedState(
              vehiclegroupFilterresponse: vehiclereportfilterbloc);
        } catch (e) {
          yield VehicleGroupFilterErorrState(msg: e.toString());
        }
      }

      // Vehicle Status Summary Filter
      else if (event is vehicleSummaryFilterEvent) {
        try {
          yield VehicleSummaryFilterLoadingState();
          var vehiclereportfilterbloc = await webService.vehiclersummaryfilter(
              event.token,
              event.vendorId,
              event.branchid,
              event.araino,
              event.fromdate,
              event.fromTime,
              event.toDate,
              event.toTime,
              event.vehiclelist,
              event.pagenumber,
              event.pagesize);
          yield VehicleSummaryFilterLoadedState(
              vehiclesummaryFilterresponse: vehiclereportfilterbloc);
        } catch (e) {
          yield VehicleSummaryFilterErorrState(msg: e.toString());
        }
      }

      // Driver master filter
      else if (event is DriverMasterFilterEvent) {
        try {
          yield DriverMasterFilterLoadingState();
          var drivermasterfilterbloc = await webService.drivermasterfilter(
              event.token,
              event.vendorId,
              event.branchid,
              event.drivercode,
              event.pagenumber,
              event.pagesize);
          yield DriverMasterFilterLoadedState(
              driverMasterFilter: drivermasterfilterbloc);
        } catch (e) {
          yield DriverMasterFilterErorrState(msg: e.toString());
        }
      }
      // ------------------------------------
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
      }

      // Vehicle wise travel history
      else if (event is VehicleWiseTravelEvents) {
        try {
          yield VehicleWiseTravelLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclewisetravelhistory(
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
                  event.pagesize);
          yield VehicleWiseTravelLoadedState(
              vehiclewisetravelResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Vehicle wise time wise travel history
      else if (event is VehicleWiseTimeWiseTravelEvents) {
        try {
          yield VehicleWiseTimeWiseTravelLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclewisetimewisetravelhistory(
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
                  event.pagesize);
          yield VehicleWiseTimeWiseTravelLoadedState(
              vehiclewisewimewisetravelResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Vehicle  wise filter
      else if (event is VehicleWiseFilterEvents) {
        try {
          yield VehicleWiseFilterLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclewisefilter(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.fromTime,
                  event.toDate,
                  event.toTime,
                  event.vehiclelist,
                  event.pagenumber,
                  event.pagesize);
          yield VehicleWiseFilterLoadedState(
              vehiclewisefilterResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Vehicle wise time wise filter
      else if (event is VehicleWiseTimeWiseFilterEvents) {
        try {
          yield VehicleWiseTimeWiseFilterLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclewisetimewisefilter(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.fromTime,
                  event.toDate,
                  event.toTime,
                  event.vehiclelist,
                  event.pagenumber,
                  event.pagesize);
          yield VehicleWiseTimeWiseFilterLoadedState(
              vehiclewisetimewisefilterResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Vehicle wise search
      else if (event is VehicleWiseSearchEvents) {
        try {
          yield VehicleWiseSearchLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclewisesearch(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.toDate,
                  event.searchtxt,
                  event.pagenumber,
                  event.pagesize);
          yield VehicleWiseSearchLoadedState(
              vehiclewisesearchResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Vehicle wise time wise search
      else if (event is VehicleWiseTimeWiseSearchEvents) {
        try {
          yield VehicleWiseTimeWiseSearchLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.vehiclewisetimewisesearch(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.fromTime,
                  event.toDate,
                  event.toTime,
                  event.searchtxt,
                  event.pagenumber,
                  event.pagesize);
          yield VehicleWiseTimeWiseSearchLoadedState(
              vehiclewisetimewisesearchResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // date and time wise distance travel
      else if (event is DateAndTimeWiseTravelEvents) {
        try {
          yield DateAndTimeWiseTravelLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.dateandtimewisetravelhistory(
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
                  event.pagesize);
          yield DateAndTimeWiseTravelLoadedState(
              dateandtimewisetravelResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // date and time wise filter travel
      else if (event is DateAndTimeWiseFilterEvents) {
        try {
          yield DateAndTimeWiseFilterLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.dateandtimewisefilter(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.fromTime,
                  event.toDate,
                  event.toTime,
                  event.vehiclelist,
                  event.pagenumber,
                  event.pagesize);
          yield DateAndTimeWiseFilterLoadedState(
              dateandtimewisefilterResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // date and time wise filter travel
      else if (event is DateAndTimeWiseSearchEvents) {
        try {
          yield DateAndTimeWiseSearchLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.dateandtimewisesearch(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.araino,
                  event.fromdate,
                  event.fromTime,
                  event.toDate,
                  event.toTime,
                  event.searchtxt,
                  event.pagenumber,
                  event.pagesize);
          yield DateAndTimeWiseSearchLoadedState(
              dateandtimewisesearchResponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Frame packet filter
      else if (event is FrameFilterEvent) {
        try {
          yield FrameFilterLoadingState();
          var vehiclestatusreportfilterbloc = await webService.frampacketfilter(
              event.token,
              event.vendorId,
              event.branchid,
              event.arai,
              event.fromdate,
              event.fromtime,
              event.todate,
              event.totime,
              event.vehiclelist,
              event.framepacketoption,
              event.pagenumber,
              event.pagesize);
          yield FrameFilterLoadedState(
              frameFilterresponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Frame packet grid filter

      else if (event is FrameGridFilterEvent) {
        try {
          yield FrameGridFilterLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.framepacketgridfilter(
                  event.token,
                  event.vendorId,
                  event.branchid,
                  event.arai,
                  event.fromdate,
                  event.fromtime,
                  event.todate,
                  event.totime,
                  event.vehiclelist,
                  event.framepacketoption,
                  event.pagenumber,
                  event.pagesize);
          yield FrameGridFilterLoadedState(
              framegridFilterresponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // device master driver code filter
      else if (event is DeviceMasterDrivercode) {
        try {
          yield DMFDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc = await webService.dmfdrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield DMFDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      //Vehicle vsrno
      else if (event is VehicleVSrNoEvent) {
        try {
          yield VehicleVSrNoLoadingState();
          var vehiclestatusreportfilterbloc = await webService.vehiclevsrno(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield VehicleVSrNoLoadedState(
              vehiclevsrnoresponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      //Frame Packet Option Grid
      else if (event is FramePacketOptionGridEvent) {
        try {
          yield FramePacketOptiongridLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.framepacketoptiongrid(
            event.token,
            event.arai,
          );
          yield FramePacketOptiongridLoadedState(
              vehiclevsrnoresponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Vehicle Status report driver code
      else if (event is VehicleStsRptDriverCodeEvent) {
        try {
          yield VehicleStsRptDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc = await webService.vsrdcdrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield VehicleStsRptDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // date wise travel history driver code filter
      else if (event is DateWiseDriverCodeEvent) {
        try {
          yield DateWiseDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.datewisedrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield DateWiseDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Driver wise vehicle assign driver code
      else if (event is DriverWiseDriverCodeEvent) {
        try {
          yield DriverWiseDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.driverwisedrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield DriverWiseDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Frame packet driver code
      else if (event is FramepacketDriverCodeEvent) {
        try {
          yield FramePacketDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.framepacketdrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield FramePacketDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Frame packet grid driver code
      else if (event is FramepacketGridDriverCodeEvent) {
        try {
          yield FramePacketGridDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.framepacketgriddrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield FramePacketGridDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // Over speed vehicle filter
      else if (event is OverSpeedVehicleFilterEvent) {
        try {
          yield OverSpeedVehicleFilterLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.overspeedvehiclefilter(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield OverSpeedVehicleFilterLoadedState(
              overspeedvehiclefilterresponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }
      // search frame packet report ----------
      else if (event is SearchFramePacktReportEvent) {
        try {
          yield SearchFramePacketLoadingState();
          var frame_packet_response = await webService.searchTextFramePckt(
            event.token,
            event.vendorId,
            event.branchId,
            event.araiNonarai,
            event.fromDate,
            event.formTime,
            event.toDate,
            event.toTime,
            event.searchText,
            event.framepacketoption,
            event.pageNumber,
            event.pageSize,
          );
          yield SearchFramePacketLoadedState(
              searchFramePacket: frame_packet_response);
          print("Serch pkt res------$frame_packet_response");
        } catch (e) {
          print(e.toString());
          yield SearchFramePacketErrorState(msg: e.toString());
        }
      }

      // search frame packet grid report ----------
      else if (event is SearchFramePacktGridEvent) {
        try {
          yield SearchFramePacketGridLoadingState();
          var frame_packet_grid_response =
              await webService.searchTextFramePcktgrid(
            event.token,
            event.vendorId,
            event.branchId,
            event.araiNonarai,
            event.fromDate,
            event.formTime,
            event.toDate,
            event.toTime,
            event.searchText,
            event.framepacketoption,
            event.pageNumber,
            event.pageSize,
          );
          yield SearchFramePacketGridLoadedState(
              searchFramePacketgrid: frame_packet_grid_response);
          print("Serch pkt res------$frame_packet_grid_response");
        } catch (e) {
          print(e.toString());
          yield SearchFramePacketGridErrorState(msg: e.toString());
        }
      } else if (event is SearchVehicleStatusGroupEvent) {
        try {
          yield SearchVehicleStatusGroupLoadingState();
          var response = await webService.searchvehstatusgrouprpt(
              event.token,
              event.vendorId,
              event.branchid,
              event.araino,
              event.fromdate,
              event.fromTime,
              event.toDate,
              event.toTime,
              event.searchText,
              event.pagenumber,
              event.pagesize);
          yield SearchVehicleStatusGroupLoadedState(
              searchVehicleStatusGroupResponse: response);
          print("Serch pkt res------$response");
        } catch (e) {
          print(e.toString());
          yield SearchVehicleStatusGroupErrorState(msg: e.toString());
        }
      }

      //! ---------------- // Search Vehicle Status Report --------------
      else if (event is SearchVehicleStatusEvent) {
        try {
          yield SearchVehicleStatusReportLoadingState();
          var vehiclestatusreportresponse = await webService.searchvehstatusrpt(
            event.token,
            event.vendorId,
            event.branchid,
            event.araino,
            event.fromdate,
            event.fromTime,
            event.toDate,
            event.toTime,
            event.searchText,
            event.pagenumber,
            event.pagesize,
          );
          yield SearchVehicleStatusReportLoadedState(
              searchvehicleStatusGroupResponse: vehiclestatusreportresponse);
        } catch (e) {
          print(e.toString());
        }
        yield SearchVehicleStatusReportErrorState(
            msg: "Enetr in Error state...");
      }
      //! Search Vehicle Status Summary----------------
      //  ------------------- // Search Vehicle Status Summary--------------

      else if (event is SearchvehicleStatusSummaryEvent) {
        try {
          yield SearchVehicleStatusGroupLoadingState();
          var vehiclestatussummaryresponse =
              await webService.searchvehicleStatusSummary(
            event.token,
            event.vendorId,
            event.branchid,
            event.araino,
            event.fromdate,
            event.fromTime,
            event.toDate,
            event.toTime,
            event.searchText,
            event.pagenumber,
            event.pagesize,
          );
          yield SearchVehicleStatusSummaryLoadedState(
              searchVehicleStatusGroupResponse: vehiclestatussummaryresponse);
        } catch (e) {
          print(e.toString());
        }
      }

      // Driver master driver code---------
      else if (event is DriverMasterDriverCodeEvent) {
        try {
          yield DriverMasterDriverCodeLoadingState();
          var vehiclestatusreportfilterbloc =
              await webService.drivermasterdrivercode(
            event.token,
            event.vendorId,
            event.branchId,
          );
          yield DriverMasterDriverCodeLoadedState(
              dmfdriverCoderesponse: vehiclestatusreportfilterbloc);
        } catch (e) {
          print(e.toString());
        }
      }

      // ---------------------------------
      //  Date wise travel filter
      else if (event is DateWiseTravelFilterEvent) {
        try {
          yield DateWiseTravelFilterLoadingState();
          var devicemasterfilterbloc = await webService.datewisetravelfilter(
              event.token,
              event.vendorId,
              event.branchid,
              event.arai,
              event.fromdate,
              event.todate,
              event.vehiclelist,
              event.pagenumber,
              event.pagesize);
          yield DateWiseTravelFilterLoadedState(
              dateWiseTravelFilterResponse: devicemasterfilterbloc);
        } catch (e) {
          yield DeviceMasterFilterErorrState(msg: e.toString());
        }
      }
      //! Get Point Of Interest Bloc
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
          yield POIDeleteLoadedState(editDeviceResponse: editDeviceResponse);
        } catch (e) {
          print(e.toString());
          yield POIDeleteErrorState(msg: e.toString());
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
        //! VTS Geofence---------------------------------->
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
      //! Route Define Post Data-------------------------------->
      else if (event is RouteDefinePostEvents) {
        try {
          yield RouteDefinePostLoadingState();
          var routedefinepost = await webService.routedefinepost(
              event.token,
              event.vendorid,
              event.branchid,
              event.routefrom,
              event.routeto,
              event.routename,
              event.midwaypoint);
          yield RouteDefinePostLoadedState(routedefinepost: routedefinepost);
        } catch (e) {
          yield RouteDefinePostErrorState(msg: e.toString());
        }
      }//Main Bloc

 //  ------------------- // Get veh speed data--------------

      else if (event is GetVehSpeedDataEvent) {
        try {
          yield GetVehSpeedLoadingState();
          var getvehspeedDetailres =
          await webService.getvehspeedDetail(
            event.token,
            event.vendorId,
            event.branchid,
            event.araino,
            event.fromdate,
            event.fromTime,
            event.toDate,
            event.toTime,
            event.vehicleStatusList,
            event.vehicleList,
            event.pagenumber,
            event.pagesize,
          );
          print("Enter in main bloc of speed data-----------${getvehspeedDetailres.data!.length}");
          yield GetVehSpeedLoadedState(
              getVehSpeedResponse: getvehspeedDetailres);
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }
}
