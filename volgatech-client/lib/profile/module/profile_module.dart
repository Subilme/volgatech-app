import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/profile/model/profile_api.dart';

class ProfileModule extends BaseAppModule {
  final ProfileApi api;

  ProfileModule({
    required super.appModel,
  }) : api = ProfileApi(appModel: appModel);
}
