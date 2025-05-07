import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {

  static final SharedPreferencesService _instance =
  SharedPreferencesService._internal();

  SharedPreferencesService._internal();

  factory SharedPreferencesService() {
    return _instance;
  }

  static SharedPreferences? _pref;

  Future<void> initSharedPref() async {
    _pref = await SharedPreferences.getInstance();
  }

  static const String kFirstName = "firstName";
  static const String kLastName = "lastName";
  static const String kEmail = "email";
  static const String kUserName = "userName";
  static const String kIsUserLoggedIn = "isUserLoggedIn";
  static const String kPassword = "password";

  Future<void> saveUserInfo({
    required String firstName,
    required String lastName,
    required String emailId,
    required String userName,
    // required String password,
  }) async {
    ///At above we initialise SharedPreferences as null so it can accept null or can accept actual value
    ///so while accessing those NUll safe variable we need to write ?
    ///means if it is null then statement after ? will not get executed

    ///If we write !. the if our SharedPreferences will null
    ///then also it will explicitly try to execute this statement and our application will get crash
    await _pref?.setString(kFirstName, firstName);
    await _pref?.setString(kLastName, lastName);
    await _pref?.setString(kEmail, emailId);
    await _pref?.setString(kUserName, userName);
    // await _pref?.setString("password", password);
  }

  ///THIS METHOD WILL SAVE THE STRING VALUE INTO SHARED PREFERENCE
  Future<void> savePrefString(
      {required String key, required String value}) async {
    await _pref?.setString(key, value);
  }

  ///IT WILL RETURN STRING DATA FROM SHARED PREFERENCES
  /// ?? '' ==> MEANS IT IT IS NULL THEN RETURN EMPTY STRING
  String getPrefString({required String prefKey}) {
    return _pref?.getString(prefKey) ?? '';
  }

  bool getPrefBool({required String prefKey}) {
    return _pref?.getBool(prefKey) ?? false;
  }

  Future<void> savePrefBool(
      {required String prefKey, required bool value}) async {
    await _pref?.setBool(prefKey, value);
  }
}
