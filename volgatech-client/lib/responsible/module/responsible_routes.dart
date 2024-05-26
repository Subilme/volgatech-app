import 'package:volgatech_client/core/no_animation_material_page_route.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';
import 'package:volgatech_client/responsible/responsible_detail_page.dart';

class ResponsibleRoutes {

  NoAnimationMaterialPageRoute responsibleDetailRoute({
    required Responsible responsible,
  }) =>
      NoAnimationMaterialPageRoute(
        builder: (context) => ResponsibleDetailPage(
          responsible: responsible,
        ),
      );

}