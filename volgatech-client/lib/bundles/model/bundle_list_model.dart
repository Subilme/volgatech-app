import 'package:volgatech_client/bundles/model/bundle_api.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_events.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/category/model/category_api.dart';
import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/category/model/entities/category_events.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';

class BundleListModel extends ListModel<BundleInfo> with SearchFilter {
  BundleApi get api => appModel.bundleModule.api;

  CategoryApi get categoryApi => appModel.categoryModule.api;

  bool groupItemsByCategory = false;

  List<Category> categories = [];

  BundleListModel({required super.appModel});

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();

    addSubscription(
      eventBus.on<BundleUpdatedEvent>().listen((event) {
        reloadData();
      }),
    );
    addSubscription(
      eventBus.on<BundleDeletedEvent>().listen((event) {
        reloadData();
      }),
    );
    addSubscription(
      eventBus.on<CategoryUpdatedEvent>().listen((event) {
        if (groupItemsByCategory) {
          reloadData();
        }
      }),
    );
    addSubscription(
      eventBus.on<CategoryDeletedEvent>().listen((event) {
        if (groupItemsByCategory) {
          reloadData();
        }
      }),
    );
  }

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    categories.clear();
    if (groupItemsByCategory) {
      await _loadCategories();
    }

    var response = await api.loadBundleList(
      searchString: searchString,
      groupItems: groupItemsByCategory,
    );
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onNextItemsLoaded(response.result!, loadingUuid);
    }
  }

  Future<void> _loadCategories() async {
    var response = await categoryApi.loadCategoryList();
    if (!response.isError) {
      categories = response.result!;
    }
  }

  Future<bool> deleteCategory(Category category) async {
    var response = await categoryApi.deleteCategory(
      categoryId: category.categoryId,
    );

    if (response.isError) {
      addError(response.error!);
      return false;
    }

    appModel.eventBus.fire(BundleDeletedEvent(this));
    return true;
  }
}
