import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/storage/model/storage_api.dart';
import 'package:volgatech_client/storage/module/storage_routes.dart';

class StorageModule extends BaseAppModule {
  final StorageApi api;
  final StorageRoutes routes = StorageRoutes();

  List<Storage> storages = [];

  StorageModule({
    required super.appModel,
  }) : api = StorageApi(appModel: appModel);

  @override
  Future<void> initComponent() async {
    await loadStorageList();

    super.initComponent();
  }

  Future<void> loadStorageList() async {
    var response = await api.loadStorageList();

    if (!response.isError) {
      storages = response.result ?? [];
    }
  }
}
