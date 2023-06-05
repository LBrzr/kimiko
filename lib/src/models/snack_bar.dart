import 'package:flutter/material.dart';

import '/src/models/code.dart';
import '/src/resources/constants.dart';

/// Custom snack bar data model
///
/// With predefined shape and border color
/// Using [goodColor] for [SnackBarFromStyle.good] announcements
/// Using [badColor] for [SnackBarFromStyle.bad] announcements
/// Using [SnackBarFromStyle.code] for [Code] based announcements
class KimikoSnackBar extends SnackBar {
  static const defaultDuration = Duration(seconds: 3),
      defaultActionDuration = Duration(seconds: 7);

  factory KimikoSnackBar.good({
    Key? key,
    required String content,
    SnackBarAction? action,
    Duration? duration,
  }) =>
      KimikoSnackBar.fromColor(
        content: content,
        color: KimikoConstants.goodColor,
        key: key,
        action: action,
        duration: duration,
      );

  factory KimikoSnackBar.bad({
    Key? key,
    required String content,
    SnackBarAction? action,
    Duration? duration,
  }) =>
      KimikoSnackBar.fromColor(
        content: content,
        color: KimikoConstants.errorColor,
        key: key,
        action: action,
        duration: duration,
      );

  factory KimikoSnackBar.code(Code code,
          {SnackBarAction? action, Duration? duration}) =>
      code.state
          ? KimikoSnackBar.good(
              content: code.message, action: action, duration: duration)
          : KimikoSnackBar.bad(
              content: code.message, action: action, duration: duration);

  KimikoSnackBar.fromColor({
    Key? key,
    required String content,
    SnackBarAction? action,
    required Color color,
    Duration? duration,
  }) : super(
          key: key,
          action: action,
          content: Text(content),
          margin: const EdgeInsets.symmetric(horizontal: 17.5, vertical: 10),
          duration: duration ??
              (action != null ? defaultActionDuration : defaultDuration),
          shape: OutlineInputBorder(
            borderRadius: KimikoConstants.borderRadius,
            borderSide: BorderSide(color: color, width: 1),
          ),
        );
}
