import 'package:shared_preferences/shared_preferences.dart';
import 'package:movie/config/application.dart';
import 'package:movie/const/app_constants.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  static SharedPreferences? _preferences;

  LocalStorageService._internal();

  get json => null;

  static Future<LocalStorageService?> getInstance() async {
    _instance ??= LocalStorageService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  /// Logged In
  bool? get isUserLoggedIn =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.loggedIn) ?? false;
  set isUserLoggedIn(bool? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.loggedIn, value);

  /// Calendar Id
  String? get calendarId =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.calendarId);
  set calendarId(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.calendarId, value);

  /// Folder Id
  String? get folderId =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.folderId);
  set folderId(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.folderId, value);

  /// Folder Name
  String? get folderName =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.folderName);
  set folderName(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.folderName, value);

  /// Calendar Name
  String? get calendarName =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.calenderName);
  set calendarName(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.calenderName, value);

  /// Category Id
  String? get categoryId =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.categoryId);
  set categoryId(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.categoryId, value);

  /// Category Name
  String? get categoryName =>
      _getDataFromDisk(AppLocalStoragePreferencesKeys.categoryName);
  set categoryName(String? value) =>
      _saveDataToDisk(AppLocalStoragePreferencesKeys.categoryName, value);

  dynamic _getDataFromDisk(String key) {
    if (_preferences != null) {
      var value = _preferences!.get(key);
      return value;
    }
  }

  void removeDataFromLocalStorage() async {
    Application.localStorageService!.categoryId = null;
    Application.localStorageService!.calendarId = null;
    Application.localStorageService!.categoryName = null;
    Application.localStorageService!.calendarName = null;
    Application.localStorageService!.isUserLoggedIn = false;
    Application.userDetails = null;
  }

  void _saveDataToDisk<T>(String key, T content) async {
    if (_preferences != null) {
      if (content is String) {
        await _preferences!.setString(key, content);
      } else if (content is bool) {
        await _preferences!.setBool(key, content);
      } else if (content is int) {
        await _preferences!.setInt(key, content);
      } else if (content is double) {
        await _preferences!.setDouble(key, content);
      } else if (content is List<String>) {
        await _preferences!.setStringList(key, content);
      } else {
        await _preferences!.setString(key, content.toString());
      }
    }
  }
}
