import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';

class BundleItemListModel extends ListModel<BundleItemInfo> with SearchFilter {
  BundleApi get api => appModel.bundleModule.api;

  BundleItemListModel({required super.appModel});

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    var response = await api.loadBundleItemList(
      searchString: searchString,
    );
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onNextItemsLoaded(response.result!, loadingUuid);
    }
  }
}
