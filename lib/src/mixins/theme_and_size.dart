import 'package:flutter/material.dart';

/// Theme, MediaQuery and other staff provider for stateful widgets
mixin ThemeAndSizeMixin<T extends StatefulWidget> on State<T> {
  late ThemeData theme;
  late Size size;
  late MediaQueryData mediaQuery;
  late TextTheme textTheme;
  late TextStyle subtitleStyle;

  @override
  void didChangeDependencies() {
    mediaQuery = MediaQuery.of(context);
    size = mediaQuery.size;
    theme = Theme.of(context);
    textTheme = theme.textTheme;
    subtitleStyle = theme.textTheme.titleMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: theme.textTheme.displayLarge!.color,
    );
    super.didChangeDependencies();
  }
}
