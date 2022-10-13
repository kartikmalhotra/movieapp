import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/config/application.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie/config/routes/routes_const.dart';

import 'package:movie/const/app_constants.dart';
import 'package:movie/main.dart';
import 'package:movie/shared/repository/auth_repo.dart';
import 'package:movie/utils/utils.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepositoryImpl repository;

  AuthBloc({required this.repository}) : super(const AuthInitial()) {
    on<LoginEvent>((event, emit) => _mapLoginEventToState(event, emit));
    on<ForgetPasswordEvent>(
        (event, emit) => _mapForgetPasswordEventToState(event, emit));
    on<LogoutEvent>((event, emit) => _mapLogoutEventToState(emit));
    on<SignUpEvent>((event, emit) => _mapSignUpEventToState(event, emit));
    on<DeleteAccountEvent>(
      (event, emit) => _mapDeleteAccountEventToState(emit),
    );
  }

  Future<void> _mapLoginEventToState(
      LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoader());
    final response = await repository.login(event.email, event.password);
    if (response is UserCredential) {
      _saveSecureStorage(response, event.email, event.password);
      // Application.firebaseAnalyticsService!.logLoginIn();
      emit(const LoginResultState(loggedIn: true));
    } else {
      emit(const LoginResultState(
          loggedIn: false, errorResult: "Something went wrong"));
    }
  }

  Future<void> _mapForgetPasswordEventToState(
      ForgetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(const ForgetPasswordLoader());
    final response = await repository.forgetPassword(event.email);
    if (response != null && response['message'] != null) {
      emit(ForgetPasswordState(message: response['message']));
    } else {
      emit(ForgetPasswordState(errorResult: response["error"].toString()));
    }
  }

  Future<void> _mapSignUpEventToState(
      SignUpEvent event, Emitter<AuthState> emit) async {
    emit(const SignUpLoader());
    final response = await repository.registerUsingEmailPassword(
        name: event.name, email: event.email, password: event.password);
    if (response != null) {
      logoutUser();
      await Utils.showSuccessToast("Your account is created");
      emit(const SignupResultState(signedIn: true));
    } else {
      if (response != null) {
        emit(const SignupResultState(errorResult: "Something went wrong"));
        return;
      }
      emit(const SignupResultState(errorResult: "Something went wrong"));
    }
  }

  Future<void> _mapLogoutEventToState(emit) async {
    emit(const AuthLoader());

    final response = await repository.logout();
    logoutUser();
    emit(const LogoutState(isLogout: true));
    Navigator.pushNamedAndRemoveUntil(
        MovieApp.globalContext, AppRoutes.login, ((route) => false));
  }

  Future<void> _mapDeleteAccountEventToState(emit) async {
    emit(const AuthLoader());

    final response = await repository.deleteAccount();
    if (response['error'] == null) {
      logoutUser();
      emit(const DeleteState(isDeleted: true));
    } else {
      emit(const DeleteState(isDeleted: false));
    }
  }

  void _saveSecureStorage(UserCredential user, email, password) async {
    // _firebaseMessaging.getToken().then((token) {
    //   print("FCM Token is " + (token ?? ""));
    //   sendTokenToServer(token);
    // });

    /// Store in Class
    AppUser.accessToken = user.credential?.accessToken;
    AppUser.email = email;
    AppUser.password = password;
    AppUser.firebaseToken = await FirebaseMessaging.instance.getToken();
    AppUser.isLoggedIn = true;

    /// Store in Storage
    Application.localStorageService!.isUserLoggedIn = AppUser.isLoggedIn;
    if (AppUser.accessToken != null) {
      Application.secureStorageService!.accessToken =
          Future.value(AppUser.accessToken);
    }
    Application.secureStorageService!.email = Future.value(AppUser.email);
    Application.secureStorageService!.password = Future.value(AppUser.password);
    Application.secureStorageService!.refreshToken =
        Future.value(AppUser.firebaseToken);

    // Application.firebaseAnalyticsService!.setUserId(id: AppUser.email);

    if (kDebugMode) {
      print(AppUser.accessToken);
    }
  }

  void logoutUser() async {
    AppUser.email =
        AppUser.password = AppUser.firebaseToken = AppUser.accessToken = null;
    AppUser.isLoggedIn = false;
    Application.localStorageService!.removeDataFromLocalStorage();
    await Application.secureStorageService!.deleteAllDataFromSecureStorage();
  }

  void sendTokenToServer(String? value) async {
    if (value != null && AppUser.firebaseToken != null) {
      try {
        var response = await Application.restService!.requestCall(
            apiEndPoint: "/api/mobile-tokens",
            requestParmas: {"mobileToken": value},
            addAutherization: true,
            method: RestAPIRequestMethods.post);
        if (kDebugMode) {
          print("Firebase token sent to server" + response.toString());
        }
      } catch (exe) {
        if (kDebugMode) {
          print("Firebase Exeception $exe");
        }
      }
    }
  }
}
