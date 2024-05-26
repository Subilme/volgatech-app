import 'package:volgatech_client/category/model/category_api.dart';
import 'package:volgatech_client/core/model/app/module/base_app_module.dart';

class CategoryModule extends BaseAppModule {
  final CategoryApi api;

  CategoryModule({
    required super.appModel,
  }) : api = CategoryApi(
          appModel: appModel,
        );
}
