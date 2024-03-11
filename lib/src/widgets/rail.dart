import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class KimikoRail extends StatelessWidget {
  static late ScrollController _scrollController;

  final Widget child;
  final AnimationController animationController;
  final void Function()? onHide, onShow;
  final Offset offset;
  final ScrollDirection hideScrollDirection;
  final Animation<double> _hideAnimation;
  final Animation<Offset> _slideAnimation;

  KimikoRail({
    super.key,
    required ScrollController scrollController,
    required this.animationController,
    required this.child,
    this.onHide,
    this.onShow,
    this.offset = const Offset(0, 3),
    this.hideScrollDirection = ScrollDirection.reverse,
  })  : _hideAnimation =
            Tween<double>(begin: 1, end: 0).animate(animationController),
        _slideAnimation = Tween<Offset>(begin: Offset.zero, end: offset)
            .animate(animationController) {
    scrollController.addListener(() {
      if (scrollController.positions.first.userScrollDirection ==
          hideScrollDirection) {
        hide();
        return;
      }
      show();
    });
  }

  void hide() {
    animationController.forward();
    onHide?.call();
  }

  void show() {
    animationController.reverse();
    onShow?.call();
  }

  static get scrollController => _scrollController;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _hideAnimation,
        child: child,
      ),
    );
  }
}
