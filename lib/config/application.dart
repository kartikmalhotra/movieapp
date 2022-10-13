import 'dart:io';

import 'package:flutter/material.dart';
import 'package:movie/config/routes/routes.dart';
import 'package:movie/services/firebase_analytics.dart';
import 'package:movie/services/local_storage.dart';
import 'package:movie/services/native_service.dart';
import 'package:movie/services/rest_api_service.dart';
import 'package:movie/services/secure_storage.dart';
import 'package:movie/services/timezone_service.dart';
import 'package:movie/shared/models/profile_model.dart';

class Application {
  static String? preferedLanguage;
  static String? preferedTheme;
  static UserDetails? userDetails;
  static Brightness? hostSystemBrightness;
  static LocalStorageService? localStorageService;
  static SecureStorageService? secureStorageService;
  static NativeAPIService? nativeAPIService;
  // static FirebaseMessaging? firebaseMessaging;
  static TimezoneService? timezoneService;
  static AppRouteSetting? routeSetting;

  static RestAPIService? restService;
  static TargetPlatform platform =
      Platform.isIOS ? TargetPlatform.iOS : TargetPlatform.android;
}

abstract class AppUser {
  static bool? isLoggedIn;
  static String? accessToken;
  static String? token;
  static String? firebaseToken;
  static String? email;
  static String? password;
}
