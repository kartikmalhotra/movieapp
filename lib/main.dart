import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:movie/screens/movies/bloc/movies_bloc.dart';
import 'package:movie/screens/movies/repository/movies_repository.dart';
import 'package:movie/services/native_service.dart';
import 'package:movie/shared/bloc/auth/auth_bloc.dart';
import 'package:movie/shared/bloc/playlist/bloc/playlist_bloc.dart';
import 'package:movie/shared/bloc/playlist/repository/playlist_repository.dart';
import 'package:movie/shared/repository/auth_repo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:movie/config/application.dart';
import 'package:movie/config/routes/routes.dart';
import 'package:movie/config/routes/routes_const.dart';
import 'package:movie/config/theme/theme.dart';
import 'package:movie/services/local_storage.dart';
import 'package:movie/services/rest_api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie/services/secure_storage.dart';
import 'package:movie/services/timezone_service.dart';

import 'package:movie/config/routes/routes.dart' as routes;

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   if (message.data.isNotEmpty) {
//     Utils.navigateToPage(message);
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Plugin must be initialized before using
  await FlutterDownloader.initialize(
      debug:
          true // optional: set to false to disable printing logs to console (default: true)

      );

  // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (await Permission.storage.request().isGranted) {
    if (kDebugMode) {
      print("MANAGE_EXTERNAL_STORAGE Granted");
    }
  } else {
    if (kDebugMode) {
      print("MANAGE_EXTERNAL_STORAGE Not Granted");
    }
  }

  Application.localStorageService = await LocalStorageService.getInstance();
  Application.secureStorageService = SecureStorageService.getInstance();
  Application.nativeAPIService = NativeAPIService.getInstance();
  Application.timezoneService = TimezoneService.getInstance();

  AppUser.isLoggedIn = Application.localStorageService?.isUserLoggedIn;

  if (AppUser.isLoggedIn == true) {
    await storeUserDataInClass();
  }
  Application.restService = RestAPIService.getInstance();
  Application.routeSetting = routes.AppRouteSetting.getInstance();
  runApp(MovieApp());
}

class MovieApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext get globalContext => navigatorKey.currentState!.context;
  const MovieApp({Key? key}) : super(key: key);

  @override
  _MovieAppState createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    final MoviesRepositoryImpl movieRepositoryImpl = MoviesRepositoryImpl();
    final PlaylistRepositoryImpl playlistRepositoryImpl =
        PlaylistRepositoryImpl();
    final DateTime dateTime = DateTime.now();
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesBloc>(
            create: (context) => MoviesBloc(repository: movieRepositoryImpl)
              ..add(GetMoviesEvent(dateTime: dateTime))),
        BlocProvider<PlaylistBloc>(
          create: (context) => PlaylistBloc(repository: playlistRepositoryImpl)
            ..add(GetPlaylistEvent(dateTime: dateTime)),
        ),
        BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(repository: AuthRepositoryImpl())),
      ],
      child: MaterialApp(
        title: 'Movie app',
        navigatorKey: MovieApp.navigatorKey,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouteSetting.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData['themeData'] as ThemeData,
      ),
    );
  }
}

Future<void> storeUserDataInClass() async {
  AppUser.accessToken = await Application.secureStorageService!.accessToken;
  AppUser.email = await Application.secureStorageService!.email;
  AppUser.password = await Application.secureStorageService!.password;
  AppUser.firebaseToken = await Application.secureStorageService!.refreshToken;
  if (kDebugMode) {
    print(AppUser.accessToken);
  }
}
