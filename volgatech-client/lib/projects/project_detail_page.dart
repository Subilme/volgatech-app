import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/page/details/base_item_details_rowed_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';
import 'package:volgatech_client/core/view/widgets/base_alert_dialog.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';
import 'package:volgatech_client/projects/create_edit_project_form_page.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';
import 'package:volgatech_client/projects/model/entities/project_events.dart';
import 'package:volgatech_client/projects/model/project_detail_model.dart';

enum PopupMenuOptions {
  edit,
  delete,
}

class ProjectDetailPage extends BasePage {
  final int projectId;

  const ProjectDetailPage({
    super.key,
    required this.projectId,
  });

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends BaseItemDetailsRowedPageState<
    ProjectDetailPage, ProjectDetailModel> {
  @override
  void initState() {
    super.initState();

    eventBus.on<ProjectUpdatedEvent>().listen((event) {
      reloadItem();
    });
  }

  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: super.decorateBody(context, body),
        ),
      ],
    );
  }

  @override
  List<Widget> buildItemDetailsRows(BuildContext context) {
    return [
      if (model.item!.responsible != null)
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: "Ответственный: ",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              TextSpan(text: model.item!.responsible!.name),
            ],
          ),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      if (model.item!.description?.isNotEmpty ?? false)
        Text(
          model.item!.description!,
        ),
      const Text(
        "Компоненты, используемые в проекте:",
        style: AppTextStyle.title,
      ),
      ...model.item!.bundleItems.map<Widget>(
        (e) => CardWidget(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(e.name ?? "Компонент #${e.bundleItemInfoId}"),
              const SizedBox(height: 6),
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: "Количество: "),
                    TextSpan(
                      text: "${e.count} шт.",
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                style: AppTextStyle.small,
              ),
            ],
          ),
        ),
      ),
    ].separate((index, length) => const SizedBox(height: 12)).toList();
  }

  Widget _buildHeader(BuildContext context) {
    if (model.isLoading) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.fromLTRB(400, 20, 400, 0),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 50),
              Flexible(
                child: Text(
                  model.item?.name ?? "#${model.item?.projectId}",
                  style: Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 50),
            ],
          ),
          Row(
            children: [
              const CustomBackButton(),
              const Spacer(),
              if (appUser.canAddEdit)
                PopupMenuButton(
                  onSelected: (value) async {
                    if (value == PopupMenuOptions.edit) {
                      var result = await showDialog(
                        context: context,
                        builder: (context) => CreateEditProjectFormPage(
                          project: model.item,
                        ),
                      );

                      if (result is Project) {
                        showMessage(message: "Проект изменен");
                        model.updateItem(result);
                      }
                    } else {
                      var result = await BaseAlertDialog.showDialog(
                        context: context,
                        title: "Вы действительно хотите удалить проект?",
                        onPositiveButtonPressed: () =>
                            Navigator.of(context).pop(true),
                        onNegativeButtonPressed: () =>
                            Navigator.of(context).pop(false),
                      );

                      if (result == true) {
                        showLoadingIndicator();
                        var success = await model.deleteProject();
                        if (success) {
                          Navigator.of(context).pop();
                          eventBus.fire(ProjectDeletedEvent(this));
                          showMessage(message: "Проект удален");
                        }
                        hideLoadingIndicator();
                      }
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: PopupMenuOptions.edit,
                      child: Row(
                        children: [
                          const Icon(Icons.edit).rightPadding(6),
                          const Text("Редактировать"),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: PopupMenuOptions.delete,
                      child: Row(
                        children: [
                          const Icon(Icons.delete).rightPadding(6),
                          const Text("Удалить"),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ],
      ),
    );
  }

  @override
  ProjectDetailModel? createModel() => ProjectDetailModel(
        appModel: appModel,
        projectId: widget.projectId,
      );

  @override
  EdgeInsets get itemDetailsPadding => const EdgeInsets.symmetric(
        horizontal: 400,
        vertical: 20,
      );
}
