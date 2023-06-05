import 'package:flutter/material.dart';

import '/src/mixins/reactable_button_mixin.dart';
import '/src/mixins/theme_and_size.dart';

class KimikoOutlinedButton extends ReactableButtonWidget {
  const KimikoOutlinedButton({
    this.backgroundColor,
    this.accentColor,
    super.key,
    this.text,
    this.content,
    required super.onTap,
  });

  final String? text;
  final Widget? content;
  final Color? backgroundColor, accentColor;

  @override
  State<KimikoOutlinedButton> createState() => KimikoOutlinedButtonState();
}

class KimikoOutlinedButtonState extends State<KimikoOutlinedButton>
    with ThemeAndSizeMixin, ReactableButtonStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: react,
      child: Material(
        color: widget.backgroundColor ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: widget.accentColor ?? theme.shadowColor,
          ),
        ),
        child: Center(
          child: processing
              ? loadingWidget
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: widget.content ??
                      Text(
                        widget.text!,
                        style: textTheme.titleMedium!.copyWith(
                            color: widget.accentColor ??
                                theme.colorScheme.onSurface),
                      ),
                ),
        ),
      ),
    );
  }
}
