import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{

  // static Future<SharedPreferences> get _instance async =>
  //     _prefsInstance ??= await SharedPreferences.getInstance();

  /*static late SharedPreferences _prefsInstance;


   static Future<SharedPreferences> init() async{
    _prefsInstance=await SharedPreferences.getInstance();
    return _prefsInstance;
  }


  static Future<bool> setUserToken(String token) async{
    var prefs=await  _prefsInstance;
    return prefs.setString("UserToken", token);
  }

  static getUserToken()async{
    var prefs=_prefsInstance;
    return prefs.getString("UserToken");
  }


  static logout(){
    _prefsInstance.remove("UserToken");
    return _prefsInstance.clear();
  }*/


   final  String authenticate_token = "auth_token";
  final String username = "Username";
  final String vendorid = "VendorId";
  final String branchid = "BranchId";
  final String vendorName= "vendorName";
  final String branchName= "branchName";
  final String userType= "userType";

   static final String _kLanguageCode = "language";

   static Future<String> getLanguageCode() async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();

     return prefs.getString(_kLanguageCode) ?? 'en';
   }

   /// ----------------------------------------------------------
   /// Method that saves the user language code
   /// ----------------------------------------------------------
   static Future<bool> setLanguageCode(String value) async {
     final SharedPreferences prefs = await SharedPreferences.getInstance();

     return prefs.setString(_kLanguageCode, value);
   }
  Future<void> setUserToken(String auth_token1) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authenticate_token, auth_token1);
  }

  Future<String> getUserToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String auth_token;
    auth_token =pref.getString(authenticate_token)!;
    return auth_token;
  }


  Future<void> setUserName(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.username, username);
  }

  Future<String> getUserName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String username;
    username = (pref.getString(this.username) ?? null)!;
    return username;
  }

  Future<void> setVendorId(int VendorId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.vendorid, VendorId);
  }

  Future<int> getVendorId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int vendorId;
    vendorId = (pref.getInt(this.vendorid) ?? null)!;
    return vendorId;
  }

  Future<void> setBranchId(int BranchId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(this.branchid, BranchId);
  }

  Future<int> getBranchId() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    int branchId;
    branchId = (pref.getInt(this.branchid) ?? null)!;
    return branchId;
  }

  Future<void> setVendorName(String vendorname) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.vendorName, vendorname);
  }

  Future<String> getVendorName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String vendorname;
    vendorname = (pref.getString(this.vendorName) ?? null)!;
    return vendorname;
  }

  Future<void> setBranchName(String branchname) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.branchName, branchname);
  }

  Future<String> getBranchName() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String branchname;
    branchname = (pref.getString(this.branchName) ?? null)!;
    return branchname;
  }


  Future<void> setUserType(String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(this.userType, userType);
  }

  Future<String> getUserType() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String usertype;
    usertype = (pref.getString(this.userType) ?? null)!;
    return usertype;
  }

}