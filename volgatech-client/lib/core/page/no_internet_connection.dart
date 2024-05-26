import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/app/internet_monitor.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

class NoInternetConnection extends StatelessWidget {
  final InternetMonitor internetMonitor;

  const NoInternetConnection({
    super.key,
    required this.internetMonitor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: internetMonitor,
      builder: (context, value, child) => buildNoInternetAnimatedSwitcher(
        context,
        value,
        child,
      ),
      child: buildNoInternetSafeArea(context),
    );
  }

  Widget buildNoInternetSafeArea(BuildContext context) {
    return SafeArea(
      child: buildText(),
    );
  }

  Widget buildText() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                'Вы не в сети. Проверьте подключение к Интернету.',
                style: AppTextStyle.body1.copyWith(
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNoInternetAnimatedSwitcher(
      BuildContext context, bool value, Widget? child) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AnimatedSwitcher(
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (widget, animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(animation),
            child: widget,
          );
        },
        duration: const Duration(milliseconds: 250),
        child: (value) ? const SizedBox.shrink() : child,
      ),
    );
  }
}
