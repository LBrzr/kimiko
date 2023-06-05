import 'dart:ui';

import 'package:flutter/material.dart';

import '/src/resources/constants.dart';

class KimikoGlass extends StatelessWidget {
  const KimikoGlass({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.blur = 10,
  });

  final Widget child;
  final double blur;
  final Color? color;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Theme.of(context).scaffoldBackgroundColor.withOpacity(.5),
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius ?? KimikoConstants.borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }
}
