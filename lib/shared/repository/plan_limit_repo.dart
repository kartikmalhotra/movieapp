import 'package:movie/config/application.dart';
import 'package:movie/const/app_constants.dart';

abstract class PlanLimitRepository {}

class PlanLimitRepositoryImpl extends PlanLimitRepository {
  // @override
  Future<dynamic> getDialyLimit() async {
    final response = await Application.restService!.requestCall(
        apiEndPoint: '/api/payment/limits',
        method: RestAPIRequestMethods.get,
        addAutherization: true);
    return response;
  }

  Future<dynamic> checkPlanLimits() async {
    final response = await Application.restService!.requestCall(
        apiEndPoint: '/api/payment/check-plan-limits',
        method: RestAPIRequestMethods.get,
        addAutherization: true);
    return response;
  }

  Future<dynamic> getPostsCount() async {
    final response = await Application.restService!.requestCall(
        apiEndPoint: '/api/posts/count',
        method: RestAPIRequestMethods.get,
        addAutherization: true);
    return response;
  }
}
