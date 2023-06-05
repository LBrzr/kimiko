import 'dart:ui' show window;

import 'package:flutter/material.dart';

import 'package:country_list_pick/country_list_pick.dart';
import 'package:country_list_pick/support/code_countrys.dart';
import 'package:kimiko/kimiko.dart';


class CountryCodeWidget extends StatefulWidget {
  const CountryCodeWidget({
    Key? key,
    this.initialSelection,
    this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  final void Function(CountryCode?)? onChanged;
  final String? initialSelection;
  final bool enabled;

  @override
  State<CountryCodeWidget> createState() => CountryCodeWidgetState();
}

class CountryCodeWidgetState extends State<CountryCodeWidget>
    with ThemeAndSizeMixin {
  static CountryCode? _country;

  CountryCode? get country => _country;

  @override
  void initState() {
    super.initState();
    final s = codes.cast().firstWhere(
          (code) =>
              code['code'] ==
              (widget.initialSelection ?? window.locale.countryCode),
          orElse: () => null,
        );
    if (s != null) {
      _country ??= CountryCode(
        name: s['name'],
        code: s['code'],
        dialCode: s['dial_code'],
        flagUri: 'flags/${s['code'].toLowerCase()}.png',
      );
      widget.onChanged?.call(_country);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -2.5),
      child: IgnorePointer(
        ignoring: !widget.enabled,
        child: CountryListPick(
          appBar: AppBar(
            systemOverlayStyle: theme.brightness == Brightness.light
                ? KimikoConstants.defaultSysStyle
                : KimikoConstants.defaultSysStyleDark,
            centerTitle: true,
            foregroundColor: theme.iconTheme.color,
            title: Text(KStrings.pickCountry.value),
          ),

          // if you need custome picker use this
          pickerBuilder: (context, CountryCode? countryCode) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                countryCode!.flagUri!,
                package: 'country_list_pick',
                height: 20,
                color: !widget.enabled ? Colors.grey : null,
                colorBlendMode: !widget.enabled ? BlendMode.saturation : null,
              ),
              const SizedBox(width: 7.5),
              Text(
                countryCode.dialCode!,
                style: textTheme.titleMedium!.copyWith(
                  color: !widget.enabled ? theme.disabledColor : null,
                ),
              ),
            ],
          ),

          // To disable option set to false
          theme: CountryTheme(
            isShowFlag: true,
            isShowTitle: false,
            isShowCode: true,
            isDownIcon: false,
            showEnglishName: true,
            // alphabetTextColor: textTheme.headline1!.color,
            alphabetSelectedTextColor: Colors.white,
            alphabetSelectedBackgroundColor: theme.primaryColorDark,
            searchText: KStrings.searchForCountry.value,
            searchHintText: KStrings.search.value,
            lastPickText: KStrings.lastPick.value,
          ),
          // Set default value
          initialSelection: _country?.code,
          // or
          // initialSelection: 'US'
          onChanged: (country) {
            setState(() => _country = country);
            widget.onChanged?.call(country);
          },
          // Whether to allow the widget to set a custom UI overlay
          // useUiOverlay: true,
          // Whether the country list should be wrapped in a SafeArea
          // useSafeArea: true,
        ),
      ),
    );
  }
}
