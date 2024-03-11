import 'package:flutter/material.dart';

class ModalPageRoute extends PageRoute {
  final String routeName;
  final Duration? duration;
  final Color? color;
  final double initialScale, initialOffset;
  final bool dismissible;
  final Widget page;

  ModalPageRoute({
    required this.routeName,
    this.initialOffset = 20,
    this.dismissible = true,
    this.duration,
    this.color,
    this.initialScale = .875,
    required this.page,
    this.barrierLabel,
  });

  @override
  RouteSettings get settings => RouteSettings(name: routeName);

  @override
  Color? get barrierColor => color ?? Colors.black26;

  @override
  final String? barrierLabel;

  @override
  bool get barrierDismissible => dismissible;

  @override
  bool get opaque => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, (1 - animation.value) * initialOffset),
        child: child!,
      ),
      child: FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween(begin: initialScale, end: 1.0).animate(animation),
          child: page,
        ),
      ),
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      duration ?? const Duration(milliseconds: 250);
}
