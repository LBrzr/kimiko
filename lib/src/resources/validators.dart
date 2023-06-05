import '/src/resources/constants.dart';
import '/src/resources/strings.dart';

class KimikoValidators {
  const KimikoValidators._();

  static const strings = KimikoStrings.instance;

  static String? defaultDate(List<int>? values) {
    if (values == null ||
        values.fold<int>(0, (previousValue, value) => previousValue + value) ==
            0) {
      return strings[KStrings.isRequired];
    }
    for (int value in values) {
      if (value == 0) {
        return strings[KStrings.isInvalid];
      }
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else if (RegExp(KimikoStrings.phoneNumberRegex).hasMatch(value)) {
      return null;
    } else {
      return strings[KStrings.isInvalid];
    }
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else {
      return null;
    }
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else if (RegExp(KimikoStrings.emailRegex).hasMatch(value)) {
      return null;
    } else {
      return strings[KStrings.isInvalid];
    }
  }

  static String? nullableEmail(String? value) {
    if (value == null) {
      return null;
    } else {
      return email(value);
    }
  }

  static String? password(String? value, [int? length]) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else if (value.length < (length ?? KimikoConstants.minPasswordLength)) {
      return KimikoStrings.mustBeAtLeast(
          length ?? KimikoConstants.minPasswordLength);
    } else {
      return null;
    }
  }

  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else if (value != password) {
      return strings[KStrings.mustMatchPassword];
    } else {
      return null;
    }
  }

  static String? double_(String? value) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else if (double.tryParse(value) != null) {
      return null;
    } else {
      return strings[KStrings.isInvalid];
    }
  }

  static String? int_(String? value) {
    if (value == null || value.isEmpty) {
      return strings[KStrings.isRequired];
    } else if (int.tryParse(value) != null) {
      return null;
    } else {
      return strings[KStrings.isInvalid];
    }
  }
}
