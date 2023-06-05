import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/src/mixins/theme_and_size.dart';
import '/src/resources/constants.dart';
import '/src/resources/strings.dart';
import '/src/resources/validators.dart';
import 'drop_down.dart';

class KimikoBirthdateDropdownField extends StatefulWidget {
  const KimikoBirthdateDropdownField({
    Key? key,
    required this.onChanged,
    this.label,
    this.validator,
    this.initialValue,
  }) : super(key: key);

  final DateTime? initialValue;

  /// values are order like following:
  /// [0] - month
  /// [1] - day
  /// [2] - year
  final String? Function(List<int>? values)? validator;
  final String? label;
  final void Function(int month, int day, int year) onChanged;

  @override
  State<KimikoBirthdateDropdownField> createState() =>
      _KimikoBirthdateDropdownFieldState();
}

class _KimikoBirthdateDropdownFieldState
    extends State<KimikoBirthdateDropdownField> with ThemeAndSizeMixin {
  static const strings = KimikoStrings.instance;
  static const minAge = 15, maxAge = 70;
  final date = DateTime.now();
  late DropdownStyle dropdownStyle;
  late DropdownButtonStyle dropdownButtonStyle;
  late int month;
  late int day;
  late int year;

  @override
  void initState() {
    month = widget.initialValue?.month ?? 0;
    day = widget.initialValue?.day ?? 0;
    year = widget.initialValue?.year ?? 0;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dropdownButtonStyle = DropdownButtonStyle(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      padding: const EdgeInsets.fromLTRB(15.5, 15.5, 5, 15.5),
      shape: RoundedRectangleBorder(
        borderRadius: KimikoConstants.borderRadius,
        side: BorderSide(width: .75, color: theme.shadowColor),
      ),
    );
    dropdownStyle = DropdownStyle(
      padding: const EdgeInsets.all(12.5),
      color: theme.colorScheme.background,
      borderRadius: KimikoConstants.borderRadius,
    );
  }

  DropdownItem<int> itemMapper(MapEntry<int, String> item) => DropdownItem<int>(
        value: item.key + 1,
        child: Text(item.value.padLeft(2, '0'), style: textTheme.bodyMedium),
      );

  get spacer => const SizedBox(width: 8);

  @override
  Widget build(BuildContext context) {
    final title = Text(widget.label ?? strings[KStrings.date],
        style:
            textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onSurface));
    return FormField<List<int>>(
      validator: widget.validator ?? KimikoValidators.defaultDate,
      initialValue: [month, day, year],
      builder: (field) {
        final hasError = field.hasError;
        final child = Row(
          children: [
            Expanded(
              child: CustomDropdown<int>(
                hasError: hasError
                    ? field.value![0] == (widget.initialValue?.month ?? 0)
                    : false,
                dropdownButtonStyle: dropdownButtonStyle,
                dropdownStyle: dropdownStyle,
                onChange: (int value, int index) {
                  field.didChange([month = value, day, year]);
                  widget.onChanged(month = value, day, year);
                },
                items: List.generate(12, (index) => (index + 1).toString())
                    .asMap()
                    .entries
                    .map<DropdownItem<int>>(itemMapper)
                    .toList(growable: false),
                child: Text(strings[KStrings.month],
                    style: textTheme.bodyMedium!
                        .copyWith(color: theme.colorScheme.onSurface)),
              ),
            ),
            spacer,
            Expanded(
              child: CustomDropdown<int>(
                hasError: hasError
                    ? field.value![1] == (widget.initialValue?.day ?? 0)
                    : false,
                dropdownButtonStyle: dropdownButtonStyle,
                dropdownStyle: dropdownStyle,
                onChange: (int value, int index) {
                  field.didChange([month, day = value, year]);
                  widget.onChanged(month, day = value, year);
                },
                items: List.generate(31, (index) => (index + 1).toString())
                    .asMap()
                    .entries
                    .map<DropdownItem<int>>(itemMapper)
                    .toList(growable: false),
                child: Text(strings[KStrings.day],
                    style: textTheme.bodyMedium!
                        .copyWith(color: theme.colorScheme.onSurface)),
              ),
            ),
            spacer,
            Expanded(
              child: CustomDropdown<int>(
                hasError: hasError
                    ? field.value![2] == (widget.initialValue?.year ?? 0)
                    : false,
                dropdownButtonStyle: dropdownButtonStyle,
                dropdownStyle: dropdownStyle,
                onChange: (int value, int index) {
                  field.didChange([month, day, year = value]);
                  widget.onChanged(month, day, year = value);
                },
                items: List.generate(
                        maxAge, (index) => (date.year - (index + minAge) + 1))
                    .asMap()
                    .entries
                    .map<DropdownItem<int>>(
                        (MapEntry<int, int> item) => DropdownItem<int>(
                              value: item.value,
                              child: Text(item.value.toString(),
                                  style: textTheme.bodyMedium),
                            ))
                    .toList(growable: false),
                child: Text(strings[KStrings.year],
                    style: textTheme.bodyMedium!
                        .copyWith(color: theme.colorScheme.onSurface)),
              ),
            ),
          ],
        );
        return Column(
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
                              children: [
                            TextSpan(text: field.errorText!),
                          ]))
                    ],
                  )
                : title,
            const SizedBox(height: 5),
            child,
          ],
        );
      },
    );
  }
}
