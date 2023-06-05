/// This file contains **Prototypal Strings Extension Pattern**.

import 'package:flutter/cupertino.dart' show Locale;

/// This enum contains all the string keys used in the app.
enum _KimikoStringKey {
  dashboard,
  email,
  password,
  phone,
  isRequired,
  mustMatchPassword,
  isInvalid,
  date,
  month,
  day,
  year,
  searchForCountry,
  search,
  lastPick,
  pickCountry,
  resendCode,
  codeNotReceived,
}

/// Type definition for [_KimikoStringKey] to more friendly [KStrings] name.
typedef KStrings = _KimikoStringKey;

/// This extension uses the [_KimikoStringKey] enum to get the string [value]
extension KimikoStringExtension on KStrings {
  String get value => KimikoStrings.instance[this];
}

/// This class contains strings, their translations and all logic related to locale configuration.
/// Usage:
/// 1. Directly use the [KStrings] enum to get the string [value] thanks to the [KimikoStringExtension] extension.
/// 2. Use the [[] operator] to get the string value by passing the [KStrings] enum to an [instance].
class KimikoStrings {
  const KimikoStrings._();

  static const instance = KimikoStrings._();

  static void setLocale(Locale locale) {
    if (_texts.containsKey(locale.languageCode)) {
      _locale = locale;
    }
  }

  static get defaultLocale => const Locale('en');

  static Locale _locale = defaultLocale;

  String get language => _locale.languageCode;

  String _localeText(KStrings key) => _texts[language]![key]!;

  String operator [](KStrings key) => _localeText(key);

  static const _texts = <String, Map<_KimikoStringKey, String>>{
    'fr': _fr,
    'en': _en,
  };

  // font family
  static const hpFontFamily = 'HP', signikaFontFamily = 'Signika';

  static const String phoneNumberRegex = r'^\+?[0-9]{10,13}$',
      emailRegex = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';

  static String mustBeAtLeast(int length) =>
      'must be at least $length characters';

  // default english strings
  static const _en = {
    KStrings.dashboard: 'Dashboard',
    KStrings.email: 'Email',
    KStrings.password: 'Password',
    KStrings.phone: 'Phone',
    KStrings.isRequired: 'is required',
    KStrings.isInvalid: 'is invalid',
    KStrings.date: 'Date',
    KStrings.month: 'Month',
    KStrings.day: 'Day',
    KStrings.year: 'Year',
    KStrings.searchForCountry: 'Search for country',
    KStrings.search: 'Search',
    KStrings.lastPick: 'Last pick',
    KStrings.pickCountry: 'Pick country',
    KStrings.resendCode: 'Resend code',
    KStrings.codeNotReceived: 'Code not received?',
    KStrings.mustMatchPassword: 'must match password',
  };

  // default french strings
  static const _fr = {
    KStrings.dashboard: 'Tableau de bord',
    KStrings.email: 'Email',
    KStrings.password: 'Mot de passe',
    KStrings.phone: 'Téléphone',
    KStrings.isRequired: 'Ce champ est requis',
    KStrings.isInvalid: 'Ce champ est invalide',
    KStrings.date: 'Date',
    KStrings.month: 'Mois',
    KStrings.day: 'Jour',
    KStrings.year: 'Année',
    KStrings.searchForCountry: 'Rechercher un pays',
    KStrings.search: 'Rechercher',
    KStrings.lastPick: 'Dernier choix',
    KStrings.pickCountry: 'Choisir un pays',
    KStrings.resendCode: 'Renvoyer le code',
    KStrings.codeNotReceived: 'Code non reçu ?',
    KStrings.mustMatchPassword: 'doit correspondre au mot de passe',
  };
}
