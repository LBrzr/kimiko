import 'package:flutter/material.dart';

import '/src/mixins/reactable_button_mixin.dart';
import '/src/mixins/theme_and_size.dart';
import '/src/resources/constants.dart';

class KimikoFlatButton extends ReactableButtonWidget {
  const KimikoFlatButton({
    super.key,
    this.text,
    this.content,
    super.enabled = true,
    required super.onTap,
  });

  final String? text;
  final Widget? content;

  @override
  State<KimikoFlatButton> createState() => KimikoFlatButtonState();
}

class KimikoFlatButtonState extends State<KimikoFlatButton>
    with ThemeAndSizeMixin, ReactableButtonStateMixin {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.enabled ? theme.primaryColor : theme.disabledColor,
      borderRadius: KimikoConstants.borderRadius,
      clipBehavior: Clip.antiAlias,
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
                        style: textTheme.titleMedium!
                            .copyWith(color: Colors.white),
                      ),
                ),
        ),
      ),
    );
  }
}
