import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';
import 'package:volgatech_client/projects/model/entities/project_events.dart';
import 'package:volgatech_client/projects/model/project_api.dart';

class ProjectListModel extends ListModel<Project> {
  ProjectApi get api => appModel.projectModule.api;

  ProjectListModel({required super.appModel});

  @override
  void subscribeToEvents() {
    super.subscribeToEvents();

    addSubscription(
      eventBus.on<ProjectUpdatedEvent>().listen((event) {
        reloadData();
      }),
    );
    addSubscription(
      eventBus.on<ProjectDeletedEvent>().listen((event) {
        reloadData();
      }),
    );
  }

  @override
  Future<void> loadNextItems(String? loadingUuid) async {
    var response = await api.loadProjectList();
    if (response.isError) {
      onLoadingError(response.error!);
    } else {
      onNextItemsLoaded(response.result!, loadingUuid);
    }
  }

  Future<bool> deleteProject(Project project) async {
    var response = await api.deleteProject(
      projectId: project.projectId,
    );
    if (response.isError) {
      onLoadingError(response.error!);
      return false;
    }

    return true;
  }
}
