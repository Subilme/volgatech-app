import 'dart:io';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

mixin BottomSheetMixin {
  final ValueNotifier<bool> _isCanClosePageWithSwipe = ValueNotifier(true);

  // Использовать, если нужно чтобы длинное тело BottomSheet
  // не закрывалось сразу после свайпа вниз
  Widget wrapBottomSheetWithScrollNotification({
    required Widget child,
    ScrollController? controller,
  }) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels > 20) {
          _isCanClosePageWithSwipe.value = false;
        }
        return !_isCanClosePageWithSwipe.value;
      },
      child: NotificationListener<ScrollEndNotification>(
        onNotification: (notification) {
          _isCanClosePageWithSwipe.value = notification.metrics.pixels == 0;
          return false;
        },
        child: ValueListenableBuilder(
          builder: (context, value, child) {
            var scrollView = SingleChildScrollView(
              controller: controller,
              physics: const ClampingScrollPhysics(),
              child: child,
            );
            return Platform.isIOS
                ? ScrollConfiguration(
                    behavior: const ScrollBehavior(), child: scrollView)
                : scrollView;
          },
          valueListenable: _isCanClosePageWithSwipe,
          child: child,
        ),
      ),
    );
  }

  Future<dynamic> showAppBottomSheet({
    required BuildContext context,
    required Widget child,
    Widget? title,
    EdgeInsets? contentPadding,
    bool useRootNavigator = false,
  }) async {
    return showCupertinoModalBottomSheet(
      bounce: false,
      context: context,
      useRootNavigator: useRootNavigator,
      barrierColor: Colors.transparent,
      backgroundColor: AppColors.surfaceColor,
      topRadius: const Radius.circular(32),
      builder: (context) => Material(
        color: AppColors.surfaceColor,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              child,
              bottomSheetHeader(
                context,
                title: title,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheetHeader(
    BuildContext context, {
    Widget? title,
    EdgeInsets? buttonPadding,
  }) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        width: 43,
        height: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }
}
