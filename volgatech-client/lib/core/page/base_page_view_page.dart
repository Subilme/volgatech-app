import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:volgatech_client/core/model/models/list_model.dart';
import 'package:volgatech_client/core/page/base_infinity_scroll_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';

abstract class BasePageViewPageState<T extends BasePage, DPT extends ListModel>
    extends BaseInfinityScrollPageState<T, DPT> {
  final PageController _pageController = PageController();

  @override
  Widget buildBodyContent(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: fullItemCount,
      itemBuilder: (context, index) {
        return buildListItem(context, index);
      },
    );
  }
}
