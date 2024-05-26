import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_events.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/projects/model/entities/project_events.dart';
import 'package:volgatech_client/responsible/model/responsible_api.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/model/models/base_data_model.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';
import 'package:volgatech_client/storage/model/storage_api.dart';

enum ReportType {
  storage,
  responsible,
  bundleItem;

  @override
  String toString() {
    switch (this) {
      case ReportType.storage:
        return "Места хранения";
      case ReportType.responsible:
        return "Ответственные";
      case ReportType.bundleItem:
        return "Компоненты";
    }
  }
}

class ReportModel extends BaseDataModel with SearchFilter {
  ReportType type = ReportType.storage;

  List<Storage> storages = [];
  Storage? storageParent;

  List<Responsible> responsibles = [];
  List<BundleItemInfo> bundles = [];

  StorageApi get storageApi => appModel.storageModule.api;

  ResponsibleApi get responsibleApi => appModel.responsibleModule.api;

  BundleApi get bundleApi => appModel.bundleModule.api;

  bool get noData =>
      (type == ReportType.storage && storages.isEmpty) ||
      (type == ReportType.responsible && responsibles.isEmpty);

  ReportModel({required super.appModel});

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();

    addSubscription(
      eventBus.on<BundleItemUpdatedEvent>().listen((event) {
        reloadData();
      }),
    );
    addSubscription(
      eventBus.on<BundleItemDeletedEvent>().listen((event) {
        reloadData();
      }),
    );
  }

  @override
  Future<void> loadData() async {
    if (isLoading) {
      return;
    }
    isLoading = true;

    if (type == ReportType.storage) {
      await loadStorageList();
    } else if (type == ReportType.responsible) {
      await loadResponsibleList();
    } else {
      await loadBundleItemList();
    }

    isLoading = false;
    notifyModelListeners();
  }

  Future<void> loadStorageList() async {
    var response = await storageApi.loadStorageList(
      searchString: searchString,
      parentId: storageParent?.storageId,
      onlySuperStorage: storageParent == null ? true : false,
    );

    if (response.isError) {
      onLoadingError(response.error!);
      return;
    }

    storages = response.result ?? [];
    appModel.storageModule.storages = response.result ?? [];
  }

  Future<void> createStorage(Storage newStorage) async {
    var response = await storageApi.createStorage(
      name: newStorage.name,
      parentId: newStorage.parentStorage?.storageId,
    );

    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      appModel.eventBus.fire(ProjectUpdatedEvent(this));
    }
  }

  Future<void> loadResponsibleList() async {
    var response = await responsibleApi.loadResponsibleList(
      searchString: searchString,
    );

    if (response.isError) {
      onLoadingError(response.error!);
      return;
    }

    responsibles = response.result ?? [];
    appModel.responsibleModule.responsibles = response.result ?? [];
  }

  Future<void> createResponsible(String name) async {
    var response = await responsibleApi.createResponsible(name: name);

    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      reloadData();
    }
  }

  Future<void> loadBundleItemList() async {
    var response = await bundleApi.loadBundleItemList(
      searchString: searchString,
    );

    if (response.isError) {
      onLoadingError(response.error!);
      return;
    }

    bundles = response.result ?? [];
  }

  Future<void> createBundleItem(BundleItemInfo bundleItem) async {
    var response = await bundleApi.createBundleItem(
      name: bundleItem.name!,
      count: bundleItem.count,
    );

    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      reloadData();
    }
  }
}
