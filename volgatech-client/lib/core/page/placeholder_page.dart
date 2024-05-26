import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/app_user.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:provider/provider.dart';

/// Экран-заглушка "В разработке".
/// Используется как замена экранов, которые еще в разработке или еще не начаты.
/// Если на такие экраны есть переходы из других частей приложения.
class PlaceholderPage extends StatefulWidget {
  final String? title;

  const PlaceholderPage({
    this.title,
    super.key,
  });

  @override
  _PlaceholderPageState createState() => _PlaceholderPageState();
}

class _PlaceholderPageState extends State<PlaceholderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'В разработке',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: AppColors.white,
            ),
            onPressed: () => context.read<AppUser>().logout(),
          )
        ],
        elevation: 0,
        foregroundColor: AppColors.white,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xFF7A8AFF),
      body: Center(
        child: Image.asset(
          'assets/ic_in_developing.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
