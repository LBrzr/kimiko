part of '../views/side.dart';

class KimikoSideBarItem<T> {
  final T value;
  final IconData icon;
  final String title;
  final String? tooltip;
  final void Function()? onSelected;
  final Widget content;

  const KimikoSideBarItem({
    required this.value,
    required this.icon,
    required this.title,
    required this.content,
    this.onSelected,
    this.tooltip,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KimikoSideBarItem &&
          runtimeType == other.runtimeType &&
          other.value == value;

  @override
  int get hashCode => value.hashCode;
}
