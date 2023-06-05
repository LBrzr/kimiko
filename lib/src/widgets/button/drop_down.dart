import 'package:flutter/material.dart';

import '/src/mixins/theme_and_size.dart';

class CustomDropdown<T> extends StatefulWidget {
  /// the child widget for the button, this will be ignored if text is supplied
  final Widget child;

  /// onChange is called when the selected option is changed.;
  /// It will pass back the value and the index of the option.
  final void Function(T, int) onChange;

  final T? value; // ! added this

  /// list of DropdownItems
  final List<DropdownItem<T>> items;
  final DropdownStyle dropdownStyle;

  /// dropdownButtonStyles passes styles to OutlineButton.styleFrom()
  final DropdownButtonStyle dropdownButtonStyle;

  /// dropdown button icon defaults to caret
  final Widget? icon;
  final bool hideIcon;

  final bool hasError;

  /// if true the dropdown icon will as a leading icon, default to false
  final bool leadingIcon;
  const CustomDropdown({
    Key? key,
    this.hideIcon = false,
    required this.child,
    required this.items,
    this.dropdownStyle = const DropdownStyle(),
    this.dropdownButtonStyle = const DropdownButtonStyle(),
    this.icon,
    this.leadingIcon = false,
    required this.onChange,
    this.hasError = false,
    this.value,
  }) : super(key: key);

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>>
    with TickerProviderStateMixin, ThemeAndSizeMixin {
  final LayerLink layerLink = LayerLink();
  late OverlayEntry overlayEntry;
  late AnimationController animationController;
  late Animation<double> expandAnimation, rotateAnimation;
  late DropdownButtonStyle style;
  bool isOpen = false;
  int currentIndex = -1;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    expandAnimation =
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    rotateAnimation = Tween(begin: 0.0, end: 0.5).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeInOut));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    style = DropdownButtonStyle(
      elevation: widget.dropdownButtonStyle.elevation ?? 0,
      padding: widget.dropdownButtonStyle.padding ?? const EdgeInsets.all(12.5),
      shape: widget.dropdownButtonStyle.shape,
      backgroundColor: widget.dropdownButtonStyle.backgroundColor ??
          theme.colorScheme.background,
      height: widget.dropdownButtonStyle.height,
      width: widget.dropdownButtonStyle.width,
      primaryColor:
          widget.dropdownButtonStyle.primaryColor ?? theme.disabledColor,
      constraints: widget.dropdownButtonStyle.constraints,
      mainAxisAlignment: widget.dropdownButtonStyle.mainAxisAlignment ??
          MainAxisAlignment.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    // link the overlay to the button
    return CompositedTransformTarget(
      link: layerLink,
      child: SizedBox(
        width: style.width,
        height: style.height,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: style.primaryColor,
            padding: style.padding,
            backgroundColor: style.backgroundColor,
            elevation: style.elevation,
            shape: style.shape,
            side: BorderSide(
                width: .75,
                color: widget.hasError
                    ? theme.colorScheme.error
                    : theme.shadowColor),
          ),
          onPressed: _toggleDropdown,
          child: Row(
            mainAxisAlignment: style.mainAxisAlignment!,
            textDirection:
                widget.leadingIcon ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (currentIndex == -1)
                widget.child
              else
                widget.items[currentIndex],
              if (!widget.hideIcon)
                RotationTransition(
                  turns: rotateAnimation,
                  child: widget.icon ??
                      const Icon(Icons.keyboard_arrow_down_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlayEntry() {
    // find the size and position of the current widget
    RenderBox renderBox = context.findRenderObject()! as RenderBox;
    final size = renderBox.size;

    final offset = renderBox.localToGlobal(Offset.zero);
    final topOffset = offset.dy + size.height + 5;
    return OverlayEntry(
      // full screen GestureDetector to register when a
      // user has clicked away from the dropdown
      builder: (context) => GestureDetector(
        onTap: () => _toggleDropdown(close: true),
        behavior: HitTestBehavior.translucent,
        // full screen container to register taps anywhere and close drop down
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                top: topOffset,
                width: widget.dropdownStyle.width ?? size.width,
                child: CompositedTransformFollower(
                  offset:
                      widget.dropdownStyle.offset ?? Offset(0, size.height + 5),
                  link: layerLink,
                  showWhenUnlinked: false,
                  child: Material(
                    elevation: widget.dropdownStyle.elevation ??
                        theme.popupMenuTheme.elevation ??
                        8,
                    borderRadius: widget.dropdownStyle.borderRadius,
                    color: widget.dropdownStyle.color,
                    child: SizeTransition(
                      axisAlignment: 1,
                      sizeFactor: expandAnimation,
                      child: ConstrainedBox(
                        constraints: widget.dropdownStyle.constraints ??
                            BoxConstraints.loose(Size.fromHeight(size.height *
                                (widget.items.length > 4
                                    ? 4
                                    : widget.items.length))),
                        child: ListView(
                          padding: widget.dropdownStyle.padding,
                          shrinkWrap: true,
                          children: widget.items.asMap().entries.map((item) {
                            return InkWell(
                              borderRadius: widget.dropdownStyle.borderRadius,
                              onTap: () {
                                setState(() => currentIndex = item.key);
                                widget.onChange(item.value.value, item.key);
                                _toggleDropdown();
                              },
                              child: Padding(
                                padding: widget.dropdownStyle.itemPadding,
                                child: item.value,
                              ),
                            );
                          }).toList(growable: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleDropdown({bool close = false}) async {
    if (isOpen || close) {
      await animationController.reverse();
      overlayEntry.remove();
      setState(() {
        isOpen = false;
      });
    } else {
      overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(overlayEntry);
      setState(() => isOpen = true);
      animationController.forward();
    }
  }
}

/// DropdownItem is just a wrapper for each child in the dropdown list.\n
/// It holds the value of the item.
class DropdownItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const DropdownItem({Key? key, required this.value, required this.child})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class DropdownButtonStyle {
  final MainAxisAlignment? mainAxisAlignment;
  final OutlinedBorder? shape;
  final double? elevation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? primaryColor;
  const DropdownButtonStyle({
    this.mainAxisAlignment,
    this.backgroundColor,
    this.primaryColor,
    this.constraints,
    this.height,
    this.width,
    this.elevation,
    this.padding,
    this.shape,
  });

  DropdownButtonStyle copyWith({
    MainAxisAlignment? mainAxisAlignment,
    OutlinedBorder? shape,
    double? elevation,
    Color? backgroundColor,
    EdgeInsets? padding,
    BoxConstraints? constraints,
    double? width,
    double? height,
    Color? primaryColor,
  }) {
    return DropdownButtonStyle(
      mainAxisAlignment: mainAxisAlignment ?? this.mainAxisAlignment,
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      padding: padding ?? this.padding,
      constraints: constraints ?? this.constraints,
      width: width ?? this.width,
      height: height ?? this.height,
      primaryColor: primaryColor ?? this.primaryColor,
    );
  }
}

class DropdownStyle {
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets itemPadding;
  final BoxConstraints? constraints;

  /// position of the top left of the dropdown relative to the top left of the button
  final Offset? offset;

  ///button width must be set for this to take effect
  final double? width;

  const DropdownStyle({
    this.itemPadding = const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    this.constraints,
    this.offset,
    this.width,
    this.elevation,
    this.color,
    this.padding,
    this.borderRadius,
  });
}
