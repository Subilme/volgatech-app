import 'package:flutter/widgets.dart';
import 'package:volgatech_client/auth/module/auth_module.dart';
import 'package:volgatech_client/bundles/module/bundle_module.dart';
import 'package:volgatech_client/category/module/category_module.dart';
import 'package:volgatech_client/core/model/app/module/base_app_module.dart';
import 'package:volgatech_client/profile/module/profile_module.dart';
import 'package:volgatech_client/projects/module/project_module.dart';
import 'package:volgatech_client/report/module/report_module.dart';
import 'package:volgatech_client/responsible/module/responsible_module.dart';
import 'package:volgatech_client/storage/module/storage_module.dart';

mixin ModuleFastAccessMixin {
  @required
  T getModule<T extends BaseAppModule>();

  AuthModule get authModule => getModule<AuthModule>();

  BundleModule get bundleModule => getModule<BundleModule>();

  ProfileModule get profileModule => getModule<ProfileModule>();

  CategoryModule get categoryModule => getModule<CategoryModule>();

  ProjectModule get projectModule => getModule<ProjectModule>();

  ReportModule get reportModule => getModule<ReportModule>();

  ResponsibleModule get responsibleModule => getModule<ResponsibleModule>();

  StorageModule get storageModule => getModule<StorageModule>();
}
