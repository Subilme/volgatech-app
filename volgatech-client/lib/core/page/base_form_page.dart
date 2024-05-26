import 'dart:core';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:volgatech_client/core/base_page_model_mixin.dart';
import 'package:volgatech_client/core/model/models/form_model.dart';
import 'package:volgatech_client/core/page/base_page.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

abstract class BaseFormPageState<T extends BasePage,
        TFormModel extends FormModel> extends BasePageState<T>
    with BasePageModelMixin<T, TFormModel> {
  final formKey = GlobalKey<FormState>();

  final AutoScrollController formScrollController = AutoScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );
  bool isFullScreenSizeForm = false;
  bool isFormSubmitting = false;
  double _maxPageHeight = 0;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  TFormModel get formModel => pageModel!;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var primaryController = PrimaryScrollController.of(context);
      formScrollController.parentController = primaryController;
    });
    super.initState();
  }

  /// Переопределить и реализовать отправку формы
  @protected
  Future<void> submitForm(BuildContext context);

  /// Переопределить и реализовать внешний вид формы
  @protected
  Widget buildForm(BuildContext context);

  @override
  Widget buildBody(BuildContext context) {
    return isFullScreenSizeForm
        ? buildFullScreenSizeFormBody(context)
        : buildDefaultFormBody(context);
  }

  @protected
  Widget buildDefaultFormBody(BuildContext context) {
    return SingleChildScrollView(
      padding: formPadding(context),
      controller: formScrollController,
      child: AutofillGroup(
        child: Form(
          autovalidateMode: autovalidateMode,
          key: formKey,
          child: SafeArea(
            child: buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget buildFullScreenSizeFormBody(BuildContext context) {
    return LayoutBuilder(
      builder: (context, boxSizing) {
        _maxPageHeight = max(boxSizing.maxHeight, _maxPageHeight);
        return SingleChildScrollView(
          controller: formScrollController,
          child: Container(
            width: boxSizing.maxWidth,
            constraints: BoxConstraints(
              minHeight: _maxPageHeight,
            ),
            padding: formPadding(context),
            child: Form(
              autovalidateMode: autovalidateMode,
              key: formKey,
              child: buildForm(context),
            ),
          ),
        );
      },
    );
  }

  EdgeInsets? formPadding(BuildContext context) => null;

  @override
  void dispose() {
    formScrollController.dispose();
    super.dispose();
  }

  @protected
  Future<void> trySubmitForm(BuildContext context) async {
    if (isFormSubmitting) {
      return;
    }
    isFormSubmitting = true;
    if (await validate()) {
      formKey.currentState?.save();
      FocusScope.of(context).unfocus();
      showLoadingIndicator();
      await submitForm(context);
      hideLoadingIndicator();
    }
    isFormSubmitting = false;
  }

  @protected
  Future<bool> validate() async {
    return formKey.currentState?.validate() ?? false;
  }
}
