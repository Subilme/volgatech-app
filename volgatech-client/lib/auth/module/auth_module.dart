import 'package:volgatech_client/auth/model/auth_api.dart';
import 'package:volgatech_client/auth/module/auth_routes.dart';
import 'package:volgatech_client/core/model/app/module/base_app_module.dart';

class AuthModule extends BaseAppModule {
  final AuthApi api;

  final AuthRoutes routes = AuthRoutes();

  AuthModule({
    required super.appModel,
  }) : api = AuthApi(appModel: appModel);
}
