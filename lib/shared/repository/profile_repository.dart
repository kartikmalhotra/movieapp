import 'package:movie/config/application.dart';
import 'package:movie/const/api_path.dart';
import 'package:movie/const/app_constants.dart';
import 'package:movie/shared/models/profile_model.dart';

abstract class ProfileRepository {
  UserDetails? get userDetails => null;
  set userDetailsData(UserDetails data);

  Future<dynamic> fetchUserProfile();
}

class ProfileRepositoryImpl extends ProfileRepository {
  UserDetails? _userDetails;

  @override
  UserDetails? get userDetails => _userDetails;

  @override
  set userDetailsData(UserDetails data) {
    _userDetails = data;
  }

  @override
  Future<dynamic> fetchUserProfile() async {
    final response = await Application.restService?.requestCall(
        apiEndPoint: ApiRestEndPoints.user,
        method: RestAPIRequestMethods.get,
        addAutherization: true);
    return response;
  }
}
