import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';

class KimikoLikeButton extends StatefulWidget {
  const KimikoLikeButton({
    Key? key,
    this.color,
    this.isDense = false,
    required this.hasHeart,
    required this.likeUnlike,
  }) : super(key: key);

  final bool isDense, hasHeart;
  final Color? color;
  final void Function() likeUnlike;

  @override
  State<KimikoLikeButton> createState() => _KimikoLikeButtonState();
}

class _KimikoLikeButtonState extends State<KimikoLikeButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 750),
        value: hasHeart ? 1 : 0);
    animation = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    super.initState();
  }

  bool get isDense => widget.isDense;

  bool get hasHeart => widget.hasHeart;

  void like() {
    controller.isCompleted ? controller.reverse() : controller.forward();
    widget.likeUnlike();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: like,
      child: IconTheme(
        data: theme.iconTheme.copyWith(
            color: widget.color ?? theme.primaryColor,
            size: isDense ? theme.iconTheme.size! * .85 : null),
        child: Padding(
          padding:
              isDense ? const EdgeInsets.all(8.0) : const EdgeInsets.all(12.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(IconlyLight.heart),
              AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Transform.scale(
                      scale: animation.value * .9, child: child),
                  child: const Icon(IconlyBold.heart))
            ],
          ),
        ),
      ),
    );
  }
}
