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
    this.randomColors = const <Color>[],
    this.backgroundColor = Colors.transparent,
    this.randomRate = 0.825,
    this.offset = true,
    this.duration = const Duration(minutes: 120),
    this.length = 100000,
    this.angle,
    this.iconSize,
    this.scale = 2,
    this.densityFactor = 1.0,
    this.enableBounceAnimation = true,
    this.bounceAnimationDuration = const Duration(milliseconds: 1500),
    this.bounceSizeFactor = 0.2,
    this.enableRotation = true,
    this.rotationAnimationDuration = const Duration(milliseconds: 2000),
    this.maxRotationAngle = 1.0,
  });

  /// Delay before the scrolling starts
  /// default is 0
  final Duration startDelay;

  /// Duration of the complete scrolling
  /// default is 1 hour
  final Duration duration;

  /// Random colors to apply to chosen icons
  /// if empty, the context [ThemeData.colorScheme.secondaryColor] will be used
  final List<Color> randomColors;

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

  /// Factor to control the density of icons
  /// Higher value means more icons per row
  /// default is 1.0
  final double densityFactor;

  /// Enable bouncing animation on colored icons
  /// default is true
  final bool enableBounceAnimation;

  /// Duration of the bouncing animation
  /// default is 1500 milliseconds
  final Duration bounceAnimationDuration;

  /// Factor controlling the bounce size amplitude
  /// default is 0.2 (representing 20% size increase)
  final double bounceSizeFactor;

  /// Enable rotation animation on icons
  /// default is true
  final bool enableRotation;

  /// Duration of the rotation animation
  /// default is 4000 milliseconds
  final Duration rotationAnimationDuration;

  /// Maximum rotation angle in radians
  /// default is 0.3 radians (approximately 17 degrees)
  final double maxRotationAngle;

  factory KimikoScrollingIconBackground.bng(
    List<Color> randomColors,
  ) =>
      KimikoScrollingIconBackground(
        scale: 2.75,
        iconSize: 45,
        densityFactor: 1.2,
        icons: const [
          CupertinoIcons.heart_fill,
          Icons.heart_broken,
          CupertinoIcons.heart,
          IconlyBold.heart,
          CupertinoIcons.heart_circle_fill,
          IconlyLight.heart,
          CupertinoIcons.heart_circle,
        ],
        randomColors: randomColors,
      );

  factory KimikoScrollingIconBackground.musik(
    List<Color> randomColors,
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
        randomColors: randomColors,
        densityFactor: 1.2,
      );

  @override
  State<KimikoScrollingIconBackground> createState() =>
      _KimikoScrollingIconBackgroundState();
}

class _KimikoScrollingIconBackgroundState
    extends State<KimikoScrollingIconBackground> with ThemeAndSizeMixin, TickerProviderStateMixin {
  final scrollController = ScrollController();
  List<IconData> get icons => widget.icons;
  Size _screenSize = Size.zero;

  /// Map to store animation controllers for each colored icon
  final Map<int, AnimationController> _bounceControllers = {};

  /// Map to store animations for each colored icon
  final Map<int, Animation<double>> _bounceAnimations = {};

  /// Map to store rotation animation controllers for each icon
  final Map<int, AnimationController> _rotationControllers = {};

  /// Map to store rotation animations for each icon
  final Map<int, Animation<double>> _rotationAnimations = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => Future.delayed(widget.startDelay, scroll));
  }

  @override
  void dispose() {
    scrollController.dispose();
    // Dispose all animation controllers
    for (final controller in _bounceControllers.values) {
      controller.dispose();
    }
    for (final controller in _rotationControllers.values) {
      controller.dispose();
    }
    super.dispose();
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

  /// Calculate how many icons are needed to fill the screen width
  int _calculateIconsPerRow() {
    // Calculate based on screen dimensions and rotation angle
    final double effectiveWidth = max(
      _screenSize.width * 1.5,
      _screenSize.height * 1.5,
    );

    // Calculate how many icons can fit in the effective width
    return max(
      (effectiveWidth / dimension * widget.densityFactor).ceil(),
      icons.length,
    );
  }

  /// Get a random color from the randomColors list or use theme secondary color as fallback
  Color _getRandomColor() {
    if (widget.randomColors.isEmpty) {
      return theme.colorScheme.secondary;
    }
    return widget.randomColors[random.nextInt(widget.randomColors.length)];
  }

  /// Create or get a bounce animation controller and animation for a specific icon
  Animation<double> _getBounceAnimation(int iconId) {
    if (!_bounceControllers.containsKey(iconId)) {
      // Create a new controller with random start point for staggered effect
      final controller = AnimationController(
        duration: widget.bounceAnimationDuration,
        vsync: this,
      );

      // Create a curved animation that bounces
      final animation = Tween<double>(
        begin: 1.0 - widget.bounceSizeFactor,
        end: 1.0 + 2 * widget.bounceSizeFactor,
      ).animate(CurvedAnimation(
        parent: controller,
        // Use elasticInOut for bouncing effect
        curve: Curves.elasticInOut,
      ));

      // Add random initial delay for staggered effect
      final delay = Duration(milliseconds: random.nextInt(2 * widget.bounceAnimationDuration.inMilliseconds));

      // Start animation after delay
      Future.delayed(delay, () {
        if (mounted) {
          // Start with repeating animation
          controller.repeat(reverse: true);
        }
      });

      _bounceControllers[iconId] = controller;
      _bounceAnimations[iconId] = animation;
    }

    return _bounceAnimations[iconId]!;
  }

  /// Create or get a rotation animation controller and animation for a specific icon
  Animation<double> _getRotationAnimation(int iconId) {
    if (!_rotationControllers.containsKey(iconId)) {
      // Create a new controller
      final controller = AnimationController(
        duration: widget.rotationAnimationDuration,
        vsync: this,
      );

      // Generate random start and end angles for more natural movement
      final startAngle = -widget.maxRotationAngle + (random.nextDouble() * widget.maxRotationAngle / 2);
      final endAngle = widget.maxRotationAngle - (random.nextDouble() * widget.maxRotationAngle / 2);

      // Create a curved animation that rotates
      final animation = Tween<double>(
        begin: startAngle,
        end: endAngle,
      ).animate(CurvedAnimation(
        parent: controller,
        // Use a sine curve for smooth rotation
        curve: Curves.easeInOut,
      ));

      // Add random initial delay for staggered effect
      final delay = Duration(milliseconds: random.nextInt(1500));

      // Start animation after delay
      Future.delayed(delay, () {
        if (mounted) {
          // Start with repeating animation
          controller.repeat(reverse: true);
        }
      });

      _rotationControllers[iconId] = controller;
      _rotationAnimations[iconId] = animation;
    }

    return _rotationAnimations[iconId]!;
  }

  Widget _randomlyBuilder(int position, [int index = 0]) {
    final int iconId = position + (index * 10000); // Unique ID for the icon
    final isColored = random.nextDouble() > widget.randomRate!;
    final iconColor = isColored ? _getRandomColor() : null;

    // Base widget to be wrapped with animations
    Widget iconWidget = Icon(
      icon(index + position),
      size: iconSize,
      color: iconColor,
    );

    // Apply bounce animation if enabled and icon is colored
    if (isColored && widget.enableBounceAnimation) {
      iconWidget = AnimatedBuilder(
        animation: _getBounceAnimation(iconId),
        builder: (context, child) {
          return Transform.scale(
            scale: _bounceAnimations[iconId]!.value,
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    // Apply rotation animation if enabled (for all icons)
    if (widget.enableRotation) {
      iconWidget = AnimatedBuilder(
        animation: _getRotationAnimation(iconId),
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimations[iconId]!.value,
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    // Final container
    return SizedBox.square(
      dimension: dimension,
      child: Center(child: iconWidget),
    );
  }

  Widget _normalBuilder(int position, [int index = 0]) {
    final int iconId = position + (index * 10000); // Unique ID for the icon

    // Base icon widget
    Widget iconWidget = Icon(
      icon(index + position),
      size: iconSize,
    );

    // Apply rotation animation if enabled
    if (widget.enableRotation) {
      iconWidget = AnimatedBuilder(
        animation: _getRotationAnimation(iconId),
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimations[iconId]!.value,
            child: child,
          );
        },
        child: iconWidget,
      );
    }

    return SizedBox.square(
      dimension: dimension,
      child: Center(child: iconWidget),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Store the screen size for calculations
    _screenSize = MediaQuery.of(context).size;

    // Calculate the number of icons needed for each row
    final iconsPerRow = _calculateIconsPerRow();

    return RepaintBoundary(
      child: Material(
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
                    iconsPerRow,
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
      ),
    );
  }
}
