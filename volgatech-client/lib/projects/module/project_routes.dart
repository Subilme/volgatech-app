import 'package:flutter/material.dart';
import 'package:volgatech_client/core/no_animation_material_page_route.dart';
import 'package:volgatech_client/projects/project_detail_page.dart';
import 'package:volgatech_client/projects/project_list_page.dart';

class ProjectRoutes {
  NoAnimationMaterialPageRoute projectListRoute() =>
      NoAnimationMaterialPageRoute(
        builder: (context) => const ProjectListPage(),
        settings: const RouteSettings(
          arguments: {'screen_name': 'App_ProjectListPage'},
        ),
      );

  NoAnimationMaterialPageRoute projectDetailRoute({required int projectId}) =>
      NoAnimationMaterialPageRoute(
        builder: (context) => ProjectDetailPage(projectId: projectId),
        settings: const RouteSettings(
          arguments: {'screen_name': 'App_ProjectDetailPage'},
        ),
      );
}
