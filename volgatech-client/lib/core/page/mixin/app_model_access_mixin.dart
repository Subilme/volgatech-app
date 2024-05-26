import 'package:volgatech_client/core/model/api/app_api.dart';
import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/core/model/app_model.dart';
import 'package:volgatech_client/core/model/app_user.dart';
import 'package:volgatech_client/core/page/mixin/module_fast_access_mixin.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

mixin AppModelAccessMixin<T extends StatefulWidget>
    on State<T>, ModuleFastAccessMixin {
  late final AppModel appModel = context.read<AppModel>();
  late final AppUser appUser = appModel.appUser;
  late final AppApi appApi = appModel.appApi;
  late final EventBus eventBus = appModel.eventBus;
  late final ThemeBuilder themeBuilder = context.read<ThemeBuilder>();

  @override
  TModule getModule<TModule extends BaseAppModule>() =>
      appModel.getModule<TModule>();
}
