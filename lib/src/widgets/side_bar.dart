part of '../views/side.dart';

class _KimikoSideBar<T> extends StatefulWidget {
  const _KimikoSideBar({
    super.key,
    required this.items,
    required this.bottomItems,
    required this.initialValue,
    this.backgroundColor,
    this.onSelected,
    this.titleWidth,
    this.expanded = true,
  });

  final List<KimikoSideBarItem<T>> items, bottomItems;
  final void Function(KimikoSideBarItem<T> item)? onSelected;
  final bool expanded;
  final T initialValue;
  final double? titleWidth;
  final Color? backgroundColor;

  @override
  State<_KimikoSideBar<T>> createState() => _KimikoSideBarState<T>();
}

class _KimikoSideBarState<T> extends State<_KimikoSideBar<T>>
    with ThemeAndSizeMixin, TickerProviderStateMixin {
  late final titleWidth = min(size.width * .125, widget.titleWidth ?? 150);
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
    value: widget.expanded ? 1 : 0,
  );
  late final animation =
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
  late final Map<T, AnimationController> controllers;
  late T selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
    controllers = Map.fromIterables(
      [
        ...widget.items.map((i) => i.value),
        ...widget.bottomItems.map((i) => i.value)
      ],
      List.generate(
        widget.items.length + widget.bottomItems.length,
        (_) => AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 150),
        ),
      ),
    );
    controllers[selected]!.forward();
  }

  @override
  void dispose() {
    controllers.forEach((key, value) => value.dispose());
    animationController.dispose();
    super.dispose();
  }

  void expandReduce() => animationController.isCompleted ? expand() : reduce();

  Future<void> expand() => animationController.reverse();
  Future<void> reduce() => animationController.forward();

  void onItemSelected(KimikoSideBarItem<T> item) {
    controllers[selected]!.reverse();
    widget.onSelected?.call(item);
    item.onSelected?.call();
    setState(() => selected = item.value);
    controllers[item.value]!.forward();
  }

  Widget buildItem(KimikoSideBarItem<T> item) {
    final isSelected = selected == item.value;
    final accentColor = isSelected ? theme.primaryColor : null;
    return InkWell(
      onTap: isSelected ? () {} : () => onItemSelected(item),
      borderRadius: KimikoConstants.borderRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                Icon(item.icon, color: accentColor),
                buildTitle(item.title, accentColor),
              ],
            ),
            Positioned(
              left: -10,
              child: SizeTransition(
                axisAlignment: 0,
                sizeFactor: controllers[item.value]!,
                child: Padding(
                  padding: const EdgeInsets.only(right: 7.5),
                  child: Material(
                    borderRadius: KimikoConstants.borderRadius,
                    color: theme.primaryColor,
                    child: SizedBox(height: theme.iconTheme.size, width: 4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(String title, [Color? color]) => SizeTransition(
        sizeFactor: animation,
        axis: Axis.horizontal,
        child: SizedBox(
          width: titleWidth,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              title,
              style: TextStyle(color: color),
            ),
          ),
        ),
      );

  Widget get divider => Row(
        children: [
          const SizedBox(width: 20, child: Divider()),
          SizeTransition(
            sizeFactor: animation,
            axis: Axis.horizontal,
            child: SizedBox(width: titleWidth, child: const Divider()),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: KimikoConstants.borderRadius,
        side: BorderSide(
          width: KimikoConstants.borderSideWidth,
          color: theme.shadowColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    onPressed: expandReduce,
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      progress: animation,
                    ),
                  ),
                  buildTitle(KimikoStrings.instance[KStrings.dashboard]),
                ],
              ),
              divider,
              Expanded(
                child: Column(children: widget.items.map(buildItem).toList()),
              ),
              divider,
              ...widget.bottomItems.map(buildItem),
            ],
          ),
        ),
      ),
    );
  }
}
