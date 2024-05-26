import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/module/bundle_routes.dart';
import 'package:volgatech_client/core/model/app/module/base_app_module.dart';

class BundleModule extends BaseAppModule {
  final BundleApi api;
  final BundleRoutes routes = BundleRoutes();

  BundleModule({
    required super.appModel,
  }) : api = BundleApi(appModel: appModel);
}
