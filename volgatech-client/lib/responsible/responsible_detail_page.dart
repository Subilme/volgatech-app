import 'package:flutter/material.dart';
import 'package:volgatech_client/core/page/base_list_view_page.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/widgets/card_widget.dart';
import 'package:volgatech_client/core/view/widgets/custom_back_button.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';
import 'package:volgatech_client/responsible/model/responsible_detail_model.dart';

class ResponsibleDetailPage extends BasePage {
  final Responsible responsible;

  const ResponsibleDetailPage({
    super.key,
    required this.responsible,
  });

  @override
  _ResponsibleDetailPageState createState() => _ResponsibleDetailPageState();
}

class _ResponsibleDetailPageState extends BaseListViewPageState<
    ResponsibleDetailPage, ResponsibleDetailModel> {
  @override
  bool get shouldProcessItemTap => false;

  @override
  Widget decorateBody(BuildContext context, Widget body) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(400, 20, 400, 0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 50),
                  Flexible(
                    child: Text(
                      model.responsible.name,
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 50),
                ],
              ),
              const CustomBackButton(),
            ],
          ),
        ),
        Expanded(
          child: super.decorateBody(context, body),
        ),
      ],
    );
  }

  @override
  Widget buildSeparator({
    BuildContext? context,
    int? index,
    bool shouldBuild = true,
  }) =>
      const SizedBox(height: 16);

  @override
  Widget buildListItemImpl(BuildContext context, int index) {
    return CardWidget(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            model.items[index].name ??
                "#${model.items[index].bundleItemInfoId}",
          ),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(text: "Количество: "),
                TextSpan(
                  text: "${model.items[index].count} шт.",
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ],
            ),
            style: AppTextStyle.small,
          ),
        ],
      ),
    );
  }

  @override
  ResponsibleDetailModel? createModel() => ResponsibleDetailModel(
        appModel: appModel,
        responsible: widget.responsible,
      );

  @override
  void onListItemTap(BuildContext context, index) {}
}
