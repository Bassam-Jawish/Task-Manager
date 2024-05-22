
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/user_model.dart';

part 'auth_api_service.g.dart';

@RestApi()
abstract class AuthApiService {
  factory AuthApiService(Dio dio) {
    return _AuthApiService(dio);
  }

  @POST('/auth/login')
  Future<HttpResponse<UserInfoModel>> login(
      @Field("username") String userName,
      @Field("password") String password,
      @Field("expiresInMins") int expiresInMins,
      );
}