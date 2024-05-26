import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/storage/model/entities/storages_event.dart';
import 'package:volgatech_client/storage/model/storage_api.dart';

class StorageDetailsModel extends ListModel<BundleItemInfo> {
  Storage storage;

  StorageApi get api => appModel.storageModule.api;

  StorageDetailsModel({
    required super.appModel,
    required this.storage,
  });

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();

    addSubscription(
      eventBus.on<StorageUpdatedEvent>().listen((event) {
        reloadData();
      }),
    );
  }

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    var response = await api.loadBundleItemListForStorage(
      storageId: storage.storageId,
    );

    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onNextItemsLoaded(response.result!, loadingUuid);
    }
  }
}
