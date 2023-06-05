import 'package:flutter/material.dart';

import '/src/mixins/theme_and_size.dart';
import '/src/resources/strings.dart';

class KimikoRadioList<T> extends StatefulWidget {
  const KimikoRadioList({
    super.key,
    this.validator,
    required this.label,
    this.onChanged,
    this.initialValue,
    required this.items,
    required this.builder,
    this.listPadding = const EdgeInsets.symmetric(horizontal: 20),
  });

  final String? Function(T? value)? validator;
  final String label;
  final void Function(T? value)? onChanged;
  final T? initialValue;
  final List<T> items;
  final Widget Function(T item) builder;
  final EdgeInsetsGeometry listPadding;

  @override
  State<KimikoRadioList<T>> createState() => _KimikoRadioListState<T>();
}

class _KimikoRadioListState<T> extends State<KimikoRadioList<T>>
    with ThemeAndSizeMixin {
  T? value;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T>(
        initialValue: value,
        validator: widget.validator,
        builder: (field) {
          final title = Text(widget.label,
              style: textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.onSurface));
          final hasError = field.hasError;
          final accentColor =
              hasError ? theme.colorScheme.error : theme.shadowColor;
          return SizedBox(
            height: 65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hasError
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          title,
                          RichText(
                            text: TextSpan(
                              text: ' : ',
                              style: textTheme.bodySmall!
                                  .copyWith(color: theme.colorScheme.error),
                              children: [TextSpan(text: field.errorText!)],
                            ),
                          )
                        ],
                      )
                    : title,
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: widget.listPadding,
                    scrollDirection: Axis.horizontal,
                    children: widget.items.map(widget.builder).toList(),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
