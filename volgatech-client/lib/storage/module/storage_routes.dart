import 'package:volgatech_client/storage/model/entities/storage.dart';
import 'package:volgatech_client/core/no_animation_material_page_route.dart';
import 'package:volgatech_client/storage/storage_detail_page.dart';

class StorageRoutes {
  NoAnimationMaterialPageRoute storageDetailRoute({required Storage storage}) =>
      NoAnimationMaterialPageRoute(
        builder: (context) => StorageDetailPage(
          storage: storage,
        ),
      );
}
