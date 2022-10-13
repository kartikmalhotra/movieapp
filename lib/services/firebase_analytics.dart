// import 'package:firebase_analytics/firebase_analytics.dart';

// class FirebaseAnalyticsService {
//   static FirebaseAnalytics? _instance;
//   static FirebaseAnalyticsService? _service;

//   FirebaseAnalyticsService._internal();

//   static FirebaseAnalyticsService? getInstance() {
//     _instance ??= FirebaseAnalytics.instance;
//     _service ??= FirebaseAnalyticsService._internal();
//     return _service;
//   }

//   FirebaseAnalyticsObserver appAnalyticsObserver() {
//     if (_instance == null) {
//       _instance = FirebaseAnalytics.instance;
//     }
//     return FirebaseAnalyticsObserver(analytics: _instance!);
//   }

//   Future setUserId({String? id}) async {
//     await _instance!.setUserId(id: id);
//   }

//   Future logSignUp(String email) async {
//     await _instance!.logSignUp(signUpMethod: email);
//   }

//   Future logLoginIn() async {
//     await _instance!.logLogin();
//   }
// }
