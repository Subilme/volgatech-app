import 'package:flutter/material.dart';
import 'package:volgatech_client/bundles/bundle_details_page.dart';
import 'package:volgatech_client/bundles/bundle_item_details_page.dart';
import 'package:volgatech_client/bundles/bundle_list_page.dart';
import 'package:volgatech_client/core/no_animation_material_page_route.dart';

class BundleRoutes {
  NoAnimationMaterialPageRoute bundleDetailsRoute({required int bundleId}) =>
      NoAnimationMaterialPageRoute(
        builder: (context) => BundleDetailsPage(bundleId: bundleId),
        settings: const RouteSettings(
          arguments: {'screen_name': 'App_BundleDetailsPage'},
        ),
      );

  NoAnimationMaterialPageRoute bundleListRoute() =>
      NoAnimationMaterialPageRoute(
        builder: (context) => const BundleListPage(),
        settings: const RouteSettings(
          arguments: {'screen_name': 'App_BundleListPage'},
        ),
      );

  NoAnimationMaterialPageRoute bundleItemDetailsRoute({
    required int bundleItemInfoId,
  }) =>
      NoAnimationMaterialPageRoute(
        builder: (context) => BundleItemDetailsPage(
          bundleItemInfoId: bundleItemInfoId,
        ),
      );
}
