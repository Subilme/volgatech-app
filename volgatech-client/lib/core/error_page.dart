import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volgatech_client/core/model/extension/iterable_extension.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';
import 'package:volgatech_client/core/view/extension/simple_padding_extension.dart';

class ErrorPage extends StatefulWidget {
  final String error;
  final Future<void> Function() onRetry;

  const ErrorPage({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  bool isLoading = false;
  final backgroundColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLogoImage(context),
          Text(
            widget.error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ).bottomPadding(30),
          if (isLoading)
            _buildLoader(context)
          else
            _buildButton(context),
        ].separate((index, length) => const SizedBox(height: 30)).toList(),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return SizedBox(
      width: 400,
      child: ElevatedButton(
        style: const ButtonStyle(
          elevation: MaterialStatePropertyAll(0),
        ),
        onPressed: isLoading
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await widget.onRetry.call();
                setState(() {
                  isLoading = false;
                });
              },
        child: const Text("Попробовать снова"),
      ),
    );
  }

  Widget _buildLogoImage(BuildContext context) {
    return SizedBox(
      height: 300,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipOval(
          child: Image.asset(AssetsCatalog.logo),
        ),
      ),
    );
  }

  Widget _buildLoader(BuildContext context) {
    return Center(
      child: Platform.isAndroid
          ? const SizedBox(
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(),
            )
          : const CupertinoActivityIndicator(
              radius: 25,
            ),
    );
  }
}
