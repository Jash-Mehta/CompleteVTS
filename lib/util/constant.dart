class Constant {
  static String baseUrl = 'https://vtsgpsapi.m-techinnovations.com/api/';
  // static String loginUrl = baseUrl + 'Users/authenticate';
  static String loginUrl = baseUrl + 'Users/authenticate';
  static String updateloginUrl =
      baseUrl + 'UpdateLogin_Audit_History/AddUpdateLogin_Audit_History_Login';
  static String updatelogoutUrl =
      baseUrl + 'UpdateLogin_Audit_History/AddUpdateLogin_Audit_History_LogOut';

  static String getAllVehicleDetailUrl = baseUrl + 'vehicles?Vendorid=';
  static String getSearchVehicleUrl = baseUrl + 'Vehicles/';
  static String addNewVehicleUrl = baseUrl + 'Vehicles';
  static String editVehicleUrl = baseUrl + 'Vehicles/';

  static String vendorNameUrl = baseUrl + 'Vendors/FillVendor';
  static String branchNameUrl = baseUrl + 'Branch/FillBranch/';
  static String userNameUrl = baseUrl + 'Users/FillUser/';
  static String vehicleFillUrl = baseUrl + 'Vehicles/FillVehicle/';
  static String vehicleFillSrnoUrl = baseUrl + 'Vehicles/FillVehiclevsrno/';
  static String assignMenuListUrl = baseUrl + 'AssignMenuRights/FillMenu';
  static String checkuserUrl = baseUrl + 'ForgetPassword/';
  static String forgetPasswordUrl = baseUrl + 'ForgetPassword';
  static String resetPasswordUrl = baseUrl + 'ResetPassword';
  static String dashboardUrl =
      baseUrl + 'Dashboards/GetDashboardDetails?VendorId=';

  static String vehicleTypeFillUrl = baseUrl + 'Vehicles/FillVehicleType/';

  static String alertFillUrl = baseUrl + 'AlertGroup/FillAlertType';
  static String vehicleTypeUrl = baseUrl + 'Vehicles/FillVehicleType';
  static String driverNamesUrl = baseUrl + 'Drivers/FillDriver/';
  static String deviceNamesUrl = baseUrl + 'Device/FillDevice/';
  static String userTypeUrl = baseUrl + '/Users/FillUserType';

  static String getprofileDetailsUrl = baseUrl + 'Profile/';
  static String updateprofileUrl = baseUrl + 'Profile/';

  static String getAllSubscriptionUrl = baseUrl + 'Subscription?VendorID=';
  static String searchSubscriptionUrl = baseUrl + 'Subscription/';
  static String addSubscriptionUrl = baseUrl + 'Subscription';
  static String editSubscriptionUrl = baseUrl + 'Subscription/';

  static String getAllVendorDetailUrl = baseUrl + 'Vendors?pageNumber=';
  static String getSearchVendorUrl = baseUrl + 'Vendors/';
  static String addNewVendorUrl = baseUrl + 'Vendors';
  static String editVendorUrl = baseUrl + 'Vendors/';

  static String getAllBranchDetailUrl = baseUrl + 'Branch?VendorID=';
  static String getSearchBranchUrl = baseUrl + 'Branch/';
  static String addNewBranchUrl = baseUrl + 'Branch';
  static String editBranchUrl = baseUrl + 'Branch/';

  static String getAllDriverUrl = baseUrl + 'Drivers?VendorID=';
  static String getSearchDriverUrl = baseUrl + 'Drivers/';
  static String addNewDriverUrl = baseUrl + 'Drivers';
  static String editDriverUrl = baseUrl + 'Drivers/';

  static String getAllDeviceDetailUrl = baseUrl + 'Device?VendorID=';
  static String getSearchDeviceUrl = baseUrl + 'Device/';
  static String addNewDeviceUrl = baseUrl + 'Device';
  static String editdeviceUrl = baseUrl + 'Device/';

  static String getAllAlertDetailUrl = baseUrl + 'AlertGroup?VendorID=';
  static String getSearchAlertUrl = baseUrl + 'AlertGroup/Search/';
  static String addAlertUrl = baseUrl + 'AlertGroup';
  static String editAlertUrl = baseUrl + 'AlertGroup/';

  static String getAllCreateUserUrl = baseUrl + 'Drivers?VendorID=';

  static String getAllUserUrl = baseUrl + 'Users?VendorId=';
  static String getsearchUserUrl = baseUrl + 'Users/';
  static String addUserUrl = baseUrl + 'Users';
  static String editUserUrl = baseUrl + 'Users/';

  static String alertNotificationUrl =
      baseUrl + 'AlertNotification/GetAllAlertNotification?VendorId=';
  static String searchAlertNotificationUrl =
      baseUrl + 'AlertNotification/Search?VendorId=';
  static String dateWiseSearchAlertNotificationUrl =
      baseUrl + 'AlertNotification/GetDatewiseAlertNotification?VendorId=';
  static String clearAlertNotificationUrl =
      baseUrl + '/AlertNotification/ClearAlertNotification?VendorId=';
  static String clearAllNotificationUrl =
      baseUrl + '/AlertNotification/ClearAllAlertNotificationAsync?VendorId=';
  static String alertFilterVehicleImeinoUrl =
      baseUrl + '/AlertNotification/FillVehicleIMEINo/';
  static String alertFilterVehiclesrnoUrl =
      baseUrl + '/AlertNotification/FillVehicleListVSrNo/';
  static String getFilteralertNotificationClick =
      baseUrl + 'AlertNotification/AlertFilter?VendorId=';
  static String getSearchFilteralertNotification =
      baseUrl + 'AlertNotification/SearchAlertFilter?VendorId=';

  static String alertFilterCompanyUrl =
      baseUrl + 'AlertNotification/FillVendor';
  static String alertFilterBranchUrl =
      baseUrl + 'AlertNotification/FillBranch/';
  static String alertFilterTypeUrl =
      baseUrl + 'AlertNotification/FillAlertType';

  static String getAnalyticReportStatusClick =
      baseUrl + 'Dashboards/GetSearchAnalyticReportStatus?VendorId=';
  static String getSearchAnalyticReportStatusClick =
      baseUrl + 'Dashboards/GetDashboardDetailsVehicleRegNoBySearch?VendorId=';
  static String getAnalyticReportDetails =
      baseUrl + 'Dashboards/GetAnalyticReportVehicleNoByIdDetail?VendorId=';

  // static String getVehicleHistoryDetail = baseUrl + 'VTSHistory/GetHistoryDetailsVehicleRegNo?VendorId=';
  static String getVehicleHistoryDetail =
      baseUrl + 'VTSHistory/GetVehicleHistory?VendorId=';
  static String getVehicleHistoryFilterDetail =
      baseUrl + 'VTSHistory/ApplyVehicleHistoryAPi?VendorId=';
  static String getVehicleHistorySearchFilterDetail =
      baseUrl + 'VTSHistory/ApplySearchVehicleHistoryAPi?VendorId=';
  static String getVehicleHistoryById =
      baseUrl + 'VTSHistory/GetVehicleHistoryById?VendorId=';

  static String getLiveTrackingUrl =
      baseUrl + 'VTSLive/GetLiveTracking?VendorId=';
  static String getLiveTrackingByIdUrl =
      baseUrl + 'VTSLive/GetVehicleLiveById?VendorId=';

  static String getVehilcStatusWithCountUrl =
      baseUrl + 'VTSLive/GetVehicleStatusWithCount?VendorId=';
  static String getStartLocationUrl =
      baseUrl + 'VTSLive/GetStartLocationVTSLiveDetails?VendorId=';
  static String getNextLocationUrl =
      baseUrl + 'VTSLive/GetNextLocationVTSLiveDetails?VendorId=';
  static String getStartLocationImeiUrl =
      baseUrl + 'VTSLive/GetStartLocationVTSLiveDetailsByIMEINo?VendorId=';
  static String getNextLocationImeiUrl =
      baseUrl + 'VTSLive/GetNextLocationVTSLiveDetailsByIMEINoNew?VendorId=';

  static String getLiveTrackingCompanyUrl = baseUrl + 'VTSLive/FillVendor';
  static String getLiveTrackingBranchUrl = baseUrl + 'VTSLive/FillBranch/';
  static String getLiveTrackingFilterUrl =
      baseUrl + 'VTSLive/PostApplyFilter?VendorId=';
  static String getSearchLiveTrackingFilterUrl =
      baseUrl + 'VTSLive/SearchFilter?VendorId=';
  static String getSearchLiveTrackingUrl =
      baseUrl + 'VTSLive/SearchLiveVehicle?VendorId=';

  static String getVehicleStatusUrl =
      baseUrl + 'VTSHistory/GetFillVehicleStatus';
  static String createAssignMenuRightsUrl =
      baseUrl + 'AssignMenuRights/AssignMenuRights';
  static String removeAssignMenuRightsUrl =
      baseUrl + 'AssignMenuRights/RemoveMenuRights';

  static String getGeofenceCreateDetailsUrl =
      baseUrl + 'GeofenceCreate/GetGeofenceCreateDetails?VendorId=';
  static String searchGeofenceCreateByIdUrl = baseUrl + 'GeofenceCreate/';
  static String deleteGeofenceCreateByIdUrl = baseUrl + 'GeofenceCreate/';
  static String geofenceCategoryUrl =
      baseUrl + 'GeofenceCreate/GETGEOCategoryDetails';
  static String addGeofenceUrl = baseUrl + 'GeofenceCreate';

  static String getOverSpeedFillVendorUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/FillVendor';
  static String getOverSpeedFillBranchUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/FillBranch/1';
  static String getOverSpeedIMEIUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/FillVehicleList_IMEINo/1/1';
  static String getOverSpeedReportUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/GetOverSpeedReport?VendorId=';
  static String searchOverSpeedReportUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/SearchOverSpeedReport?VendorId=';
   static String OverSpeedfiltersearchUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/FilterSearchOverSpeed?VendorId=';
  static String filterOverSpeedUrl =
      baseUrl + 'VehicleWiseOverSpeedReport/FilterOverSpeed?VendorId=';

  // static String getFramePacketReportVendorUrl =
  //     baseUrl + 'FramePacketReport/FillVendor';
  // static String getFramePacketReportBranchUrl =
  //     baseUrl + 'FramePacketReport/FillBranch/1';
  // static String getFramePacketReportIMEIUrl =
  //     baseUrl + 'FramePacketReport/FillVehicleListIMEINo/1/1';
  // static String getFramePacketReportFillFrameUrl =
  //     baseUrl + 'FramePacketReport/FillFramePacket?ARAI_NONARAI=arai';
    static String FramefiltersearchUrl =
      baseUrl + 'FramePacketReport/FilterSearchFramepacketReport';
    static String FramegridfiltersearchUrl =
      baseUrl + 'FramePacketGridviewReport/FilterSearchFramePacketGridviewReport?VendorId=';
  static String FramePacketReportUrl =
      baseUrl + 'FramePacketReport/GetFramepacketReport?VendorId=';
  static String FramePacketGridUrl = baseUrl +
      'FramePacketGridviewReport/GetFramePacketGridViewReport?VendorId=';
  // https://vtsgpsapi.m-techinnovations.com/api/FramePacketReport/GetFramepacketReport?VendorId=1&BranchId=1&ARAI_NONARAI=arai&FromDate=01-sep-2022&FromTime=12:30&ToDate=30-sep-2022&ToTime=18:30&IMEINO=867322033819244&FramePacketOption=datapacket&PageNumber=1&PageSize=10
  static String getFramePacketReportSearchUrl =
      baseUrl + 'FramePacketReport/GetFramepacketReport?VendorId=';
  static String getFramePacketReportFilter =
      baseUrl + 'FramePacketReport/FilterFramepacketReport?VendorId=';
  // static String framepacketgridurl =
  //     'FramePacketGridviewReport/FilterFramePacketGridViewReport';
// ! travel Summary Report-----------------
  static String travelSummaryReportfillvendor =
      baseUrl + 'TravelSummaryReport/GetTravelSummaryReport';
  static String travelSummarySearch =
      baseUrl + 'TravelSummaryReport/SearchTravelSummaryReport';
  static String travelSummaryFilter =
      baseUrl + 'TravelSummaryReport/FilterTravelSummaryReport';
  //! Distance travel Summary Report-----------------------------
  static String DistanceSummaryReport =
      baseUrl + 'DistanceTravelSummary/GetDistanceTravelSummaryReport';
  static String distancesummaryfilter = baseUrl +
      'DistanceTravelSummary/FilterDistanceTravelSummaryReport_SummaryRange';
  static String distancesummarysearch =
      baseUrl + 'DistanceTravelSummary/SearchDistanceTravelSummaryReport';
  // Driver Wise Vehicle Assign
  static String driverwisevehicleassign =
      baseUrl + 'DriverWiseVehicalAssignReports/GetDriverVehicleAssign';
  static String driverwisevehiclefilter =
      baseUrl + 'DriverWiseVehicalAssignReports/FilterApplyDriverVehicleAssign';

  static String datewisetravelfilter =
      baseUrl + 'DateWiseTravelHistoryReport/ApplyFilterDatewiseTravelHistory';
  // https://vtsgpsapi.m-techinnovations.com/api/DriverWiseVehicalAssignReports/FilterApplyDriverVehicleAssign?VendorId=1&BranchId=1&VSrNo=all&PageNumber=1&PageSize=10
  static String driverwisevehicleassignsearch =
      baseUrl + 'DriverWiseVehicalAssignReports/SearchDriverVehicleAssign';
   static String driverwisevafiltersearchurl =
      baseUrl + 'DriverWiseVehicalAssignReports/FilterSearchApplyDriverVehicleAssign?VendorId=';
  static String datewisetravelhistory =
      baseUrl + 'DateWiseTravelHistoryReport/GetAllDatewiseTravelHistory';
  // TimeWiseTravelHistoryReport/GetAllTimeWiseTravelHistory
  static String datewisesearch = baseUrl +
      'DateWiseTravelHistorySummaryReport/SearchDatewiseTravelHistorySummary';
  static String searchvehiclestatusgroupurl = baseUrl +
      'VehicleStatusGroupByReport/SearchVehicleStatusGroupByReport?VendorId=';

  static String vehiclewisetravelhistory =
      baseUrl + 'VehicleWiseTravelHistoryReport/GetAllVehicleWiseTravelHistory';

  static String vehiclewisefilter = baseUrl +
      'VehicleWiseTravelHistoryReport/ApplyFilterVehicleWiseTravelHistory';

   static String vehiclewisefiltersearch = baseUrl +
      'VehicleWiseTravelHistoryReport/FilterSearchVehicleWiseTravelHistory?VendorId=';
    static String vehiclewisetwisefiltersearch = baseUrl +
      'VehiclewiseTimewiseTravelHistoryReport/FilterSearchVehicleWiseTimeWiseTravelHistory?VendorId=';

  static String vehicletimewisefilter = baseUrl +
      'VehiclewiseTimewiseTravelHistoryReport/ApplyFilterVehicleWiseTimeWiseTravelHistory';

  static String vehiclewisesearch =
      baseUrl + 'VehicleWiseTravelHistoryReport/SearchVehicleWiseTravelHistory';

  static String vehicletimewisesearch = baseUrl +
      'VehiclewiseTimewiseTravelHistoryReport/SearchVehicleWiseTimeWiseTravelHistory';

  static String vehicletimewisetravelhistory = baseUrl +
      'VehiclewiseTimewiseTravelHistoryReport/GetAllVehicleWiseTimeWiseTravelHistory';

  static String dateandtimewisedistance =
      baseUrl + 'TimeWiseTravelHistoryReport/GetAllTimeWiseTravelHistory';
  static String dateandtimewisefilter =
      baseUrl + 'TimeWiseTravelHistoryReport/ApplyFilterTimeWiseTravelHistory';
  static String dateandtimewisesearch =
      baseUrl + 'TimeWiseTravelHistoryReport/SearchTimeWiseTravelHistory';

  static String getVehcleReportUrl =
      baseUrl + 'VehicleMasterReports/GetVehicleReport?VendorId=';
  static String searchVehicleReporturl =
      baseUrl + 'VehicleMasterReports/SearchVehicleReport?VendorId=';
  static String filterVehicleReporturl =
      baseUrl + 'VehicleMasterReports/ApplyFilterVehicleMaster?VendorId=';
  static String devicemasterfilterurl =
      baseUrl + 'DeviceMasterReports/FilterApplyDeviceReport';
  static String drivermasterurl =
      baseUrl + 'DriverMasterReports/DriverMasterReport';
  static String drivermasterfilterurl =
      baseUrl + 'DriverMasterReports/FilterApplyDriverReport';
  static String devicemasterreporturl =
      baseUrl + 'DeviceMasterReports/DeviceMasterReport?VendorId=';
  static String overspeedfilterurl =
      baseUrl + 'VehicleWiseOverSpeedReport/FilterOverSpeed';
  static String vehiclestatusgroupurl = baseUrl +
      'VehicleStatusGroupByReport/GetVehicleStatusGroupByReport?VendorId=';
  static String vehiclestatusreporturl =
      baseUrl + 'VehicleStatusReport/GetVehicleStatusReport?VendorId=';
  static String vehiclestatussummaryurl = baseUrl +
      'VehicleStatusSummaryReport/GetVehicleStatusSummaryReport?VendorId=';
  static String vehiclestatusfilter =
      baseUrl + 'VehicleStatusReport/FilterVehicleStatusReport';
  static String vehiclegroupfilter = baseUrl +
      'VehicleStatusGroupByReport/FilterVehicleStatusGroupByReport?VendorId=';
  static String vehiclesummaryfilter = baseUrl +
      'VehicleStatusSummaryReport/FilterVehicleStatusSummaryReport?VendorId=';

  static String framefilterurl =
      baseUrl + 'FramePacketReport/FilterFramepacketReport';
  static String framegridfilterurl =
      baseUrl + 'FramePacketGridviewReport/FilterFramePacketGridViewReport';
  static String getDeviceMasterReportUrl =
      baseUrl + 'DeviceMasterReports/DeviceMasterReport?VendorId=';

  static String searchDeviceMasterReportUrl =
      baseUrl + 'DeviceMasterReports/SearchDeviceMasterReport?VendorId=';
 
   static String DeviceMasterFilterSearchUrl =
      baseUrl + 'DeviceMasterReports/FilterSearchApplyDeviceReport?VendorId=';
  
   // https://vtsgpsapi.m-techinnovations.com/api/DeviceMasterReports/FilterSearchApplyDeviceReport?VendorId=1&BranchId=1&DeviceNo=DC01422&SearchText=mo&PageNumber=1&PageSize=10

  static String getdriverwisevehassignReportUrl = baseUrl +
      'DriverWiseVehicalAssignReports/GetDriverVehicleAssign?VendorId=';

  static String searchDriverwiseAssignReportUrl = baseUrl +
      'DriverWiseVehicalAssignReports/SearchDriverVehicleAssign?VendorId=1';

  static String searchDatewiseTravelrurl = baseUrl +
      '/DateWiseTravelHistoryReport/SearchDatewiseTravelHistory?VendorId=';
   static String DatewiseTravelHFilterSearchurl = baseUrl +
      'DateWiseTravelHistoryReport/FilterSearchDatewiseTravelHistory?VendorId=';
   static String DateTimewiseDFilterSearchurl = baseUrl +
      'TimeWiseTravelHistoryReport/FilterSearchTimeWiseTravelHistory?VendorId=';
  static String searchdrivermasterurl =
      baseUrl + '/DriverMasterReports/SearchDriverMasterReport?VendorId=';
   static String drivermasterfilsearchurl =
      baseUrl + '/DriverMasterReports/FilterSearchApplyDriverReport?VendorId=';
// /DriverMasterReports/FilterSearchApplyDriverReport?VendorId=1&BranchId=1&DriverCode=ALL&SearchText=adi&PageNumber=1&PageSize=10
  static String searchFramePacketrurl =
      baseUrl + 'FramePacketReport/SearchFramepacketReport?VendorId=';

  static String searchFramePacketgridurl = baseUrl +
      '/FramePacketGridviewReport/SearchFramePacketGridViewReport?VendorId=1';

  static String searchvehiclestatusreporturl =
      baseUrl + 'VehicleStatusReport/SearchVehicleStatusReport?VendorId=';
  
   static String vehstatusfiltersearchurl =
      baseUrl + 'VehicleStatusReport/FilterSearchVehicleStatusReport?VendorId=';
    
   static String vehsummaryfiltersearchurl =
      baseUrl + 'VehicleStatusSummaryReport/FilterSearchVehicleStatusSummaryReport?VendorId=';

     static String vehgroupfiltersearchurl =
      baseUrl + 'VehicleStatusGroupByReport/FilterSearchVehicleStatusGroupByReport?VendorId=';

  static String searchvehiclestatussummaryurl = baseUrl +
      'VehicleStatusSummaryReport/SearchVehicleStatusSummaryReport?VendorId=';

  //  https://vtsgpsapi.m-techinnovations.com/api/FramePacketGridviewReport/FillFramePacket?ARAI_NONARAI=arai
  static String getPointOfInterstCreateUrl =
      baseUrl + 'PointOfInterestCreate/GetPointofInterestDetails';

  // '${baseUrl}/PointOfInterestCreate/GetPointofInterestDetails';

  static String searchStrPointOfInterstCreateUrl =
      baseUrl + 'PointOfInterestCreate';

  static String getPOITypeUrl =
      baseUrl + 'PointOfInterestCreate/GETPOITypeDetails';
  static String routesdetailbyname =
      baseUrl + 'RouteDefine/GetRoutesDetailsByRouteName';
  static String speedurl =
      baseUrl + 'VTSHistory/ApplyVehicleHistoryAPI?VendorId=';
  static String vtslivegeo = baseUrl + "VTSLive/GetGEODetails?VendorId=";
  static String vtshistoryspeedparameter = baseUrl +
      'VTSHistory/GetHistoryStartLocationWithSpeedParameter?VendorId=';
}
