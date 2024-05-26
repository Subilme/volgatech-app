import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volgatech_client/core/model/helpers/assets_catalog.dart';
import 'package:volgatech_client/core/theme/theme_builder.dart';

class AppSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFocusChanged;
  final ValueChanged<String>? onSubmitted;

  final String initString;

  const AppSearchBar({
    super.key,
    this.onChanged,
    this.onFocusChanged,
    this.onSubmitted,
    this.initString = '',
  });

  @override
  AppSearchBarState createState() => AppSearchBarState();
}

class AppSearchBarState extends State<AppSearchBar> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    _searchController.text = widget.initString;
    _searchFocusNode.addListener(() {
      widget.onFocusChanged?.call();
      setState(() {});
    });
    _searchController.addListener(() {
      if (_searchController.text.isNotEmpty) setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey.withOpacity(0.07),
            blurRadius: 18.0,
            offset: const Offset(0.0, 1.0),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        onChanged: _onSearch,
        onSubmitted: _onSubmitted,
        decoration: textFieldDecoration(),
      ),
    );
  }

  InputDecoration textFieldDecoration() {
    return InputDecoration(
      fillColor: AppColors.white,
      prefixIconConstraints: BoxConstraints.tight(const Size(56, 36)),
      prefixIcon: _searchFocusNode.hasFocus
          ? null
          : const SizedBox(
              height: 24,
              width: 24,
              child: Icon(
                Icons.search,
                color: AppColors.grey,
              ),
            ),
      isDense: true,
      hintText: 'Поиск',
      hintStyle:
          AppTextStyle.body1.copyWith(color: AppColors.grey, height: 1.7),
      suffixIconConstraints: BoxConstraints.tight(const Size(56, 36)),
      suffixIcon: !isSearchActive
          ? null
          : CupertinoButton(
              minSize: 24,
              padding: EdgeInsets.zero,
              onPressed: () {
                clear();
                _searchFocusNode.unfocus();
              },
              child: Image.asset(
                AssetsCatalog.icCancel,
                color: AppColors.secondaryColor,
              ),
            ),
    );
  }

  void _onSearch(String searchString) {
    widget.onChanged?.call(searchString);
  }

  void _onSubmitted(String searchString) {
    _searchFocusNode.unfocus();
    widget.onSubmitted?.call(searchString);
  }

  void clear() {
    _searchController.clear();
    widget.onChanged?.call('');
  }

  bool get isSearchActive {
    return _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
  }
}
