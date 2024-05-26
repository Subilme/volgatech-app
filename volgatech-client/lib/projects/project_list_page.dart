import 'package:flutter/material.dart';
import 'package:volgatech_client/core/page/base_list_view_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/view/widgets/base_alert_dialog.dart';
import 'package:volgatech_client/projects/create_edit_project_form_page.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';
import 'package:volgatech_client/projects/model/entities/project_events.dart';
import 'package:volgatech_client/projects/model/project_list_model.dart';
import 'package:volgatech_client/projects/view/project_list_item.dart';

class ProjectListPage extends BasePage {
  const ProjectListPage({super.key});

  @override
  _ProjectListPageState createState() => _ProjectListPageState();
}

class _ProjectListPageState
    extends BaseListViewPageState<ProjectListPage, ProjectListModel> {
  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Column(
      children: [
        if (model.isAllLoaded && !model.hasError && appUser.canAddEdit)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 400, vertical: 20),
            child: ElevatedButton(
              onPressed: _addProject,
              child: const Text("Создать новый проект"),
            ),
          ),
        Expanded(child: super.decorateBody(context, body)),
      ],
    );
  }

  @override
  Widget buildListItemImpl(BuildContext context, int index) => ProjectListItem(
        project: model.items[index],
        onEdit: _editProject,
        onDelete: _deleteProject,
      );

  @override
  Widget buildSeparator({
    BuildContext? context,
    int? index,
    bool shouldBuild = true,
  }) =>
      const SizedBox(height: 16);

  @override
  ProjectListModel? createModel() => ProjectListModel(appModel: appModel);

  @override
  void onListItemTap(BuildContext context, index) {
    Navigator.of(context).push(
      projectModule.routes.projectDetailRoute(
        projectId: model.items[index].projectId,
      ),
    );
  }

  void _addProject() {
    showDialog(
      context: context,
      useRootNavigator: false,
      builder: (context) => const CreateEditProjectFormPage(),
    );
  }

  void _editProject(Project project) async {
    showDialog(
      context: context,
      builder: (context) => CreateEditProjectFormPage(project: project),
    );
  }

  void _deleteProject(Project project) async {
    var result = await BaseAlertDialog.showDialog(
      context: context,
      title: "Вы действительно хотите удалить проект?",
      onPositiveButtonPressed: () => Navigator.of(context).pop(true),
      onNegativeButtonPressed: () => Navigator.of(context).pop(false),
    );

    if (result == true) {
      showLoadingIndicator();
      var success = await model.deleteProject(project);
      hideLoadingIndicator();

      if (success) {
        showMessage(message: "Проект удален");
        eventBus.fire(ProjectDeletedEvent(this));
      }
    }
  }
}
