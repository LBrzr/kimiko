import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

import '/src/mixins/theme_and_size.dart';

class KimikoRichText extends StatefulWidget {
  const KimikoRichText({
    Key? key,
    this.normalText,
    required this.superText,
    required this.onTap,
    this.color,
    this.normalTextStyle,
    this.superTextStyle,
  }) : super(key: key);

  /// Represents the text before the super text
  /// if null, it will be empty
  final String? normalText;

  /// Represents the text after the normal text
  /// will be highlighted and clickable
  final String superText;

  /// Represents the function that will be called when the super text is tapped
  final void Function() onTap;

  /// Represents the color of the super text
  /// if null, it will be the default color [ThemeData.primaryColorLight]
  /// useless if [superTextStyle] is not null
  final Color? color;

  /// Represents the style of the normal text
  /// if null, it will be the default style [TextTheme.bodyText2]
  final TextStyle? normalTextStyle;

  /// Represents the style of the super text
  /// if null, it will be the default style [TextTheme.bodyText2] with applied [color]
  final TextStyle? superTextStyle;

  @override
  State<KimikoRichText> createState() => _KimikoRichTextState();
}

class _KimikoRichTextState extends State<KimikoRichText>
    with ThemeAndSizeMixin {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: widget.normalText ?? '',
        style: widget.normalTextStyle ?? textTheme.bodyText2,
        children: [
          TextSpan(
              text: widget.superText,
              style: widget.superTextStyle ??
                  textTheme.bodyText2?.copyWith(
                      color: widget.color ?? theme.primaryColorLight),
              recognizer: TapGestureRecognizer()..onTap = widget.onTap)
        ],
      ),
    );
  }
}
