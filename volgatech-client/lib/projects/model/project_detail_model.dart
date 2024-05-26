import 'package:volgatech_client/core/model/models/item_model.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';
import 'package:volgatech_client/projects/model/entities/project_events.dart';
import 'package:volgatech_client/projects/model/project_api.dart';

class ProjectDetailModel extends ItemModel<Project> {
  final int projectId;

  ProjectApi get api => appModel.projectModule.api;

  ProjectDetailModel({
    required super.appModel,
    required this.projectId,
  });

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();

    addSubscription(
      eventBus.on<ProjectUpdatedEvent>().listen((event) {
        reloadData();
      }),
    );
  }

  @override
  Future<void> loadItemData() async {
    var response = await api.loadProjectDetail(projectId: projectId);
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onItemLoaded(response.result!);
    }
  }

  Future<bool> deleteProject() async {
    var response = await api.deleteProject(
      projectId: item!.projectId,
    );
    if (response.isError) {
      onLoadingError(response.error!);
      return false;
    } else {
      return true;
    }
  }
}
