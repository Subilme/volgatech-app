import 'package:volgatech_client/category/model/category_api.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';

class CategoryListModel extends ListModel<Category> with SearchFilter {
  CategoryApi get api => appModel.categoryModule.api;

  CategoryListModel({required super.appModel});

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    var response = await api.loadCategoryList();
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onNextItemsLoaded(response.result!, loadingUuid);
    }
  }
}
