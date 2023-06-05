import 'package:flutter/material.dart';

import '/src/widgets/glass.dart';

/// background with image
/// must be used with [KimikoGlass] for best results
/// [child] is the widget to be displayed on top of the background
///
/// How to use:
/// ```dart
///
/// final key = GlobalKey<KimimoImagedBackgroundState>(); // get a global key
///
/// KimimoImagedBackground(
///   key: key, // set the key to the [KimikoImagedBackground] widget
///   child: KimikoGlass( // (optional) wrap the child with [KimikoGlass]
///     child: Center(child: Text('Hello World')),
///   ),
/// );
///
/// final image = AssetImage('assets/images/image.png'); // get an ImageProvider
/// key.currentState!.setBackground(image); // set the background
/// ```
class KimikoImagedBackground extends StatefulWidget {
  const KimikoImagedBackground({super.key, required this.child});

  final Widget child;

  factory KimikoImagedBackground.glass({Key? key, required Widget child}) =>
      KimikoImagedBackground(
        key: key,
        child: KimikoGlass(
          borderRadius: BorderRadius.zero,
          blur: 60,
          child: child,
        ),
      );

  @override
  State<KimikoImagedBackground> createState() => KimikoImagedBackgroundState();
}

class KimikoImagedBackgroundState extends State<KimikoImagedBackground> {
  ImageProvider? _image;

  /// set the background image
  void setBackground(ImageProvider? image) => setState(() => _image = image);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_image != null) Image(image: _image!, fit: BoxFit.cover),
        widget.child,
      ],
    );
  }
}
