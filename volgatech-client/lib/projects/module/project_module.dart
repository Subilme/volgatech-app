import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/projects/model/project_api.dart';
import 'package:volgatech_client/projects/module/project_routes.dart';

class ProjectModule extends BaseAppModule {
  final ProjectApi api;
  final ProjectRoutes routes = ProjectRoutes();

  ProjectModule({
    required super.appModel,
  }) : api = ProjectApi(
          appModel: appModel,
        );
}
