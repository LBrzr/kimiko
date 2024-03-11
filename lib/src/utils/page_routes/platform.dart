import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
PageRoute<T> PlatformPageRoute<T>({
  required RouteSettings settings,
  required WidgetBuilder builder,
  bool maintainState = true,
  bool fullscreenDialog = false,
}) {
  late final bool useMaterial;
  try {
    useMaterial = Platform.isAndroid;
  } on Error {
    useMaterial = true;
    debugPrint('Navigate using material');
  }
  return useMaterial
      ? MaterialPageRoute<T>(settings: settings, builder: builder)
      : CupertinoPageRoute<T>(settings: settings, builder: builder);
}
