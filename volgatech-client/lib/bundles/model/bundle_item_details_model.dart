import 'package:volgatech_client/bundles/model/entities/bundle_events.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item.dart';
import 'package:volgatech_client/bundles/model/entities/functional_type.dart';
import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/model/models/item_model.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';

class BundleItemDetailsModel extends ItemModel<BundleItemInfo> {
  final int bundleItemInfoId;

  BundleApi get api => appModel.bundleModule.api;

  List<Storage> storages = [];
  List<Project> projects = [];

  BundleItemDetailsModel({
    required super.appModel,
    required this.bundleItemInfoId,
  });

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();

    addSubscription(
      eventBus.on<BundleUpdatedEvent>().listen((event) {
        reloadData();
      }),
    );
  }

  @override
  Future<void> loadItemData() async {
    var response = await api.loadBundleItemDetails(
      bundleItemInfoId: bundleItemInfoId,
    );
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onItemLoaded(response.result!);
    }
  }

  Future<void> editBundleItem(BundleItemInfo bundleItem) async {
    var response = await api.editBundleItem(
      bundleItemId: item!.bundleItemInfoId,
      name: bundleItem.name!,
      count: bundleItem.count,
    );
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onItemLoaded(response.result!);
    }
  }

  Future<bool> deleteBundleItem() async {
    var response = await api.deleteBundleItem(
      bundleItemId: item!.bundleItemInfoId,
    );

    if (response.isError) {
      onLoadingError(response.error!);
      return false;
    }

    return true;
  }

  void changeBundleItemFunctional(
    BundleItem bundleItem,
    FunctionalType type,
  ) async {
    var response = await api.changeBundleItemFunctional(
      bundleItemId: bundleItem.bundleItemId,
      type: type,
    );
    if (response.isError) {
      addError(response.error!);
    } else {
      bundleItem.functionalType = type;
      notifyModelListeners();
    }
  }

  void changeBundleItemStorage(
    BundleItem bundleItem,
    Storage storage,
  ) async {
    var response = await api.changeBundleItemStorage(
      bundleItemId: bundleItem.bundleItemId,
      storageId: storage.storageId,
    );
    if (response.isError) {
      addError(response.error!);
    } else {
      bundleItem.storage = storage;
      notifyModelListeners();
    }
  }

  void changeBundleItemProject(
    BundleItem bundleItem,
    Project project,
  ) async {
    var response = await api.changeBundleItemProject(
      bundleItemId: bundleItem.bundleItemId,
      projectId: project.projectId,
    );
    if (response.isError) {
      addError(response.error!);
    } else {
      bundleItem.project = response.result!.project;
      notifyModelListeners();
    }
  }
}
