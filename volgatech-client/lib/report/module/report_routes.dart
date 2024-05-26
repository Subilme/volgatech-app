import 'package:flutter/material.dart';
import 'package:volgatech_client/core/no_animation_material_page_route.dart';
import 'package:volgatech_client/report/report_page.dart';

class ReportRoutes {
  NoAnimationMaterialPageRoute reportRoute() => NoAnimationMaterialPageRoute(
        builder: (context) => const ReportPage(),
        settings: const RouteSettings(
          arguments: {'screen_name': 'App_ReportPage'},
        ),
      );
}
