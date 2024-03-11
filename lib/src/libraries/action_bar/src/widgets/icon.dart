import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '/src/mixins/theme_and_size.dart';
import '/src/resources/constants.dart';
import '../../action_bar.dart';

class KimikoActionBarIcon extends StatefulWidget {
  const KimikoActionBarIcon({super.key, required this.item});

  final KimikoActionBarItem item;

  @override
  State<KimikoActionBarIcon> createState() => _KimikoActionBarIconState();
}

class _KimikoActionBarIconState extends State<KimikoActionBarIcon>
    with ThemeAndSizeMixin {
  late final focusNode = widget.item.focusNode ?? FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.addListener(onStateChanged);
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.removeListener(onStateChanged);
    super.dispose();
  }

  void onStateChanged() {
    setState(() {});
  }

  KimikoActionBarItem get item => widget.item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: KimikoConstants.borderRadius,
        side: focusNode.hasFocus
            ? BorderSide(
                color: theme.primaryColor,
                width: KimikoConstants.borderSideWidth,
              )
            : BorderSide.none,
      ),
      child: Tooltip(
        preferBelow: true,
        message: item.title,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        ),
        child: InkWell(
          onTap: item.onPressed,
          borderRadius: KimikoConstants.borderRadius,
          focusNode: focusNode,
          focusColor: Colors.transparent,
          mouseCursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(item.icon),
          ),
        ),
      ),
    );
  }
}

/* 
class CustomPathShape extends BoxShape {
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();

    path.moveTo(0, rect.height);   // Move to (0, 0)
    path.lineTo(rect.width, 0);    // Line to (1, 1)
    path.lineTo(rect.width, rect.height); // Line to (12, 1)
    path.lineTo(0, rect.height);   // Line to (12, 5)
    path.close();                  // Close the path

    return path;
  }
} */

class CustomPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black // Set the color to black
      ..style = PaintingStyle.fill; // Fill the shape

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(1, 1)
      ..lineTo(12, 1)
      ..lineTo(12, 5)
      ..lineTo(0, 5)
      ..lineTo(-12, 5)
      ..lineTo(-12, 1)
      ..lineTo(-1, 1)
      ..close(); // Close the path

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
