part of '../views/side.dart';

class KimikoSideBarTheme<T> {
  final void Function(KimikoSideBarItem<T> item)? onSelected;
  final bool expanded;
  final T? initialValue;
  final double? titleWidth;
  final Color? backgroundColor;

  const KimikoSideBarTheme({
    this.onSelected,
    this.expanded = false,
    this.initialValue,
    this.titleWidth,
    this.backgroundColor,
  });
}
