import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/src/mixins/theme_and_size.dart';
import '/src/resources/constants.dart';
import '/src/resources/validators.dart';
import '/src/resources/strings.dart';

class KimikoTextField extends StatefulWidget {
  const KimikoTextField({
    Key? key,
    this.label,
    this.hint,
    this.backgroundColor,
    this.validator,
    this.onChanged,
    this.controller,
    this.hide = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.onSubmitted,
    this.maxLines,
    this.endIcon,
    this.enabled = true,
    this.autofillHints = const [],
  }) : super(key: key);

  /// pre-defined text field for password
  factory KimikoTextField.password({
    Key? key,
    String? label,
    String? hint,
    Color? backgroundColor,
    String? Function(String? value)? validator,
    void Function(String value)? onChanged,
    TextEditingController? controller,
    TextInputType type = TextInputType.text,
    TextInputAction action = TextInputAction.next,
    void Function(String? value)? onSubmitted,
    Widget? endIcon,
    bool enabled = true,
  }) =>
      KimikoTextField(
        key: key,
        label: label ?? KStrings.password.value,
        hint: hint,
        backgroundColor: backgroundColor,
        validator: validator ?? KimikoValidators.required,
        onChanged: onChanged,
        controller: controller,
        hide: true,
        type: type,
        action: action,
        onSubmitted: onSubmitted,
        maxLines: 1,
        endIcon: endIcon,
        enabled: enabled,
        autofillHints: const [AutofillHints.password],
      );

  /// pre-defined text field for email
  factory KimikoTextField.email({
    Key? key,
    String? label,
    String? hint,
    Color? backgroundColor,
    bool nullable = false,
    String? Function(String? value)? validator,
    void Function(String value)? onChanged,
    TextEditingController? controller,
    TextInputAction action = TextInputAction.next,
    void Function(String? value)? onSubmitted,
    Widget? endIcon,
    bool enabled = true,
  }) =>
      KimikoTextField(
        key: key,
        label: label ?? KStrings.email.value,
        hint: hint,
        backgroundColor: backgroundColor,
        validator: validator ??
            (nullable
                ? KimikoValidators.nullableEmail
                : KimikoValidators.email),
        onChanged: onChanged,
        controller: controller,
        hide: false,
        type: TextInputType.emailAddress,
        action: action,
        onSubmitted: onSubmitted,
        endIcon: endIcon,
        enabled: enabled,
        autofillHints: const [AutofillHints.email],
      );

  /// pre-defined text field for phone
  factory KimikoTextField.phone({
    Key? key,
    String? label,
    String? hint,
    Color? backgroundColor,
    String? Function(String? value)? validator,
    void Function(String value)? onChanged,
    TextEditingController? controller,
    TextInputAction action = TextInputAction.next,
    void Function(String? value)? onSubmitted,
    Widget? endIcon,
    bool enabled = true,
  }) =>
      KimikoTextField(
        key: key,
        label: label ?? KStrings.phone.value,
        hint: hint,
        backgroundColor: backgroundColor,
        validator: validator ?? KimikoValidators.phone,
        onChanged: onChanged,
        controller: controller,
        hide: false,
        type: TextInputType.phone,
        action: action,
        onSubmitted: onSubmitted,
        endIcon: endIcon,
        enabled: enabled,
        autofillHints: const [AutofillHints.telephoneNumber],
      );

  /// if true, the text field will be hidden
  /// riquered for password fields
  final bool hide;

  /// submit action
  /// receives last field [value] as parameter
  final void Function(String? value)? onSubmitted;

  /// text field [TextInputType] type
  /// default is [TextInputType.text]
  final TextInputType type;

  /// text field [TextInputAction] action
  /// default is [TextInputAction.next]
  final TextInputAction action;

  /// text field [TextEditingController]
  final TextEditingController? controller;

  /// text field validator
  /// receives last field [value] as parameter
  final String? Function(String? value)? validator;

  /// text field on change callback
  /// receives last field [value] as parameter
  final void Function(String value)? onChanged;

  /// text field label
  final String? label;

  /// text field hint
  final String? hint;

  /// text field background color
  final Color? backgroundColor;

  /// max lines
  final int? maxLines;

  /// text field end icon
  final Widget? endIcon;

  /// enable text field
  final bool enabled;

  /// autofillHints text field
  final List<String> autofillHints;

  @override
  State<KimikoTextField> createState() => _KimikoTextFieldState();
}

class _KimikoTextFieldState extends State<KimikoTextField>
    with ThemeAndSizeMixin {
  bool obscure = false;

  @override
  initState() {
    obscure = widget.hide;
    super.initState();
  }

  Widget buildField({
    required FormFieldState<String> field,
    required Color accentColor,
  }) =>
      TextField(
        enabled: widget.enabled,
        autofillHints: widget.autofillHints,
        cursorColor: theme.primaryColorLight,
        controller: widget.controller,
        onChanged: (value) {
          field.didChange(value);
          widget.onChanged?.call(value);
        },
        onSubmitted: widget.onSubmitted,
        obscureText: obscure,
        keyboardType: widget.type,
        textInputAction: widget.action,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(12.5),
          fillColor: widget.backgroundColor,
          filled: widget.backgroundColor != null,
          suffixIconColor: theme.iconTheme.color,
          hintText: widget.hint,
          suffixIconConstraints:
              BoxConstraints.loose(const Size.fromHeight(25)),
          suffixIcon: widget.hide
              ? MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => setState(() => obscure = !obscure),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.5),
                      child: Icon(
                        obscure ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
                        color: field.hasError ? theme.colorScheme.error : null,
                      ),
                    ),
                  ),
                )
              : field.hasError
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8.5),
                      child: Icon(Icons.error_rounded,
                          color: theme.colorScheme.error),
                    )
                  : widget.endIcon,
          border: OutlineInputBorder(
            borderRadius: KimikoConstants.borderRadius,
            borderSide: BorderSide(
              width: KimikoConstants.borderSideWidth,
              color: accentColor,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: KimikoConstants.borderRadius,
            borderSide: BorderSide(
              width: KimikoConstants.borderSideWidth,
              color: accentColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: KimikoConstants.borderRadius,
            borderSide: BorderSide(
                width: KimikoConstants.borderSideWidth,
                color: theme.colorScheme.error),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: KimikoConstants.borderRadius,
            borderSide: BorderSide(
              width: KimikoConstants.borderSideWidth,
              color: theme.primaryColorLight,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return FormField(
      enabled: widget.enabled,
      validator: widget.validator,
      initialValue: widget.controller?.text,
      builder: (field) {
        final hasError = field.hasError;
        final accentColor =
            hasError ? theme.colorScheme.error : theme.shadowColor;
        final fieldWidget = buildField(field: field, accentColor: accentColor);
        if (widget.label != null) {
          final title = Text(widget.label!,
              style: textTheme.bodyMedium!
                  .copyWith(color: theme.colorScheme.onSurface));
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
                            children: [TextSpan(text: field.errorText!)],
                          ),
                        )
                      ],
                    )
                  : title,
              const SizedBox(height: 5),
              fieldWidget,
            ],
          );
        } else {
          return fieldWidget;
        }
      },
    );
  }
}
