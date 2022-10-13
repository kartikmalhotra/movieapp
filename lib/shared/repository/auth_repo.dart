import 'package:movie/config/application.dart';
import 'package:movie/const/api_path.dart';
import 'package:movie/const/app_constants.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:movie/utils/utils.dart';

abstract class AuthRepository {
  Future<dynamic> login(String email, String password);
  Future<dynamic> forgetPassword(String email);
  Future<dynamic> logout();
  Future<dynamic> deleteAccount();
  Future<dynamic> signUp(String email, String password, String name);
}

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<dynamic> login(String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential? user = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user;
    } catch (exe) {
      Utils.showSuccessToast(exe.toString());
    }
  }

  @override
  Future<dynamic> forgetPassword(String email) async {
    // final response = await Application.restService!.requestCall(
    //   apiEndPoint: ApiRestEndPoints.recoverPassword,
    //   method: RestAPIRequestMethods.post,
    //   requestParmas: {"email": email},
    // );
    // return response;
  }

  @override
  Future<dynamic> logout() async {
    String _fcmToken = await Application.secureStorageService!.fcmToken;

    // if (_fcmToken.isNotEmpty) {
    //   /// Delete FCM Token
    //   final deleteTokenResponse = await Application.restService!.requestCall(
    //       apiEndPoint: ApiRestEndPoints.mobileToken,
    //       addAutherization: true,
    //       requestParmas: {
    //         "mobileToken": _fcmToken,
    //       },
    //       method: RestAPIRequestMethods.delete);
    //   print("Delete FCM Token ${deleteTokenResponse.toString()}");
    // }

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    return null;
  }

  @override
  Future<dynamic> deleteAccount() async {
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.deleteAccount,
      addAutherization: true,
      requestParmas: {},
      method: RestAPIRequestMethods.delete,
    );
    return response;
  }

  @override
  Future<dynamic> signUp(String email, String password, String name) async {
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.signUp,
      requestParmas: {
        "email": email,
        "password": password,
        "name": name,
        "passwordConfirm": password
      },
      method: RestAPIRequestMethods.post,
    );
    return response;
  }

  Future<User?> registerUsingEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
      await user!.updateProfile(displayName: name);
      await user.reload();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Utils.showFailureToast('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Utils.showFailureToast('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    return user;
  }
}
