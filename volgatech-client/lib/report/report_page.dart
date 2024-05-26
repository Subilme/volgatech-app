import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/bundles/view/create_edit_bundle_item_alert.dart';
import 'package:volgatech_client/core/base_page_model_mixin.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/app_search_bar.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/report/model/report_model.dart';
import 'package:volgatech_client/responsible/view/create_edit_responsible_alert.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/storage/view/create_edit_storage_alert.dart';

class ReportPage extends BasePage {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends BasePageState<ReportPage>
    with BasePageModelMixin<ReportPage, ReportModel> {
  ReportModel get model => pageModel!;

  @override
  void initState() {
    super.initState();

    model.reloadData();
  }

  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 300, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              DropdownButtonFormField(
                value: model.type,
                items: ReportType.values
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  setState(() {
                    model.type = value;
                    model.storageParent = null;
                    model.searchString = "";
                  });
                  model.reloadData();
                },
              ).bottomPadding(16),
              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: AppSearchBar(
                      initString: model.searchString,
                      onChanged: _onSearch,
                      onSubmitted: _onSearch,
                    ).rightPadding(8),
                  ),
                  Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            appUser.canAddEdit ? null : AppColors.greenLight,
                      ),
                      onPressed: _onAddTap,
                      child: const Text("Добавить"),
                    ),
                  ),
                ],
              ),
            ],
          ).bottomPadding(15),
          Expanded(child: super.decorateBody(context, body)),
        ],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    if (model.isLoading) {
      return buildLoadingIndicator(context);
    }
    return model.noData
        ? buildEmptyItemPlaceholder(context)
        : buildContent(context);
  }

  Widget buildContent(BuildContext context) {
    return model.type == ReportType.storage
        ? _buildStorageList(context)
        : model.type == ReportType.responsible
            ? _buildResponsibleList(context)
            : _buildBundleItemList(context);
  }

  Widget _buildStorageList(BuildContext context) {
    if (model.storages.isEmpty && !model.isLoading) {
      return buildEmptyItemPlaceholder(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (model.storageParent != null)
          GestureDetector(
            onTap: () {
              setState(() => model.storageParent = null);
              model.reloadData();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset(AssetsCatalog.icArrowBack),
                ),
                Text(model.storageParent!.name),
              ],
            ),
          ),
        Flexible(
          child: ListView.separated(
            itemBuilder: (context, index) => CardWidget(
              padding: const EdgeInsets.all(12),
              child: GestureDetector(
                onTap: () {
                  if (model.storages[index].hasSubstorages) {
                    model.storageParent = model.storages[index];
                    model.reloadData();
                    return;
                  }
                  Navigator.of(context).push(
                    appModel.storageModule.routes.storageDetailRoute(
                      storage: model.storages[index],
                    ),
                  );
                },
                child: Text(model.storages[index].name),
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: model.storages.length,
          ),
        ),
      ],
    );
  }

  Widget _buildResponsibleList(BuildContext context) {
    if (model.responsibles.isEmpty && !model.isLoading) {
      return buildEmptyItemPlaceholder(context);
    }

    return ListView.separated(
      itemBuilder: (context, index) => CardWidget(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            appModel.responsibleModule.routes.responsibleDetailRoute(
              responsible: model.responsibles[index],
            ),
          ),
          child: Text(model.responsibles[index].name),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: model.responsibles.length,
    );
  }

  Widget _buildBundleItemList(BuildContext context) {
    if (model.bundles.isEmpty && !model.isLoading) {
      return buildEmptyItemPlaceholder(context);
    }

    return ListView.separated(
      itemBuilder: (context, index) => CardWidget(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () => Navigator.of(context).push(
            appModel.bundleModule.routes.bundleItemDetailsRoute(
              bundleItemInfoId: model.bundles[index].bundleItemInfoId,
            ),
          ),
          child: Text(
            model.bundles[index].name ??
                "Компонент #${model.bundles[index].bundleItemInfoId}",
          ),
        ),
      ),
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      padding: const EdgeInsets.symmetric(vertical: 20),
      itemCount: model.bundles.length,
    );
  }

  /// Плейсхолдер, который отображается, если данные сущности не были загружены
  Widget buildEmptyItemPlaceholder(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          model.hasError
              ? 'Ошибка загрузки'
              : model.noData
                  ? 'Список пуст'
                  : '',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }

  void _onSearch(String searchString) async {
    if (model.searchString.trim() == searchString.trim()) {
      return;
    }

    model.searchString = searchString;
    model.reloadData();
  }

  void _onAddTap() async {
    if (!appUser.canAddEdit) {
      showMessage(message: "У вас недостаточно прав");
      return;
    }

    if (model.type == ReportType.storage) {
      var result = await showDialog(
        context: context,
        builder: (context) => CreateEditStorageAlert(
          storages: storageModule.storages,
        ),
      );
      if (result is! Storage) {
        return;
      }

      showLoadingIndicator();
      model.createStorage(result);
      hideLoadingIndicator();
    } else if (model.type == ReportType.responsible) {
      var result = await showDialog(
        context: context,
        builder: (context) => CreateEditResponsibleAlert(),
      );
      if (result is! String || result.isEmpty) {
        return;
      }

      showLoadingIndicator();
      model.createResponsible(result);
      hideLoadingIndicator();
    } else if (model.type == ReportType.bundleItem) {
      var result = await showDialog(
        context: context,
        builder: (context) => const CreateEditBundleItemAlert(),
      );
      if (result is! BundleItemInfo) {
        return;
      }

      showLoadingIndicator();
      model.createBundleItem(result);
      hideLoadingIndicator();
    }
  }

  @override
  ReportModel? createModel() => ReportModel(appModel: appModel);
}
