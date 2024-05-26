import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  /// Базовые цвета
  static const Color black = Color(0xFF000000);
  static const Color midnightBlack = Color(0xFF111111);
  static const Color lightBlack = Color(0xFF121B35);
  static const Color white = Color(0xFFFFFFFF);
  static const Color green = Colors.teal;
  static const Color greenLight = Color(0xFFEBF5F5);
  static const Color red = Color(0xFFFF5A5A);
  static const Color darkBlue = Color(0xFF004097);
  static const Color skyBlue = Color(0xFFE8F2FF);
  static const Color lightGrey = Color(0xFFD9D9D9);
  static const Color skyGrey = Color(0xFFF0F3F6);
  static const Color mistGrey = Color(0xFFF7F8FA);
  static const Color brightGray = Color(0xFFEFEFEF);
  static const Color grey = Color(0xFFADB3BC);
  static const Color sonicSilver = Color(0xFF727677);
  static const Color midGrey = Color(0xFFC4C4C4);
  static const Color smokeGrey = Color(0xFF93939A);
  static const Color darkGrey = Color(0xFF3F3F3F);
  static const Color turquoise = Color(0xFF14C8C7);
  static const Color lightBlue = Colors.lightBlue;
  static const Color cyan = Colors.cyan;
  static const Color lavand = Color(0xFFF4F2FF);
  static const Color greenGrass = Color(0xFF5BB859);

  /// Основной цвет, который чаще всего отображается на экранах и компонентах
  /// приложения.
  static const Color primaryColor = turquoise;

  /// Цвет, который используется для контраста основного цвета (например в
  /// Notification(System) bar'е).
  static const Color primaryVariantColor = Color(0xFF4897FF);

  /// Вторичный цвет для FAB'ов, селекторов, слайдеров, переключателей,
  /// подсветки выделенного текста, прогрессбаров, ссылок и заголовков.
  static const Color secondaryColor = Color(0xFF0B485A);

  /// Цвет, который используется для контраста вторичного цвета (например
  /// текст внутри кнопки)
  static const Color secondaryVariantColor = Color(0xFF463ABA);

  /// Цвет фона отображается за скролящимся содержимым.
  static const Color backgroundColor = white;

  /// Цвет поверхности используется на карточках, bottomSheet и меню.
  static const Color surfaceColor = white;

  /// Цвет ошибки указывает на ошибки в компонентах, например недопустимый
  /// текст в текстовом поле.
  static const Color errorColor = red;

  /// Цвет [Scaffold] background.
  static const Color scaffoldBackgroundColor = white;

  /// The background color of [Dialog] elements.
  static const Color dialogBackground = white;

  /// Background theme color for the [AppBar].
  static const Color appBarBackground = AppColors.white;

  /// Background theme color for the [ProgressIndicator],
  /// [CircularProgressIndicator], [RefreshIndicator], [CupertinoActivityIndicator].
  static const Color updatingIndicatorColor = primaryColor;

  /// Цвета «on*» в основном применяются к тексту, значкам и штрихам.
  /// Иногда их наносят на поверхности.
  /// Такие цвета используются для того, чтобы элементы, использующие их, были
  /// четкими и разборчивыми по сравнению с цветами за ними.
  static const Color onPrimaryColor = white;
  static const Color onSecondaryColor = black;
  static const Color onBackgroundColor = black;
  static const Color onSurfaceColor = black;
  static const Color onErrorColor = white;

  /// Цвета для элементов
  static const Color defaultText = midnightBlack;
  static const Color divider = Color(0xFFCED2DC);
  static const Color border = secondaryColor;
  static const Color disabledBorder = Color(0xFFB9BECB);
  static const Color hint = Color(0xB58C95E6);
  static const Color pinKeyboardColor = Color(0xFF03A8B4);
  static const Color pinKeyboardPressedColor = Color(0xFF0B485A);
  static const Color pinCodeFieldColor = Color(0xFFC4C4C4);
  static const Color pinCodeFieldFilledColor = Color(0xFF0B485A);
}

class AppTextStyle {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    color: AppColors.defaultText,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle title2 = TextStyle(
    fontSize: 16,
    color: AppColors.defaultText,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 14,
    color: AppColors.defaultText,
  );
  static const TextStyle body2 = TextStyle(
    fontSize: 17,
    color: AppColors.defaultText,
  );

  static const TextStyle small = TextStyle(
    fontSize: 12,
    color: AppColors.defaultText,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle small2 = TextStyle(
    fontSize: 11,
    color: AppColors.defaultText,
  );

  static const TextStyle small3 = TextStyle(
    fontSize: 10,
    color: AppColors.defaultText,
  );

  static const TextStyle hyperLink = TextStyle(
    fontSize: 14,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primaryVariantColor,
    color: AppColors.primaryVariantColor,
  );
}

extension TextStyleExtension on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get normal => copyWith(fontWeight: FontWeight.normal);
}

/// Класс для формирования "визуальной темы" приложения
/// - внешний вид текстов
/// - внешний вид кнопок
/// - внешний вид полей ввода
/// - и т.д.
/// Позволяет в одном месте задать внешний вид бОльшей части стандарных
/// компонентов Flutter, и потом не дублировать код для их визуальной настройки.
class ThemeBuilder {
  static const double cardBorderRadius = 20.0;
  static const double defaultPadding = 12.0;
  static const double defaultSmallPadding = 6.0;

  static SystemUiOverlayStyle get systemUiOverlayStyle =>
      const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      );

  ThemeData buildThemeData() {
    var textTheme = _buildTextTheme();
    return ThemeData(
      useMaterial3: true,
      dialogBackgroundColor: AppColors.dialogBackground,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      primaryColor: AppColors.primaryColor,
      cupertinoOverrideTheme: const CupertinoThemeData(
        brightness: Brightness.light,
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(
            color: AppColors.black,
            fontSize: 21,
          ),
        ),
      ),
      dialogTheme: const DialogTheme(
        titleTextStyle: AppTextStyle.title,
        backgroundColor: AppColors.dialogBackground,
        surfaceTintColor: Colors.transparent,
      ),
      switchTheme: _buildSwitchThemeData(),
      textSelectionTheme: _buildTextSelectionThemeData(),
      appBarTheme: _buildAppBarTheme(),
      textTheme: textTheme,
      popupMenuTheme: _buildPopupMenuTheme(),
      elevatedButtonTheme: _buildElevatedButtonThemeData(),
      outlinedButtonTheme: _buildOutlinedButtonThemeData(),
      textButtonTheme: _buildTextButtonThemeData(),
      radioTheme: _buildRadioThemeData(),
      checkboxTheme: _buildCheckBoxThemeData(),
      inputDecorationTheme: _buildInputDecorationTheme(textTheme),
      pageTransitionsTheme: _buildPageTransitionsTheme(),
      floatingActionButtonTheme: _buildFloatingActionButtonThemeData(),
      tabBarTheme: _buildTabBarTheme(textTheme),
      dividerTheme: _buildDividerThemeData(),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        brightness: Brightness.light,
        background: AppColors.backgroundColor,
        error: AppColors.errorColor,
        onError: AppColors.onErrorColor,
        onBackground: AppColors.onBackgroundColor,
        surface: AppColors.surfaceColor,
        onPrimary: AppColors.onPrimaryColor,
        onSecondary: AppColors.onSecondaryColor,
        onSurface: AppColors.onSurfaceColor,
        primaryContainer: AppColors.primaryVariantColor,
        secondaryContainer: AppColors.secondaryVariantColor,
      ),
    );
  }

  TextTheme _buildTextTheme() {
    var textColor = AppColors.defaultText;
    return TextTheme(
      //Don't rewrite caption, overline, subtitle1, subtitle2 styles
      displayLarge: TextStyle(
        fontSize: 45,
        color: textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        color: textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 33,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: textColor,
      ),
    );
  }

  TextSelectionThemeData _buildTextSelectionThemeData() {
    return TextSelectionThemeData(
      cursorColor: AppColors.smokeGrey,
      selectionHandleColor: AppColors.primaryColor.withOpacity(0.7),
    );
  }

  SwitchThemeData _buildSwitchThemeData() {
    return SwitchThemeData(
      thumbColor: MaterialStateProperty.all(AppColors.white),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryColor;
        }
        return AppColors.lightGrey;
      }),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  AppBarTheme _buildAppBarTheme() {
    return const AppBarTheme(
      backgroundColor: AppColors.appBarBackground,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTextStyle.title2,
    );
  }

  DividerThemeData _buildDividerThemeData() {
    return const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    );
  }

  CheckboxThemeData _buildCheckBoxThemeData() {
    return CheckboxThemeData(
      checkColor: const MaterialStatePropertyAll(AppColors.primaryVariantColor),
      fillColor: MaterialStateProperty.all(Colors.transparent),
      side: MaterialStateBorderSide.resolveWith(
        (states) => const BorderSide(
          width: 1.0,
          color: AppColors.grey,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  RadioThemeData _buildRadioThemeData() {
    return RadioThemeData(
      fillColor: MaterialStateProperty.all(AppColors.primaryVariantColor),
    );
  }

  ElevatedButtonThemeData _buildElevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        backgroundColor: AppColors.secondaryColor,
        foregroundColor: AppColors.white,
        disabledBackgroundColor: AppColors.greenLight,
        disabledForegroundColor: AppColors.white,
        textStyle: AppTextStyle.body1,
        elevation: 0.0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        minimumSize: const Size.fromHeight(42.0),
      ),
    );
  }

  OutlinedButtonThemeData _buildOutlinedButtonThemeData() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(35.0),
        ),
        minimumSize: const Size(100, 24),
        side: const BorderSide(width: 1, color: AppColors.primaryColor),
      ),
    );
  }

  static ButtonStyle get miniButtonStyle {
    return ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      minimumSize: const MaterialStatePropertyAll(Size.fromHeight(26.0)),
      padding: MaterialStateProperty.all(EdgeInsets.zero),
      textStyle: MaterialStateProperty.all(
        AppTextStyle.small.copyWith(
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    );
  }

  TextButtonThemeData _buildTextButtonThemeData() {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all(const EdgeInsets.all(4)),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 19.0),
        ),
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return AppColors.secondaryColor;
          }
          if (states.contains(MaterialState.pressed)) {
            return AppColors.secondaryColor;
          }
          return AppColors.secondaryColor;
        }),
        splashFactory: NoSplash.splashFactory,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  InputDecorationTheme _buildInputDecorationTheme(TextTheme textTheme) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        width: 0,
        color: Colors.transparent,
      ),
    );
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.mistGrey,
      border: border,
      enabledBorder: border,
      counterStyle: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
      disabledBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(color: AppColors.disabledBorder),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(
          color: AppColors.errorColor,
          width: 1,
        ),
      ),
      errorBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(
          color: AppColors.errorColor,
          width: 1,
        ),
      ),
      focusedBorder: border.copyWith(
        borderSide: border.borderSide.copyWith(
          color: AppColors.border,
          width: 1,
        ),
      ),
      hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.grey),
      labelStyle: textTheme.bodyMedium,
      errorStyle: textTheme.bodyMedium?.copyWith(color: AppColors.errorColor),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      isDense: true,
    );
  }

  PageTransitionsTheme _buildPageTransitionsTheme() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      },
    );
  }

  PopupMenuThemeData _buildPopupMenuTheme() {
    return PopupMenuThemeData(
      elevation: 8,
      color: AppColors.white,
      labelTextStyle: const MaterialStatePropertyAll(
        TextStyle(
          color: AppColors.onSurfaceColor,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }

  FloatingActionButtonThemeData _buildFloatingActionButtonThemeData() {
    return const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.secondaryColor,
    );
  }

  TabBarTheme _buildTabBarTheme(TextTheme textTheme) {
    return TabBarTheme(
      labelColor: AppColors.defaultText,
      unselectedLabelColor: AppColors.grey,
      labelStyle: AppTextStyle.small,
      unselectedLabelStyle: AppTextStyle.small,
      dividerColor: Colors.transparent,
      indicator: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }

  InputDecoration buildSearchInputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
      border: InputBorder.none,
      hintStyle: TextStyle(color: AppColors.hint),
      errorMaxLines: 1,
    );
  }

  /// Настройка темы для пикера даты
  /// Обязательно сгенерировать swatch цвета, т.к. [DatePickerDialog] использует
  /// почти весь пул цветов (например для выбранной даты используется 500
  /// значение цвета)
  Theme buildDatePickerTheme({
    required Widget child,
  }) {
    return Theme(
      data: ThemeData(
        colorSchemeSeed: AppColors.primaryColor,
        datePickerTheme: const DatePickerThemeData(
          surfaceTintColor: AppColors.white,
          backgroundColor: Colors.white,
        ),
      ),
      child: child,
    );
  }

  Theme buildDateYearTheme({
    required Widget child,
  }) {
    return Theme(
      data: ThemeData(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
          thickness: 0,
          endIndent: 0,
          indent: 0,
        ),
        dividerColor: Colors.red,
        colorSchemeSeed: AppColors.primaryColor,
        datePickerTheme: const DatePickerThemeData(
          surfaceTintColor: AppColors.white,
          backgroundColor: Colors.white,
        ),
      ),
      child: child,
    );
  }

  BoxDecoration buildCardDecoration(BuildContext context) => BoxDecoration(
        boxShadow: [
          buildDefaultShadow(context),
        ],
        color: AppColors.surfaceColor,
        borderRadius: BorderRadius.circular(cardBorderRadius),
      );

  BoxShadow buildDefaultShadow(BuildContext context) => BoxShadow(
        color: AppColors.darkGrey.withOpacity(0.07),
        blurRadius: 18.0,
        spreadRadius: 0.0,
        offset: const Offset(0.0, 1.0),
      );

  BoxDecoration buildCircleDecoration(BuildContext context) => BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          buildDefaultShadow(context),
        ],
        color: AppColors.surfaceColor,
      );
}
