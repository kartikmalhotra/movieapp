/// class for having API Endpoints used in the application
abstract class ApiRestEndPoints {
  /// API end points for the user service
  static const String user = '/api/user';
  static const String userDetail = '/users/:id';
  static const String login = '/api/session/login';
  static const String logout = '/api/session/logout';
  static const String deleteAccount = '/api/user?allData=true';
  static const String getMoviesList = "";
  static const String signUp = "/api/signup";
}
