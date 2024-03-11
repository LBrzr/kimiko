import 'package:flutter/material.dart'
    show
        BuildContext,
        Color,
        Divider,
        FocusNode,
        IconData,
        VerticalDivider,
        Widget;

import '../widgets/icon.dart';

abstract class KimikoActionBarEntry {
  const KimikoActionBarEntry();
  Widget buildIcon(BuildContext context);
  Widget buildOption(BuildContext context);
}

class KimikoActionBarDivider extends KimikoActionBarEntry {
  const KimikoActionBarDivider({
    this.color,
    this.indent = 7.5,
    this.endIndent = 7.5,
    this.thickness = 1.0,
    this.dimension = 7,
  });

  final double? indent, endIndent, thickness, dimension;
  final Color? color;

  @override
  Widget buildIcon(BuildContext context) => VerticalDivider(
        color: color,
        endIndent: endIndent,
        indent: indent,
        thickness: thickness,
        width: dimension,
      );

  @override
  Widget buildOption(BuildContext context) => Divider(
        color: color,
        endIndent: endIndent,
        indent: indent,
        thickness: thickness,
        height: dimension,
      );
}

class KimikoActionBarItem extends KimikoActionBarEntry {
  final IconData icon;
  final String title;
  final FocusNode? focusNode;
  final dynamic Function() onPressed;

  const KimikoActionBarItem({
    required this.icon,
    required this.title,
    required this.onPressed,
    this.focusNode,
  });

  @override
  Widget buildIcon(BuildContext context) => KimikoActionBarIcon(item: this);

  @override
  Widget buildOption(BuildContext context) => KimikoActionBarIcon(item: this);
}
