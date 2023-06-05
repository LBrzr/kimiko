import 'dart:math';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';

import 'package:iconly/iconly.dart';

import '/src/mixins/theme_and_size.dart';

class KimikoScrollingIconBackground extends StatefulWidget {
  const KimikoScrollingIconBackground({
    super.key,
    required this.icons,
    this.startDelay = Duration.zero,
    this.randomColor,
    this.backgroundColor,
    this.randomRate = 0.925,
    this.offset = true,
    this.duration = const Duration(minutes: 60),
    this.length = 100000,
    this.angle,
    this.iconSize,
    this.scale = 2,
  });

  /// Delay before the scrolling starts
  /// default is 0
  final Duration startDelay;

  /// Duration of the complete scrolling
  /// default is 1 hour
  final Duration duration;

  /// Random color to apply to chosen icons
  /// if not set, the context [ThemeData.colorScheme.secondaryColor] will be used
  final Color? randomColor;

  /// Background color
  final Color? backgroundColor;

  /// Random rate to apply to chosen icons
  /// default is 0.925
  final double? randomRate;

  /// Length of the scrolling
  /// default is 100000
  final double length;

  /// list rotation angle
  /// if null, a random angle will be generated
  final double? angle;

  /// Icons to use
  final List<IconData> icons;

  /// Icon size
  /// if null the context [ThemeData.iconTheme.size] * 3 will be used
  /// and if [ThemeData.iconTheme.size] is not set, 60 will be used
  final double? iconSize;

  /// Zoom scale to hide border white space
  /// default is 2
  final double scale;

  /// Offset the icons or not
  final bool offset;

  factory KimikoScrollingIconBackground.bng(
    Color? randomColor,
  ) =>
      KimikoScrollingIconBackground(
        scale: 2.75,
        iconSize: 35,
        icons: const [
          CupertinoIcons.heart_fill,
          Icons.heart_broken,
          CupertinoIcons.heart,
          IconlyBold.heart,
          CupertinoIcons.heart_circle_fill,
          IconlyLight.heart,
          CupertinoIcons.heart_circle,
        ],
        randomColor: randomColor,
      );

  factory KimikoScrollingIconBackground.musik(
    Color? randomColor,
  ) =>
      KimikoScrollingIconBackground(
        icons: const [
          CupertinoIcons.double_music_note,
          CupertinoIcons.music_mic,
          CupertinoIcons.music_note_list,
          IconlyBold.volume_up,
          CupertinoIcons.mic_fill,
          CupertinoIcons.music_note,
        ],
        randomColor: randomColor,
      );

  @override
  State<KimikoScrollingIconBackground> createState() =>
      _KimikoScrollingIconBackgroundState();
}

class _KimikoScrollingIconBackgroundState
    extends State<KimikoScrollingIconBackground> with ThemeAndSizeMixin {
  final scrollController = ScrollController();
  List<IconData> get icons => widget.icons;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Future.delayed(widget.startDelay, scroll));
  }

  // generate random angle
  double get angle => widget.angle ?? random.nextDouble() * pi;

  // inifinit auto scroll using [scrollController]
  void scroll() {
    scrollController.animateTo(
      widget.length, // scrollController.position.maxScrollExtent,
      duration: widget.duration,
      curve: Curves.linear,
    );
  }

  static final random = Random();

  double get iconSize => widget.iconSize ?? (theme.iconTheme.size ?? 20) * 3;
  double get dimension => iconSize * 1.65;

  IconData icon(int index) => icons[index % icons.length];

  Widget _randomlyBuilder(int position, [int index = 0]) => SizedBox.square(
        dimension: dimension,
        child: Center(
          child: Icon(
            icon(index + position),
            size: iconSize,
            color: random.nextDouble() > widget.randomRate!
                ? widget.randomColor ?? theme.colorScheme.secondary
                : null,
          ),
        ),
      );

  Widget _normalBuilder(int position, [int index = 0]) => SizedBox.square(
        dimension: dimension,
        child: Center(
          child: Icon(
            icon(index + position),
            size: iconSize,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      child: Transform.scale(
        scale: widget.scale,
        child: Transform.rotate(
          angle: angle,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 75),
            itemBuilder: (context, index) => SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  icons.length,
                  widget.offset
                      ? widget.randomRate == null
                          ? (position) => _normalBuilder(position, index)
                          : (position) => _randomlyBuilder(position, index)
                      : widget.randomRate == null
                          ? _normalBuilder
                          : _randomlyBuilder,
                ).toList()
                  ..shuffle(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
