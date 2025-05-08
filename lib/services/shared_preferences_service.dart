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

  // Preference keys
  static const String kFirstName = "firstName";
  static const String kLastName = "lastName";
  static const String kEmail = "email";
  static const String kUserName = "userName";
  static const String kPassword = "password";
  static const String kIsUserLoggedIn = "isUserLoggedIn";

  // Save all user info at once
  Future<void> saveUserInfo({
    required String firstName,
    required String lastName,
    required String emailId,
    required String userName,
  }) async {
    // Print the data being saved to SharedPreferences
    print('Saving user info: $firstName, $lastName, $emailId, $userName');

    await _pref?.setString(kFirstName, firstName);
    await _pref?.setString(kLastName, lastName);
    await _pref?.setString(kEmail, emailId);
    await _pref?.setString(kUserName, userName);
  }

  // Save a string value
  Future<void> savePrefString({
    required String key,
    required String value,
  }) async {
    await _pref?.setString(key, value);
  }

  // Retrieve a string value
  String getPrefString({
    required String prefKey,
  }) {
    return _pref?.getString(prefKey) ?? '';
  }

  // Retrieve a boolean value
  bool getPrefBool({
    required String prefKey,
  }) {
    return _pref?.getBool(prefKey) ?? false;
  }

  // Save a boolean value
  Future<void> savePrefBool({
    required String prefKey,
    required bool value,
  }) async {
    await _pref?.setBool(prefKey, value);
  }

  // Get string async (in case you want fresh instance)
  Future<String?> getStringAsync({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Set string async (fresh instance)
  Future<void> setStringAsync({
    required String key,
    required String value,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
}