import 'dart:math' show min;

import 'package:flutter/material.dart';

import 'package:animations/animations.dart';

import '/src/mixins/theme_and_size.dart';
import '/src/resources/constants.dart';
import '/src/resources/strings.dart';

part '../models/side_bar_item.dart';
part '../models/side_bar_theme.dart';
part '../widgets/side_bar.dart';

class KimikoSideView<T> extends StatefulWidget {
  const KimikoSideView({
    super.key,
    required this.items,
    required this.bottomItems,
    this.theme,
  });

  final List<KimikoSideBarItem<T>> items, bottomItems;
  final KimikoSideBarTheme<T>? theme;

  @override
  State<KimikoSideView<T>> createState() => KimikoSideViewState<T>();
}

class KimikoSideViewState<T> extends State<KimikoSideView<T>>
    with ThemeAndSizeMixin {
  final _barKey = GlobalKey<_KimikoSideBarState>();
  late T selected;

  @override
  void initState() {
    super.initState();
    selected = widget.theme?.initialValue ?? widget.items.first.value;
  }

  Future<void> expandSideBar() async => _barKey.currentState?.expand();
  Future<void> reduceSideBar() async => _barKey.currentState?.reduce();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.5, 12.5, 12.5, 15),
      child: Row(
        children: [
          _KimikoSideBar<T>(
            key: _barKey,
            items: widget.items,
            initialValue: selected,
            bottomItems: widget.bottomItems,
            titleWidth: widget.theme?.titleWidth,
            backgroundColor: widget.theme?.backgroundColor,
            expanded: widget.theme?.expanded ?? true,
            onSelected: (item) => setState(() => selected = item.value),
          ),
          const SizedBox(width: 15),
          Flexible(
            child: PageTransitionSwitcher(
              // reverse: !_isLoggedIn,
              duration: const Duration(seconds: 1),
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) =>
                  SharedAxisTransition(
                fillColor: Colors.transparent,
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.vertical,
                child: child,
              ),
              child: widget.items
                  .firstWhere((i) => i.value == selected,
                      orElse: () => widget.bottomItems
                          .firstWhere((i) => i.value == selected))
                  .content,
            ),
          ),
        ],
      ),
    );
  }
}
