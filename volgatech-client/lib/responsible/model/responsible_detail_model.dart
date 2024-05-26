import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';
import 'package:volgatech_client/responsible/model/responsible_api.dart';

class ResponsibleDetailModel extends ListModel<BundleItemInfo> {
  final Responsible responsible;

  ResponsibleApi get api => appModel.responsibleModule.api;

  ResponsibleDetailModel({
    required super.appModel,
    required this.responsible,
  });

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    var response = await api.loadBundleItemListForResponsible(
      responsibleId: responsible.responsibleId,
    );

    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onNextItemsLoaded(response.result!, loadingUuid);
    }
  }
}
