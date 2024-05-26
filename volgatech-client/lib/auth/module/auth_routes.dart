import 'package:flutter/material.dart';
import 'package:volgatech_client/auth/auth_form_page.dart';
import 'package:volgatech_client/auth/register_form_page.dart';
import 'package:volgatech_client/core/no_animation_material_page_route.dart';

class AuthRoutes {
  NoAnimationMaterialPageRoute authFormRoute() =>
      NoAnimationMaterialPageRoute(
        builder: (context) => const AuthFormPage(),
        settings: const RouteSettings(
          arguments: {
            'screen_name': 'App_AuthFormPage',
          },
        ),
      );

  NoAnimationMaterialPageRoute registerFormRoute() =>
      NoAnimationMaterialPageRoute(
        builder: (context) => const RegisterFormPage(),
        settings: const RouteSettings(
          arguments: {
            'screen_name': 'App_RegisterFormPage',
          },
        ),
      );
}
