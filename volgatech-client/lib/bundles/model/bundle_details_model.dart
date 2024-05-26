import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/model/entities/bundle.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_events.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/core/model/models/item_model.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';

class BundleDetailsModel extends ItemModel<BundleInfo> {
  final int bundleId;

  BundleApi get api => appModel.bundleModule.api;

  BundleDetailsModel({
    required super.appModel,
    required this.bundleId,
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
    var response = await api.loadBundleDetails(itemId: bundleId);

    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onItemLoaded(response.result!);
    }
  }

  void changeBundleItemStorage(Bundle bundle, Storage storage) async {
    var response = await api.changeBundleStorage(
      bundleId: bundle.bundleId,
      storageId: storage.storageId,
    );
    if (response.isError) {
      addError(response.error!);
    } else {
      bundle.storage = storage;
      notifyModelListeners();
    }
  }

  Future<bool> deleteBundleItem() async {
    var response = await api.deleteBundle(
      bundleId: item!.bundleInfoId,
    );

    if (response.isError) {
      onLoadingError(response.error!);
      return false;
    }

    return true;
  }
}
