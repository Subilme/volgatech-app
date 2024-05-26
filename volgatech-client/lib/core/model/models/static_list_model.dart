import 'package:volgatech_client/core/model/models/list_model.dart';


class StaticListModel<T> extends ListModel<T> {
  StaticListModel({
    required super.appModel,
    super.items,
  });

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    isAllLoaded = true;
    isLoading = false;
  }
}
