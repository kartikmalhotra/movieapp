import 'package:movie/config/application.dart';
import 'package:movie/const/api_path.dart';
import 'package:movie/const/app_constants.dart';

abstract class UserRepository {
  Future<dynamic> fetchUserDetails();
}

class UserRepositoryImpl extends UserRepository {
  @override
  Future<dynamic> fetchUserDetails() async {
    final response = await Application.restService!.requestCall(
      apiEndPoint: ApiRestEndPoints.user,
      method: RestAPIRequestMethods.get,
    );
    return response;
  }
}
