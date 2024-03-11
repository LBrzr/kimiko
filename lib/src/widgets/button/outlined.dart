import 'package:flutter/material.dart';

import '../../resources/constants.dart';
import '/src/mixins/reactable_button_mixin.dart';
import '/src/mixins/theme_and_size.dart';

class KimikoOutlinedButton extends ReactableButtonWidget {
  const KimikoOutlinedButton({
    this.backgroundColor,
    this.accentColor,
    super.key,
    this.text,
    this.content,
    super.enabled = true,
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
    return Material(
      color: widget.backgroundColor ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: KimikoConstants.borderRadius,
        side: BorderSide(
          color: widget.accentColor ?? theme.shadowColor,
        ),
      ),
      child: InkWell(
        onTap: widget.enabled ? react : null,
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
