import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'strings.dart';

class KimikoConstants {
  const KimikoConstants._();

  static const borderSideWidth = 1.0, minPasswordLength = 6;

  static final borderRadiusSmall = BorderRadius.circular(3),
      borderRadius = BorderRadius.circular(6),
      borderRadiusBig = BorderRadius.circular(8),
      borderRadiusHuge = BorderRadius.circular(12.5);

  static const bodyColor = Color(0xff2E384D),
      displayColor = Color(0xFF2E3C7A),
      disabledColor = Color(0xff8C98A9),
      primaryColor = Color(0xFF556197),
      primaryColorDark = Color(0xff182E8D),
      primaryColorLight = Color(0xFF8392D3),
      secondaryColor = Color(0xffFFE066),
      goodColor = Color(0xff78e08f),
      errorColor = Color(0xffFF7C7C),
      back = Color(0xff02020A),
      extraLight = Color(0xffDAE2DF),
      scaffoldBackgroundColor = Color(0xffF2F5FF),
      surfaceDark = Color(0xE022262C),
      _primaryColorDark = Color(0xFF191E25);

  static final typo = Typography.blackRedmond.apply(
        bodyColor: bodyColor,
        displayColor: displayColor,
        fontFamily: KimikoStrings.signikaFontFamily,
      ),
      theme = ThemeData(
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        typography: Typography.material2018(black: typo),
        // textTheme: typo,
        shadowColor: const Color(0x45567d8f),
        primaryColor: primaryColor,
        primaryColorDark: primaryColorDark,
        primaryColorLight: primaryColorLight,
        iconTheme: const IconThemeData(color: Color(0xFF556197), size: 20),
        tabBarTheme: TabBarTheme(
          labelColor: bodyColor,
          unselectedLabelColor: disabledColor,
          labelPadding: const EdgeInsets.only(bottom: 7.5),
          labelStyle: typo.titleLarge,
          unselectedLabelStyle: typo.titleLarge,
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          backgroundColor: Colors.white,
          titleTextStyle: typo.titleLarge,
          contentTextStyle: typo.bodyMedium,
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: typo.bodyMedium,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(primaryColor),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: borderRadius)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 20, horizontal: 24)),
            elevation: MaterialStateProperty.all(1),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: scaffoldBackgroundColor,
          behavior: SnackBarBehavior.floating,
          contentTextStyle: typo.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: KimikoStrings.hpFontFamily,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          surface: Color(0xffF9FAFF),
          onSurface: Color(0xff89898f),
        ).copyWith(background: Colors.white), // primarySwatch: Colors.blue,
      );

  static const defaultSysStyle = SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white60,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      defaultSysStyleDark = SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: surfaceDark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: _primaryColorDark,
        systemNavigationBarIconBrightness: Brightness.dark,
      );

  static final overlayStyle = SystemUiOverlayStyle(
    statusBarColor:
        KimikoConstants.theme.scaffoldBackgroundColor.withOpacity(.5),
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.white,
  );
}
