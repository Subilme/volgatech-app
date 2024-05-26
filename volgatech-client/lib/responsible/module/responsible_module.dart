import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';
import 'package:volgatech_client/responsible/model/responsible_api.dart';
import 'package:volgatech_client/responsible/module/responsible_routes.dart';

class ResponsibleModule extends BaseAppModule {
  final ResponsibleApi api;
  final ResponsibleRoutes routes = ResponsibleRoutes();

  List<Responsible> responsibles = [];

  ResponsibleModule({
    required super.appModel,
  }) : api = ResponsibleApi(appModel: appModel);

  @override
  Future<void> initComponent() async {
    await loadResponsibleList();

    super.initComponent();
  }

  Future<void> loadResponsibleList() async {
    var response = await api.loadResponsibleList();

    if (!response.isError) {
      responsibles = response.result ?? [];
    }
  }
}
