import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/report/module/report_routes.dart';

class ReportModule extends BaseAppModule {
  final ReportRoutes routes = ReportRoutes();

  ReportModule({required super.appModel});
}
